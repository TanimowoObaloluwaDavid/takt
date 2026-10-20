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

/// A person with a Takt account. Passwords are stored only as Argon2id
/// hashes; this row never leaves the server with its password hash.
abstract class TaktUser
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  TaktUser._({
    this.id,
    required this.email,
    required this.displayName,
    required this.passwordHash,
    required this.createdAt,
  });

  factory TaktUser({
    int? id,
    required String email,
    required String displayName,
    required String passwordHash,
    required DateTime createdAt,
  }) = _TaktUserImpl;

  factory TaktUser.fromJson(Map<String, dynamic> jsonSerialization) {
    return TaktUser(
      id: jsonSerialization['id'] as int?,
      email: jsonSerialization['email'] as String,
      displayName: jsonSerialization['displayName'] as String,
      passwordHash: jsonSerialization['passwordHash'] as String,
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = TaktUserTable();

  static const db = TaktUserRepository._();

  @override
  int? id;

  /// Normalized (lower-case) sign-in address.
  String email;

  /// Name shown in the team list.
  String displayName;

  /// Argon2id PHC hash. Never returned by an endpoint.
  String passwordHash;

  /// When the account was created.
  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [TaktUser]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TaktUser copyWith({
    int? id,
    String? email,
    String? displayName,
    String? passwordHash,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TaktUser',
      if (id != null) 'id': id,
      'email': email,
      'displayName': displayName,
      'passwordHash': passwordHash,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TaktUser',
      if (id != null) 'id': id,
      'email': email,
      'displayName': displayName,
      'passwordHash': passwordHash,
      'createdAt': createdAt.toJson(),
    };
  }

  static TaktUserInclude include() {
    return TaktUserInclude._();
  }

  static TaktUserIncludeList includeList({
    _is.WhereExpressionBuilder<TaktUserTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TaktUserTable>? orderBy,
    _is.OrderByListBuilder<TaktUserTable>? orderByList,
    TaktUserInclude? include,
  }) {
    return TaktUserIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TaktUser.t),
      orderByList: orderByList?.call(TaktUser.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TaktUserImpl extends TaktUser {
  _TaktUserImpl({
    int? id,
    required String email,
    required String displayName,
    required String passwordHash,
    required DateTime createdAt,
  }) : super._(
         id: id,
         email: email,
         displayName: displayName,
         passwordHash: passwordHash,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [TaktUser]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TaktUser copyWith({
    Object? id = _Undefined,
    String? email,
    String? displayName,
    String? passwordHash,
    DateTime? createdAt,
  }) {
    return TaktUser(
      id: id is int? ? id : this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      passwordHash: passwordHash ?? this.passwordHash,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class TaktUserUpdateTable extends _is.UpdateTable<TaktUserTable> {
  TaktUserUpdateTable(super.table);

  _is.ColumnValue<String, String> email(String value) => _is.ColumnValue(
    table.email,
    value,
  );

  _is.ColumnValue<String, String> displayName(String value) => _is.ColumnValue(
    table.displayName,
    value,
  );

  _is.ColumnValue<String, String> passwordHash(String value) => _is.ColumnValue(
    table.passwordHash,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class TaktUserTable extends _is.Table<int?> {
  TaktUserTable({super.tableRelation}) : super(tableName: 'takt_user') {
    updateTable = TaktUserUpdateTable(this);
    email = _is.ColumnString(
      'email',
      this,
    );
    displayName = _is.ColumnString(
      'displayName',
      this,
    );
    passwordHash = _is.ColumnString(
      'passwordHash',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final TaktUserUpdateTable updateTable;

  /// Normalized (lower-case) sign-in address.
  late final _is.ColumnString email;

  /// Name shown in the team list.
  late final _is.ColumnString displayName;

  /// Argon2id PHC hash. Never returned by an endpoint.
  late final _is.ColumnString passwordHash;

  /// When the account was created.
  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    email,
    displayName,
    passwordHash,
    createdAt,
  ];
}

class TaktUserInclude extends _is.IncludeObject {
  TaktUserInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => TaktUser.t;
}

class TaktUserIncludeList extends _is.IncludeList {
  TaktUserIncludeList._({
    _is.WhereExpressionBuilder<TaktUserTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TaktUser.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => TaktUser.t;
}

class TaktUserRepository {
  const TaktUserRepository._();

  /// Returns a list of [TaktUser]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<TaktUser>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TaktUserTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TaktUserTable>? orderBy,
    _is.OrderByListBuilder<TaktUserTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<TaktUser>(
      where: where?.call(TaktUser.t),
      orderBy: orderBy?.call(TaktUser.t),
      orderByList: orderByList?.call(TaktUser.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [TaktUser] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<TaktUser?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TaktUserTable>? where,
    int? offset,
    _is.OrderByBuilder<TaktUserTable>? orderBy,
    _is.OrderByListBuilder<TaktUserTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<TaktUser>(
      where: where?.call(TaktUser.t),
      orderBy: orderBy?.call(TaktUser.t),
      orderByList: orderByList?.call(TaktUser.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [TaktUser] by its [id] or null if no such row exists.
  Future<TaktUser?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<TaktUser>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [TaktUser]s in the list and returns the inserted rows.
  ///
  /// The returned [TaktUser]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TaktUser>> insert(
    _is.DatabaseSession session,
    List<TaktUser> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<TaktUser>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [TaktUser] and returns the inserted row.
  ///
  /// The returned [TaktUser] will have its `id` field set.
  Future<TaktUser> insertRow(
    _is.DatabaseSession session,
    TaktUser row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<TaktUser>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [TaktUser]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [TaktUser]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TaktUser>> upsert(
    _is.DatabaseSession session,
    List<TaktUser> rows, {
    required _is.ColumnSelections<TaktUserTable> conflictColumns,
    _is.ColumnSelections<TaktUserTable>? updateColumns,
    _is.WhereExpressionBuilder<TaktUserTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<TaktUser>(
      rows,
      conflictColumns: conflictColumns(TaktUser.t),
      updateColumns: updateColumns?.call(TaktUser.t),
      updateWhere: updateWhere?.call(TaktUser.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [TaktUser] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [TaktUser] will have its `id` field set.
  Future<TaktUser?> upsertRow(
    _is.DatabaseSession session,
    TaktUser row, {
    required _is.ColumnSelections<TaktUserTable> conflictColumns,
    _is.ColumnSelections<TaktUserTable>? updateColumns,
    _is.WhereExpressionBuilder<TaktUserTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<TaktUser>(
      row,
      conflictColumns: conflictColumns(TaktUser.t),
      updateColumns: updateColumns?.call(TaktUser.t),
      updateWhere: updateWhere?.call(TaktUser.t),
      transaction: transaction,
    );
  }

  /// Updates all [TaktUser]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TaktUser>> update(
    _is.DatabaseSession session,
    List<TaktUser> rows, {
    _is.ColumnSelections<TaktUserTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<TaktUser>(
      rows,
      columns: columns?.call(TaktUser.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [TaktUser]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TaktUser> updateRow(
    _is.DatabaseSession session,
    TaktUser row, {
    _is.ColumnSelections<TaktUserTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<TaktUser>(
      row,
      columns: columns?.call(TaktUser.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TaktUser] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<TaktUser?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<TaktUserUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<TaktUser>(
      id,
      columnValues: columnValues(TaktUser.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [TaktUser]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TaktUser>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<TaktUserUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<TaktUserTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TaktUserTable>? orderBy,
    _is.OrderByListBuilder<TaktUserTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<TaktUser>(
      columnValues: columnValues(TaktUser.t.updateTable),
      where: where(TaktUser.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TaktUser.t),
      orderByList: orderByList?.call(TaktUser.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [TaktUser]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TaktUser>> delete(
    _is.DatabaseSession session,
    List<TaktUser> rows, {
    _is.OrderByBuilder<TaktUserTable>? orderBy,
    _is.OrderByListBuilder<TaktUserTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<TaktUser>(
      rows,
      orderBy: orderBy?.call(TaktUser.t),
      orderByList: orderByList?.call(TaktUser.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [TaktUser].
  Future<TaktUser> deleteRow(
    _is.DatabaseSession session,
    TaktUser row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TaktUser>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TaktUser>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TaktUserTable> where,
    _is.OrderByBuilder<TaktUserTable>? orderBy,
    _is.OrderByListBuilder<TaktUserTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<TaktUser>(
      where: where(TaktUser.t),
      orderBy: orderBy?.call(TaktUser.t),
      orderByList: orderByList?.call(TaktUser.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TaktUserTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<TaktUser>(
      where: where?.call(TaktUser.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [TaktUser] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TaktUserTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<TaktUser>(
      where: where(TaktUser.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
