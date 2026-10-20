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

/// One step in a job's routing. Operations run in ascending sequence.
abstract class Operation
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Operation._({
    this.id,
    required this.jobId,
    required this.sequence,
    required this.workCenterId,
    required this.setupMinutes,
    required this.unitRunMinutes,
    required this.description,
  });

  factory Operation({
    int? id,
    required int jobId,
    required int sequence,
    required int workCenterId,
    required int setupMinutes,
    required double unitRunMinutes,
    required String description,
  }) = _OperationImpl;

  factory Operation.fromJson(Map<String, dynamic> jsonSerialization) {
    return Operation(
      id: jsonSerialization['id'] as int?,
      jobId: jsonSerialization['jobId'] as int,
      sequence: jsonSerialization['sequence'] as int,
      workCenterId: jsonSerialization['workCenterId'] as int,
      setupMinutes: jsonSerialization['setupMinutes'] as int,
      unitRunMinutes: (jsonSerialization['unitRunMinutes'] as num).toDouble(),
      description: jsonSerialization['description'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Owning job.
  int jobId;

  /// Position in the routing, starting at 10 and stepping by 10.
  int sequence;

  /// Work center that performs this step.
  int workCenterId;

  /// Fixed setup time for this step.
  int setupMinutes;

  /// Run time per unit, in minutes.
  double unitRunMinutes;

  /// What happens at this step.
  String description;

  /// Returns a shallow copy of this [Operation]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Operation copyWith({
    int? id,
    int? jobId,
    int? sequence,
    int? workCenterId,
    int? setupMinutes,
    double? unitRunMinutes,
    String? description,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Operation',
      if (id != null) 'id': id,
      'jobId': jobId,
      'sequence': sequence,
      'workCenterId': workCenterId,
      'setupMinutes': setupMinutes,
      'unitRunMinutes': unitRunMinutes,
      'description': description,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Operation',
      if (id != null) 'id': id,
      'jobId': jobId,
      'sequence': sequence,
      'workCenterId': workCenterId,
      'setupMinutes': setupMinutes,
      'unitRunMinutes': unitRunMinutes,
      'description': description,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OperationImpl extends Operation {
  _OperationImpl({
    int? id,
    required int jobId,
    required int sequence,
    required int workCenterId,
    required int setupMinutes,
    required double unitRunMinutes,
    required String description,
  }) : super._(
         id: id,
         jobId: jobId,
         sequence: sequence,
         workCenterId: workCenterId,
         setupMinutes: setupMinutes,
         unitRunMinutes: unitRunMinutes,
         description: description,
       );

  /// Returns a shallow copy of this [Operation]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Operation copyWith({
    Object? id = _Undefined,
    int? jobId,
    int? sequence,
    int? workCenterId,
    int? setupMinutes,
    double? unitRunMinutes,
    String? description,
  }) {
    return Operation(
      id: id is int? ? id : this.id,
      jobId: jobId ?? this.jobId,
      sequence: sequence ?? this.sequence,
      workCenterId: workCenterId ?? this.workCenterId,
      setupMinutes: setupMinutes ?? this.setupMinutes,
      unitRunMinutes: unitRunMinutes ?? this.unitRunMinutes,
      description: description ?? this.description,
    );
  }
}
