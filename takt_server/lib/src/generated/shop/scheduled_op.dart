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

/// A placed operation on a specific machine.
abstract class ScheduledOp
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ScheduledOp._({
    this.id,
    required this.runId,
    required this.jobId,
    required this.operationId,
    required this.workCenterId,
    required this.machineIndex,
    required this.startMinute,
    required this.endMinute,
    required this.queueMinutes,
    required this.changeoverMinutes,
    required this.sequenceOnMachine,
    required this.isTardy,
  });

  factory ScheduledOp({
    int? id,
    required int runId,
    required int jobId,
    required int operationId,
    required int workCenterId,
    required int machineIndex,
    required int startMinute,
    required int endMinute,
    required int queueMinutes,
    required int changeoverMinutes,
    required int sequenceOnMachine,
    required bool isTardy,
  }) = _ScheduledOpImpl;

  factory ScheduledOp.fromJson(Map<String, dynamic> jsonSerialization) {
    return ScheduledOp(
      id: jsonSerialization['id'] as int?,
      runId: jsonSerialization['runId'] as int,
      jobId: jsonSerialization['jobId'] as int,
      operationId: jsonSerialization['operationId'] as int,
      workCenterId: jsonSerialization['workCenterId'] as int,
      machineIndex: jsonSerialization['machineIndex'] as int,
      startMinute: jsonSerialization['startMinute'] as int,
      endMinute: jsonSerialization['endMinute'] as int,
      queueMinutes: jsonSerialization['queueMinutes'] as int,
      changeoverMinutes: jsonSerialization['changeoverMinutes'] as int,
      sequenceOnMachine: jsonSerialization['sequenceOnMachine'] as int,
      isTardy: _is.BoolJsonExtension.fromJson(jsonSerialization['isTardy']),
    );
  }

  static final t = ScheduledOpTable();

  static const db = ScheduledOpRepository._();

  @override
  int? id;

  /// Owning run.
  int runId;

  /// Job this operation belongs to.
  int jobId;

  /// Source operation.
  int operationId;

  /// Work center used.
  int workCenterId;

  /// Index of the parallel machine inside the work center.
  int machineIndex;

  /// Start minute relative to the run horizon.
  int startMinute;

  /// End minute relative to the run horizon.
  int endMinute;

  /// Minutes this operation waited for its machine.
  int queueMinutes;

  /// Changeover minutes charged before this operation.
  int changeoverMinutes;

  /// Position on this machine, starting at zero.
  int sequenceOnMachine;

  /// Whether the parent job finishes after its due time.
  bool isTardy;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ScheduledOp]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ScheduledOp copyWith({
    int? id,
    int? runId,
    int? jobId,
    int? operationId,
    int? workCenterId,
    int? machineIndex,
    int? startMinute,
    int? endMinute,
    int? queueMinutes,
    int? changeoverMinutes,
    int? sequenceOnMachine,
    bool? isTardy,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ScheduledOp',
      if (id != null) 'id': id,
      'runId': runId,
      'jobId': jobId,
      'operationId': operationId,
      'workCenterId': workCenterId,
      'machineIndex': machineIndex,
      'startMinute': startMinute,
      'endMinute': endMinute,
      'queueMinutes': queueMinutes,
      'changeoverMinutes': changeoverMinutes,
      'sequenceOnMachine': sequenceOnMachine,
      'isTardy': isTardy,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ScheduledOp',
      if (id != null) 'id': id,
      'runId': runId,
      'jobId': jobId,
      'operationId': operationId,
      'workCenterId': workCenterId,
      'machineIndex': machineIndex,
      'startMinute': startMinute,
      'endMinute': endMinute,
      'queueMinutes': queueMinutes,
      'changeoverMinutes': changeoverMinutes,
      'sequenceOnMachine': sequenceOnMachine,
      'isTardy': isTardy,
    };
  }

  static ScheduledOpInclude include() {
    return ScheduledOpInclude._();
  }

  static ScheduledOpIncludeList includeList({
    _is.WhereExpressionBuilder<ScheduledOpTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ScheduledOpTable>? orderBy,
    _is.OrderByListBuilder<ScheduledOpTable>? orderByList,
    ScheduledOpInclude? include,
  }) {
    return ScheduledOpIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ScheduledOp.t),
      orderByList: orderByList?.call(ScheduledOp.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ScheduledOpImpl extends ScheduledOp {
  _ScheduledOpImpl({
    int? id,
    required int runId,
    required int jobId,
    required int operationId,
    required int workCenterId,
    required int machineIndex,
    required int startMinute,
    required int endMinute,
    required int queueMinutes,
    required int changeoverMinutes,
    required int sequenceOnMachine,
    required bool isTardy,
  }) : super._(
         id: id,
         runId: runId,
         jobId: jobId,
         operationId: operationId,
         workCenterId: workCenterId,
         machineIndex: machineIndex,
         startMinute: startMinute,
         endMinute: endMinute,
         queueMinutes: queueMinutes,
         changeoverMinutes: changeoverMinutes,
         sequenceOnMachine: sequenceOnMachine,
         isTardy: isTardy,
       );

  /// Returns a shallow copy of this [ScheduledOp]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ScheduledOp copyWith({
    Object? id = _Undefined,
    int? runId,
    int? jobId,
    int? operationId,
    int? workCenterId,
    int? machineIndex,
    int? startMinute,
    int? endMinute,
    int? queueMinutes,
    int? changeoverMinutes,
    int? sequenceOnMachine,
    bool? isTardy,
  }) {
    return ScheduledOp(
      id: id is int? ? id : this.id,
      runId: runId ?? this.runId,
      jobId: jobId ?? this.jobId,
      operationId: operationId ?? this.operationId,
      workCenterId: workCenterId ?? this.workCenterId,
      machineIndex: machineIndex ?? this.machineIndex,
      startMinute: startMinute ?? this.startMinute,
      endMinute: endMinute ?? this.endMinute,
      queueMinutes: queueMinutes ?? this.queueMinutes,
      changeoverMinutes: changeoverMinutes ?? this.changeoverMinutes,
      sequenceOnMachine: sequenceOnMachine ?? this.sequenceOnMachine,
      isTardy: isTardy ?? this.isTardy,
    );
  }
}

