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

/// One persisted result of the solver. Times are minutes from horizonStart.
abstract class ScheduleRun
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ScheduleRun._({
    this.id,
    required this.shopId,
    required this.createdAt,
    required this.seed,
    required this.horizonStart,
    required this.onTimeJobs,
    required this.tardyJobs,
    required this.totalTardinessMinutes,
    required this.makespanMinutes,
    required this.objective,
    required this.bottleneckWorkCenterId,
    required this.bottleneckUtilization,
  });

  factory ScheduleRun({
    int? id,
    required int shopId,
    required DateTime createdAt,
    required int seed,
    required DateTime horizonStart,
    required int onTimeJobs,
    required int tardyJobs,
    required int totalTardinessMinutes,
    required int makespanMinutes,
    required double objective,
    required int bottleneckWorkCenterId,
    required double bottleneckUtilization,
  }) = _ScheduleRunImpl;

  factory ScheduleRun.fromJson(Map<String, dynamic> jsonSerialization) {
    return ScheduleRun(
      id: jsonSerialization['id'] as int?,
      shopId: jsonSerialization['shopId'] as int,
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      seed: jsonSerialization['seed'] as int,
      horizonStart: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['horizonStart'],
      ),
      onTimeJobs: jsonSerialization['onTimeJobs'] as int,
      tardyJobs: jsonSerialization['tardyJobs'] as int,
      totalTardinessMinutes: jsonSerialization['totalTardinessMinutes'] as int,
      makespanMinutes: jsonSerialization['makespanMinutes'] as int,
      objective: (jsonSerialization['objective'] as num).toDouble(),
      bottleneckWorkCenterId:
          jsonSerialization['bottleneckWorkCenterId'] as int,
      bottleneckUtilization: (jsonSerialization['bottleneckUtilization'] as num)
          .toDouble(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Owning shop.
  int shopId;

  /// When the run was produced.
  DateTime createdAt;

  /// Seed used, so any run can be reproduced exactly.
  int seed;

  /// Calendar anchor that minute zero maps to.
  DateTime horizonStart;

  /// Jobs that finished on or before their due time.
  int onTimeJobs;

  /// Jobs that finished late.
  int tardyJobs;

  /// Sum of minutes late across all jobs in this run.
  int totalTardinessMinutes;

  /// Time from minute zero until the last operation ends.
  int makespanMinutes;

  /// Solver objective (lower is better).
  double objective;

  /// Work center with the highest utilisation.
  int bottleneckWorkCenterId;

  /// Utilisation of the bottleneck, 0..1+.
  double bottleneckUtilization;

  /// Returns a shallow copy of this [ScheduleRun]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ScheduleRun copyWith({
    int? id,
    int? shopId,
    DateTime? createdAt,
    int? seed,
    DateTime? horizonStart,
    int? onTimeJobs,
    int? tardyJobs,
    int? totalTardinessMinutes,
    int? makespanMinutes,
    double? objective,
    int? bottleneckWorkCenterId,
    double? bottleneckUtilization,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ScheduleRun',
      if (id != null) 'id': id,
      'shopId': shopId,
      'createdAt': createdAt.toJson(),
      'seed': seed,
      'horizonStart': horizonStart.toJson(),
      'onTimeJobs': onTimeJobs,
      'tardyJobs': tardyJobs,
      'totalTardinessMinutes': totalTardinessMinutes,
      'makespanMinutes': makespanMinutes,
      'objective': objective,
      'bottleneckWorkCenterId': bottleneckWorkCenterId,
      'bottleneckUtilization': bottleneckUtilization,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ScheduleRun',
      if (id != null) 'id': id,
      'shopId': shopId,
      'createdAt': createdAt.toJson(),
      'seed': seed,
      'horizonStart': horizonStart.toJson(),
      'onTimeJobs': onTimeJobs,
      'tardyJobs': tardyJobs,
      'totalTardinessMinutes': totalTardinessMinutes,
      'makespanMinutes': makespanMinutes,
      'objective': objective,
      'bottleneckWorkCenterId': bottleneckWorkCenterId,
      'bottleneckUtilization': bottleneckUtilization,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ScheduleRunImpl extends ScheduleRun {
  _ScheduleRunImpl({
    int? id,
    required int shopId,
    required DateTime createdAt,
    required int seed,
    required DateTime horizonStart,
    required int onTimeJobs,
    required int tardyJobs,
    required int totalTardinessMinutes,
    required int makespanMinutes,
    required double objective,
    required int bottleneckWorkCenterId,
    required double bottleneckUtilization,
  }) : super._(
         id: id,
         shopId: shopId,
         createdAt: createdAt,
         seed: seed,
         horizonStart: horizonStart,
         onTimeJobs: onTimeJobs,
         tardyJobs: tardyJobs,
         totalTardinessMinutes: totalTardinessMinutes,
         makespanMinutes: makespanMinutes,
         objective: objective,
         bottleneckWorkCenterId: bottleneckWorkCenterId,
         bottleneckUtilization: bottleneckUtilization,
       );

  /// Returns a shallow copy of this [ScheduleRun]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ScheduleRun copyWith({
    Object? id = _Undefined,
    int? shopId,
    DateTime? createdAt,
    int? seed,
    DateTime? horizonStart,
    int? onTimeJobs,
    int? tardyJobs,
    int? totalTardinessMinutes,
    int? makespanMinutes,
    double? objective,
    int? bottleneckWorkCenterId,
    double? bottleneckUtilization,
  }) {
    return ScheduleRun(
      id: id is int? ? id : this.id,
      shopId: shopId ?? this.shopId,
      createdAt: createdAt ?? this.createdAt,
      seed: seed ?? this.seed,
      horizonStart: horizonStart ?? this.horizonStart,
      onTimeJobs: onTimeJobs ?? this.onTimeJobs,
      tardyJobs: tardyJobs ?? this.tardyJobs,
      totalTardinessMinutes:
          totalTardinessMinutes ?? this.totalTardinessMinutes,
      makespanMinutes: makespanMinutes ?? this.makespanMinutes,
      objective: objective ?? this.objective,
      bottleneckWorkCenterId:
          bottleneckWorkCenterId ?? this.bottleneckWorkCenterId,
      bottleneckUtilization:
          bottleneckUtilization ?? this.bottleneckUtilization,
    );
  }
}
