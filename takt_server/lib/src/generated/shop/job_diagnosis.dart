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

/// Why one job lands where it does. Computed, never stored.
abstract class JobDiagnosis
    implements _is.SerializableModel, _is.ProtocolSerialization {
  JobDiagnosis._({
    required this.jobId,
    required this.code,
    required this.title,
    required this.dueMinute,
    required this.finishMinute,
    required this.tardinessMinutes,
    required this.queueMinutes,
    required this.bindingWorkCenterId,
    required this.bindingWorkCenterName,
    required this.bindingQueueMinutes,
    required this.explanation,
    required this.chain,
    required this.isTardy,
  });

  factory JobDiagnosis({
    required int jobId,
    required String code,
    required String title,
    required int dueMinute,
    required int finishMinute,
    required int tardinessMinutes,
    required int queueMinutes,
    required int bindingWorkCenterId,
    required String bindingWorkCenterName,
    required int bindingQueueMinutes,
    required String explanation,
    required List<String> chain,
    required bool isTardy,
  }) = _JobDiagnosisImpl;

  factory JobDiagnosis.fromJson(Map<String, dynamic> jsonSerialization) {
    return JobDiagnosis(
      jobId: jsonSerialization['jobId'] as int,
      code: jsonSerialization['code'] as String,
      title: jsonSerialization['title'] as String,
      dueMinute: jsonSerialization['dueMinute'] as int,
      finishMinute: jsonSerialization['finishMinute'] as int,
      tardinessMinutes: jsonSerialization['tardinessMinutes'] as int,
      queueMinutes: jsonSerialization['queueMinutes'] as int,
      bindingWorkCenterId: jsonSerialization['bindingWorkCenterId'] as int,
      bindingWorkCenterName:
          jsonSerialization['bindingWorkCenterName'] as String,
      bindingQueueMinutes: jsonSerialization['bindingQueueMinutes'] as int,
      explanation: jsonSerialization['explanation'] as String,
      chain: _i4q4669s.Protocol().deserialize<List<String>>(
        jsonSerialization['chain'],
      ),
      isTardy: _is.BoolJsonExtension.fromJson(jsonSerialization['isTardy']),
    );
  }

  /// Job id.
  int jobId;

  /// Shop-floor reference.
  String code;

  /// Short description.
  String title;

  /// Due minute relative to horizon.
  int dueMinute;

  /// Finish minute relative to horizon.
  int finishMinute;

  /// Minutes late, zero when on time.
  int tardinessMinutes;

  /// Total queue time across the routing.
  int queueMinutes;

  /// Work center where this job lost the most time waiting.
  int bindingWorkCenterId;

  /// Name of that work center.
  String bindingWorkCenterName;

  /// Queue minutes lost at that work center.
  int bindingQueueMinutes;

  /// One-sentence causal explanation.
  String explanation;

  /// Human-readable step trace.
  List<String> chain;

  /// Whether the job is late.
  bool isTardy;

  /// Returns a shallow copy of this [JobDiagnosis]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  JobDiagnosis copyWith({
    int? jobId,
    String? code,
    String? title,
    int? dueMinute,
    int? finishMinute,
    int? tardinessMinutes,
    int? queueMinutes,
    int? bindingWorkCenterId,
    String? bindingWorkCenterName,
    int? bindingQueueMinutes,
    String? explanation,
    List<String>? chain,
    bool? isTardy,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'JobDiagnosis',
      'jobId': jobId,
      'code': code,
      'title': title,
      'dueMinute': dueMinute,
      'finishMinute': finishMinute,
      'tardinessMinutes': tardinessMinutes,
      'queueMinutes': queueMinutes,
      'bindingWorkCenterId': bindingWorkCenterId,
      'bindingWorkCenterName': bindingWorkCenterName,
      'bindingQueueMinutes': bindingQueueMinutes,
      'explanation': explanation,
      'chain': chain.toJson(),
      'isTardy': isTardy,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'JobDiagnosis',
      'jobId': jobId,
      'code': code,
      'title': title,
      'dueMinute': dueMinute,
      'finishMinute': finishMinute,
      'tardinessMinutes': tardinessMinutes,
      'queueMinutes': queueMinutes,
      'bindingWorkCenterId': bindingWorkCenterId,
      'bindingWorkCenterName': bindingWorkCenterName,
      'bindingQueueMinutes': bindingQueueMinutes,
      'explanation': explanation,
      'chain': chain.toJson(),
      'isTardy': isTardy,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _JobDiagnosisImpl extends JobDiagnosis {
  _JobDiagnosisImpl({
    required int jobId,
    required String code,
    required String title,
    required int dueMinute,
    required int finishMinute,
    required int tardinessMinutes,
    required int queueMinutes,
    required int bindingWorkCenterId,
    required String bindingWorkCenterName,
    required int bindingQueueMinutes,
    required String explanation,
    required List<String> chain,
    required bool isTardy,
  }) : super._(
         jobId: jobId,
         code: code,
         title: title,
         dueMinute: dueMinute,
         finishMinute: finishMinute,
         tardinessMinutes: tardinessMinutes,
         queueMinutes: queueMinutes,
         bindingWorkCenterId: bindingWorkCenterId,
         bindingWorkCenterName: bindingWorkCenterName,
         bindingQueueMinutes: bindingQueueMinutes,
         explanation: explanation,
         chain: chain,
         isTardy: isTardy,
       );

  /// Returns a shallow copy of this [JobDiagnosis]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  JobDiagnosis copyWith({
    int? jobId,
    String? code,
    String? title,
    int? dueMinute,
    int? finishMinute,
    int? tardinessMinutes,
    int? queueMinutes,
    int? bindingWorkCenterId,
    String? bindingWorkCenterName,
    int? bindingQueueMinutes,
    String? explanation,
    List<String>? chain,
    bool? isTardy,
  }) {
    return JobDiagnosis(
      jobId: jobId ?? this.jobId,
      code: code ?? this.code,
      title: title ?? this.title,
      dueMinute: dueMinute ?? this.dueMinute,
      finishMinute: finishMinute ?? this.finishMinute,
      tardinessMinutes: tardinessMinutes ?? this.tardinessMinutes,
      queueMinutes: queueMinutes ?? this.queueMinutes,
      bindingWorkCenterId: bindingWorkCenterId ?? this.bindingWorkCenterId,
      bindingWorkCenterName:
          bindingWorkCenterName ?? this.bindingWorkCenterName,
      bindingQueueMinutes: bindingQueueMinutes ?? this.bindingQueueMinutes,
      explanation: explanation ?? this.explanation,
      chain: chain ?? this.chain.map((e0) => e0).toList(),
      isTardy: isTardy ?? this.isTardy,
    );
  }
}
