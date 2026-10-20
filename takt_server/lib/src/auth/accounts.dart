import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'passwords.dart';
import 'sessions.dart';

/// Account lifecycle and sign-in. Workspace access is intentionally separate:
/// a session manages the account, while each workspace has a scoped key for
/// data calls.
class AccountService {
  const AccountService();

  Future<AuthResult> register(
    Session session, {
    required String email,
    required String password,
    required String displayName,
  }) async {
    final normalized = normalizeEmail(email);
    if (!isValidEmail(normalized)) {
      throw TaktException(message: 'Enter a valid email address.');
    }
    final nameError = validateDisplayName(displayName);
    if (nameError != null) throw TaktException(message: nameError);
    final passwordError = validatePassword(password);
    if (passwordError != null) throw TaktException(message: passwordError);

    final existing = await TaktUser.db.find(
      session,
      where: (t) => t.email.equals(normalized),
      limit: 1,
    );
    if (existing.isNotEmpty) {
      throw TaktException(
        message: 'An account with that email already exists. Sign in instead.',
      );
    }

    final hash = await hashPassword(password);
    TaktUser user;
    try {
      final rows = await TaktUser.db.insert(session, [
        TaktUser(
          email: normalized,
          displayName: displayName.trim(),
          passwordHash: hash,
          createdAt: DateTime.now(),
        ),
      ]);
      user = rows.first;
    } catch (exception) {
      // The unique index is the final guard against two simultaneous signups.
      final again = await TaktUser.db.find(
        session,
        where: (t) => t.email.equals(normalized),
        limit: 1,
      );
      if (again.isNotEmpty) {
        throw TaktException(
          message:
              'An account with that email already exists. Sign in instead.',
        );
      }
      throw TaktException(message: 'Could not create the account. Try again.');
    }

    final token = await issueSession(session, user.id!);
    return AuthResult(
      token: token,
      user: publicUser(user),
      workspaces: const [],
    );
  }

  Future<AuthResult> login(
    Session session, {
    required String email,
    required String password,
  }) async {
    final normalized = normalizeEmail(email);
    if (!isValidEmail(normalized) || password.isEmpty) {
      throw TaktException(message: 'Email or password is incorrect.');
    }

    try {
      LoginThrottle.check(normalized);
    } on ThrottledLoginException catch (error) {
      throw TaktException(message: error.toString());
    }

    final rows = await TaktUser.db.find(
      session,
      where: (t) => t.email.equals(normalized),
      limit: 1,
    );
    if (rows.isEmpty) {
      await burnPasswordTime(password);
      LoginThrottle.fail(normalized);
      throw TaktException(message: 'Email or password is incorrect.');
    }

    final user = rows.first;
    final valid = await verifyPassword(password, user.passwordHash);
    if (!valid) {
      LoginThrottle.fail(normalized);
      throw TaktException(message: 'Email or password is incorrect.');
    }

    LoginThrottle.succeed(normalized);
    final token = await issueSession(session, user.id!);
    return AuthResult(
      token: token,
      user: publicUser(user),
      workspaces: await listWorkspaceAccess(session, user.id!),
    );
  }

  Future<AuthResult> me(Session session, String token) async {
    final access = await requireUser(session, token);
    return AuthResult(
      token: token,
      user: publicUser(access.user),
      workspaces: await listWorkspaceAccess(session, access.user.id!),
    );
  }

  Future<bool> logout(Session session, String token) async {
    await revokeSession(session, token);
    return true;
  }

  Future<bool> changePassword(
    Session session,
    String token, {
    required String currentPassword,
    required String newPassword,
  }) async {
    final access = await requireUser(session, token);
    final currentValid = await verifyPassword(
      currentPassword,
      access.user.passwordHash,
    );
    if (!currentValid) {
      throw TaktException(message: 'That current password is not correct.');
    }
    final passwordError = validatePassword(newPassword);
    if (passwordError != null) throw TaktException(message: passwordError);

    access.user.passwordHash = await hashPassword(newPassword);
    await TaktUser.db.update(session, [access.user]);
    await revokeOtherSessions(session, access.user.id!, token);
    return true;
  }
}
