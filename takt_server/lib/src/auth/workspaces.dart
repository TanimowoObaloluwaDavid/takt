import 'package:serverpod/serverpod.dart';

import '../access/access.dart';
import '../generated/protocol.dart';
import '../services/demo_service.dart';
import 'passwords.dart';
import 'sessions.dart';

/// Workspace creation, membership, and team management.
class WorkspaceService {
  const WorkspaceService();

  Future<List<WorkspaceAccess>> list(Session session, int userId) =>
      listWorkspaceAccess(session, userId);

  Future<WorkspaceAccess> create(
    Session session, {
    required int userId,
    required String name,
    required String currency,
    required bool withSample,
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw TaktException(message: 'Give the workspace a name.');
    }
    if (trimmed.length > 80) {
      throw TaktException(message: 'Keep the name to 80 characters.');
    }
    final code = currency.trim().isEmpty
        ? 'USD'
        : currency.trim().toUpperCase();
    if (code.length != 3) {
      throw TaktException(message: 'Use a three-letter currency code.');
    }

    final rows = await Shop.db.insert(session, [
      Shop(
        name: trimmed,
        accessKey: generateAccessKey(),
        currency: code,
        minutesPerDay: 1440,
        createdAt: DateTime.now(),
      ),
    ]);
    final shop = rows.first;

    await WorkspaceMember.db.insert(session, [
      WorkspaceMember(
        shopId: shop.id!,
        userId: userId,
        role: roleOwner,
        accessKey: shop.accessKey,
        createdAt: DateTime.now(),
      ),
    ]);

    if (withSample) {
      await const DemoService().load(session, shop);
    }

    return WorkspaceAccess(
      shopId: shop.id!,
      name: shop.name,
      currency: shop.currency,
      role: roleOwner,
      accessKey: shop.accessKey,
      createdAt: shop.createdAt,
    );
  }

  /// Claims an existing owner-key workspace for an account. This is the bridge
  /// for workspaces created before accounts existed.
  Future<WorkspaceAccess> claim(
    Session session, {
    required int userId,
    required String accessKey,
  }) async {
    final key = accessKey.trim();
    final shops = await Shop.db.find(
      session,
      where: (t) => t.accessKey.equals(key),
      limit: 1,
    );
    if (shops.isEmpty) {
      throw TaktException(
        message: 'That is not a full-access workspace key.',
      );
    }
    final shop = shops.first;

    final owners = await WorkspaceMember.db.find(
      session,
      where: (t) => t.shopId.equals(shop.id!) & t.role.equals(roleOwner),
      limit: 1,
    );
    if (owners.isNotEmpty) {
      if (owners.first.userId == userId) {
        return WorkspaceAccess(
          shopId: shop.id!,
          name: shop.name,
          currency: shop.currency,
          role: roleOwner,
          accessKey: shop.accessKey,
          createdAt: shop.createdAt,
        );
      }
      throw TaktException(
        message:
            'This workspace already belongs to an account. Ask the owner to invite you.',
      );
    }

    final existing = await WorkspaceMember.db.find(
      session,
      where: (t) => t.shopId.equals(shop.id!) & t.userId.equals(userId),
      limit: 1,
    );
    if (existing.isNotEmpty) {
      final member = existing.first;
      member.role = roleOwner;
      member.accessKey = shop.accessKey;
      await WorkspaceMember.db.update(session, [member]);
    } else {
      await WorkspaceMember.db.insert(session, [
        WorkspaceMember(
          shopId: shop.id!,
          userId: userId,
          role: roleOwner,
          accessKey: shop.accessKey,
          createdAt: DateTime.now(),
        ),
      ]);
    }

    return WorkspaceAccess(
      shopId: shop.id!,
      name: shop.name,
      currency: shop.currency,
      role: roleOwner,
      accessKey: shop.accessKey,
      createdAt: shop.createdAt,
    );
  }

  /// Resolves a scoped key to its role without echoing the key back.
  Future<WorkspaceAccess> access(
    Session session,
    String credential,
  ) async {
    final access = await requireShop(session, credential);
    return WorkspaceAccess(
      shopId: access.shop.id!,
      name: access.shop.name,
      currency: access.shop.currency,
      role: access.role,
      accessKey: '',
      createdAt: access.shop.createdAt,
    );
  }

