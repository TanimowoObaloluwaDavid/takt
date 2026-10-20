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

/// A group of identical parallel machines that can perform an operation.
abstract class WorkCenter
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  WorkCenter._({
    this.id,
    required this.shopId,
    required this.name,
    required this.code,
    required this.machines,
    required this.changeoverMinutes,
    required this.notes,
  });

  factory WorkCenter({
    int? id,
    required int shopId,
    required String name,
    required String code,
    required int machines,
    required int changeoverMinutes,
    required String notes,
  }) = _WorkCenterImpl;

  factory WorkCenter.fromJson(Map<String, dynamic> jsonSerialization) {
    return WorkCenter(
      id: jsonSerialization['id'] as int?,
      shopId: jsonSerialization['shopId'] as int,
      name: jsonSerialization['name'] as String,
      code: jsonSerialization['code'] as String,
      machines: jsonSerialization['machines'] as int,
      changeoverMinutes: jsonSerialization['changeoverMinutes'] as int,
      notes: jsonSerialization['notes'] as String,
    );
  }

  static final t = WorkCenterTable();

  static const db = WorkCenterRepository._();

  @override
  int? id;

  /// Owning shop.
  int shopId;

  /// Human name, e.g. "CNC Mill 2".
  String name;

  /// Short code shown on the schedule, e.g. "CNC-02".
  String code;

  /// Number of identical machines in this work center.
  int machines;

  /// Flat changeover time when the machine switches to a different job.
  int changeoverMinutes;

  /// Optional note about capability or crew.
  String notes;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [WorkCenter]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  WorkCenter copyWith({
    int? id,
    int? shopId,
    String? name,
    String? code,
    int? machines,
    int? changeoverMinutes,
    String? notes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WorkCenter',
      if (id != null) 'id': id,
      'shopId': shopId,
      'name': name,
      'code': code,
      'machines': machines,
      'changeoverMinutes': changeoverMinutes,
      'notes': notes,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'WorkCenter',
      if (id != null) 'id': id,
      'shopId': shopId,
      'name': name,
      'code': code,
      'machines': machines,
      'changeoverMinutes': changeoverMinutes,
      'notes': notes,
    };
  }

  static WorkCenterInclude include() {
    return WorkCenterInclude._();
  }

  static WorkCenterIncludeList includeList({
    _is.WhereExpressionBuilder<WorkCenterTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<WorkCenterTable>? orderBy,
    _is.OrderByListBuilder<WorkCenterTable>? orderByList,
    WorkCenterInclude? include,
  }) {
    return WorkCenterIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(WorkCenter.t),
      orderByList: orderByList?.call(WorkCenter.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WorkCenterImpl extends WorkCenter {
  _WorkCenterImpl({
    int? id,
    required int shopId,
    required String name,
    required String code,
    required int machines,
    required int changeoverMinutes,
    required String notes,
  }) : super._(
         id: id,
         shopId: shopId,
         name: name,
         code: code,
         machines: machines,
         changeoverMinutes: changeoverMinutes,
         notes: notes,
       );

  /// Returns a shallow copy of this [WorkCenter]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  WorkCenter copyWith({
    Object? id = _Undefined,
    int? shopId,
    String? name,
    String? code,
    int? machines,
    int? changeoverMinutes,
    String? notes,
  }) {
    return WorkCenter(
      id: id is int? ? id : this.id,
      shopId: shopId ?? this.shopId,
      name: name ?? this.name,
      code: code ?? this.code,
      machines: machines ?? this.machines,
      changeoverMinutes: changeoverMinutes ?? this.changeoverMinutes,
      notes: notes ?? this.notes,
    );
  }
}

class WorkCenterUpdateTable extends _is.UpdateTable<WorkCenterTable> {
  WorkCenterUpdateTable(super.table);

  _is.ColumnValue<int, int> shopId(int value) => _is.ColumnValue(
    table.shopId,
    value,
  );

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<String, String> code(String value) => _is.ColumnValue(
    table.code,
    value,
  );

  _is.ColumnValue<int, int> machines(int value) => _is.ColumnValue(
    table.machines,
    value,
  );

  _is.ColumnValue<int, int> changeoverMinutes(int value) => _is.ColumnValue(
    table.changeoverMinutes,
    value,
  );

  _is.ColumnValue<String, String> notes(String value) => _is.ColumnValue(
    table.notes,
    value,
  );
}

class WorkCenterTable extends _is.Table<int?> {
  WorkCenterTable({super.tableRelation}) : super(tableName: 'work_center') {
    updateTable = WorkCenterUpdateTable(this);
    shopId = _is.ColumnInt(
      'shopId',
      this,
    );
    name = _is.ColumnString(
      'name',
      this,
    );
    code = _is.ColumnString(
      'code',
      this,
    );
    machines = _is.ColumnInt(
      'machines',
      this,
    );
    changeoverMinutes = _is.ColumnInt(
      'changeoverMinutes',
      this,
    );
    notes = _is.ColumnString(
      'notes',
      this,
    );
  }

  late final WorkCenterUpdateTable updateTable;

  /// Owning shop.
  late final _is.ColumnInt shopId;

  /// Human name, e.g. "CNC Mill 2".
  late final _is.ColumnString name;

  /// Short code shown on the schedule, e.g. "CNC-02".
  late final _is.ColumnString code;

  /// Number of identical machines in this work center.
  late final _is.ColumnInt machines;

  /// Flat changeover time when the machine switches to a different job.
  late final _is.ColumnInt changeoverMinutes;

  /// Optional note about capability or crew.
  late final _is.ColumnString notes;

