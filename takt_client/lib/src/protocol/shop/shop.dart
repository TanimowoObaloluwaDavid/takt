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

/// A job shop workspace. The access key is the only credential and scopes
/// every query; it is generated server-side and never guessed by the client.
abstract class Shop
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Shop._({
    this.id,
    required this.name,
    required this.accessKey,
    required this.currency,
    required this.minutesPerDay,
    required this.createdAt,
  });

  factory Shop({
    int? id,
    required String name,
    required String accessKey,
    required String currency,
    required int minutesPerDay,
    required DateTime createdAt,
  }) = _ShopImpl;

  factory Shop.fromJson(Map<String, dynamic> jsonSerialization) {
    return Shop(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      accessKey: jsonSerialization['accessKey'] as String,
      currency: jsonSerialization['currency'] as String,
      minutesPerDay: jsonSerialization['minutesPerDay'] as int,
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Display name of the shop.
  String name;

  /// Unguessable workspace key. Acts as the bearer credential for all calls.
  String accessKey;

  /// ISO currency code used for display only.
  String currency;

  /// Minutes of available production time per working day.
  int minutesPerDay;

  /// When the workspace was created.
  DateTime createdAt;

  /// Returns a shallow copy of this [Shop]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Shop copyWith({
    int? id,
    String? name,
    String? accessKey,
    String? currency,
    int? minutesPerDay,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Shop',
      if (id != null) 'id': id,
      'name': name,
      'accessKey': accessKey,
      'currency': currency,
      'minutesPerDay': minutesPerDay,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Shop',
      if (id != null) 'id': id,
      'name': name,
      'accessKey': accessKey,
      'currency': currency,
      'minutesPerDay': minutesPerDay,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ShopImpl extends Shop {
  _ShopImpl({
    int? id,
    required String name,
    required String accessKey,
    required String currency,
    required int minutesPerDay,
    required DateTime createdAt,
  }) : super._(
         id: id,
         name: name,
         accessKey: accessKey,
         currency: currency,
         minutesPerDay: minutesPerDay,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Shop]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Shop copyWith({
    Object? id = _Undefined,
    String? name,
    String? accessKey,
    String? currency,
    int? minutesPerDay,
    DateTime? createdAt,
  }) {
    return Shop(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      accessKey: accessKey ?? this.accessKey,
      currency: currency ?? this.currency,
      minutesPerDay: minutesPerDay ?? this.minutesPerDay,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
