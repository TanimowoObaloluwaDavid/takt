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

/// One workspace as seen by one signed-in person, including the scoped
/// key that browser should use for this workspace and its role.
abstract class WorkspaceAccess
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  WorkspaceAccess._({
    required this.shopId,
    required this.name,
    required this.currency,
    required this.role,
    required this.accessKey,
    required this.createdAt,
  });

  factory WorkspaceAccess({
    required int shopId,
    required String name,
    required String currency,
    required String role,
    required String accessKey,
    required DateTime createdAt,
  }) = _WorkspaceAccessImpl;

  factory WorkspaceAccess.fromJson(Map<String, dynamic> jsonSerialization) {
    return WorkspaceAccess(
      shopId: jsonSerialization['shopId'] as int,
      name: jsonSerialization['name'] as String,
      currency: jsonSerialization['currency'] as String,
      role: jsonSerialization['role'] as String,
      accessKey: jsonSerialization['accessKey'] as String,
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// Workspace id.
  int shopId;

  /// Workspace name.
  String name;

  /// Display currency.
  String currency;

  /// owner, editor, or viewer.
  String role;

  /// Scoped bearer key. The owner receives the full-access shop key.
  String accessKey;

  /// When the workspace was created.
  DateTime createdAt;

  /// Returns a shallow copy of this [WorkspaceAccess]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  WorkspaceAccess copyWith({
    int? shopId,
    String? name,
    String? currency,
    String? role,
    String? accessKey,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WorkspaceAccess',
      'shopId': shopId,
      'name': name,
      'currency': currency,
      'role': role,
      'accessKey': accessKey,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'WorkspaceAccess',
      'shopId': shopId,
      'name': name,
      'currency': currency,
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

class _WorkspaceAccessImpl extends WorkspaceAccess {
  _WorkspaceAccessImpl({
    required int shopId,
    required String name,
    required String currency,
    required String role,
    required String accessKey,
    required DateTime createdAt,
  }) : super._(
         shopId: shopId,
         name: name,
         currency: currency,
         role: role,
         accessKey: accessKey,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [WorkspaceAccess]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  WorkspaceAccess copyWith({
    int? shopId,
    String? name,
    String? currency,
    String? role,
    String? accessKey,
    DateTime? createdAt,
  }) {
    return WorkspaceAccess(
      shopId: shopId ?? this.shopId,
      name: name ?? this.name,
      currency: currency ?? this.currency,
      role: role ?? this.role,
      accessKey: accessKey ?? this.accessKey,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
