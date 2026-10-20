import 'package:serverpod/serverpod.dart';

import '../auth/accounts.dart';
import '../generated/protocol.dart';

class AuthEndpoint extends Endpoint {
  static const _accounts = AccountService();

  Future<AuthResult> register(
    Session session,
    String email,
    String password,
    String displayName,
  ) => _accounts.register(
    session,
    email: email,
    password: password,
    displayName: displayName,
  );

  Future<AuthResult> login(
    Session session,
    String email,
    String password,
  ) => _accounts.login(session, email: email, password: password);

  Future<AuthResult> me(Session session, String token) =>
      _accounts.me(session, token);

  Future<bool> logout(Session session, String token) =>
      _accounts.logout(session, token);

  Future<bool> changePassword(
    Session session,
    String token,
    String currentPassword,
    String newPassword,
  ) => _accounts.changePassword(
    session,
    token,
    currentPassword: currentPassword,
    newPassword: newPassword,
  );
}
