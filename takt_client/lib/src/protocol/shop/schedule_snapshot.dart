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
import '../shop/job.dart' as _ix23gwt3;
import '../shop/schedule_run.dart' as _ii8kkrl8;
import '../shop/scheduled_op.dart' as _ivlde1fs;
import '../shop/shop_diagnosis.dart' as _iyxbuykk;
import '../shop/work_center.dart' as _irrtkymq;

/// Everything the client needs to render one run.
abstract class ScheduleSnapshot
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ScheduleSnapshot._({
    required this.run,
    required this.scheduledOps,
    required this.diagnosis,
    required this.jobs,
    required this.workCenters,
  });

  factory ScheduleSnapshot({
    required _ii8kkrl8.ScheduleRun run,
    required List<_ivlde1fs.ScheduledOp> scheduledOps,
    required _iyxbuykk.ShopDiagnosis diagnosis,
    required List<_ix23gwt3.Job> jobs,
    required List<_irrtkymq.WorkCenter> workCenters,
  }) = _ScheduleSnapshotImpl;

  factory ScheduleSnapshot.fromJson(Map<String, dynamic> jsonSerialization) {
    return ScheduleSnapshot(
      run: _i93te42s.Protocol().deserialize<_ii8kkrl8.ScheduleRun>(
        jsonSerialization['run'],
      ),
      scheduledOps: _i93te42s.Protocol()
          .deserialize<List<_ivlde1fs.ScheduledOp>>(
            jsonSerialization['scheduledOps'],
          ),
      diagnosis: _i93te42s.Protocol().deserialize<_iyxbuykk.ShopDiagnosis>(
        jsonSerialization['diagnosis'],
      ),
      jobs: _i93te42s.Protocol().deserialize<List<_ix23gwt3.Job>>(
        jsonSerialization['jobs'],
      ),
      workCenters: _i93te42s.Protocol().deserialize<List<_irrtkymq.WorkCenter>>(
        jsonSerialization['workCenters'],
      ),
    );
  }

  /// The run header.
  _ii8kkrl8.ScheduleRun run;

  /// Placed operations.
  List<_ivlde1fs.ScheduledOp> scheduledOps;

  /// Per-job verdicts.
  _iyxbuykk.ShopDiagnosis diagnosis;

  /// Jobs referenced by the run.
  List<_ix23gwt3.Job> jobs;

  /// Work centers referenced by the run.
  List<_irrtkymq.WorkCenter> workCenters;

  /// Returns a shallow copy of this [ScheduleSnapshot]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ScheduleSnapshot copyWith({
    _ii8kkrl8.ScheduleRun? run,
    List<_ivlde1fs.ScheduledOp>? scheduledOps,
    _iyxbuykk.ShopDiagnosis? diagnosis,
    List<_ix23gwt3.Job>? jobs,
    List<_irrtkymq.WorkCenter>? workCenters,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ScheduleSnapshot',
      'run': run.toJson(),
      'scheduledOps': scheduledOps.toJson(valueToJson: (v) => v.toJson()),
      'diagnosis': diagnosis.toJson(),
      'jobs': jobs.toJson(valueToJson: (v) => v.toJson()),
      'workCenters': workCenters.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ScheduleSnapshot',
      'run': run.toJsonForProtocol(),
      'scheduledOps': scheduledOps.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'diagnosis': diagnosis.toJsonForProtocol(),
      'jobs': jobs.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'workCenters': workCenters.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _ScheduleSnapshotImpl extends ScheduleSnapshot {
  _ScheduleSnapshotImpl({
    required _ii8kkrl8.ScheduleRun run,
    required List<_ivlde1fs.ScheduledOp> scheduledOps,
    required _iyxbuykk.ShopDiagnosis diagnosis,
    required List<_ix23gwt3.Job> jobs,
    required List<_irrtkymq.WorkCenter> workCenters,
  }) : super._(
         run: run,
         scheduledOps: scheduledOps,
         diagnosis: diagnosis,
         jobs: jobs,
         workCenters: workCenters,
       );

  /// Returns a shallow copy of this [ScheduleSnapshot]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ScheduleSnapshot copyWith({
    _ii8kkrl8.ScheduleRun? run,
    List<_ivlde1fs.ScheduledOp>? scheduledOps,
    _iyxbuykk.ShopDiagnosis? diagnosis,
    List<_ix23gwt3.Job>? jobs,
    List<_irrtkymq.WorkCenter>? workCenters,
  }) {
    return ScheduleSnapshot(
      run: run ?? this.run.copyWith(),
      scheduledOps:
          scheduledOps ?? this.scheduledOps.map((e0) => e0.copyWith()).toList(),
      diagnosis: diagnosis ?? this.diagnosis.copyWith(),
      jobs: jobs ?? this.jobs.map((e0) => e0.copyWith()).toList(),
      workCenters:
          workCenters ?? this.workCenters.map((e0) => e0.copyWith()).toList(),
    );
  }
}
