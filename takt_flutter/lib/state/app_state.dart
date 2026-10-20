import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takt_client/takt_client.dart';

/// Owns every server interaction and the single source of truth for the UI.
///
/// A signed-in account has a revocable session token for account and team
/// management, plus a scoped key for the active workspace. A guest has only a
/// workspace key. The server enforces the role behind that key on every write;
/// [canWrite] is the UI's matching affordance, not the security boundary.
class AppState extends ChangeNotifier {
  AppState(this._client) {
    _client.connectivityMonitor?.addListener(_connectivityChanged);
  }

  final Client _client;

  @override
  void dispose() {
    _client.connectivityMonitor?.removeListener(_connectivityChanged);
    super.dispose();
  }

  static const _sessionStorage = 'takt.session.token';
  static const _keyStorage = 'takt.workspace.key';
  static const _shopStorage = 'takt.workspace.id';

  /// The app solves with a stable seed so a re-run is reproducible and the
  /// what-if comparison is anchored to the plan on screen.
  static const defaultSeed = 90210;

  Shop? shop;
  List<WorkCenter> workCenters = const [];
  List<JobBundle> bundles = const [];
  ScheduleSnapshot? snapshot;
  List<ScheduleRun> history = const [];

  AuthUser? user;
  String? sessionToken;
  List<WorkspaceAccess> workspaces = const [];
  List<MemberInfo> members = const [];

  String _credential = '';
  String role = 'owner';

  bool booting = true;
  bool loading = false;
  bool solving = false;
  bool membersLoading = false;
  bool offline = false;

  /// True when data changed after the last solve, so the verdict is stale.
  bool scheduleStale = false;

  String? error;
  String? notice;

  bool get hasWorkspace => shop != null;
  bool get isSignedIn => user != null && sessionToken != null;
  bool get isOwner => role == 'owner';
  bool get isViewer => role == 'viewer';
  bool get canWrite => role == 'owner' || role == 'editor';

  /// The scoped key used for data calls. It is intentionally stored apart from
  /// [Shop.accessKey], which is blank for member keys. The fallback keeps a
  /// locally captured demo shop working when it was hydrated without a login.
  String get accessKey =>
      _credential.isNotEmpty ? _credential : (shop?.accessKey ?? '');

  WorkspaceAccess? get currentAccess {
    final id = shop?.id;
    if (id == null) return null;
    for (final access in workspaces) {
      if (access.shopId == id) return access;
    }
    return null;
  }

  /// True when the open workspace is part of the signed-in account's list.
  /// Opening a shared key while signed in does not grant account-level team
  /// visibility for a shop the account has not joined.
  bool get isAccountWorkspace => isSignedIn && currentAccess != null;

  /// Any account member can see the people list; only an owner can manage it.
  bool get canViewTeam => isAccountWorkspace;
  bool get canManageTeam =>
      isAccountWorkspace && currentAccess?.role == 'owner';

  String get roleName => switch (role) {
    'owner' => 'Owner',
    'editor' => 'Editor',
    'viewer' => 'Viewer',
    _ => role,
  };

  bool get hasJobs => bundles.isNotEmpty;
  bool get hasWorkCenters => workCenters.isNotEmpty;

  void _connectivityChanged(bool connected) {
    if (offline == !connected) return;
    offline = !connected;
    notifyListeners();
  }

  /// Re-runs the safest read for the current screen. Wired to the offline
  /// banner; the caller can also use it after any recoverable network error.
  Future<void> retry() async {
    if (hasWorkspace) {
      await refresh();
    } else if (isSignedIn) {
      await refreshAccount();
    } else {
      await boot();
    }
  }

