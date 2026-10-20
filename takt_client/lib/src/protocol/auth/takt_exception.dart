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

/// A user-facing failure that the Flutter client can display verbatim.
/// Registered with the protocol so Serverpod serializes it as a 400 instead
/// of hiding the message behind a generic internal-server error.
abstract class TaktException
    implements
        _isc.SerializableException,
        _isc.SerializableModel,
        _isc.ProtocolSerialization {
  TaktException._({required this.message});

  factory TaktException({required String message}) = _TaktExceptionImpl;

  factory TaktException.fromJson(Map<String, dynamic> jsonSerialization) {
    return TaktException(message: jsonSerialization['message'] as String);
  }

  /// Human-readable explanation safe to show in the UI.
  String message;

  /// Returns a shallow copy of this [TaktException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  TaktException copyWith({String? message});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TaktException',
      'message': message,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TaktException',
      'message': message,
    };
  }

  @override
  String toString() {
    return 'TaktException(message: $message)';
  }
}

class _TaktExceptionImpl extends TaktException {
  _TaktExceptionImpl({required String message}) : super._(message: message);

  /// Returns a shallow copy of this [TaktException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  TaktException copyWith({String? message}) {
    return TaktException(message: message ?? this.message);
  }
}
