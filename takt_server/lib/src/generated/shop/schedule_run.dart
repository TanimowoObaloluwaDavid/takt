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

/// One persisted result of the solver. Times are minutes from horizonStart.
abstract class ScheduleRun
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ScheduleRun._({
    this.id,
    required this.shopId,
    required this.createdAt,
    required this.seed,
    required this.horizonStart,
    required this.onTimeJobs,
    required this.tardyJobs,
    required this.totalTardinessMinutes,
    required this.makespanMinutes,
    required this.objective,
    required this.bottleneckWorkCenterId,
    required this.bottleneckUtilization,
  });

  factory ScheduleRun({
    int? id,
    required int shopId,
    required DateTime createdAt,
    required int seed,
    required DateTime horizonStart,
    required int onTimeJobs,
    required int tardyJobs,
    required int totalTardinessMinutes,
    required int makespanMinutes,
    required double objective,
    required int bottleneckWorkCenterId,
    required double bottleneckUtilization,
  }) = _ScheduleRunImpl;

  factory ScheduleRun.fromJson(Map<String, dynamic> jsonSerialization) {
    return ScheduleRun(
      id: jsonSerialization['id'] as int?,
      shopId: jsonSerialization['shopId'] as int,
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      seed: jsonSerialization['seed'] as int,
      horizonStart: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['horizonStart'],
      ),
      onTimeJobs: jsonSerialization['onTimeJobs'] as int,
      tardyJobs: jsonSerialization['tardyJobs'] as int,
      totalTardinessMinutes: jsonSerialization['totalTardinessMinutes'] as int,
      makespanMinutes: jsonSerialization['makespanMinutes'] as int,
      objective: (jsonSerialization['objective'] as num).toDouble(),
      bottleneckWorkCenterId:
          jsonSerialization['bottleneckWorkCenterId'] as int,
      bottleneckUtilization: (jsonSerialization['bottleneckUtilization'] as num)
          .toDouble(),
    );
  }

  static final t = ScheduleRunTable();

  static const db = ScheduleRunRepository._();

  @override
  int? id;

  /// Owning shop.
  int shopId;

  /// When the run was produced.
  DateTime createdAt;

  /// Seed used, so any run can be reproduced exactly.
  int seed;

  /// Calendar anchor that minute zero maps to.
  DateTime horizonStart;

  /// Jobs that finished on or before their due time.
  int onTimeJobs;

  /// Jobs that finished late.
  int tardyJobs;

  /// Sum of minutes late across all jobs in this run.
  int totalTardinessMinutes;

  /// Time from minute zero until the last operation ends.
  int makespanMinutes;

  /// Solver objective (lower is better).
  double objective;

  /// Work center with the highest utilisation.
  int bottleneckWorkCenterId;

  /// Utilisation of the bottleneck, 0..1+.
  double bottleneckUtilization;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ScheduleRun]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ScheduleRun copyWith({
    int? id,
    int? shopId,
    DateTime? createdAt,
    int? seed,
    DateTime? horizonStart,
    int? onTimeJobs,
    int? tardyJobs,
    int? totalTardinessMinutes,
    int? makespanMinutes,
    double? objective,
    int? bottleneckWorkCenterId,
    double? bottleneckUtilization,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ScheduleRun',
      if (id != null) 'id': id,
      'shopId': shopId,
      'createdAt': createdAt.toJson(),
      'seed': seed,
      'horizonStart': horizonStart.toJson(),
      'onTimeJobs': onTimeJobs,
      'tardyJobs': tardyJobs,
      'totalTardinessMinutes': totalTardinessMinutes,
      'makespanMinutes': makespanMinutes,
      'objective': objective,
      'bottleneckWorkCenterId': bottleneckWorkCenterId,
      'bottleneckUtilization': bottleneckUtilization,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ScheduleRun',
      if (id != null) 'id': id,
      'shopId': shopId,
      'createdAt': createdAt.toJson(),
      'seed': seed,
      'horizonStart': horizonStart.toJson(),
      'onTimeJobs': onTimeJobs,
      'tardyJobs': tardyJobs,
      'totalTardinessMinutes': totalTardinessMinutes,
      'makespanMinutes': makespanMinutes,
      'objective': objective,
      'bottleneckWorkCenterId': bottleneckWorkCenterId,
      'bottleneckUtilization': bottleneckUtilization,
    };
  }

  static ScheduleRunInclude include() {
    return ScheduleRunInclude._();
  }

  static ScheduleRunIncludeList includeList({
    _is.WhereExpressionBuilder<ScheduleRunTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ScheduleRunTable>? orderBy,
    _is.OrderByListBuilder<ScheduleRunTable>? orderByList,
    ScheduleRunInclude? include,
  }) {
    return ScheduleRunIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ScheduleRun.t),
      orderByList: orderByList?.call(ScheduleRun.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ScheduleRunImpl extends ScheduleRun {
  _ScheduleRunImpl({
    int? id,
    required int shopId,
    required DateTime createdAt,
    required int seed,
    required DateTime horizonStart,
    required int onTimeJobs,
    required int tardyJobs,
    required int totalTardinessMinutes,
    required int makespanMinutes,
    required double objective,
    required int bottleneckWorkCenterId,
    required double bottleneckUtilization,
  }) : super._(
         id: id,
         shopId: shopId,
         createdAt: createdAt,
         seed: seed,
         horizonStart: horizonStart,
         onTimeJobs: onTimeJobs,
         tardyJobs: tardyJobs,
         totalTardinessMinutes: totalTardinessMinutes,
         makespanMinutes: makespanMinutes,
         objective: objective,
         bottleneckWorkCenterId: bottleneckWorkCenterId,
         bottleneckUtilization: bottleneckUtilization,
       );

  /// Returns a shallow copy of this [ScheduleRun]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ScheduleRun copyWith({
    Object? id = _Undefined,
    int? shopId,
    DateTime? createdAt,
    int? seed,
    DateTime? horizonStart,
    int? onTimeJobs,
    int? tardyJobs,
    int? totalTardinessMinutes,
    int? makespanMinutes,
    double? objective,
    int? bottleneckWorkCenterId,
    double? bottleneckUtilization,
  }) {
    return ScheduleRun(
      id: id is int? ? id : this.id,
      shopId: shopId ?? this.shopId,
      createdAt: createdAt ?? this.createdAt,
      seed: seed ?? this.seed,
      horizonStart: horizonStart ?? this.horizonStart,
      onTimeJobs: onTimeJobs ?? this.onTimeJobs,
      tardyJobs: tardyJobs ?? this.tardyJobs,
      totalTardinessMinutes:
          totalTardinessMinutes ?? this.totalTardinessMinutes,
      makespanMinutes: makespanMinutes ?? this.makespanMinutes,
      objective: objective ?? this.objective,
      bottleneckWorkCenterId:
          bottleneckWorkCenterId ?? this.bottleneckWorkCenterId,
      bottleneckUtilization:
          bottleneckUtilization ?? this.bottleneckUtilization,
    );
  }
}

