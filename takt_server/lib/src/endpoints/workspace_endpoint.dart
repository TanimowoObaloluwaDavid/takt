import 'package:serverpod/serverpod.dart';

import '../auth/sessions.dart';
import '../auth/workspaces.dart';
import '../generated/protocol.dart';

class WorkspaceEndpoint extends Endpoint {
  static const _workspaces = WorkspaceService();

  Future<List<WorkspaceAccess>> list(Session session, String token) async {
    final access = await requireUser(session, token);
    return _workspaces.list(session, access.user.id!);
  }

  Future<WorkspaceAccess> create(
    Session session,
    String token,
    String name,
    String currency,
    bool withSample,
  ) async {
    final access = await requireUser(session, token);
    return _workspaces.create(
      session,
      userId: access.user.id!,
      name: name,
      currency: currency,
      withSample: withSample,
    );
  }

  Future<WorkspaceAccess> claim(
    Session session,
    String token,
    String accessKey,
  ) async {
    final access = await requireUser(session, token);
    return _workspaces.claim(
      session,
      userId: access.user.id!,
      accessKey: accessKey,
    );
  }

  /// Resolves a scoped key without an account, so the client can show the
  /// correct role for a shared key. It never echoes the key.
  Future<WorkspaceAccess> access(Session session, String accessKey) =>
      _workspaces.access(session, accessKey);

  Future<List<MemberInfo>> members(
    Session session,
    String token,
    int shopId,
  ) async {
    final access = await requireUser(session, token);
    return _workspaces.members(
      session,
      userId: access.user.id!,
      shopId: shopId,
    );
  }

  Future<MemberInfo> invite(
    Session session,
    String token,
    int shopId,
    String email,
    String role,
  ) async {
    final access = await requireUser(session, token);
    return _workspaces.invite(
      session,
      userId: access.user.id!,
      shopId: shopId,
      email: email,
      role: role,
    );
  }

  Future<MemberInfo> setRole(
    Session session,
    String token,
    int shopId,
    int userId,
    String role,
  ) async {
    final access = await requireUser(session, token);
    return _workspaces.setRole(
      session,
      userId: access.user.id!,
      shopId: shopId,
      memberUserId: userId,
      role: role,
    );
  }

  Future<bool> removeMember(
    Session session,
    String token,
    int shopId,
    int userId,
  ) async {
    final access = await requireUser(session, token);
    return _workspaces.removeMember(
      session,
      userId: access.user.id!,
      shopId: shopId,
      memberUserId: userId,
    );
  }
}
