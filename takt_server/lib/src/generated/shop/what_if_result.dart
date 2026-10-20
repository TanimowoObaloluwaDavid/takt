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

/// Delta between the current run and a capacity experiment.
abstract class WhatIfResult
    implements _is.SerializableModel, _is.ProtocolSerialization {
  WhatIfResult._({
    required this.workCenterName,
    required this.extraMachines,
    required this.baselineTardyJobs,
    required this.scenarioTardyJobs,
    required this.baselineTardinessMinutes,
    required this.scenarioTardinessMinutes,
    required this.savedTardinessMinutes,
    required this.jobsSaved,
  });

  factory WhatIfResult({
    required String workCenterName,
    required int extraMachines,
    required int baselineTardyJobs,
    required int scenarioTardyJobs,
    required int baselineTardinessMinutes,
    required int scenarioTardinessMinutes,
    required int savedTardinessMinutes,
    required int jobsSaved,
  }) = _WhatIfResultImpl;

  factory WhatIfResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return WhatIfResult(
      workCenterName: jsonSerialization['workCenterName'] as String,
      extraMachines: jsonSerialization['extraMachines'] as int,
      baselineTardyJobs: jsonSerialization['baselineTardyJobs'] as int,
      scenarioTardyJobs: jsonSerialization['scenarioTardyJobs'] as int,
      baselineTardinessMinutes:
          jsonSerialization['baselineTardinessMinutes'] as int,
      scenarioTardinessMinutes:
          jsonSerialization['scenarioTardinessMinutes'] as int,
      savedTardinessMinutes: jsonSerialization['savedTardinessMinutes'] as int,
      jobsSaved: jsonSerialization['jobsSaved'] as int,
    );
  }

  /// Work center that was changed.
  String workCenterName;

  /// Machines added for the experiment.
  int extraMachines;

  /// Late jobs in the current run.
  int baselineTardyJobs;

  /// Late jobs with the extra capacity.
  int scenarioTardyJobs;

  /// Total tardiness in the current run.
  int baselineTardinessMinutes;

  /// Total tardiness with the extra capacity.
  int scenarioTardinessMinutes;

  /// Tardiness minutes removed. Negative means the change made things worse.
  int savedTardinessMinutes;

  /// Jobs moved from late to on time.
  int jobsSaved;

  /// Returns a shallow copy of this [WhatIfResult]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  WhatIfResult copyWith({
    String? workCenterName,
    int? extraMachines,
    int? baselineTardyJobs,
    int? scenarioTardyJobs,
    int? baselineTardinessMinutes,
    int? scenarioTardinessMinutes,
    int? savedTardinessMinutes,
    int? jobsSaved,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WhatIfResult',
      'workCenterName': workCenterName,
      'extraMachines': extraMachines,
      'baselineTardyJobs': baselineTardyJobs,
      'scenarioTardyJobs': scenarioTardyJobs,
      'baselineTardinessMinutes': baselineTardinessMinutes,
      'scenarioTardinessMinutes': scenarioTardinessMinutes,
      'savedTardinessMinutes': savedTardinessMinutes,
      'jobsSaved': jobsSaved,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'WhatIfResult',
      'workCenterName': workCenterName,
      'extraMachines': extraMachines,
      'baselineTardyJobs': baselineTardyJobs,
      'scenarioTardyJobs': scenarioTardyJobs,
      'baselineTardinessMinutes': baselineTardinessMinutes,
      'scenarioTardinessMinutes': scenarioTardinessMinutes,
      'savedTardinessMinutes': savedTardinessMinutes,
      'jobsSaved': jobsSaved,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _WhatIfResultImpl extends WhatIfResult {
  _WhatIfResultImpl({
    required String workCenterName,
    required int extraMachines,
    required int baselineTardyJobs,
    required int scenarioTardyJobs,
    required int baselineTardinessMinutes,
    required int scenarioTardinessMinutes,
    required int savedTardinessMinutes,
    required int jobsSaved,
  }) : super._(
         workCenterName: workCenterName,
         extraMachines: extraMachines,
         baselineTardyJobs: baselineTardyJobs,
         scenarioTardyJobs: scenarioTardyJobs,
         baselineTardinessMinutes: baselineTardinessMinutes,
         scenarioTardinessMinutes: scenarioTardinessMinutes,
         savedTardinessMinutes: savedTardinessMinutes,
         jobsSaved: jobsSaved,
       );

  /// Returns a shallow copy of this [WhatIfResult]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  WhatIfResult copyWith({
    String? workCenterName,
    int? extraMachines,
    int? baselineTardyJobs,
    int? scenarioTardyJobs,
    int? baselineTardinessMinutes,
    int? scenarioTardinessMinutes,
    int? savedTardinessMinutes,
    int? jobsSaved,
  }) {
    return WhatIfResult(
      workCenterName: workCenterName ?? this.workCenterName,
      extraMachines: extraMachines ?? this.extraMachines,
      baselineTardyJobs: baselineTardyJobs ?? this.baselineTardyJobs,
      scenarioTardyJobs: scenarioTardyJobs ?? this.scenarioTardyJobs,
      baselineTardinessMinutes:
          baselineTardinessMinutes ?? this.baselineTardinessMinutes,
      scenarioTardinessMinutes:
          scenarioTardinessMinutes ?? this.scenarioTardinessMinutes,
      savedTardinessMinutes:
          savedTardinessMinutes ?? this.savedTardinessMinutes,
      jobsSaved: jobsSaved ?? this.jobsSaved,
    );
  }
}
