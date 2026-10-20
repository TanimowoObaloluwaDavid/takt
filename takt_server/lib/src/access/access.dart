import 'dart:math';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Thrown for anything the caller can fix: a bad key, missing data, or an
/// impossible request. Kept top-level so Serverpod can serialize it.
class WorkspaceException implements Exception {
  WorkspaceException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Resolves the workspace from its bearer key.
///
/// The key is the only credential in this build. Every endpoint goes through
/// here, so no query can reach another shop's rows.
Future<Shop> requireShop(Session session, String accessKey) async {
  final key = accessKey.trim();
  if (key.isEmpty) {
    throw WorkspaceException('A workspace key is required.');
  }

  final rows = await Shop.db.find(
    session,
    where: (t) => t.accessKey.equals(key),
    limit: 1,
  );

  if (rows.isEmpty) {
    throw WorkspaceException('That workspace key does not exist.');
  }
  return rows.first;
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