class ScheduledOpUpdateTable extends _is.UpdateTable<ScheduledOpTable> {
  ScheduledOpUpdateTable(super.table);

  _is.ColumnValue<int, int> runId(int value) => _is.ColumnValue(
    table.runId,
    value,
  );

  _is.ColumnValue<int, int> jobId(int value) => _is.ColumnValue(
    table.jobId,
    value,
  );

  _is.ColumnValue<int, int> operationId(int value) => _is.ColumnValue(
    table.operationId,
    value,
  );

  _is.ColumnValue<int, int> workCenterId(int value) => _is.ColumnValue(
    table.workCenterId,
    value,
  );

  _is.ColumnValue<int, int> machineIndex(int value) => _is.ColumnValue(
    table.machineIndex,
    value,
  );

  _is.ColumnValue<int, int> startMinute(int value) => _is.ColumnValue(
    table.startMinute,
    value,
  );

  _is.ColumnValue<int, int> endMinute(int value) => _is.ColumnValue(
    table.endMinute,
    value,
  );

  _is.ColumnValue<int, int> queueMinutes(int value) => _is.ColumnValue(
    table.queueMinutes,
    value,
  );

  _is.ColumnValue<int, int> changeoverMinutes(int value) => _is.ColumnValue(
    table.changeoverMinutes,
    value,
  );

  _is.ColumnValue<int, int> sequenceOnMachine(int value) => _is.ColumnValue(
    table.sequenceOnMachine,
    value,
  );

  _is.ColumnValue<bool, bool> isTardy(bool value) => _is.ColumnValue(
    table.isTardy,
    value,
  );
}