  Future<void> boot() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_sessionStorage);
    final savedKey = prefs.getString(_keyStorage);

    if (token != null && token.isNotEmpty) {
      try {
        final auth = await _client.auth.me(token);
        user = auth.user;
        sessionToken = token;
        workspaces = auth.workspaces;
        if (workspaces.isNotEmpty) {
          final savedShopId = prefs.getInt(_shopStorage);
          final target = workspaces.firstWhere(
            (workspace) => workspace.shopId == savedShopId,
            orElse: () => workspaces.first,
          );
          try {
            await _openAccess(target);
          } catch (exception) {
            // Keep the account session; a failed workspace fetch should not
            // sign the person out. The picker can retry opening the shop.
            error = describeError(exception);
          }
        }
      } catch (exception) {
        await _clearSessionStorage();
        user = null;
        sessionToken = null;
        workspaces = const [];
        error = describeError(exception);
      }
    }

    if (shop == null && savedKey != null && savedKey.isNotEmpty) {
      try {
        await _openCredential(savedKey, persist: false);
        error = null;
      } catch (exception) {
        await prefs.remove(_keyStorage);
        error ??= describeError(exception);
      }
    }

    booting = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    return _guard(() async {
      final result = await _client.auth.login(email.trim(), password);
      await _acceptAuth(result);
    });
  }

  Future<bool> register(
    String displayName,
    String email,
    String password,
  ) async {
    return _guard(() async {
      final result = await _client.auth.register(
        email.trim(),
        password,
        displayName.trim(),
      );
      await _acceptAuth(result);
      notice = 'Account created. Create or open a workspace.';
    });
  }

  Future<bool> createWorkspace(
    String name,
    String currency, {
    bool withSample = true,
  }) async {
    return _guard(() async {
      if (isSignedIn) {
        final access = await _client.workspace.create(
          sessionToken!,
          name.trim(),
          currency,
          withSample,
        );
        await refreshAccount(silent: true);
        _rememberWorkspace(access);
        await _openAccess(access);
        notice = withSample
            ? 'Workspace created with the sample shop. Run the solver to see the diagnosis.'
            : 'Workspace created. Add work centers and jobs.';
        return;
      }

      final created = await _client.shop.create(name.trim(), currency);
      if (withSample) {
        await _client.shop.loadDemo(created.accessKey);
      }
      role = 'owner';
      _credential = created.accessKey;
      shop = created;
      await _reload();
      await _persistActive(created.accessKey);
      notice = withSample
          ? 'Sample shop loaded. Run the solver to see the diagnosis.'
          : 'Workspace created. Add work centers and jobs.';
    });
  }

  Future<bool> claimWorkspace(String key) async {
    return _guard(() async {
      if (!isSignedIn) {
        throw TaktException(
          message: 'Sign in before claiming a workspace.',
        );
      }
      final access = await _client.workspace.claim(sessionToken!, key.trim());
      await refreshAccount(silent: true);
      _rememberWorkspace(access);
      await _openAccess(access);
      notice = 'Workspace claimed. You are the owner.';
    });
  }

  /// Opens any key, including a scoped key shared by an owner. Signed-in users
  /// can use this for a guest link without adding it to their account.
  Future<bool> openWorkspace(String key) async {
    return _guard(() async {
      await _openCredential(key.trim());
    });
  }

  Future<bool> switchWorkspace(int shopId) async {
    return _guard(() async {
      final access = workspaces.firstWhere(
        (workspace) => workspace.shopId == shopId,
      );
      await _openAccess(access);
    });
  }

  /// Leaves the current workspace while staying signed in, so the workspace
  /// picker can be shown. A guest returns to the welcome screen.
  Future<void> leaveWorkspace() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyStorage);
    await prefs.remove(_shopStorage);
    _clearWorkspaceData();
    notifyListeners();
  }

  Future<void> refresh() async {
    await _guard(_reload);
  }

  Future<bool> renameWorkspace(String name) async {
    if (!canWrite) {
      error = 'View-only access. Ask the owner for editor access.';
      notifyListeners();
      return false;
    }
    return _guard(() async {
      final updated = await _client.shop.rename(accessKey, name.trim());
      shop = updated;
      notice = 'Workspace renamed.';
    });
  }

  Future<bool> loadSample() async {
    if (!canWrite) {
      error = 'View-only access. Ask the owner for editor access.';
      notifyListeners();
      return false;
    }
    return _guard(() async {
      await _client.shop.loadDemo(accessKey);
      await _reload();
      notice = 'Sample shop loaded.';
    });
  }

  Future<void> solve() async {
    if (solving || !hasWorkspace) return;
    if (!canWrite) {
      error = 'View-only access. Ask the owner to run the solver.';
      notifyListeners();
      return;
    }
    solving = true;
    error = null;
    notifyListeners();
    try {
      final result = await _client.schedule.solve(
        accessKey,
        seed: defaultSeed,
      );
      snapshot = result;
      scheduleStale = false;
      history = await _client.schedule.history(accessKey);
    } catch (exception) {
      error = describeError(exception);
    } finally {
      solving = false;
      notifyListeners();
    }
  }

  Future<WhatIfResult?> whatIf(int workCenterId, int extraMachines) async {
    try {
      return await _client.schedule.whatIf(
        accessKey,
        workCenterId: workCenterId,
        extraMachines: extraMachines,
      );
    } catch (exception) {
      error = describeError(exception);
      notifyListeners();
      return null;
    }
  }

  Future<bool> saveJob(JobBundle bundle) async {
    if (!canWrite) {
      error = 'View-only access. Ask the owner for editor access.';
      notifyListeners();
      return false;
    }
    return _guard(() async {
      await _client.job.save(accessKey, bundle);
      await _reload();
      scheduleStale = snapshot != null;
      notice = 'Job saved. Re-run the solver to update the verdict.';
    });
  }

  Future<bool> deleteJob(int id) async {
    if (!canWrite) {
      error = 'View-only access. Ask the owner for editor access.';
      notifyListeners();
      return false;
    }
    return _guard(() async {
      await _client.job.remove(accessKey, id);
      await _reload();
      scheduleStale = snapshot != null;
      notice = 'Job removed.';
    });
  }

  Future<bool> saveWorkCenter(WorkCenter center) async {
    if (!canWrite) {
      error = 'View-only access. Ask the owner for editor access.';
      notifyListeners();
      return false;
    }
    return _guard(() async {
      await _client.workCenter.save(accessKey, center);
      await _reload();
      scheduleStale = snapshot != null;
      notice = 'Work center saved.';
    });
  }

  Future<bool> deleteWorkCenter(int id) async {
    if (!canWrite) {
      error = 'View-only access. Ask the owner for editor access.';
      notifyListeners();
      return false;
    }
    return _guard(() async {
      await _client.workCenter.remove(accessKey, id);
      await _reload();
      scheduleStale = snapshot != null;
      notice = 'Work center removed.';
    });
  }

  Future<void> loadMembers() async {
    if (!isAccountWorkspace) {
      members = const [];
      return;
    }
    membersLoading = true;
    notifyListeners();
    try {
      members = await _client.workspace.members(sessionToken!, shop!.id!);
      error = null;
    } catch (exception) {
      error = describeError(exception);
    } finally {
      membersLoading = false;
      notifyListeners();
    }
  }

  Future<MemberInfo?> inviteMember(String email, String role) async {
    if (!canManageTeam) {
      error = 'Sign in as the workspace owner to invite people.';
      notifyListeners();
      return null;
    }
    try {
      final invited = await _client.workspace.invite(
        sessionToken!,
        shop!.id!,
        email.trim(),
        role,
      );
      members = await _client.workspace.members(sessionToken!, shop!.id!);
      notice = '${invited.displayName} added as ${_roleLabel(invited.role)}.';
      notifyListeners();
      return invited;
    } catch (exception) {
      error = describeError(exception);
      notifyListeners();
      return null;
    }
  }

  Future<bool> setMemberRole(int userId, String role) async {
    if (!canManageTeam) return false;
    try {
      await _client.workspace.setRole(
        sessionToken!,
        shop!.id!,
        userId,
        role,
      );
      members = await _client.workspace.members(sessionToken!, shop!.id!);
      notice = 'Role updated.';
      notifyListeners();
      return true;
    } catch (exception) {
      error = describeError(exception);
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeMember(int userId) async {
    if (!canManageTeam) return false;
    try {
      await _client.workspace.removeMember(
        sessionToken!,
        shop!.id!,
        userId,
      );
      members = await _client.workspace.members(sessionToken!, shop!.id!);
      notice = 'Workspace access removed.';
      notifyListeners();
      return true;
    } catch (exception) {
      error = describeError(exception);
      notifyListeners();
      return false;
    }
  }

  Future<bool> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    if (!isSignedIn) return false;
    try {
      await _client.auth.changePassword(
        sessionToken!,
        currentPassword,
        newPassword,
      );
      notice = 'Password changed. Other sessions were signed out.';
      notifyListeners();
      return true;
    } catch (exception) {
      error = describeError(exception);
      notifyListeners();
      return false;
    }
  }

  Future<void> refreshAccount({bool silent = false}) async {
    final token = sessionToken;
    if (token == null) return;
    try {
      final auth = await _client.auth.me(token);
      user = auth.user;
      workspaces = auth.workspaces;
      if (!silent) notifyListeners();
    } catch (exception) {
      if (!silent) {
        error = describeError(exception);
        notifyListeners();
      }
    }
  }

  Future<void> signOut() async {
    final token = sessionToken;
    if (token != null) {
      try {
        await _client.auth.logout(token);
      } catch (_) {
        // The local session is cleared even if the network is unavailable.
      }
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionStorage);
    await prefs.remove(_keyStorage);
    await prefs.remove(_shopStorage);
    user = null;
    sessionToken = null;
    workspaces = const [];
    _clearWorkspaceData();
    error = null;
    notice = null;
    notifyListeners();
  }

  void clearMessages() {
    if (error == null && notice == null) return;
    error = null;
    notice = null;
    notifyListeners();
  }

  /// Team management is session-scoped. If the post-create account refresh
  /// failed or raced, still treat the new workspace as part of this account.
  void _rememberWorkspace(WorkspaceAccess access) {
    final index = workspaces.indexWhere(
      (workspace) => workspace.shopId == access.shopId,
    );
    if (index < 0) {
      workspaces = [...workspaces, access];
      return;
    }
    final updated = [...workspaces];
    updated[index] = access;
    workspaces = updated;
  }

  Future<void> _acceptAuth(AuthResult result) async {
    user = result.user;
    sessionToken = result.token;
    workspaces = result.workspaces;
    await _saveSession(result.token);

    if (workspaces.isEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyStorage);
      await prefs.remove(_shopStorage);
      _clearWorkspaceData();
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final savedShopId = prefs.getInt(_shopStorage);
    final target = workspaces.firstWhere(
      (workspace) => workspace.shopId == savedShopId,
      orElse: () => workspaces.first,
    );
    try {
      await _openAccess(target);
    } catch (exception) {
      // Keep the successful sign-in. A missing or revoked workspace key should
      // surface in the picker, not turn a valid login into a failure.
      error = describeError(exception);
    }
  }

  Future<void> _openAccess(WorkspaceAccess access) async {
    final key = access.accessKey;
    if (key.isEmpty) {
      throw TaktException(message: 'This workspace key is missing.');
    }
    final fetched = await _client.shop.fetch(key);
    final centers = await _client.workCenter.list(key);
    final jobs = await _client.job.list(key);
    final runs = await _client.schedule.history(key);

    // Commit only after every read succeeds. A failed switch must leave the
    // previous workspace fully usable rather than mixing its shop with a new
    // credential. The snapshot is tied to the old shop and is cleared.
    _credential = key;
    role = access.role;
    shop = fetched;
    workCenters = centers;
    bundles = jobs;
    history = runs;
    snapshot = null;
    scheduleStale = false;
    notice = null;
    await _loadMembersQuiet();
    await _persistActive(key, shopId: access.shopId);
  }

  Future<void> _openCredential(String key, {bool persist = true}) async {
    if (key.isEmpty) {
      throw TaktException(message: 'Paste a workspace key.');
    }
    final access = await _client.workspace.access(key);
    final fetched = await _client.shop.fetch(key);
    final centers = await _client.workCenter.list(key);
    final jobs = await _client.job.list(key);
    final runs = await _client.schedule.history(key);

    _credential = key;
    role = access.role;
    shop = fetched;
    workCenters = centers;
    bundles = jobs;
    history = runs;
    snapshot = null;
    scheduleStale = false;
    notice = null;
    await _loadMembersQuiet();
    if (persist) await _persistActive(key);
  }

  Future<void> _reload() async {
    final centers = await _client.workCenter.list(accessKey);
    final jobs = await _client.job.list(accessKey);
    final runs = await _client.schedule.history(accessKey);
    workCenters = centers;
    bundles = jobs;
    history = runs;
  }

  Future<void> _loadMembersQuiet() async {
    if (!isAccountWorkspace) {
      members = const [];
      return;
    }
    try {
      members = await _client.workspace.members(sessionToken!, shop!.id!);
    } catch (_) {
      // Team management is secondary to opening the workspace.
    }
  }

  Future<void> _persistActive(String key, {int? shopId}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyStorage, key);
    if (shopId != null) {
      await prefs.setInt(_shopStorage, shopId);
    } else {
      await prefs.remove(_shopStorage);
    }
  }

  Future<void> _saveSession(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionStorage, token);
  }

  Future<void> _clearSessionStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionStorage);
  }

  void _clearWorkspaceData() {
    shop = null;
    workCenters = const [];
    bundles = const [];
    snapshot = null;
    history = const [];
    members = const [];
    scheduleStale = false;
    _credential = '';
    role = 'owner';
  }

  Future<bool> _guard(Future<void> Function() action) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      await action();
      return true;
    } catch (exception) {
      error = describeError(exception);
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}

String _roleLabel(String role) => switch (role) {
  'owner' => 'Owner',
  'editor' => 'Editor',
  'viewer' => 'Viewer',
  _ => role,
};

String describeError(Object error) {
  if (error is TaktException) {
    final message = error.message.replaceAll(RegExp(r'\s+'), ' ').trim();
    return message.isEmpty ? 'Something went wrong.' : message;
  }

  var text = error.toString();
  for (final prefix in const [
    'Exception: ',
    'ServerpodClientException: ',
    'TaktException: ',
    'WorkspaceException: ',
  ]) {
    if (text.startsWith(prefix)) {
      text = text.substring(prefix.length);
    }
  }
  final wrapped = RegExp(r'^TaktException\(message: (.*)\)$').firstMatch(text);
  if (wrapped != null) text = wrapped.group(1)!;
  text = text.replaceAll(RegExp(r'\s+'), ' ').trim();
  if (text.length > 320) {
    text = '${text.substring(0, 320)}…';
  }
  return text.isEmpty ? 'Something went wrong.' : text;
}