  @override
  List<_is.Column> get columns => [
    id,
    shopId,
    name,
    code,
    machines,
    changeoverMinutes,
    notes,
  ];
}

class WorkCenterInclude extends _is.IncludeObject {
  WorkCenterInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => WorkCenter.t;
}

class WorkCenterIncludeList extends _is.IncludeList {
  WorkCenterIncludeList._({
    _is.WhereExpressionBuilder<WorkCenterTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(WorkCenter.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => WorkCenter.t;
}

class WorkCenterRepository {
  const WorkCenterRepository._();

  /// Returns a list of [WorkCenter]s matching the given query parameters.
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
  Future<List<WorkCenter>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<WorkCenterTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<WorkCenterTable>? orderBy,
    _is.OrderByListBuilder<WorkCenterTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<WorkCenter>(
      where: where?.call(WorkCenter.t),
      orderBy: orderBy?.call(WorkCenter.t),
      orderByList: orderByList?.call(WorkCenter.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [WorkCenter] matching the given query parameters.
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
  Future<WorkCenter?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<WorkCenterTable>? where,
    int? offset,
    _is.OrderByBuilder<WorkCenterTable>? orderBy,
    _is.OrderByListBuilder<WorkCenterTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<WorkCenter>(
      where: where?.call(WorkCenter.t),
      orderBy: orderBy?.call(WorkCenter.t),
      orderByList: orderByList?.call(WorkCenter.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [WorkCenter] by its [id] or null if no such row exists.
  Future<WorkCenter?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<WorkCenter>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [WorkCenter]s in the list and returns the inserted rows.
  ///
  /// The returned [WorkCenter]s will have their `id` fields set.
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
  Future<List<WorkCenter>> insert(
    _is.DatabaseSession session,
    List<WorkCenter> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<WorkCenter>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [WorkCenter] and returns the inserted row.
  ///
  /// The returned [WorkCenter] will have its `id` field set.
  Future<WorkCenter> insertRow(
    _is.DatabaseSession session,
    WorkCenter row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<WorkCenter>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [WorkCenter]s in the list and returns the resulting rows.
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
  /// The returned [WorkCenter]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<WorkCenter>> upsert(
    _is.DatabaseSession session,
    List<WorkCenter> rows, {
    required _is.ColumnSelections<WorkCenterTable> conflictColumns,
    _is.ColumnSelections<WorkCenterTable>? updateColumns,
    _is.WhereExpressionBuilder<WorkCenterTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<WorkCenter>(
      rows,
      conflictColumns: conflictColumns(WorkCenter.t),
      updateColumns: updateColumns?.call(WorkCenter.t),
      updateWhere: updateWhere?.call(WorkCenter.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [WorkCenter] and returns the resulting row.
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
  /// The returned [WorkCenter] will have its `id` field set.
  Future<WorkCenter?> upsertRow(
    _is.DatabaseSession session,
    WorkCenter row, {
    required _is.ColumnSelections<WorkCenterTable> conflictColumns,
    _is.ColumnSelections<WorkCenterTable>? updateColumns,
    _is.WhereExpressionBuilder<WorkCenterTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<WorkCenter>(
      row,
      conflictColumns: conflictColumns(WorkCenter.t),
      updateColumns: updateColumns?.call(WorkCenter.t),
      updateWhere: updateWhere?.call(WorkCenter.t),
      transaction: transaction,
    );
  }

  /// Updates all [WorkCenter]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<WorkCenter>> update(
    _is.DatabaseSession session,
    List<WorkCenter> rows, {
    _is.ColumnSelections<WorkCenterTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<WorkCenter>(
      rows,
      columns: columns?.call(WorkCenter.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [WorkCenter]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<WorkCenter> updateRow(
    _is.DatabaseSession session,
    WorkCenter row, {
    _is.ColumnSelections<WorkCenterTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<WorkCenter>(
      row,
      columns: columns?.call(WorkCenter.t),
      transaction: transaction,
    );
  }

  /// Updates a single [WorkCenter] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<WorkCenter?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<WorkCenterUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<WorkCenter>(
      id,
      columnValues: columnValues(WorkCenter.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [WorkCenter]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<WorkCenter>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<WorkCenterUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<WorkCenterTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<WorkCenterTable>? orderBy,
    _is.OrderByListBuilder<WorkCenterTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<WorkCenter>(
      columnValues: columnValues(WorkCenter.t.updateTable),
      where: where(WorkCenter.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(WorkCenter.t),
      orderByList: orderByList?.call(WorkCenter.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [WorkCenter]s in the list and returns the deleted rows.
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
  Future<List<WorkCenter>> delete(
    _is.DatabaseSession session,
    List<WorkCenter> rows, {
    _is.OrderByBuilder<WorkCenterTable>? orderBy,
    _is.OrderByListBuilder<WorkCenterTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<WorkCenter>(
      rows,
      orderBy: orderBy?.call(WorkCenter.t),
      orderByList: orderByList?.call(WorkCenter.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [WorkCenter].
  Future<WorkCenter> deleteRow(
    _is.DatabaseSession session,
    WorkCenter row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<WorkCenter>(
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
  Future<List<WorkCenter>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<WorkCenterTable> where,
    _is.OrderByBuilder<WorkCenterTable>? orderBy,
    _is.OrderByListBuilder<WorkCenterTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<WorkCenter>(
      where: where(WorkCenter.t),
      orderBy: orderBy?.call(WorkCenter.t),
      orderByList: orderByList?.call(WorkCenter.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<WorkCenterTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<WorkCenter>(
      where: where?.call(WorkCenter.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [WorkCenter] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<WorkCenterTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<WorkCenter>(
      where: where(WorkCenter.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
