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

/// A revocable browser session. The raw token is returned once to the
/// client; only its SHA-256 hash is stored here.
abstract class UserSession
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  UserSession._({
    this.id,
    required this.userId,
    required this.tokenHash,
    required this.createdAt,
    required this.expiresAt,
    required this.lastSeenAt,
  });

  factory UserSession({
    int? id,
    required int userId,
    required String tokenHash,
    required DateTime createdAt,
    required DateTime expiresAt,
    required DateTime lastSeenAt,
  }) = _UserSessionImpl;

  factory UserSession.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserSession(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      tokenHash: jsonSerialization['tokenHash'] as String,
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      expiresAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
      lastSeenAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['lastSeenAt'],
      ),
    );
  }

  static final t = UserSessionTable();

  static const db = UserSessionRepository._();

  @override
  int? id;

  /// Account this session belongs to.
  int userId;

  /// SHA-256 hex digest of the raw session token.
  String tokenHash;

  /// When the session was issued.
  DateTime createdAt;

  /// Hard expiry. Sessions are not refreshed indefinitely.
  DateTime expiresAt;

  /// Last time the session was used to load the account.
  DateTime lastSeenAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [UserSession]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  UserSession copyWith({
    int? id,
    int? userId,
    String? tokenHash,
    DateTime? createdAt,
    DateTime? expiresAt,
    DateTime? lastSeenAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserSession',
      if (id != null) 'id': id,
      'userId': userId,
      'tokenHash': tokenHash,
      'createdAt': createdAt.toJson(),
      'expiresAt': expiresAt.toJson(),
      'lastSeenAt': lastSeenAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UserSession',
      if (id != null) 'id': id,
      'userId': userId,
      'tokenHash': tokenHash,
      'createdAt': createdAt.toJson(),
      'expiresAt': expiresAt.toJson(),
      'lastSeenAt': lastSeenAt.toJson(),
    };
  }

  static UserSessionInclude include() {
    return UserSessionInclude._();
  }

  static UserSessionIncludeList includeList({
    _is.WhereExpressionBuilder<UserSessionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserSessionTable>? orderBy,
    _is.OrderByListBuilder<UserSessionTable>? orderByList,
    UserSessionInclude? include,
  }) {
    return UserSessionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserSession.t),
      orderByList: orderByList?.call(UserSession.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserSessionImpl extends UserSession {
  _UserSessionImpl({
    int? id,
    required int userId,
    required String tokenHash,
    required DateTime createdAt,
    required DateTime expiresAt,
    required DateTime lastSeenAt,
  }) : super._(
         id: id,
         userId: userId,
         tokenHash: tokenHash,
         createdAt: createdAt,
         expiresAt: expiresAt,
         lastSeenAt: lastSeenAt,
       );

  /// Returns a shallow copy of this [UserSession]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  UserSession copyWith({
    Object? id = _Undefined,
    int? userId,
    String? tokenHash,
    DateTime? createdAt,
    DateTime? expiresAt,
    DateTime? lastSeenAt,
  }) {
    return UserSession(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      tokenHash: tokenHash ?? this.tokenHash,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
    );
  }
}

class UserSessionUpdateTable extends _is.UpdateTable<UserSessionTable> {
  UserSessionUpdateTable(super.table);

  _is.ColumnValue<int, int> userId(int value) => _is.ColumnValue(
    table.userId,
    value,
  );

