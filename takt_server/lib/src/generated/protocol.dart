/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, no_leading_underscores_for_library_prefixes
// ignore_for_file: unnecessary_type_check

import 'package:serverpod/protocol.dart' as _isp;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:takt_server/src/generated/auth/member_info.dart' as _i5rbsqm5;
import 'package:takt_server/src/generated/auth/workspace_access.dart'
    as _ijb0w01z;
import 'package:takt_server/src/generated/shop/job_bundle.dart' as _i7tmw4ip;
import 'package:takt_server/src/generated/shop/schedule_run.dart' as _ixxyfogz;
import 'package:takt_server/src/generated/shop/work_center.dart' as _i8sj0jqh;
import 'auth/auth_result.dart' as _i2iwynut;
import 'auth/auth_user.dart' as _irmjc2q5;
import 'auth/member_info.dart' as _icrfkdlg;
import 'auth/takt_exception.dart' as _irx8mk2s;
import 'auth/takt_user.dart' as _i0j7pcbw;
import 'auth/user_session.dart' as _i8i8bov3;
import 'auth/workspace_access.dart' as _iz2xnhg6;
import 'auth/workspace_member.dart' as _i4na5x1t;
import 'shop/job.dart' as _it99zazm;
import 'shop/job_bundle.dart' as _i7fechiz;
import 'shop/job_diagnosis.dart' as _i0n93601;
import 'shop/operation.dart' as _inhubnpu;
import 'shop/schedule_run.dart' as _idocr9bj;
import 'shop/schedule_snapshot.dart' as _i5asx6hq;
import 'shop/scheduled_op.dart' as _i52nwswg;
import 'shop/shop.dart' as _i3jxgs3d;
import 'shop/shop_diagnosis.dart' as _inb8e64e;
import 'shop/what_if_result.dart' as _i15bz5nf;
import 'shop/work_center.dart' as _i94r27we;
export 'auth/auth_result.dart';
export 'auth/auth_user.dart';
export 'auth/member_info.dart';
export 'auth/takt_exception.dart';
export 'auth/takt_user.dart';
export 'auth/user_session.dart';
export 'auth/workspace_access.dart';
export 'auth/workspace_member.dart';
export 'shop/job.dart';
export 'shop/job_bundle.dart';
export 'shop/job_diagnosis.dart';
export 'shop/operation.dart';
export 'shop/schedule_run.dart';
export 'shop/schedule_snapshot.dart';
export 'shop/scheduled_op.dart';
export 'shop/shop.dart';
export 'shop/shop_diagnosis.dart';
export 'shop/what_if_result.dart';
export 'shop/work_center.dart';

