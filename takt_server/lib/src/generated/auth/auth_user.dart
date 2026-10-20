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

/// Public account information. Never includes a password hash.
abstract class AuthUser
    implements _is.SerializableModel, _is.ProtocolSerialization {
  AuthUser._({
    required this.id,
    required this.email,
    required this.displayName,
    required this.createdAt,
  });

  factory AuthUser({
    required int id,
    required String email,
    required String displayName,
    required DateTime createdAt,
  }) = _AuthUserImpl;

  factory AuthUser.fromJson(Map<String, dynamic> jsonSerialization) {
    return AuthUser(
      id: jsonSerialization['id'] as int,
      email: jsonSerialization['email'] as String,
      displayName: jsonSerialization['displayName'] as String,
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// Account id.
  int id;

  /// Normalized email.
  String email;

  /// Display name.
  String displayName;

  /// When the account was created.
  DateTime createdAt;

  /// Returns a shallow copy of this [AuthUser]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AuthUser copyWith({
    int? id,
    String? email,
    String? displayName,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AuthUser',
      'id': id,
      'email': email,
      'displayName': displayName,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AuthUser',
      'id': id,
      'email': email,
      'displayName': displayName,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _AuthUserImpl extends AuthUser {
  _AuthUserImpl({
    required int id,
    required String email,
    required String displayName,
    required DateTime createdAt,
  }) : super._(
         id: id,
         email: email,
         displayName: displayName,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AuthUser]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AuthUser copyWith({
    int? id,
    String? email,
    String? displayName,
    DateTime? createdAt,
  }) {
    return AuthUser(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
