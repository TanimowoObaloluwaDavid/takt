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

import 'package:serverpod/serverpod.dart' as _is;

/// A person in a workspace. The scoped key is exposed only to the owner,
/// who can already grant or revoke access.
abstract class MemberInfo
    implements _is.SerializableModel, _is.ProtocolSerialization {
  MemberInfo._({
    required this.userId,
    required this.email,
    required this.displayName,
    required this.role,
    required this.accessKey,
    required this.createdAt,
  });

  factory MemberInfo({
    required int userId,
    required String email,
    required String displayName,
    required String role,
    required String accessKey,
    required DateTime createdAt,
  }) = _MemberInfoImpl;

  factory MemberInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return MemberInfo(
      userId: jsonSerialization['userId'] as int,
      email: jsonSerialization['email'] as String,
      displayName: jsonSerialization['displayName'] as String,
      role: jsonSerialization['role'] as String,
      accessKey: jsonSerialization['accessKey'] as String,
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// Account id.
  int userId;

  /// Sign-in address.
  String email;

  /// Display name.
  String displayName;

  /// owner, editor, or viewer.
  String role;

  /// Scoped key for this member; blank when the caller is not the owner.
  String accessKey;

  /// When the person joined.
  DateTime createdAt;

  /// Returns a shallow copy of this [MemberInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  MemberInfo copyWith({
    int? userId,
    String? email,
    String? displayName,
    String? role,
    String? accessKey,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MemberInfo',
      'userId': userId,
      'email': email,
      'displayName': displayName,
      'role': role,
      'accessKey': accessKey,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MemberInfo',
      'userId': userId,
      'email': email,
      'displayName': displayName,
      'role': role,
      'accessKey': accessKey,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _MemberInfoImpl extends MemberInfo {
  _MemberInfoImpl({
    required int userId,
    required String email,
    required String displayName,
    required String role,
    required String accessKey,
    required DateTime createdAt,
  }) : super._(
         userId: userId,
         email: email,
         displayName: displayName,
         role: role,
         accessKey: accessKey,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [MemberInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  MemberInfo copyWith({
    int? userId,
    String? email,
    String? displayName,
    String? role,
    String? accessKey,
    DateTime? createdAt,
  }) {
    return MemberInfo(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      accessKey: accessKey ?? this.accessKey,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
