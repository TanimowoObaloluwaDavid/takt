/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:serverpod_client/serverpod_client.dart' as _isc;

/// A revocable browser session. The raw token is returned once to the
/// client; only its SHA-256 hash is stored here.
abstract class UserSession
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  UserSession._({
    this.id,
    required this.userId,
    required this.tokenHash,
    required this.createdAt,
    required this.expiresAt,
    required this.lastSeenAt,
  });

  factory UserSession({
    int? id,
    required int userId,
    required String tokenHash,
    required DateTime createdAt,
    required DateTime expiresAt,
    required DateTime lastSeenAt,
  }) = _UserSessionImpl;

  factory UserSession.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserSession(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      tokenHash: jsonSerialization['tokenHash'] as String,
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      expiresAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
      lastSeenAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['lastSeenAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Account this session belongs to.
  int userId;

  /// SHA-256 hex digest of the raw session token.
  String tokenHash;

  /// When the session was issued.
  DateTime createdAt;

  /// Hard expiry. Sessions are not refreshed indefinitely.
  DateTime expiresAt;

  /// Last time the session was used to load the account.
  DateTime lastSeenAt;

  /// Returns a shallow copy of this [UserSession]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  UserSession copyWith({
    int? id,
    int? userId,
    String? tokenHash,
    DateTime? createdAt,
    DateTime? expiresAt,
    DateTime? lastSeenAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserSession',
      if (id != null) 'id': id,
      'userId': userId,
      'tokenHash': tokenHash,
      'createdAt': createdAt.toJson(),
      'expiresAt': expiresAt.toJson(),
      'lastSeenAt': lastSeenAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UserSession',
      if (id != null) 'id': id,
      'userId': userId,
      'tokenHash': tokenHash,
      'createdAt': createdAt.toJson(),
      'expiresAt': expiresAt.toJson(),
      'lastSeenAt': lastSeenAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserSessionImpl extends UserSession {
  _UserSessionImpl({
    int? id,
    required int userId,
    required String tokenHash,
    required DateTime createdAt,
    required DateTime expiresAt,
    required DateTime lastSeenAt,
  }) : super._(
         id: id,
         userId: userId,
         tokenHash: tokenHash,
         createdAt: createdAt,
         expiresAt: expiresAt,
         lastSeenAt: lastSeenAt,
       );

  /// Returns a shallow copy of this [UserSession]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  UserSession copyWith({
    Object? id = _Undefined,
    int? userId,
    String? tokenHash,
    DateTime? createdAt,
    DateTime? expiresAt,
    DateTime? lastSeenAt,
  }) {
    return UserSession(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      tokenHash: tokenHash ?? this.tokenHash,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
    );
  }
}
