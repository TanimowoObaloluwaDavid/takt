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
import 'package:takt_client/src/protocol/protocol.dart' as _i93te42s;
import '../shop/job_diagnosis.dart' as _ipfdqm72;

/// The whole shop's verdict for one run.
abstract class ShopDiagnosis
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ShopDiagnosis._({
    required this.runId,
    required this.onTimeJobs,
    required this.tardyJobs,
    required this.totalTardinessMinutes,
    required this.makespanMinutes,
    required this.bottleneckWorkCenterId,
    required this.bottleneckWorkCenterName,
    required this.bottleneckUtilization,
    required this.bottleneckQueueMinutes,
    required this.jobs,
  });

  factory ShopDiagnosis({
    required int runId,
    required int onTimeJobs,
    required int tardyJobs,
    required int totalTardinessMinutes,
    required int makespanMinutes,
    required int bottleneckWorkCenterId,
    required String bottleneckWorkCenterName,
    required double bottleneckUtilization,
    required int bottleneckQueueMinutes,
    required List<_ipfdqm72.JobDiagnosis> jobs,
  }) = _ShopDiagnosisImpl;

  factory ShopDiagnosis.fromJson(Map<String, dynamic> jsonSerialization) {
    return ShopDiagnosis(
      runId: jsonSerialization['runId'] as int,
      onTimeJobs: jsonSerialization['onTimeJobs'] as int,
      tardyJobs: jsonSerialization['tardyJobs'] as int,
      totalTardinessMinutes: jsonSerialization['totalTardinessMinutes'] as int,
      makespanMinutes: jsonSerialization['makespanMinutes'] as int,
      bottleneckWorkCenterId:
          jsonSerialization['bottleneckWorkCenterId'] as int,
      bottleneckWorkCenterName:
          jsonSerialization['bottleneckWorkCenterName'] as String,
      bottleneckUtilization: (jsonSerialization['bottleneckUtilization'] as num)
          .toDouble(),
      bottleneckQueueMinutes:
          jsonSerialization['bottleneckQueueMinutes'] as int,
      jobs: _i93te42s.Protocol().deserialize<List<_ipfdqm72.JobDiagnosis>>(
        jsonSerialization['jobs'],
      ),
    );
  }

  /// Run these numbers belong to.
  int runId;

  /// Jobs on time.
  int onTimeJobs;

  /// Jobs late.
  int tardyJobs;

  /// Total minutes late across the shop.
  int totalTardinessMinutes;

  /// Minutes from horizon start to the last operation.
  int makespanMinutes;

  /// Work center that constrains the shop.
  int bottleneckWorkCenterId;

  /// Its name.
  String bottleneckWorkCenterName;

  /// Its utilisation, 0..1+.
  double bottleneckUtilization;

  /// Total minutes jobs queued at the bottleneck.
  int bottleneckQueueMinutes;

  /// Per-job verdicts, late jobs first.
  List<_ipfdqm72.JobDiagnosis> jobs;

  /// Returns a shallow copy of this [ShopDiagnosis]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ShopDiagnosis copyWith({
    int? runId,
    int? onTimeJobs,
    int? tardyJobs,
    int? totalTardinessMinutes,
    int? makespanMinutes,
    int? bottleneckWorkCenterId,
    String? bottleneckWorkCenterName,
    double? bottleneckUtilization,
    int? bottleneckQueueMinutes,
    List<_ipfdqm72.JobDiagnosis>? jobs,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ShopDiagnosis',
      'runId': runId,
      'onTimeJobs': onTimeJobs,
      'tardyJobs': tardyJobs,
      'totalTardinessMinutes': totalTardinessMinutes,
      'makespanMinutes': makespanMinutes,
      'bottleneckWorkCenterId': bottleneckWorkCenterId,
      'bottleneckWorkCenterName': bottleneckWorkCenterName,
      'bottleneckUtilization': bottleneckUtilization,
      'bottleneckQueueMinutes': bottleneckQueueMinutes,
      'jobs': jobs.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ShopDiagnosis',
      'runId': runId,
      'onTimeJobs': onTimeJobs,
      'tardyJobs': tardyJobs,
      'totalTardinessMinutes': totalTardinessMinutes,
      'makespanMinutes': makespanMinutes,
      'bottleneckWorkCenterId': bottleneckWorkCenterId,
      'bottleneckWorkCenterName': bottleneckWorkCenterName,
      'bottleneckUtilization': bottleneckUtilization,
      'bottleneckQueueMinutes': bottleneckQueueMinutes,
      'jobs': jobs.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _ShopDiagnosisImpl extends ShopDiagnosis {
  _ShopDiagnosisImpl({
    required int runId,
    required int onTimeJobs,
    required int tardyJobs,
    required int totalTardinessMinutes,
    required int makespanMinutes,
    required int bottleneckWorkCenterId,
    required String bottleneckWorkCenterName,
    required double bottleneckUtilization,
    required int bottleneckQueueMinutes,
    required List<_ipfdqm72.JobDiagnosis> jobs,
  }) : super._(
         runId: runId,
         onTimeJobs: onTimeJobs,
         tardyJobs: tardyJobs,
         totalTardinessMinutes: totalTardinessMinutes,
         makespanMinutes: makespanMinutes,
         bottleneckWorkCenterId: bottleneckWorkCenterId,
         bottleneckWorkCenterName: bottleneckWorkCenterName,
         bottleneckUtilization: bottleneckUtilization,
         bottleneckQueueMinutes: bottleneckQueueMinutes,
         jobs: jobs,
       );

  /// Returns a shallow copy of this [ShopDiagnosis]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ShopDiagnosis copyWith({
    int? runId,
    int? onTimeJobs,
    int? tardyJobs,
    int? totalTardinessMinutes,
    int? makespanMinutes,
    int? bottleneckWorkCenterId,
    String? bottleneckWorkCenterName,
    double? bottleneckUtilization,
    int? bottleneckQueueMinutes,
    List<_ipfdqm72.JobDiagnosis>? jobs,
  }) {
    return ShopDiagnosis(
      runId: runId ?? this.runId,
      onTimeJobs: onTimeJobs ?? this.onTimeJobs,
      tardyJobs: tardyJobs ?? this.tardyJobs,
      totalTardinessMinutes:
          totalTardinessMinutes ?? this.totalTardinessMinutes,
      makespanMinutes: makespanMinutes ?? this.makespanMinutes,
      bottleneckWorkCenterId:
          bottleneckWorkCenterId ?? this.bottleneckWorkCenterId,
      bottleneckWorkCenterName:
          bottleneckWorkCenterName ?? this.bottleneckWorkCenterName,
      bottleneckUtilization:
          bottleneckUtilization ?? this.bottleneckUtilization,
      bottleneckQueueMinutes:
          bottleneckQueueMinutes ?? this.bottleneckQueueMinutes,
      jobs: jobs ?? this.jobs.map((e0) => e0.copyWith()).toList(),
    );
  }
}
