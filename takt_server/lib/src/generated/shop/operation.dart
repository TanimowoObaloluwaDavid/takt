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

/// One step in a job's routing. Operations run in ascending sequence.
abstract class Operation
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Operation._({
    this.id,
    required this.jobId,
    required this.sequence,
    required this.workCenterId,
    required this.setupMinutes,
    required this.unitRunMinutes,
    required this.description,
  });

  factory Operation({
    int? id,
    required int jobId,
    required int sequence,
    required int workCenterId,
    required int setupMinutes,
    required double unitRunMinutes,
    required String description,
  }) = _OperationImpl;

  factory Operation.fromJson(Map<String, dynamic> jsonSerialization) {
    return Operation(
      id: jsonSerialization['id'] as int?,
      jobId: jsonSerialization['jobId'] as int,
      sequence: jsonSerialization['sequence'] as int,
      workCenterId: jsonSerialization['workCenterId'] as int,
      setupMinutes: jsonSerialization['setupMinutes'] as int,
      unitRunMinutes: (jsonSerialization['unitRunMinutes'] as num).toDouble(),
      description: jsonSerialization['description'] as String,
    );
  }

  static final t = OperationTable();

  static const db = OperationRepository._();

  @override
  int? id;

  /// Owning job.
  int jobId;

  /// Position in the routing, starting at 10 and stepping by 10.
  int sequence;

  /// Work center that performs this step.
  int workCenterId;

  /// Fixed setup time for this step.
  int setupMinutes;

  /// Run time per unit, in minutes.
  double unitRunMinutes;

  /// What happens at this step.
  String description;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Operation]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Operation copyWith({
    int? id,
    int? jobId,
    int? sequence,
    int? workCenterId,
    int? setupMinutes,
    double? unitRunMinutes,
    String? description,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Operation',
      if (id != null) 'id': id,
      'jobId': jobId,
      'sequence': sequence,
      'workCenterId': workCenterId,
      'setupMinutes': setupMinutes,
      'unitRunMinutes': unitRunMinutes,
      'description': description,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Operation',
      if (id != null) 'id': id,
      'jobId': jobId,
      'sequence': sequence,
      'workCenterId': workCenterId,
      'setupMinutes': setupMinutes,
      'unitRunMinutes': unitRunMinutes,
      'description': description,
    };
  }

  static OperationInclude include() {
    return OperationInclude._();
  }

  static OperationIncludeList includeList({
    _is.WhereExpressionBuilder<OperationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<OperationTable>? orderBy,
    _is.OrderByListBuilder<OperationTable>? orderByList,
    OperationInclude? include,
  }) {
    return OperationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Operation.t),
      orderByList: orderByList?.call(Operation.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OperationImpl extends Operation {
  _OperationImpl({
    int? id,
    required int jobId,
    required int sequence,
    required int workCenterId,
    required int setupMinutes,
    required double unitRunMinutes,
    required String description,
  }) : super._(
         id: id,
         jobId: jobId,
         sequence: sequence,
         workCenterId: workCenterId,
         setupMinutes: setupMinutes,
         unitRunMinutes: unitRunMinutes,
         description: description,
       );

  /// Returns a shallow copy of this [Operation]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Operation copyWith({
    Object? id = _Undefined,
    int? jobId,
    int? sequence,
    int? workCenterId,
    int? setupMinutes,
    double? unitRunMinutes,
    String? description,
  }) {
    return Operation(
      id: id is int? ? id : this.id,
      jobId: jobId ?? this.jobId,
      sequence: sequence ?? this.sequence,
      workCenterId: workCenterId ?? this.workCenterId,
      setupMinutes: setupMinutes ?? this.setupMinutes,
      unitRunMinutes: unitRunMinutes ?? this.unitRunMinutes,
      description: description ?? this.description,
    );
  }
}

class OperationUpdateTable extends _is.UpdateTable<OperationTable> {
  OperationUpdateTable(super.table);

  _is.ColumnValue<int, int> jobId(int value) => _is.ColumnValue(
    table.jobId,
    value,
  );

  _is.ColumnValue<int, int> sequence(int value) => _is.ColumnValue(
    table.sequence,
    value,
  );

  _is.ColumnValue<int, int> workCenterId(int value) => _is.ColumnValue(
    table.workCenterId,
    value,
  );

  _is.ColumnValue<int, int> setupMinutes(int value) => _is.ColumnValue(
    table.setupMinutes,
    value,
  );

  _is.ColumnValue<double, double> unitRunMinutes(double value) =>
      _is.ColumnValue(
        table.unitRunMinutes,
        value,
      );

  _is.ColumnValue<String, String> description(String value) => _is.ColumnValue(
    table.description,
    value,
  );
}

class OperationTable extends _is.Table<int?> {
  OperationTable({super.tableRelation}) : super(tableName: 'operation') {
    updateTable = OperationUpdateTable(this);
    jobId = _is.ColumnInt(
      'jobId',
      this,
    );
    sequence = _is.ColumnInt(
      'sequence',
      this,
    );
    workCenterId = _is.ColumnInt(
      'workCenterId',
      this,
    );
    setupMinutes = _is.ColumnInt(
      'setupMinutes',
      this,
    );
    unitRunMinutes = _is.ColumnDouble(
      'unitRunMinutes',
      this,
    );
    description = _is.ColumnString(
      'description',
      this,
    );
  }