class ScheduledOpTable extends _is.Table<int?> {
  ScheduledOpTable({super.tableRelation}) : super(tableName: 'scheduled_op') {
    updateTable = ScheduledOpUpdateTable(this);
    runId = _is.ColumnInt(
      'runId',
      this,
    );
    jobId = _is.ColumnInt(
      'jobId',
      this,
    );
    operationId = _is.ColumnInt(
      'operationId',
      this,
    );
    workCenterId = _is.ColumnInt(
      'workCenterId',
      this,
    );
    machineIndex = _is.ColumnInt(
      'machineIndex',
      this,
    );
    startMinute = _is.ColumnInt(
      'startMinute',
      this,
    );
    endMinute = _is.ColumnInt(
      'endMinute',
      this,
    );
    queueMinutes = _is.ColumnInt(
      'queueMinutes',
      this,
    );
    changeoverMinutes = _is.ColumnInt(
      'changeoverMinutes',
      this,
    );
    sequenceOnMachine = _is.ColumnInt(
      'sequenceOnMachine',
      this,
    );
    isTardy = _is.ColumnBool(
      'isTardy',
      this,
    );
  }

  late final ScheduledOpUpdateTable updateTable;

  /// Owning run.
  late final _is.ColumnInt runId;

  /// Job this operation belongs to.
  late final _is.ColumnInt jobId;

  /// Source operation.
  late final _is.ColumnInt operationId;

  /// Work center used.
  late final _is.ColumnInt workCenterId;

  /// Index of the parallel machine inside the work center.
  late final _is.ColumnInt machineIndex;

  /// Start minute relative to the run horizon.
  late final _is.ColumnInt startMinute;

  /// End minute relative to the run horizon.
  late final _is.ColumnInt endMinute;

  /// Minutes this operation waited for its machine.
  late final _is.ColumnInt queueMinutes;

  /// Changeover minutes charged before this operation.
  late final _is.ColumnInt changeoverMinutes;

  /// Position on this machine, starting at zero.
  late final _is.ColumnInt sequenceOnMachine;

  /// Whether the parent job finishes after its due time.
  late final _is.ColumnBool isTardy;

  @override
  List<_is.Column> get columns => [
    id,
    runId,
    jobId,
    operationId,
    workCenterId,
    machineIndex,
    startMinute,
    endMinute,
    queueMinutes,
    changeoverMinutes,
    sequenceOnMachine,
    isTardy,
  ];
}

class ScheduledOpInclude extends _is.IncludeObject {
  ScheduledOpInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ScheduledOp.t;
}

