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

/// A group of identical parallel machines that can perform an operation.
abstract class WorkCenter
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  WorkCenter._({
    this.id,
    required this.shopId,
    required this.name,
    required this.code,
    required this.machines,
    required this.changeoverMinutes,
    required this.notes,
  });

  factory WorkCenter({
    int? id,
    required int shopId,
    required String name,
    required String code,
    required int machines,
    required int changeoverMinutes,
    required String notes,
  }) = _WorkCenterImpl;

  factory WorkCenter.fromJson(Map<String, dynamic> jsonSerialization) {
    return WorkCenter(
      id: jsonSerialization['id'] as int?,
      shopId: jsonSerialization['shopId'] as int,
      name: jsonSerialization['name'] as String,
      code: jsonSerialization['code'] as String,
      machines: jsonSerialization['machines'] as int,
      changeoverMinutes: jsonSerialization['changeoverMinutes'] as int,
      notes: jsonSerialization['notes'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Owning shop.
  int shopId;

  /// Human name, e.g. "CNC Mill 2".
  String name;

  /// Short code shown on the schedule, e.g. "CNC-02".
  String code;

  /// Number of identical machines in this work center.
  int machines;

  /// Flat changeover time when the machine switches to a different job.
  int changeoverMinutes;

  /// Optional note about capability or crew.
  String notes;

  /// Returns a shallow copy of this [WorkCenter]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  WorkCenter copyWith({
    int? id,
    int? shopId,
    String? name,
    String? code,
    int? machines,
    int? changeoverMinutes,
    String? notes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WorkCenter',
      if (id != null) 'id': id,
      'shopId': shopId,
      'name': name,
      'code': code,
      'machines': machines,
      'changeoverMinutes': changeoverMinutes,
      'notes': notes,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'WorkCenter',
      if (id != null) 'id': id,
      'shopId': shopId,
      'name': name,
      'code': code,
      'machines': machines,
      'changeoverMinutes': changeoverMinutes,
      'notes': notes,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WorkCenterImpl extends WorkCenter {
  _WorkCenterImpl({
    int? id,
    required int shopId,
    required String name,
    required String code,
    required int machines,
    required int changeoverMinutes,
    required String notes,
  }) : super._(
         id: id,
         shopId: shopId,
         name: name,
         code: code,
         machines: machines,
         changeoverMinutes: changeoverMinutes,
         notes: notes,
       );

  /// Returns a shallow copy of this [WorkCenter]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  WorkCenter copyWith({
    Object? id = _Undefined,
    int? shopId,
    String? name,
    String? code,
    int? machines,
    int? changeoverMinutes,
    String? notes,
  }) {
    return WorkCenter(
      id: id is int? ? id : this.id,
      shopId: shopId ?? this.shopId,
      name: name ?? this.name,
      code: code ?? this.code,
      machines: machines ?? this.machines,
      changeoverMinutes: changeoverMinutes ?? this.changeoverMinutes,
      notes: notes ?? this.notes,
    );
  }
}
