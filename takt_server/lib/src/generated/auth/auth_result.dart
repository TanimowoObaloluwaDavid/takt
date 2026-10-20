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
import 'package:takt_server/src/generated/protocol.dart' as _i4q4669s;
import '../auth/auth_user.dart' as _irg5n67k;
import '../auth/workspace_access.dart' as _ii9ndy3s;

/// The result of creating an account or signing in. The session token is
/// for account/workspace management; each workspace carries its own scoped
/// key for data calls.
abstract class AuthResult
    implements _is.SerializableModel, _is.ProtocolSerialization {
  AuthResult._({
    required this.token,
    required this.user,
    required this.workspaces,
  });

  factory AuthResult({
    required String token,
    required _irg5n67k.AuthUser user,
    required List<_ii9ndy3s.WorkspaceAccess> workspaces,
  }) = _AuthResultImpl;

  factory AuthResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return AuthResult(
      token: jsonSerialization['token'] as String,
      user: _i4q4669s.Protocol().deserialize<_irg5n67k.AuthUser>(
        jsonSerialization['user'],
      ),
      workspaces: _i4q4669s.Protocol()
          .deserialize<List<_ii9ndy3s.WorkspaceAccess>>(
            jsonSerialization['workspaces'],
          ),
    );
  }

  /// Raw session token. Store it only on the client, never log it.
  String token;

  /// Public account details.
  _irg5n67k.AuthUser user;

  /// Every workspace this account can open.
  List<_ii9ndy3s.WorkspaceAccess> workspaces;

  /// Returns a shallow copy of this [AuthResult]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AuthResult copyWith({
    String? token,
    _irg5n67k.AuthUser? user,
    List<_ii9ndy3s.WorkspaceAccess>? workspaces,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AuthResult',
      'token': token,
      'user': user.toJson(),
      'workspaces': workspaces.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AuthResult',
      'token': token,
      'user': user.toJsonForProtocol(),
      'workspaces': workspaces.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _AuthResultImpl extends AuthResult {
  _AuthResultImpl({
    required String token,
    required _irg5n67k.AuthUser user,
    required List<_ii9ndy3s.WorkspaceAccess> workspaces,
  }) : super._(
         token: token,
         user: user,
         workspaces: workspaces,
       );

  /// Returns a shallow copy of this [AuthResult]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AuthResult copyWith({
    String? token,
    _irg5n67k.AuthUser? user,
    List<_ii9ndy3s.WorkspaceAccess>? workspaces,
  }) {
    return AuthResult(
      token: token ?? this.token,
      user: user ?? this.user.copyWith(),
      workspaces:
          workspaces ?? this.workspaces.map((e0) => e0.copyWith()).toList(),
    );
  }
}