class ScheduledOpIncludeList extends _is.IncludeList {
  ScheduledOpIncludeList._({
    _is.WhereExpressionBuilder<ScheduledOpTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ScheduledOp.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ScheduledOp.t;
}

class ScheduledOpRepository {
  const ScheduledOpRepository._();

  /// Returns a list of [ScheduledOp]s matching the given query parameters.
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
  Future<List<ScheduledOp>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ScheduledOpTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ScheduledOpTable>? orderBy,
    _is.OrderByListBuilder<ScheduledOpTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ScheduledOp>(
      where: where?.call(ScheduledOp.t),
      orderBy: orderBy?.call(ScheduledOp.t),
      orderByList: orderByList?.call(ScheduledOp.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ScheduledOp] matching the given query parameters.
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
  Future<ScheduledOp?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ScheduledOpTable>? where,
    int? offset,
    _is.OrderByBuilder<ScheduledOpTable>? orderBy,
    _is.OrderByListBuilder<ScheduledOpTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ScheduledOp>(
      where: where?.call(ScheduledOp.t),
      orderBy: orderBy?.call(ScheduledOp.t),
      orderByList: orderByList?.call(ScheduledOp.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ScheduledOp] by its [id] or null if no such row exists.
  Future<ScheduledOp?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ScheduledOp>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ScheduledOp]s in the list and returns the inserted rows.
  ///
  /// The returned [ScheduledOp]s will have their `id` fields set.
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
  Future<List<ScheduledOp>> insert(
    _is.DatabaseSession session,
    List<ScheduledOp> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ScheduledOp>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ScheduledOp] and returns the inserted row.
  ///
  /// The returned [ScheduledOp] will have its `id` field set.
  Future<ScheduledOp> insertRow(
    _is.DatabaseSession session,
    ScheduledOp row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ScheduledOp>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ScheduledOp]s in the list and returns the resulting rows.
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
  /// The returned [ScheduledOp]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ScheduledOp>> upsert(
    _is.DatabaseSession session,
    List<ScheduledOp> rows, {
    required _is.ColumnSelections<ScheduledOpTable> conflictColumns,
    _is.ColumnSelections<ScheduledOpTable>? updateColumns,
    _is.WhereExpressionBuilder<ScheduledOpTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ScheduledOp>(
      rows,
      conflictColumns: conflictColumns(ScheduledOp.t),
      updateColumns: updateColumns?.call(ScheduledOp.t),
      updateWhere: updateWhere?.call(ScheduledOp.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ScheduledOp] and returns the resulting row.
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
  /// The returned [ScheduledOp] will have its `id` field set.
  Future<ScheduledOp?> upsertRow(
    _is.DatabaseSession session,
    ScheduledOp row, {
    required _is.ColumnSelections<ScheduledOpTable> conflictColumns,
    _is.ColumnSelections<ScheduledOpTable>? updateColumns,
    _is.WhereExpressionBuilder<ScheduledOpTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ScheduledOp>(
      row,
      conflictColumns: conflictColumns(ScheduledOp.t),
      updateColumns: updateColumns?.call(ScheduledOp.t),
      updateWhere: updateWhere?.call(ScheduledOp.t),
      transaction: transaction,
    );
  }

  /// Updates all [ScheduledOp]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ScheduledOp>> update(
    _is.DatabaseSession session,
    List<ScheduledOp> rows, {
    _is.ColumnSelections<ScheduledOpTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ScheduledOp>(
      rows,
      columns: columns?.call(ScheduledOp.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ScheduledOp]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ScheduledOp> updateRow(
    _is.DatabaseSession session,
    ScheduledOp row, {
    _is.ColumnSelections<ScheduledOpTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ScheduledOp>(
      row,
      columns: columns?.call(ScheduledOp.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ScheduledOp] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ScheduledOp?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ScheduledOpUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ScheduledOp>(
      id,
      columnValues: columnValues(ScheduledOp.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ScheduledOp]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ScheduledOp>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ScheduledOpUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ScheduledOpTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ScheduledOpTable>? orderBy,
    _is.OrderByListBuilder<ScheduledOpTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ScheduledOp>(
      columnValues: columnValues(ScheduledOp.t.updateTable),
      where: where(ScheduledOp.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ScheduledOp.t),
      orderByList: orderByList?.call(ScheduledOp.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ScheduledOp]s in the list and returns the deleted rows.
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
  Future<List<ScheduledOp>> delete(
    _is.DatabaseSession session,
    List<ScheduledOp> rows, {
    _is.OrderByBuilder<ScheduledOpTable>? orderBy,
    _is.OrderByListBuilder<ScheduledOpTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ScheduledOp>(
      rows,
      orderBy: orderBy?.call(ScheduledOp.t),
      orderByList: orderByList?.call(ScheduledOp.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ScheduledOp].
  Future<ScheduledOp> deleteRow(
    _is.DatabaseSession session,
    ScheduledOp row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ScheduledOp>(
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
  Future<List<ScheduledOp>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ScheduledOpTable> where,
    _is.OrderByBuilder<ScheduledOpTable>? orderBy,
    _is.OrderByListBuilder<ScheduledOpTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ScheduledOp>(
      where: where(ScheduledOp.t),
      orderBy: orderBy?.call(ScheduledOp.t),
      orderByList: orderByList?.call(ScheduledOp.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ScheduledOpTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ScheduledOp>(
      where: where?.call(ScheduledOp.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ScheduledOp] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ScheduledOpTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ScheduledOp>(
      where: where(ScheduledOp.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
