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

/// Links an account to a workspace with a role and a scoped access key.
/// The key is a bearer credential, so it is stored as a secret and only
/// shown to the owner (who can already access everything).
abstract class WorkspaceMember
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  WorkspaceMember._({
    this.id,
    required this.shopId,
    required this.userId,
    required this.role,
    required this.accessKey,
    required this.createdAt,
  });

  factory WorkspaceMember({
    int? id,
    required int shopId,
    required int userId,
    required String role,
    required String accessKey,
    required DateTime createdAt,
  }) = _WorkspaceMemberImpl;

  factory WorkspaceMember.fromJson(Map<String, dynamic> jsonSerialization) {
    return WorkspaceMember(
      id: jsonSerialization['id'] as int?,
      shopId: jsonSerialization['shopId'] as int,
      userId: jsonSerialization['userId'] as int,
      role: jsonSerialization['role'] as String,
      accessKey: jsonSerialization['accessKey'] as String,
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Workspace this membership belongs to.
  int shopId;

  /// Account that owns the membership.
  int userId;

  /// owner, editor, or viewer. Validated server-side.
  String role;

  /// Scoped workspace key. The owner's membership reuses the shop key.
  String accessKey;

  /// When the person joined.
  DateTime createdAt;

  /// Returns a shallow copy of this [WorkspaceMember]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  WorkspaceMember copyWith({
    int? id,
    int? shopId,
    int? userId,
    String? role,
    String? accessKey,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WorkspaceMember',
      if (id != null) 'id': id,
      'shopId': shopId,
      'userId': userId,
      'role': role,
      'accessKey': accessKey,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'WorkspaceMember',
      if (id != null) 'id': id,
      'shopId': shopId,
      'userId': userId,
      'role': role,
      'accessKey': accessKey,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WorkspaceMemberImpl extends WorkspaceMember {
  _WorkspaceMemberImpl({
    int? id,
    required int shopId,
    required int userId,
    required String role,
    required String accessKey,
    required DateTime createdAt,
  }) : super._(
         id: id,
         shopId: shopId,
         userId: userId,
         role: role,
         accessKey: accessKey,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [WorkspaceMember]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  WorkspaceMember copyWith({
    Object? id = _Undefined,
    int? shopId,
    int? userId,
    String? role,
    String? accessKey,
    DateTime? createdAt,
  }) {
    return WorkspaceMember(
      id: id is int? ? id : this.id,
      shopId: shopId ?? this.shopId,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      accessKey: accessKey ?? this.accessKey,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
