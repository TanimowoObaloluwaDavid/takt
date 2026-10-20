import 'dart:math';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

export '../generated/protocol.dart' show TaktException;

const roleOwner = 'owner';
const roleEditor = 'editor';
const roleViewer = 'viewer';
const validRoles = {roleOwner, roleEditor, roleViewer};

bool roleCanWrite(String role) => role == roleOwner || role == roleEditor;

String roleLabel(String role) => switch (role) {
  roleOwner => 'Owner',
  roleEditor => 'Editor',
  roleViewer => 'Viewer',
  _ => role,
};

/// The shop plus the authority of the key that reached it.
class ShopAccess {
  const ShopAccess({
    required this.shop,
    required this.role,
    required this.isOwnerKey,
  });

  final Shop shop;
  final String role;

  /// True when the caller used the shop's full-access key, not a membership
  /// key. Owner keys are deliberately not role-limited.
  final bool isOwnerKey;

  bool get isOwner => role == roleOwner;
  bool get canWrite => roleCanWrite(role);

  /// Never hand a member key holder the owner's full-access key.
  Shop get visibleShop => isOwner ? shop : shop.copyWith(accessKey: '');
}

/// Resolves a workspace from a scoped key and enforces the role.
///
/// The shop's original key is the owner credential and keeps full access.
/// Membership keys can be editor (read/write) or viewer (read only). Every
/// write endpoint must pass [write] so a viewer cannot mutate the shop even
/// if they call the API directly.
Future<ShopAccess> requireShop(
  Session session,
  String credential, {
  bool write = false,
}) async {
  final key = credential.trim();
  if (key.isEmpty) {
    throw TaktException(message: 'A workspace key is required.');
  }

  final shops = await Shop.db.find(
    session,
    where: (t) => t.accessKey.equals(key),
    limit: 1,
  );
  if (shops.isNotEmpty) {
    return ShopAccess(
      shop: shops.first,
      role: roleOwner,
      isOwnerKey: true,
    );
  }

  final memberships = await WorkspaceMember.db.find(
    session,
    where: (t) => t.accessKey.equals(key),
    limit: 1,
  );
  if (memberships.isEmpty) {
    throw TaktException(message: 'That workspace key does not exist.');
  }

  final member = memberships.first;
  if (!validRoles.contains(member.role)) {
    throw TaktException(
      message:
          'This workspace membership is invalid. Ask the owner to reset it.',
    );
  }
  final memberShops = await Shop.db.find(
    session,
    where: (t) => t.id.equals(member.shopId),
    limit: 1,
  );
  if (memberShops.isEmpty) {
    throw TaktException(message: 'That workspace no longer exists.');
  }
  if (write && !roleCanWrite(member.role)) {
    throw TaktException(
      message: 'This key is view-only. Ask the owner for editor access.',
    );
  }

  return ShopAccess(
    shop: memberShops.first,
    role: member.role,
    isOwnerKey: false,
  );
}

const _keyAlphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

/// 20 characters from a 32-symbol alphabet, about 100 bits of entropy.
String generateAccessKey() {
  final random = Random.secure();
  final chars = List<String>.generate(
    20,
    (_) => _keyAlphabet[random.nextInt(_keyAlphabet.length)],
  );
  return '${chars.sublist(0, 5).join()}-'
      '${chars.sublist(5, 10).join()}-'
      '${chars.sublist(10, 15).join()}-'
      '${chars.sublist(15, 20).join()}';
}