  Future<List<MemberInfo>> members(
    Session session, {
    required int userId,
    required int shopId,
  }) async {
    final caller = await _membership(session, userId, shopId);
    if (caller == null) {
      throw TaktException(
        message: 'You do not have access to this workspace.',
      );
    }

    final members = await WorkspaceMember.db.find(
      session,
      where: (t) => t.shopId.equals(shopId),
    );
    if (members.isEmpty) return const [];
    final users = await TaktUser.db.find(
      session,
      where: (t) => t.id.inSet(members.map((m) => m.userId).toSet()),
    );
    final byId = {for (final user in users) user.id!: user};

    final result = <MemberInfo>[];
    for (final member in members) {
      final user = byId[member.userId];
      if (user == null) continue;
      result.add(
        memberInfo(
          member,
          user,
          revealKey: caller.role == roleOwner,
        ),
      );
    }
    result.sort((a, b) {
      if (a.role == roleOwner && b.role != roleOwner) return -1;
      if (b.role == roleOwner && a.role != roleOwner) return 1;
      return a.displayName.toLowerCase().compareTo(
        b.displayName.toLowerCase(),
      );
    });
    return result;
  }

  Future<MemberInfo> invite(
    Session session, {
    required int userId,
    required int shopId,
    required String email,
    required String role,
  }) async {
    await _requireOwner(session, userId, shopId);
    if (role != roleEditor && role != roleViewer) {
      throw TaktException(message: 'Invite someone as an editor or viewer.');
    }
    final normalized = normalizeEmail(email);
    if (!isValidEmail(normalized)) {
      throw TaktException(message: 'Enter a valid email address.');
    }

    final users = await TaktUser.db.find(
      session,
      where: (t) => t.email.equals(normalized),
      limit: 1,
    );
    if (users.isEmpty) {
      throw TaktException(
        message:
            'Ask them to create a Takt account first, then invite that email.',
      );
    }
    final user = users.first;
    if (user.id == userId) {
      throw TaktException(message: 'You are already the owner.');
    }

    final existing = await _membership(session, user.id!, shopId);
    if (existing != null) {
      throw TaktException(
        message: 'That person is already in this workspace.',
      );
    }

    final key = await _newMemberKey(session);
    final rows = await WorkspaceMember.db.insert(session, [
      WorkspaceMember(
        shopId: shopId,
        userId: user.id!,
        role: role,
        accessKey: key,
        createdAt: DateTime.now(),
      ),
    ]);
    return memberInfo(rows.first, user, revealKey: true);
  }

  Future<MemberInfo> setRole(
    Session session, {
    required int userId,
    required int shopId,
    required int memberUserId,
    required String role,
  }) async {
    await _requireOwner(session, userId, shopId);
    if (role != roleEditor && role != roleViewer) {
      throw TaktException(message: 'Choose editor or viewer.');
    }
    final member = await _membership(session, memberUserId, shopId);
    if (member == null) {
      throw TaktException(message: 'That person is not in this workspace.');
    }
    if (member.role == roleOwner) {
      throw TaktException(message: 'The owner role cannot be changed.');
    }
    member.role = role;
    await WorkspaceMember.db.update(session, [member]);

    final users = await TaktUser.db.find(
      session,
      where: (t) => t.id.equals(memberUserId),
      limit: 1,
    );
    if (users.isEmpty) {
      throw TaktException(message: 'That account no longer exists.');
    }
    return memberInfo(member, users.first, revealKey: true);
  }

  Future<bool> removeMember(
    Session session, {
    required int userId,
    required int shopId,
    required int memberUserId,
  }) async {
    await _requireOwner(session, userId, shopId);
    if (memberUserId == userId) {
      throw TaktException(message: 'Transfer ownership before leaving.');
    }
    final member = await _membership(session, memberUserId, shopId);
    if (member == null) return true;
    if (member.role == roleOwner) {
      throw TaktException(message: 'The owner cannot be removed.');
    }
    await WorkspaceMember.db.deleteWhere(
      session,
      where: (t) => t.id.equals(member.id!),
    );
    return true;
  }

  Future<WorkspaceMember> _requireOwner(
    Session session,
    int userId,
    int shopId,
  ) async {
    final member = await _membership(session, userId, shopId);
    if (member == null || member.role != roleOwner) {
      throw TaktException(
        message: 'Only the workspace owner can manage people.',
      );
    }
    return member;
  }

  Future<WorkspaceMember?> _membership(
    Session session,
    int userId,
    int shopId,
  ) async {
    final rows = await WorkspaceMember.db.find(
      session,
      where: (t) => t.userId.equals(userId) & t.shopId.equals(shopId),
      limit: 1,
    );
    return rows.isEmpty ? null : rows.first;
  }

  Future<String> _newMemberKey(Session session) async {
    for (var attempt = 0; attempt < 8; attempt++) {
      final key = generateAccessKey();
      final shop = await Shop.db.find(
        session,
        where: (t) => t.accessKey.equals(key),
        limit: 1,
      );
      final member = await WorkspaceMember.db.find(
        session,
        where: (t) => t.accessKey.equals(key),
        limit: 1,
      );
      if (shop.isEmpty && member.isEmpty) return key;
    }
    throw TaktException(
      message: 'Could not allocate a workspace key. Try again.',
    );
  }
}
