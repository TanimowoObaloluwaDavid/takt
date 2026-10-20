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

/// A placed operation on a specific machine.
abstract class ScheduledOp
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ScheduledOp._({
    this.id,
    required this.runId,
    required this.jobId,
    required this.operationId,
    required this.workCenterId,
    required this.machineIndex,
    required this.startMinute,
    required this.endMinute,
    required this.queueMinutes,
    required this.changeoverMinutes,
    required this.sequenceOnMachine,
    required this.isTardy,
  });

  factory ScheduledOp({
    int? id,
    required int runId,
    required int jobId,
    required int operationId,
    required int workCenterId,
    required int machineIndex,
    required int startMinute,
    required int endMinute,
    required int queueMinutes,
    required int changeoverMinutes,
    required int sequenceOnMachine,
    required bool isTardy,
  }) = _ScheduledOpImpl;

  factory ScheduledOp.fromJson(Map<String, dynamic> jsonSerialization) {
    return ScheduledOp(
      id: jsonSerialization['id'] as int?,
      runId: jsonSerialization['runId'] as int,
      jobId: jsonSerialization['jobId'] as int,
      operationId: jsonSerialization['operationId'] as int,
      workCenterId: jsonSerialization['workCenterId'] as int,
      machineIndex: jsonSerialization['machineIndex'] as int,
      startMinute: jsonSerialization['startMinute'] as int,
      endMinute: jsonSerialization['endMinute'] as int,
      queueMinutes: jsonSerialization['queueMinutes'] as int,
      changeoverMinutes: jsonSerialization['changeoverMinutes'] as int,
      sequenceOnMachine: jsonSerialization['sequenceOnMachine'] as int,
      isTardy: _isc.BoolJsonExtension.fromJson(jsonSerialization['isTardy']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Owning run.
  int runId;

  /// Job this operation belongs to.
  int jobId;

  /// Source operation.
  int operationId;

  /// Work center used.
  int workCenterId;

  /// Index of the parallel machine inside the work center.
  int machineIndex;

  /// Start minute relative to the run horizon.
  int startMinute;

  /// End minute relative to the run horizon.
  int endMinute;

  /// Minutes this operation waited for its machine.
  int queueMinutes;

  /// Changeover minutes charged before this operation.
  int changeoverMinutes;

  /// Position on this machine, starting at zero.
  int sequenceOnMachine;

  /// Whether the parent job finishes after its due time.
  bool isTardy;

  /// Returns a shallow copy of this [ScheduledOp]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ScheduledOp copyWith({
    int? id,
    int? runId,
    int? jobId,
    int? operationId,
    int? workCenterId,
    int? machineIndex,
    int? startMinute,
    int? endMinute,
    int? queueMinutes,
    int? changeoverMinutes,
    int? sequenceOnMachine,
    bool? isTardy,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ScheduledOp',
      if (id != null) 'id': id,
      'runId': runId,
      'jobId': jobId,
      'operationId': operationId,
      'workCenterId': workCenterId,
      'machineIndex': machineIndex,
      'startMinute': startMinute,
      'endMinute': endMinute,
      'queueMinutes': queueMinutes,
      'changeoverMinutes': changeoverMinutes,
      'sequenceOnMachine': sequenceOnMachine,
      'isTardy': isTardy,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ScheduledOp',
      if (id != null) 'id': id,
      'runId': runId,
      'jobId': jobId,
      'operationId': operationId,
      'workCenterId': workCenterId,
      'machineIndex': machineIndex,
      'startMinute': startMinute,
      'endMinute': endMinute,
      'queueMinutes': queueMinutes,
      'changeoverMinutes': changeoverMinutes,
      'sequenceOnMachine': sequenceOnMachine,
      'isTardy': isTardy,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ScheduledOpImpl extends ScheduledOp {
  _ScheduledOpImpl({
    int? id,
    required int runId,
    required int jobId,
    required int operationId,
    required int workCenterId,
    required int machineIndex,
    required int startMinute,
    required int endMinute,
    required int queueMinutes,
    required int changeoverMinutes,
    required int sequenceOnMachine,
    required bool isTardy,
  }) : super._(
         id: id,
         runId: runId,
         jobId: jobId,
         operationId: operationId,
         workCenterId: workCenterId,
         machineIndex: machineIndex,
         startMinute: startMinute,
         endMinute: endMinute,
         queueMinutes: queueMinutes,
         changeoverMinutes: changeoverMinutes,
         sequenceOnMachine: sequenceOnMachine,
         isTardy: isTardy,
       );

  /// Returns a shallow copy of this [ScheduledOp]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ScheduledOp copyWith({
    Object? id = _Undefined,
    int? runId,
    int? jobId,
    int? operationId,
    int? workCenterId,
    int? machineIndex,
    int? startMinute,
    int? endMinute,
    int? queueMinutes,
    int? changeoverMinutes,
    int? sequenceOnMachine,
    bool? isTardy,
  }) {
    return ScheduledOp(
      id: id is int? ? id : this.id,
      runId: runId ?? this.runId,
      jobId: jobId ?? this.jobId,
      operationId: operationId ?? this.operationId,
      workCenterId: workCenterId ?? this.workCenterId,
      machineIndex: machineIndex ?? this.machineIndex,
      startMinute: startMinute ?? this.startMinute,
      endMinute: endMinute ?? this.endMinute,
      queueMinutes: queueMinutes ?? this.queueMinutes,
      changeoverMinutes: changeoverMinutes ?? this.changeoverMinutes,
      sequenceOnMachine: sequenceOnMachine ?? this.sequenceOnMachine,
      isTardy: isTardy ?? this.isTardy,
    );
  }
}
