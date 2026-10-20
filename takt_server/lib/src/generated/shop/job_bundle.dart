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
import '../shop/job.dart' as _ix23gwt3;
import '../shop/operation.dart' as _i9lzza7v;

/// A job and its full routing, saved as one unit.
abstract class JobBundle
    implements _is.SerializableModel, _is.ProtocolSerialization {
  JobBundle._({
    required this.job,
    required this.operations,
  });

  factory JobBundle({
    required _ix23gwt3.Job job,
    required List<_i9lzza7v.Operation> operations,
  }) = _JobBundleImpl;

  factory JobBundle.fromJson(Map<String, dynamic> jsonSerialization) {
    return JobBundle(
      job: _i4q4669s.Protocol().deserialize<_ix23gwt3.Job>(
        jsonSerialization['job'],
      ),
      operations: _i4q4669s.Protocol().deserialize<List<_i9lzza7v.Operation>>(
        jsonSerialization['operations'],
      ),
    );
  }

  /// Job header.
  _ix23gwt3.Job job;

  /// Routing in ascending sequence.
  List<_i9lzza7v.Operation> operations;

  /// Returns a shallow copy of this [JobBundle]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  JobBundle copyWith({
    _ix23gwt3.Job? job,
    List<_i9lzza7v.Operation>? operations,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'JobBundle',
      'job': job.toJson(),
      'operations': operations.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'JobBundle',
      'job': job.toJsonForProtocol(),
      'operations': operations.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _JobBundleImpl extends JobBundle {
  _JobBundleImpl({
    required _ix23gwt3.Job job,
    required List<_i9lzza7v.Operation> operations,
  }) : super._(
         job: job,
         operations: operations,
       );

  /// Returns a shallow copy of this [JobBundle]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  JobBundle copyWith({
    _ix23gwt3.Job? job,
    List<_i9lzza7v.Operation>? operations,
  }) {
    return JobBundle(
      job: job ?? this.job.copyWith(),
      operations:
          operations ?? this.operations.map((e0) => e0.copyWith()).toList(),
    );
  }
}