class ScheduleRunUpdateTable extends _is.UpdateTable<ScheduleRunTable> {
  ScheduleRunUpdateTable(super.table);

  _is.ColumnValue<int, int> shopId(int value) => _is.ColumnValue(
    table.shopId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<int, int> seed(int value) => _is.ColumnValue(
    table.seed,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> horizonStart(DateTime value) =>
      _is.ColumnValue(
        table.horizonStart,
        value,
      );

  _is.ColumnValue<int, int> onTimeJobs(int value) => _is.ColumnValue(
    table.onTimeJobs,
    value,
  );

  _is.ColumnValue<int, int> tardyJobs(int value) => _is.ColumnValue(
    table.tardyJobs,
    value,
  );

  _is.ColumnValue<int, int> totalTardinessMinutes(int value) => _is.ColumnValue(
    table.totalTardinessMinutes,
    value,
  );

  _is.ColumnValue<int, int> makespanMinutes(int value) => _is.ColumnValue(
    table.makespanMinutes,
    value,
  );

  _is.ColumnValue<double, double> objective(double value) => _is.ColumnValue(
    table.objective,
    value,
  );

  _is.ColumnValue<int, int> bottleneckWorkCenterId(int value) =>
      _is.ColumnValue(
        table.bottleneckWorkCenterId,
        value,
      );

  _is.ColumnValue<double, double> bottleneckUtilization(double value) =>
      _is.ColumnValue(
        table.bottleneckUtilization,
        value,
      );
}

class ScheduleRunTable extends _is.Table<int?> {
  ScheduleRunTable({super.tableRelation}) : super(tableName: 'schedule_run') {
    updateTable = ScheduleRunUpdateTable(this);
    shopId = _is.ColumnInt(
      'shopId',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
    seed = _is.ColumnInt(
      'seed',
      this,
    );
    horizonStart = _is.ColumnDateTime(
      'horizonStart',
      this,
    );
    onTimeJobs = _is.ColumnInt(
      'onTimeJobs',
      this,
    );
    tardyJobs = _is.ColumnInt(
      'tardyJobs',
      this,
    );
    totalTardinessMinutes = _is.ColumnInt(
      'totalTardinessMinutes',
      this,
    );
    makespanMinutes = _is.ColumnInt(
      'makespanMinutes',
      this,
    );
    objective = _is.ColumnDouble(
      'objective',
      this,
    );
    bottleneckWorkCenterId = _is.ColumnInt(
      'bottleneckWorkCenterId',
      this,
    );
    bottleneckUtilization = _is.ColumnDouble(
      'bottleneckUtilization',
      this,
    );
  }

  late final ScheduleRunUpdateTable updateTable;

  /// Owning shop.
  late final _is.ColumnInt shopId;

  /// When the run was produced.
  late final _is.ColumnDateTime createdAt;

  /// Seed used, so any run can be reproduced exactly.
  late final _is.ColumnInt seed;

  /// Calendar anchor that minute zero maps to.
  late final _is.ColumnDateTime horizonStart;

  /// Jobs that finished on or before their due time.
  late final _is.ColumnInt onTimeJobs;

  /// Jobs that finished late.
  late final _is.ColumnInt tardyJobs;

  /// Sum of minutes late across all jobs in this run.
  late final _is.ColumnInt totalTardinessMinutes;

  /// Time from minute zero until the last operation ends.
  late final _is.ColumnInt makespanMinutes;

  /// Solver objective (lower is better).
  late final _is.ColumnDouble objective;

  /// Work center with the highest utilisation.
  late final _is.ColumnInt bottleneckWorkCenterId;

  /// Utilisation of the bottleneck, 0..1+.
  late final _is.ColumnDouble bottleneckUtilization;

  @override
  List<_is.Column> get columns => [
    id,
    shopId,
    createdAt,
    seed,
    horizonStart,
    onTimeJobs,
    tardyJobs,
    totalTardinessMinutes,
    makespanMinutes,
    objective,
    bottleneckWorkCenterId,
    bottleneckUtilization,
  ];
}

class ScheduleRunInclude extends _is.IncludeObject {
  ScheduleRunInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ScheduleRun.t;
}

class ScheduleRunIncludeList extends _is.IncludeList {
  ScheduleRunIncludeList._({
    _is.WhereExpressionBuilder<ScheduleRunTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ScheduleRun.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ScheduleRun.t;
}

class ScheduleRunRepository {
  const ScheduleRunRepository._();

  /// Returns a list of [ScheduleRun]s matching the given query parameters.
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
  Future<List<ScheduleRun>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ScheduleRunTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ScheduleRunTable>? orderBy,
    _is.OrderByListBuilder<ScheduleRunTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ScheduleRun>(
      where: where?.call(ScheduleRun.t),
      orderBy: orderBy?.call(ScheduleRun.t),
      orderByList: orderByList?.call(ScheduleRun.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ScheduleRun] matching the given query parameters.
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
  Future<ScheduleRun?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ScheduleRunTable>? where,
    int? offset,
    _is.OrderByBuilder<ScheduleRunTable>? orderBy,
    _is.OrderByListBuilder<ScheduleRunTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ScheduleRun>(
      where: where?.call(ScheduleRun.t),
      orderBy: orderBy?.call(ScheduleRun.t),
      orderByList: orderByList?.call(ScheduleRun.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ScheduleRun] by its [id] or null if no such row exists.
  Future<ScheduleRun?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ScheduleRun>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ScheduleRun]s in the list and returns the inserted rows.
  ///
  /// The returned [ScheduleRun]s will have their `id` fields set.
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
  Future<List<ScheduleRun>> insert(
    _is.DatabaseSession session,
    List<ScheduleRun> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ScheduleRun>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ScheduleRun] and returns the inserted row.
  ///
  /// The returned [ScheduleRun] will have its `id` field set.
  Future<ScheduleRun> insertRow(
    _is.DatabaseSession session,
    ScheduleRun row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ScheduleRun>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ScheduleRun]s in the list and returns the resulting rows.
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
  /// The returned [ScheduleRun]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ScheduleRun>> upsert(
    _is.DatabaseSession session,
    List<ScheduleRun> rows, {
    required _is.ColumnSelections<ScheduleRunTable> conflictColumns,
    _is.ColumnSelections<ScheduleRunTable>? updateColumns,
    _is.WhereExpressionBuilder<ScheduleRunTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ScheduleRun>(
      rows,
      conflictColumns: conflictColumns(ScheduleRun.t),
      updateColumns: updateColumns?.call(ScheduleRun.t),
      updateWhere: updateWhere?.call(ScheduleRun.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ScheduleRun] and returns the resulting row.
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
  /// The returned [ScheduleRun] will have its `id` field set.
  Future<ScheduleRun?> upsertRow(
    _is.DatabaseSession session,
    ScheduleRun row, {
    required _is.ColumnSelections<ScheduleRunTable> conflictColumns,
    _is.ColumnSelections<ScheduleRunTable>? updateColumns,
    _is.WhereExpressionBuilder<ScheduleRunTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ScheduleRun>(
      row,
      conflictColumns: conflictColumns(ScheduleRun.t),
      updateColumns: updateColumns?.call(ScheduleRun.t),
      updateWhere: updateWhere?.call(ScheduleRun.t),
      transaction: transaction,
    );
  }

  /// Updates all [ScheduleRun]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ScheduleRun>> update(
    _is.DatabaseSession session,
    List<ScheduleRun> rows, {
    _is.ColumnSelections<ScheduleRunTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ScheduleRun>(
      rows,
      columns: columns?.call(ScheduleRun.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ScheduleRun]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ScheduleRun> updateRow(
    _is.DatabaseSession session,
    ScheduleRun row, {
    _is.ColumnSelections<ScheduleRunTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ScheduleRun>(
      row,
      columns: columns?.call(ScheduleRun.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ScheduleRun] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ScheduleRun?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ScheduleRunUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ScheduleRun>(
      id,
      columnValues: columnValues(ScheduleRun.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ScheduleRun]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ScheduleRun>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ScheduleRunUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ScheduleRunTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ScheduleRunTable>? orderBy,
    _is.OrderByListBuilder<ScheduleRunTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ScheduleRun>(
      columnValues: columnValues(ScheduleRun.t.updateTable),
      where: where(ScheduleRun.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ScheduleRun.t),
      orderByList: orderByList?.call(ScheduleRun.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ScheduleRun]s in the list and returns the deleted rows.
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
  Future<List<ScheduleRun>> delete(
    _is.DatabaseSession session,
    List<ScheduleRun> rows, {
    _is.OrderByBuilder<ScheduleRunTable>? orderBy,
    _is.OrderByListBuilder<ScheduleRunTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ScheduleRun>(
      rows,
      orderBy: orderBy?.call(ScheduleRun.t),
      orderByList: orderByList?.call(ScheduleRun.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ScheduleRun].
  Future<ScheduleRun> deleteRow(
    _is.DatabaseSession session,
    ScheduleRun row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ScheduleRun>(
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
  Future<List<ScheduleRun>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ScheduleRunTable> where,
    _is.OrderByBuilder<ScheduleRunTable>? orderBy,
    _is.OrderByListBuilder<ScheduleRunTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ScheduleRun>(
      where: where(ScheduleRun.t),
      orderBy: orderBy?.call(ScheduleRun.t),
      orderByList: orderByList?.call(ScheduleRun.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ScheduleRunTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ScheduleRun>(
      where: where?.call(ScheduleRun.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ScheduleRun] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ScheduleRunTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ScheduleRun>(
      where: where(ScheduleRun.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
