import 'package:serverpod/serverpod.dart';

import '../access/access.dart';
import '../generated/protocol.dart';
import 'passwords.dart';

/// The authenticated account behind a session token.
class UserAccess {
  UserAccess(this.user, this.session);
  final TaktUser user;
  final UserSession session;
}

const sessionLifetime = Duration(days: 30);

AuthUser publicUser(TaktUser user) => AuthUser(
  id: user.id!,
  email: user.email,
  displayName: user.displayName,
  createdAt: user.createdAt,
);

/// Resolves a raw session token. Only the SHA-256 digest is stored.
Future<UserAccess> requireUser(Session session, String rawToken) async {
  final token = rawToken.trim();
  if (token.isEmpty) {
    throw TaktException(message: 'Sign in to continue.');
  }

  final rows = await UserSession.db.find(
    session,
    where: (t) => t.tokenHash.equals(hashToken(token)),
    limit: 1,
  );
  if (rows.isEmpty) {
    throw TaktException(message: 'Your session has expired. Sign in again.');
  }

  final userSession = rows.first;
  final now = DateTime.now();
  if (!userSession.expiresAt.isAfter(now)) {
    await UserSession.db.deleteWhere(
      session,
      where: (t) => t.id.equals(userSession.id!),
    );
    throw TaktException(message: 'Your session has expired. Sign in again.');
  }

  final users = await TaktUser.db.find(
    session,
    where: (t) => t.id.equals(userSession.userId),
    limit: 1,
  );
  if (users.isEmpty) {
    await UserSession.db.deleteWhere(
      session,
      where: (t) => t.id.equals(userSession.id!),
    );
    throw TaktException(message: 'That account no longer exists.');
  }

  // Avoid a write on every request; one timestamp per hour is enough for
  // session hygiene and keeps reads cheap.
  if (now.difference(userSession.lastSeenAt) > const Duration(hours: 1)) {
    userSession.lastSeenAt = now;
    await UserSession.db.update(session, [userSession]);
  }

  return UserAccess(users.first, userSession);
}

Future<String> issueSession(Session session, int userId) async {
  final token = generateSessionToken();
  final now = DateTime.now();
  await UserSession.db.insert(session, [
    UserSession(
      userId: userId,
      tokenHash: hashToken(token),
      createdAt: now,
      expiresAt: now.add(sessionLifetime),
      lastSeenAt: now,
    ),
  ]);
  return token;
}

Future<void> revokeSession(Session session, String rawToken) async {
  final token = rawToken.trim();
  if (token.isEmpty) return;
  await UserSession.db.deleteWhere(
    session,
    where: (t) => t.tokenHash.equals(hashToken(token)),
  );
}

Future<void> revokeOtherSessions(
  Session session,
  int userId,
  String currentToken,
) async {
  final currentHash = hashToken(currentToken);
  await UserSession.db.deleteWhere(
    session,
    where: (t) => t.userId.equals(userId) & t.tokenHash.notEquals(currentHash),
  );
}

/// Every workspace this account can open, with the key scoped to its role.
Future<List<WorkspaceAccess>> listWorkspaceAccess(
  Session session,
  int userId,
) async {
  final memberships = await WorkspaceMember.db.find(
    session,
    where: (t) => t.userId.equals(userId),
  );
  if (memberships.isEmpty) return const [];

  final shopIds = memberships.map((m) => m.shopId).toSet();
  final shops = await Shop.db.find(
    session,
    where: (t) => t.id.inSet(shopIds),
  );
  final byId = {for (final shop in shops) shop.id!: shop};

  final result = <WorkspaceAccess>[];
  for (final member in memberships) {
    final shop = byId[member.shopId];
    if (shop == null) continue;
    result.add(
      WorkspaceAccess(
        shopId: shop.id!,
        name: shop.name,
        currency: shop.currency,
        role: member.role,
        // The owner's full-access key lives on the shop. Members get the
        // scoped key that the owner (or an invitation) issued to them.
        accessKey: member.role == roleOwner ? shop.accessKey : member.accessKey,
        createdAt: shop.createdAt,
      ),
    );
  }
  result.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  return result;
}

MemberInfo memberInfo(
  WorkspaceMember member,
  TaktUser user, {
  required bool revealKey,
}) => MemberInfo(
  userId: user.id!,
  email: user.email,
  displayName: user.displayName,
  role: member.role,
  accessKey: revealKey ? member.accessKey : '',
  createdAt: member.createdAt,
);