  late final OperationUpdateTable updateTable;

  /// Owning job.
  late final _is.ColumnInt jobId;

  /// Position in the routing, starting at 10 and stepping by 10.
  late final _is.ColumnInt sequence;

  /// Work center that performs this step.
  late final _is.ColumnInt workCenterId;

  /// Fixed setup time for this step.
  late final _is.ColumnInt setupMinutes;

  /// Run time per unit, in minutes.
  late final _is.ColumnDouble unitRunMinutes;

  /// What happens at this step.
  late final _is.ColumnString description;

  @override
  List<_is.Column> get columns => [
    id,
    jobId,
    sequence,
    workCenterId,
    setupMinutes,
    unitRunMinutes,
    description,
  ];
}

class OperationInclude extends _is.IncludeObject {
  OperationInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Operation.t;
}

class OperationIncludeList extends _is.IncludeList {
  OperationIncludeList._({
    _is.WhereExpressionBuilder<OperationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Operation.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Operation.t;
}

class OperationRepository {
  const OperationRepository._();

  /// Returns a list of [Operation]s matching the given query parameters.
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
  Future<List<Operation>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<OperationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<OperationTable>? orderBy,
    _is.OrderByListBuilder<OperationTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Operation>(
      where: where?.call(Operation.t),
      orderBy: orderBy?.call(Operation.t),
      orderByList: orderByList?.call(Operation.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Operation] matching the given query parameters.
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
  Future<Operation?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<OperationTable>? where,
    int? offset,
    _is.OrderByBuilder<OperationTable>? orderBy,
    _is.OrderByListBuilder<OperationTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Operation>(
      where: where?.call(Operation.t),
      orderBy: orderBy?.call(Operation.t),
      orderByList: orderByList?.call(Operation.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Operation] by its [id] or null if no such row exists.
  Future<Operation?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Operation>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Operation]s in the list and returns the inserted rows.
  ///
  /// The returned [Operation]s will have their `id` fields set.
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
  Future<List<Operation>> insert(
    _is.DatabaseSession session,
    List<Operation> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Operation>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Operation] and returns the inserted row.
  ///
  /// The returned [Operation] will have its `id` field set.
  Future<Operation> insertRow(
    _is.DatabaseSession session,
    Operation row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Operation>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Operation]s in the list and returns the resulting rows.
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
  /// The returned [Operation]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Operation>> upsert(
    _is.DatabaseSession session,
    List<Operation> rows, {
    required _is.ColumnSelections<OperationTable> conflictColumns,
    _is.ColumnSelections<OperationTable>? updateColumns,
    _is.WhereExpressionBuilder<OperationTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Operation>(
      rows,
      conflictColumns: conflictColumns(Operation.t),
      updateColumns: updateColumns?.call(Operation.t),
      updateWhere: updateWhere?.call(Operation.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Operation] and returns the resulting row.
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
  /// The returned [Operation] will have its `id` field set.
  Future<Operation?> upsertRow(
    _is.DatabaseSession session,
    Operation row, {
    required _is.ColumnSelections<OperationTable> conflictColumns,
    _is.ColumnSelections<OperationTable>? updateColumns,
    _is.WhereExpressionBuilder<OperationTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Operation>(
      row,
      conflictColumns: conflictColumns(Operation.t),
      updateColumns: updateColumns?.call(Operation.t),
      updateWhere: updateWhere?.call(Operation.t),
      transaction: transaction,
    );
  }

  /// Updates all [Operation]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Operation>> update(
    _is.DatabaseSession session,
    List<Operation> rows, {
    _is.ColumnSelections<OperationTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Operation>(
      rows,
      columns: columns?.call(Operation.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Operation]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Operation> updateRow(
    _is.DatabaseSession session,
    Operation row, {
    _is.ColumnSelections<OperationTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Operation>(
      row,
      columns: columns?.call(Operation.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Operation] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Operation?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<OperationUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Operation>(
      id,
      columnValues: columnValues(Operation.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Operation]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Operation>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<OperationUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<OperationTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<OperationTable>? orderBy,
    _is.OrderByListBuilder<OperationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Operation>(
      columnValues: columnValues(Operation.t.updateTable),
      where: where(Operation.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Operation.t),
      orderByList: orderByList?.call(Operation.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Operation]s in the list and returns the deleted rows.
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
  Future<List<Operation>> delete(
    _is.DatabaseSession session,
    List<Operation> rows, {
    _is.OrderByBuilder<OperationTable>? orderBy,
    _is.OrderByListBuilder<OperationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Operation>(
      rows,
      orderBy: orderBy?.call(Operation.t),
      orderByList: orderByList?.call(Operation.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Operation].
  Future<Operation> deleteRow(
    _is.DatabaseSession session,
    Operation row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Operation>(
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
  Future<List<Operation>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<OperationTable> where,
    _is.OrderByBuilder<OperationTable>? orderBy,
    _is.OrderByListBuilder<OperationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Operation>(
      where: where(Operation.t),
      orderBy: orderBy?.call(Operation.t),
      orderByList: orderByList?.call(Operation.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<OperationTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Operation>(
      where: where?.call(Operation.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Operation] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<OperationTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Operation>(
      where: where(Operation.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
