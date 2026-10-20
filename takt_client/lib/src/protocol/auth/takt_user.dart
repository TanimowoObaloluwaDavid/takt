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

/// A person with a Takt account. Passwords are stored only as Argon2id
/// hashes; this row never leaves the server with its password hash.
abstract class TaktUser
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  TaktUser._({
    this.id,
    required this.email,
    required this.displayName,
    required this.passwordHash,
    required this.createdAt,
  });

  factory TaktUser({
    int? id,
    required String email,
    required String displayName,
    required String passwordHash,
    required DateTime createdAt,
  }) = _TaktUserImpl;

  factory TaktUser.fromJson(Map<String, dynamic> jsonSerialization) {
    return TaktUser(
      id: jsonSerialization['id'] as int?,
      email: jsonSerialization['email'] as String,
      displayName: jsonSerialization['displayName'] as String,
      passwordHash: jsonSerialization['passwordHash'] as String,
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Normalized (lower-case) sign-in address.
  String email;

  /// Name shown in the team list.
  String displayName;

  /// Argon2id PHC hash. Never returned by an endpoint.
  String passwordHash;

  /// When the account was created.
  DateTime createdAt;

  /// Returns a shallow copy of this [TaktUser]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  TaktUser copyWith({
    int? id,
    String? email,
    String? displayName,
    String? passwordHash,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TaktUser',
      if (id != null) 'id': id,
      'email': email,
      'displayName': displayName,
      'passwordHash': passwordHash,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TaktUser',
      if (id != null) 'id': id,
      'email': email,
      'displayName': displayName,
      'passwordHash': passwordHash,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TaktUserImpl extends TaktUser {
  _TaktUserImpl({
    int? id,
    required String email,
    required String displayName,
    required String passwordHash,
    required DateTime createdAt,
  }) : super._(
         id: id,
         email: email,
         displayName: displayName,
         passwordHash: passwordHash,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [TaktUser]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  TaktUser copyWith({
    Object? id = _Undefined,
    String? email,
    String? displayName,
    String? passwordHash,
    DateTime? createdAt,
  }) {
    return TaktUser(
      id: id is int? ? id : this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      passwordHash: passwordHash ?? this.passwordHash,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
