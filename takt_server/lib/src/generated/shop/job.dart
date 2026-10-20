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

/// A customer order that must pass through a routing of operations.
abstract class Job implements _is.TableRow<int?>, _is.ProtocolSerialization {
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
      dueAt: _is.DateTimeJsonExtension.fromJson(jsonSerialization['dueAt']),
      releaseAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['releaseAt'],
      ),
      priority: jsonSerialization['priority'] as int,
      notes: jsonSerialization['notes'] as String,
    );
  }

  static final t = JobTable();

  static const db = JobRepository._();

  @override
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

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Job]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
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

  static JobInclude include() {
    return JobInclude._();
  }

  static JobIncludeList includeList({
    _is.WhereExpressionBuilder<JobTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<JobTable>? orderBy,
    _is.OrderByListBuilder<JobTable>? orderByList,
    JobInclude? include,
  }) {
    return JobIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Job.t),
      orderByList: orderByList?.call(Job.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
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
  @_is.useResult
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

class JobUpdateTable extends _is.UpdateTable<JobTable> {
  JobUpdateTable(super.table);

  _is.ColumnValue<int, int> shopId(int value) => _is.ColumnValue(
    table.shopId,
    value,
  );

  _is.ColumnValue<String, String> code(String value) => _is.ColumnValue(
    table.code,
    value,
  );

  _is.ColumnValue<String, String> title(String value) => _is.ColumnValue(
    table.title,
    value,
  );

  _is.ColumnValue<String, String> customer(String value) => _is.ColumnValue(
    table.customer,
    value,
  );

  _is.ColumnValue<int, int> quantity(int value) => _is.ColumnValue(
    table.quantity,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> dueAt(DateTime value) => _is.ColumnValue(
    table.dueAt,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> releaseAt(DateTime value) =>
      _is.ColumnValue(
        table.releaseAt,
        value,
      );

  _is.ColumnValue<int, int> priority(int value) => _is.ColumnValue(
    table.priority,
    value,
  );

  _is.ColumnValue<String, String> notes(String value) => _is.ColumnValue(
    table.notes,
    value,
  );
}

class JobTable extends _is.Table<int?> {
  JobTable({super.tableRelation}) : super(tableName: 'job') {
    updateTable = JobUpdateTable(this);
    shopId = _is.ColumnInt(
      'shopId',
      this,
    );
    code = _is.ColumnString(
      'code',
      this,
    );
    title = _is.ColumnString(
      'title',
      this,
    );
    customer = _is.ColumnString(
      'customer',
      this,
    );
    quantity = _is.ColumnInt(
      'quantity',
      this,
    );
    dueAt = _is.ColumnDateTime(
      'dueAt',
      this,
    );
    releaseAt = _is.ColumnDateTime(
      'releaseAt',
      this,
    );
    priority = _is.ColumnInt(
      'priority',
      this,
    );
    notes = _is.ColumnString(
      'notes',
      this,
    );
  }

  late final JobUpdateTable updateTable;

  /// Owning shop.
  late final _is.ColumnInt shopId;

  /// Shop-floor reference, e.g. "J-1042".
  late final _is.ColumnString code;

  /// Short description of the work.
  late final _is.ColumnString title;

  /// Customer name, used only for display.
  late final _is.ColumnString customer;

  /// Units to produce.
  late final _is.ColumnInt quantity;

  /// Promised delivery time.
  late final _is.ColumnDateTime dueAt;

  /// Material available / earliest start time.
  late final _is.ColumnDateTime releaseAt;

  /// 1 = standard, 2 = high, 3 = critical. Weights tardiness.
  late final _is.ColumnInt priority;

  /// Free-text shop notes.
  late final _is.ColumnString notes;

  @override
  List<_is.Column> get columns => [
    id,
    shopId,
    code,
    title,
    customer,
    quantity,
    dueAt,
    releaseAt,
    priority,
    notes,
  ];
}

class JobInclude extends _is.IncludeObject {
  JobInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Job.t;
}

class JobIncludeList extends _is.IncludeList {
  JobIncludeList._({
    _is.WhereExpressionBuilder<JobTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Job.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Job.t;
}

class JobRepository {
  const JobRepository._();

  /// Returns a list of [Job]s matching the given query parameters.
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
  Future<List<Job>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<JobTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<JobTable>? orderBy,
    _is.OrderByListBuilder<JobTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Job>(
      where: where?.call(Job.t),
      orderBy: orderBy?.call(Job.t),
      orderByList: orderByList?.call(Job.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Job] matching the given query parameters.
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
  Future<Job?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<JobTable>? where,
    int? offset,
    _is.OrderByBuilder<JobTable>? orderBy,
    _is.OrderByListBuilder<JobTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Job>(
      where: where?.call(Job.t),
      orderBy: orderBy?.call(Job.t),
      orderByList: orderByList?.call(Job.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Job] by its [id] or null if no such row exists.
  Future<Job?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Job>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Job]s in the list and returns the inserted rows.
  ///
  /// The returned [Job]s will have their `id` fields set.
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
  Future<List<Job>> insert(
    _is.DatabaseSession session,
    List<Job> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Job>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Job] and returns the inserted row.
  ///
  /// The returned [Job] will have its `id` field set.
  Future<Job> insertRow(
    _is.DatabaseSession session,
    Job row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Job>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Job]s in the list and returns the resulting rows.
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
  /// The returned [Job]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Job>> upsert(
    _is.DatabaseSession session,
    List<Job> rows, {
    required _is.ColumnSelections<JobTable> conflictColumns,
    _is.ColumnSelections<JobTable>? updateColumns,
    _is.WhereExpressionBuilder<JobTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Job>(
      rows,
      conflictColumns: conflictColumns(Job.t),
      updateColumns: updateColumns?.call(Job.t),
      updateWhere: updateWhere?.call(Job.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Job] and returns the resulting row.
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
  /// The returned [Job] will have its `id` field set.
  Future<Job?> upsertRow(
    _is.DatabaseSession session,
    Job row, {
    required _is.ColumnSelections<JobTable> conflictColumns,
    _is.ColumnSelections<JobTable>? updateColumns,
    _is.WhereExpressionBuilder<JobTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Job>(
      row,
      conflictColumns: conflictColumns(Job.t),
      updateColumns: updateColumns?.call(Job.t),
      updateWhere: updateWhere?.call(Job.t),
      transaction: transaction,
    );
  }

  /// Updates all [Job]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Job>> update(
    _is.DatabaseSession session,
    List<Job> rows, {
    _is.ColumnSelections<JobTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Job>(
      rows,
      columns: columns?.call(Job.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Job]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Job> updateRow(
    _is.DatabaseSession session,
    Job row, {
    _is.ColumnSelections<JobTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Job>(
      row,
      columns: columns?.call(Job.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Job] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Job?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<JobUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Job>(
      id,
      columnValues: columnValues(Job.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Job]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Job>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<JobUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<JobTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<JobTable>? orderBy,
    _is.OrderByListBuilder<JobTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Job>(
      columnValues: columnValues(Job.t.updateTable),
      where: where(Job.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Job.t),
      orderByList: orderByList?.call(Job.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Job]s in the list and returns the deleted rows.
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
  Future<List<Job>> delete(
    _is.DatabaseSession session,
    List<Job> rows, {
    _is.OrderByBuilder<JobTable>? orderBy,
    _is.OrderByListBuilder<JobTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Job>(
      rows,
      orderBy: orderBy?.call(Job.t),
      orderByList: orderByList?.call(Job.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Job].
  Future<Job> deleteRow(
    _is.DatabaseSession session,
    Job row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Job>(
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
  Future<List<Job>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<JobTable> where,
    _is.OrderByBuilder<JobTable>? orderBy,
    _is.OrderByListBuilder<JobTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Job>(
      where: where(Job.t),
      orderBy: orderBy?.call(Job.t),
      orderByList: orderByList?.call(Job.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<JobTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Job>(
      where: where?.call(Job.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Job] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<JobTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Job>(
      where: where(Job.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