  _is.ColumnValue<String, String> tokenHash(String value) => _is.ColumnValue(
    table.tokenHash,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> expiresAt(DateTime value) =>
      _is.ColumnValue(
        table.expiresAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> lastSeenAt(DateTime value) =>
      _is.ColumnValue(
        table.lastSeenAt,
        value,
      );
}

class UserSessionTable extends _is.Table<int?> {
  UserSessionTable({super.tableRelation}) : super(tableName: 'user_session') {
    updateTable = UserSessionUpdateTable(this);
    userId = _is.ColumnInt(
      'userId',
      this,
    );
    tokenHash = _is.ColumnString(
      'tokenHash',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
    expiresAt = _is.ColumnDateTime(
      'expiresAt',
      this,
    );
    lastSeenAt = _is.ColumnDateTime(
      'lastSeenAt',
      this,
    );
  }

  late final UserSessionUpdateTable updateTable;

  /// Account this session belongs to.
  late final _is.ColumnInt userId;

  /// SHA-256 hex digest of the raw session token.
  late final _is.ColumnString tokenHash;

  /// When the session was issued.
  late final _is.ColumnDateTime createdAt;

  /// Hard expiry. Sessions are not refreshed indefinitely.
  late final _is.ColumnDateTime expiresAt;

  /// Last time the session was used to load the account.
  late final _is.ColumnDateTime lastSeenAt;

  @override
  List<_is.Column> get columns => [
    id,
    userId,
    tokenHash,
    createdAt,
    expiresAt,
    lastSeenAt,
  ];
}

class UserSessionInclude extends _is.IncludeObject {
  UserSessionInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => UserSession.t;
}

class UserSessionIncludeList extends _is.IncludeList {
  UserSessionIncludeList._({
    _is.WhereExpressionBuilder<UserSessionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserSession.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => UserSession.t;
}

class UserSessionRepository {
  const UserSessionRepository._();

  /// Returns a list of [UserSession]s matching the given query parameters.
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
  Future<List<UserSession>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UserSessionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserSessionTable>? orderBy,
    _is.OrderByListBuilder<UserSessionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<UserSession>(
      where: where?.call(UserSession.t),
      orderBy: orderBy?.call(UserSession.t),
      orderByList: orderByList?.call(UserSession.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [UserSession] matching the given query parameters.
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
  Future<UserSession?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UserSessionTable>? where,
    int? offset,
    _is.OrderByBuilder<UserSessionTable>? orderBy,
    _is.OrderByListBuilder<UserSessionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<UserSession>(
      where: where?.call(UserSession.t),
      orderBy: orderBy?.call(UserSession.t),
      orderByList: orderByList?.call(UserSession.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [UserSession] by its [id] or null if no such row exists.
  Future<UserSession?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<UserSession>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [UserSession]s in the list and returns the inserted rows.
  ///
  /// The returned [UserSession]s will have their `id` fields set.
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
  Future<List<UserSession>> insert(
    _is.DatabaseSession session,
    List<UserSession> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<UserSession>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [UserSession] and returns the inserted row.
  ///
  /// The returned [UserSession] will have its `id` field set.
  Future<UserSession> insertRow(
    _is.DatabaseSession session,
    UserSession row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserSession>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [UserSession]s in the list and returns the resulting rows.
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
  /// The returned [UserSession]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UserSession>> upsert(
    _is.DatabaseSession session,
    List<UserSession> rows, {
    required _is.ColumnSelections<UserSessionTable> conflictColumns,
    _is.ColumnSelections<UserSessionTable>? updateColumns,
    _is.WhereExpressionBuilder<UserSessionTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<UserSession>(
      rows,
      conflictColumns: conflictColumns(UserSession.t),
      updateColumns: updateColumns?.call(UserSession.t),
      updateWhere: updateWhere?.call(UserSession.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [UserSession] and returns the resulting row.
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
  /// The returned [UserSession] will have its `id` field set.
  Future<UserSession?> upsertRow(
    _is.DatabaseSession session,
    UserSession row, {
    required _is.ColumnSelections<UserSessionTable> conflictColumns,
    _is.ColumnSelections<UserSessionTable>? updateColumns,
    _is.WhereExpressionBuilder<UserSessionTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<UserSession>(
      row,
      conflictColumns: conflictColumns(UserSession.t),
      updateColumns: updateColumns?.call(UserSession.t),
      updateWhere: updateWhere?.call(UserSession.t),
      transaction: transaction,
    );
  }

  /// Updates all [UserSession]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UserSession>> update(
    _is.DatabaseSession session,
    List<UserSession> rows, {
    _is.ColumnSelections<UserSessionTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<UserSession>(
      rows,
      columns: columns?.call(UserSession.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [UserSession]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserSession> updateRow(
    _is.DatabaseSession session,
    UserSession row, {
    _is.ColumnSelections<UserSessionTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserSession>(
      row,
      columns: columns?.call(UserSession.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserSession] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UserSession?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<UserSessionUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<UserSession>(
      id,
      columnValues: columnValues(UserSession.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UserSession]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UserSession>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<UserSessionUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<UserSessionTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserSessionTable>? orderBy,
    _is.OrderByListBuilder<UserSessionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<UserSession>(
      columnValues: columnValues(UserSession.t.updateTable),
      where: where(UserSession.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserSession.t),
      orderByList: orderByList?.call(UserSession.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [UserSession]s in the list and returns the deleted rows.
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
  Future<List<UserSession>> delete(
    _is.DatabaseSession session,
    List<UserSession> rows, {
    _is.OrderByBuilder<UserSessionTable>? orderBy,
    _is.OrderByListBuilder<UserSessionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<UserSession>(
      rows,
      orderBy: orderBy?.call(UserSession.t),
      orderByList: orderByList?.call(UserSession.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [UserSession].
  Future<UserSession> deleteRow(
    _is.DatabaseSession session,
    UserSession row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserSession>(
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
  Future<List<UserSession>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UserSessionTable> where,
    _is.OrderByBuilder<UserSessionTable>? orderBy,
    _is.OrderByListBuilder<UserSessionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<UserSession>(
      where: where(UserSession.t),
      orderBy: orderBy?.call(UserSession.t),
      orderByList: orderByList?.call(UserSession.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UserSessionTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<UserSession>(
      where: where?.call(UserSession.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [UserSession] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UserSessionTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<UserSession>(
      where: where(UserSession.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
