import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takt_client/takt_client.dart';

/// Owns every server interaction and the single source of truth for the UI.
///
/// The workspace key is persisted locally, never derived, and is the only
/// credential the client holds.
class AppState extends ChangeNotifier {
  AppState(this._client);

  final Client _client;

  static const _keyStorage = 'takt.workspace.key';

  /// The app solves with a stable seed so a re-run is reproducible and the
  /// what-if comparison is anchored to the plan on screen.
  static const defaultSeed = 90210;

  Shop? shop;
  List<WorkCenter> workCenters = const [];
  List<JobBundle> bundles = const [];
  ScheduleSnapshot? snapshot;
  List<ScheduleRun> history = const [];

  bool booting = true;
  bool loading = false;
  bool solving = false;

  /// True when data changed after the last solve, so the verdict is stale.
  bool scheduleStale = false;

  String? error;
  String? notice;

  bool get hasWorkspace => shop != null;
  String get accessKey => shop?.accessKey ?? '';
  bool get hasJobs => bundles.isNotEmpty;
  bool get hasWorkCenters => workCenters.isNotEmpty;

  Future<void> boot() async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(_keyStorage);

    if (key == null || key.isEmpty) {
      booting = false;
      notifyListeners();
      return;
    }

    try {
      shop = await _client.shop.fetch(key);
      await _reload();
    } catch (exception) {
      await prefs.remove(_keyStorage);
      error = describeError(exception);
    } finally {
      booting = false;
      notifyListeners();
    }
  }

  Future<bool> createWorkspace(
    String name,
    String currency, {
    bool withSample = true,
  }) async {
    return _guard(() async {
      final created = await _client.shop.create(name.trim(), currency);
      if (withSample) {
        await _client.shop.loadDemo(created.accessKey);
      }
      await _remember(created.accessKey);
      shop = created;
      await _reload();
      notice = withSample
          ? 'Sample shop loaded. Run the solver to see the diagnosis.'
          : 'Workspace created. Add work centers and jobs.';
    });
  }

  Future<bool> openWorkspace(String key) async {
    return _guard(() async {
      final found = await _client.shop.fetch(key.trim());
      await _remember(found.accessKey);
      shop = found;
      await _reload();
    });
  }

  Future<void> refresh() async {
    await _guard(_reload);
  }

  Future<bool> renameWorkspace(String name) async {
    return _guard(() async {
      final updated = await _client.shop.rename(accessKey, name.trim());
      shop = updated;
      notice = 'Workspace renamed.';
    });
  }

  Future<bool> loadSample() async {
    return _guard(() async {
      await _client.shop.loadDemo(accessKey);
      await _reload();
      notice = 'Sample shop loaded.';
    });
  }

  Future<void> solve() async {
    if (solving || !hasWorkspace) return;
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
    return _guard(() async {
      await _client.job.save(accessKey, bundle);
      await _reload();
      scheduleStale = snapshot != null;
      notice = 'Job saved. Re-run the solver to update the verdict.';
    });
  }

  Future<bool> deleteJob(int id) async {
    return _guard(() async {
      await _client.job.remove(accessKey, id);
      await _reload();
      scheduleStale = snapshot != null;
      notice = 'Job removed.';
    });
  }

  Future<bool> saveWorkCenter(WorkCenter center) async {
    return _guard(() async {
      await _client.workCenter.save(accessKey, center);
      await _reload();
      scheduleStale = snapshot != null;
      notice = 'Work center saved.';
    });
  }

  Future<bool> deleteWorkCenter(int id) async {
    return _guard(() async {
      await _client.workCenter.remove(accessKey, id);
      await _reload();
      scheduleStale = snapshot != null;
      notice = 'Work center removed.';
    });
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyStorage);
    shop = null;
    workCenters = const [];
    bundles = const [];
    snapshot = null;
    history = const [];
    scheduleStale = false;
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

  Future<void> _reload() async {
    final centers = await _client.workCenter.list(accessKey);
    final jobs = await _client.job.list(accessKey);
    final runs = await _client.schedule.history(accessKey);
    workCenters = centers;
    bundles = jobs;
    history = runs;
  }

  Future<void> _remember(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyStorage, key);
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

String describeError(Object error) {
  var text = error.toString();
  for (final prefix in const [
    'Exception: ',
    'ServerpodClientException: ',
    'WorkspaceException: ',
  ]) {
    if (text.startsWith(prefix)) {
      text = text.substring(prefix.length);
    }
  }
  text = text.replaceAll(RegExp(r'\s+'), ' ').trim();
  if (text.length > 320) {
    text = '${text.substring(0, 320)}…';
  }
  return text.isEmpty ? 'Something went wrong.' : text;
}