class Protocol extends _is.DatabaseSerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static List<_isp.TableDefinition> get targetTableDefinitions => [
    _isp.TableDefinition(
      name: 'job',
      dartName: 'Job',
      schema: 'public',
      module: 'takt',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'shopId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'code',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'title',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'customer',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'quantity',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'dueAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'releaseAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'priority',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'notes',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'operation',
      dartName: 'Operation',
      schema: 'public',
      module: 'takt',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'jobId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'sequence',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'workCenterId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'setupMinutes',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'unitRunMinutes',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'description',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'schedule_run',
      dartName: 'ScheduleRun',
      schema: 'public',
      module: 'takt',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'shopId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'seed',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'horizonStart',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'onTimeJobs',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'tardyJobs',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'totalTardinessMinutes',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'makespanMinutes',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'objective',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'bottleneckWorkCenterId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'bottleneckUtilization',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'scheduled_op',
      dartName: 'ScheduledOp',
      schema: 'public',
      module: 'takt',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'runId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'jobId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'operationId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'workCenterId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'machineIndex',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'startMinute',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'endMinute',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'queueMinutes',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'changeoverMinutes',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'sequenceOnMachine',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'isTardy',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'shop',
      dartName: 'Shop',
      schema: 'public',
      module: 'takt',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'accessKey',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'currency',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'minutesPerDay',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'takt_user',
      dartName: 'TaktUser',
      schema: 'public',
      module: 'takt',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'email',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'displayName',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'passwordHash',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'takt_user_email_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'email',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'user_session',
      dartName: 'UserSession',
      schema: 'public',
      module: 'takt',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'userId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'tokenHash',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'expiresAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'lastSeenAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'user_session_token_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'tokenHash',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'work_center',
      dartName: 'WorkCenter',
      schema: 'public',
      module: 'takt',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'shopId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'code',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'machines',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'changeoverMinutes',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'notes',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'workspace_member',
      dartName: 'WorkspaceMember',
      schema: 'public',
      module: 'takt',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'shopId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'userId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'role',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'accessKey',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'workspace_member_shop_user_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'shopId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'workspace_member_key_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'accessKey',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    ..._isp.Protocol.targetTableDefinitions,
  ];

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i2iwynut.AuthResult) {
      return _i2iwynut.AuthResult.fromJson(data) as T;
    }
    if (t == _irmjc2q5.AuthUser) {
      return _irmjc2q5.AuthUser.fromJson(data) as T;
    }
    if (t == _icrfkdlg.MemberInfo) {
      return _icrfkdlg.MemberInfo.fromJson(data) as T;
    }
    if (t == _irx8mk2s.TaktException) {
      return _irx8mk2s.TaktException.fromJson(data) as T;
    }
    if (t == _i0j7pcbw.TaktUser) {
      return _i0j7pcbw.TaktUser.fromJson(data) as T;
    }
    if (t == _i8i8bov3.UserSession) {
      return _i8i8bov3.UserSession.fromJson(data) as T;
    }
    if (t == _iz2xnhg6.WorkspaceAccess) {
      return _iz2xnhg6.WorkspaceAccess.fromJson(data) as T;
    }
    if (t == _i4na5x1t.WorkspaceMember) {
      return _i4na5x1t.WorkspaceMember.fromJson(data) as T;
    }
    if (t == _it99zazm.Job) {
      return _it99zazm.Job.fromJson(data) as T;
    }
    if (t == _i7fechiz.JobBundle) {
      return _i7fechiz.JobBundle.fromJson(data) as T;
    }
    if (t == _i0n93601.JobDiagnosis) {
      return _i0n93601.JobDiagnosis.fromJson(data) as T;
    }
    if (t == _inhubnpu.Operation) {
      return _inhubnpu.Operation.fromJson(data) as T;
    }
    if (t == _idocr9bj.ScheduleRun) {
      return _idocr9bj.ScheduleRun.fromJson(data) as T;
    }
    if (t == _i5asx6hq.ScheduleSnapshot) {
      return _i5asx6hq.ScheduleSnapshot.fromJson(data) as T;
    }
    if (t == _i52nwswg.ScheduledOp) {
      return _i52nwswg.ScheduledOp.fromJson(data) as T;
    }
    if (t == _i3jxgs3d.Shop) {
      return _i3jxgs3d.Shop.fromJson(data) as T;
    }
    if (t == _inb8e64e.ShopDiagnosis) {
      return _inb8e64e.ShopDiagnosis.fromJson(data) as T;
    }
    if (t == _i15bz5nf.WhatIfResult) {
      return _i15bz5nf.WhatIfResult.fromJson(data) as T;
    }
    if (t == _i94r27we.WorkCenter) {
      return _i94r27we.WorkCenter.fromJson(data) as T;
    }
    if (t == _is.getType<_i2iwynut.AuthResult?>()) {
      return (data != null ? _i2iwynut.AuthResult.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_irmjc2q5.AuthUser?>()) {
      return (data != null ? _irmjc2q5.AuthUser.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_icrfkdlg.MemberInfo?>()) {
      return (data != null ? _icrfkdlg.MemberInfo.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_irx8mk2s.TaktException?>()) {
      return (data != null ? _irx8mk2s.TaktException.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i0j7pcbw.TaktUser?>()) {
      return (data != null ? _i0j7pcbw.TaktUser.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i8i8bov3.UserSession?>()) {
      return (data != null ? _i8i8bov3.UserSession.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iz2xnhg6.WorkspaceAccess?>()) {
      return (data != null ? _iz2xnhg6.WorkspaceAccess.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i4na5x1t.WorkspaceMember?>()) {
      return (data != null ? _i4na5x1t.WorkspaceMember.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_it99zazm.Job?>()) {
      return (data != null ? _it99zazm.Job.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i7fechiz.JobBundle?>()) {
      return (data != null ? _i7fechiz.JobBundle.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i0n93601.JobDiagnosis?>()) {
      return (data != null ? _i0n93601.JobDiagnosis.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_inhubnpu.Operation?>()) {
      return (data != null ? _inhubnpu.Operation.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_idocr9bj.ScheduleRun?>()) {
      return (data != null ? _idocr9bj.ScheduleRun.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i5asx6hq.ScheduleSnapshot?>()) {
      return (data != null ? _i5asx6hq.ScheduleSnapshot.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i52nwswg.ScheduledOp?>()) {
      return (data != null ? _i52nwswg.ScheduledOp.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i3jxgs3d.Shop?>()) {
      return (data != null ? _i3jxgs3d.Shop.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_inb8e64e.ShopDiagnosis?>()) {
      return (data != null ? _inb8e64e.ShopDiagnosis.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i15bz5nf.WhatIfResult?>()) {
      return (data != null ? _i15bz5nf.WhatIfResult.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i94r27we.WorkCenter?>()) {
      return (data != null ? _i94r27we.WorkCenter.fromJson(data) : null) as T;
    }
    if (t == List<_iz2xnhg6.WorkspaceAccess>) {
      return (data as List)
              .map((e) => deserialize<_iz2xnhg6.WorkspaceAccess>(e))
              .toList()
          as T;
    }
    if (t == List<_inhubnpu.Operation>) {
      return (data as List)
              .map((e) => deserialize<_inhubnpu.Operation>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i52nwswg.ScheduledOp>) {
      return (data as List)
              .map((e) => deserialize<_i52nwswg.ScheduledOp>(e))
              .toList()
          as T;
    }
    if (t == List<_it99zazm.Job>) {
      return (data as List).map((e) => deserialize<_it99zazm.Job>(e)).toList()
          as T;
    }
    if (t == List<_i94r27we.WorkCenter>) {
      return (data as List)
              .map((e) => deserialize<_i94r27we.WorkCenter>(e))
              .toList()
          as T;
    }
    if (t == List<_i0n93601.JobDiagnosis>) {
      return (data as List)
              .map((e) => deserialize<_i0n93601.JobDiagnosis>(e))
              .toList()
          as T;
    }
    if (t == List<_i7tmw4ip.JobBundle>) {
      return (data as List)
              .map((e) => deserialize<_i7tmw4ip.JobBundle>(e))
              .toList()
          as T;
    }
    if (t == List<_ixxyfogz.ScheduleRun>) {
      return (data as List)
              .map((e) => deserialize<_ixxyfogz.ScheduleRun>(e))
              .toList()
          as T;
    }
    if (t == List<_i8sj0jqh.WorkCenter>) {
      return (data as List)
              .map((e) => deserialize<_i8sj0jqh.WorkCenter>(e))
              .toList()
          as T;
    }
    if (t == List<_ijb0w01z.WorkspaceAccess>) {
      return (data as List)
              .map((e) => deserialize<_ijb0w01z.WorkspaceAccess>(e))
              .toList()
          as T;
    }
    if (t == List<_i5rbsqm5.MemberInfo>) {
      return (data as List)
              .map((e) => deserialize<_i5rbsqm5.MemberInfo>(e))
              .toList()
          as T;
    }
    try {
      return _isp.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2iwynut.AuthResult => 'AuthResult',
      _irmjc2q5.AuthUser => 'AuthUser',
      _icrfkdlg.MemberInfo => 'MemberInfo',
      _irx8mk2s.TaktException => 'TaktException',
      _i0j7pcbw.TaktUser => 'TaktUser',
      _i8i8bov3.UserSession => 'UserSession',
      _iz2xnhg6.WorkspaceAccess => 'WorkspaceAccess',
      _i4na5x1t.WorkspaceMember => 'WorkspaceMember',
      _it99zazm.Job => 'Job',
      _i7fechiz.JobBundle => 'JobBundle',
      _i0n93601.JobDiagnosis => 'JobDiagnosis',
      _inhubnpu.Operation => 'Operation',
      _idocr9bj.ScheduleRun => 'ScheduleRun',
      _i5asx6hq.ScheduleSnapshot => 'ScheduleSnapshot',
      _i52nwswg.ScheduledOp => 'ScheduledOp',
      _i3jxgs3d.Shop => 'Shop',
      _inb8e64e.ShopDiagnosis => 'ShopDiagnosis',
      _i15bz5nf.WhatIfResult => 'WhatIfResult',
      _i94r27we.WorkCenter => 'WorkCenter',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('takt.', '');
    }

    switch (data) {
      case _i2iwynut.AuthResult():
        return 'AuthResult';
      case _irmjc2q5.AuthUser():
        return 'AuthUser';
      case _icrfkdlg.MemberInfo():
        return 'MemberInfo';
      case _irx8mk2s.TaktException():
        return 'TaktException';
      case _i0j7pcbw.TaktUser():
        return 'TaktUser';
      case _i8i8bov3.UserSession():
        return 'UserSession';
      case _iz2xnhg6.WorkspaceAccess():
        return 'WorkspaceAccess';
      case _i4na5x1t.WorkspaceMember():
        return 'WorkspaceMember';
      case _it99zazm.Job():
        return 'Job';
      case _i7fechiz.JobBundle():
        return 'JobBundle';
      case _i0n93601.JobDiagnosis():
        return 'JobDiagnosis';
      case _inhubnpu.Operation():
        return 'Operation';
      case _idocr9bj.ScheduleRun():
        return 'ScheduleRun';
      case _i5asx6hq.ScheduleSnapshot():
        return 'ScheduleSnapshot';
      case _i52nwswg.ScheduledOp():
        return 'ScheduledOp';
      case _i3jxgs3d.Shop():
        return 'Shop';
      case _inb8e64e.ShopDiagnosis():
        return 'ShopDiagnosis';
      case _i15bz5nf.WhatIfResult():
        return 'WhatIfResult';
      case _i94r27we.WorkCenter():
        return 'WorkCenter';
    }
    className = _isp.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AuthResult') {
      return deserialize<_i2iwynut.AuthResult>(data['data']);
    }
    if (dataClassName == 'AuthUser') {
      return deserialize<_irmjc2q5.AuthUser>(data['data']);
    }
    if (dataClassName == 'MemberInfo') {
      return deserialize<_icrfkdlg.MemberInfo>(data['data']);
    }
    if (dataClassName == 'TaktException') {
      return deserialize<_irx8mk2s.TaktException>(data['data']);
    }
    if (dataClassName == 'TaktUser') {
      return deserialize<_i0j7pcbw.TaktUser>(data['data']);
    }
    if (dataClassName == 'UserSession') {
      return deserialize<_i8i8bov3.UserSession>(data['data']);
    }
    if (dataClassName == 'WorkspaceAccess') {
      return deserialize<_iz2xnhg6.WorkspaceAccess>(data['data']);
    }
    if (dataClassName == 'WorkspaceMember') {
      return deserialize<_i4na5x1t.WorkspaceMember>(data['data']);
    }
    if (dataClassName == 'Job') {
      return deserialize<_it99zazm.Job>(data['data']);
    }
    if (dataClassName == 'JobBundle') {
      return deserialize<_i7fechiz.JobBundle>(data['data']);
    }
    if (dataClassName == 'JobDiagnosis') {
      return deserialize<_i0n93601.JobDiagnosis>(data['data']);
    }
    if (dataClassName == 'Operation') {
      return deserialize<_inhubnpu.Operation>(data['data']);
    }
    if (dataClassName == 'ScheduleRun') {
      return deserialize<_idocr9bj.ScheduleRun>(data['data']);
    }
    if (dataClassName == 'ScheduleSnapshot') {
      return deserialize<_i5asx6hq.ScheduleSnapshot>(data['data']);
    }
    if (dataClassName == 'ScheduledOp') {
      return deserialize<_i52nwswg.ScheduledOp>(data['data']);
    }
    if (dataClassName == 'Shop') {
      return deserialize<_i3jxgs3d.Shop>(data['data']);
    }
    if (dataClassName == 'ShopDiagnosis') {
      return deserialize<_inb8e64e.ShopDiagnosis>(data['data']);
    }
    if (dataClassName == 'WhatIfResult') {
      return deserialize<_i15bz5nf.WhatIfResult>(data['data']);
    }
    if (dataClassName == 'WorkCenter') {
      return deserialize<_i94r27we.WorkCenter>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _isp.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _is.Table? getTableForType(Type t) {
    {
      var table = _isp.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _i0j7pcbw.TaktUser:
        return _i0j7pcbw.TaktUser.t;
      case _i8i8bov3.UserSession:
        return _i8i8bov3.UserSession.t;
      case _i4na5x1t.WorkspaceMember:
        return _i4na5x1t.WorkspaceMember.t;
      case _it99zazm.Job:
        return _it99zazm.Job.t;
      case _inhubnpu.Operation:
        return _inhubnpu.Operation.t;
      case _idocr9bj.ScheduleRun:
        return _idocr9bj.ScheduleRun.t;
      case _i52nwswg.ScheduledOp:
        return _i52nwswg.ScheduledOp.t;
      case _i3jxgs3d.Shop:
        return _i3jxgs3d.Shop.t;
      case _i94r27we.WorkCenter:
        return _i94r27we.WorkCenter.t;
    }
    return null;
  }

  @override
  List<_isp.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'takt';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _isp.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
