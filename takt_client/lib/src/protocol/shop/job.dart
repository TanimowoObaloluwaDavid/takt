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

/// A customer order that must pass through a routing of operations.
abstract class Job
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Job._({
    this.id,
    required this.shopId,
    required this.code,
    required this.title,
    required this.customer,
    required this.quantity,
    required this.dueAt,
    required this.releaseAt,
    required this.priority,
    required this.notes,
  });

  factory Job({
    int? id,
    required int shopId,
    required String code,
    required String title,
    required String customer,
    required int quantity,
    required DateTime dueAt,
    required DateTime releaseAt,
    required int priority,
    required String notes,
  }) = _JobImpl;

  factory Job.fromJson(Map<String, dynamic> jsonSerialization) {
    return Job(
      id: jsonSerialization['id'] as int?,
      shopId: jsonSerialization['shopId'] as int,
      code: jsonSerialization['code'] as String,
      title: jsonSerialization['title'] as String,
      customer: jsonSerialization['customer'] as String,
      quantity: jsonSerialization['quantity'] as int,
      dueAt: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['dueAt']),
      releaseAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['releaseAt'],
      ),
      priority: jsonSerialization['priority'] as int,
      notes: jsonSerialization['notes'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Owning shop.
  int shopId;

  /// Shop-floor reference, e.g. "J-1042".
  String code;

  /// Short description of the work.
  String title;

  /// Customer name, used only for display.
  String customer;

  /// Units to produce.
  int quantity;

  /// Promised delivery time.
  DateTime dueAt;

  /// Material available / earliest start time.
  DateTime releaseAt;

  /// 1 = standard, 2 = high, 3 = critical. Weights tardiness.
  int priority;

  /// Free-text shop notes.
  String notes;

  /// Returns a shallow copy of this [Job]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Job copyWith({
    int? id,
    int? shopId,
    String? code,
    String? title,
    String? customer,
    int? quantity,
    DateTime? dueAt,
    DateTime? releaseAt,
    int? priority,
    String? notes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Job',
      if (id != null) 'id': id,
      'shopId': shopId,
      'code': code,
      'title': title,
      'customer': customer,
      'quantity': quantity,
      'dueAt': dueAt.toJson(),
      'releaseAt': releaseAt.toJson(),
      'priority': priority,
      'notes': notes,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Job',
      if (id != null) 'id': id,
      'shopId': shopId,
      'code': code,
      'title': title,
      'customer': customer,
      'quantity': quantity,
      'dueAt': dueAt.toJson(),
      'releaseAt': releaseAt.toJson(),
      'priority': priority,
      'notes': notes,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _JobImpl extends Job {
  _JobImpl({
    int? id,
    required int shopId,
    required String code,
    required String title,
    required String customer,
    required int quantity,
    required DateTime dueAt,
    required DateTime releaseAt,
    required int priority,
    required String notes,
  }) : super._(
         id: id,
         shopId: shopId,
         code: code,
         title: title,
         customer: customer,
         quantity: quantity,
         dueAt: dueAt,
         releaseAt: releaseAt,
         priority: priority,
         notes: notes,
       );

  /// Returns a shallow copy of this [Job]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Job copyWith({
    Object? id = _Undefined,
    int? shopId,
    String? code,
    String? title,
    String? customer,
    int? quantity,
    DateTime? dueAt,
    DateTime? releaseAt,
    int? priority,
    String? notes,
  }) {
    return Job(
      id: id is int? ? id : this.id,
      shopId: shopId ?? this.shopId,
      code: code ?? this.code,
      title: title ?? this.title,
      customer: customer ?? this.customer,
      quantity: quantity ?? this.quantity,
      dueAt: dueAt ?? this.dueAt,
      releaseAt: releaseAt ?? this.releaseAt,
      priority: priority ?? this.priority,
      notes: notes ?? this.notes,
    );
  }
}
