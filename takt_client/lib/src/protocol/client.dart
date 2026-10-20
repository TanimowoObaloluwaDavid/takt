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

import 'dart:async' as _ida;
import 'package:http/http.dart' as _i85jenna;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:takt_client/src/protocol/auth/auth_result.dart' as _iq28ciw2;
import 'package:takt_client/src/protocol/auth/member_info.dart' as _iclqc65o;
import 'package:takt_client/src/protocol/auth/workspace_access.dart'
    as _imttog6f;
import 'package:takt_client/src/protocol/shop/job_bundle.dart' as _iorcz7t1;
import 'package:takt_client/src/protocol/shop/schedule_run.dart' as _i2i6r8ak;
import 'package:takt_client/src/protocol/shop/schedule_snapshot.dart'
    as _i8ic80cy;
import 'package:takt_client/src/protocol/shop/shop.dart' as _ikodhua5;
import 'package:takt_client/src/protocol/shop/what_if_result.dart' as _i9zfk072;
import 'package:takt_client/src/protocol/shop/work_center.dart' as _ikdu04kn;
import 'protocol.dart' as _il2as5qe;

/// {@category Endpoint}
class EndpointAuth extends _isc.EndpointRef {
  EndpointAuth(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'auth';

  _ida.Future<_iq28ciw2.AuthResult> register(
    String email,
    String password,
    String displayName,
  ) => caller.callServerEndpoint<_iq28ciw2.AuthResult>(
    'auth',
    'register',
    {
      'email': email,
      'password': password,
      'displayName': displayName,
    },
  );

  _ida.Future<_iq28ciw2.AuthResult> login(
    String email,
    String password,
  ) => caller.callServerEndpoint<_iq28ciw2.AuthResult>(
    'auth',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  _ida.Future<_iq28ciw2.AuthResult> me(String token) =>
      caller.callServerEndpoint<_iq28ciw2.AuthResult>(
        'auth',
        'me',
        {'token': token},
      );

  _ida.Future<bool> logout(String token) => caller.callServerEndpoint<bool>(
    'auth',
    'logout',
    {'token': token},
  );

  _ida.Future<bool> changePassword(
    String token,
    String currentPassword,
    String newPassword,
  ) => caller.callServerEndpoint<bool>(
    'auth',
    'changePassword',
    {
      'token': token,
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    },
  );
}

/// {@category Endpoint}
class EndpointJob extends _isc.EndpointRef {
  EndpointJob(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'job';

  _ida.Future<List<_iorcz7t1.JobBundle>> list(String accessKey) =>
      caller.callServerEndpoint<List<_iorcz7t1.JobBundle>>(
        'job',
        'list',
        {'accessKey': accessKey},
      );

  _ida.Future<_iorcz7t1.JobBundle> save(
    String accessKey,
    _iorcz7t1.JobBundle bundle,
  ) => caller.callServerEndpoint<_iorcz7t1.JobBundle>(
    'job',
    'save',
    {
      'accessKey': accessKey,
      'bundle': bundle,
    },
  );

  _ida.Future<bool> remove(
    String accessKey,
    int id,
  ) => caller.callServerEndpoint<bool>(
    'job',
    'remove',
    {
      'accessKey': accessKey,
      'id': id,
    },
  );
}

/// {@category Endpoint}
class EndpointSchedule extends _isc.EndpointRef {
  EndpointSchedule(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'schedule';

  /// Runs the solver, stores the run, and returns the full snapshot.
  _ida.Future<_i8ic80cy.ScheduleSnapshot> solve(
    String accessKey, {
    int? seed,
  }) => caller.callServerEndpoint<_i8ic80cy.ScheduleSnapshot>(
    'schedule',
    'solve',
    {
      'accessKey': accessKey,
      'seed': seed,
    },
  );

  /// Re-solves with extra machines on one work center and reports the delta.
  /// Both runs share a seed, so the comparison isolates the capacity change.
  _ida.Future<_i9zfk072.WhatIfResult> whatIf(
    String accessKey, {
    required int workCenterId,
    required int extraMachines,
  }) => caller.callServerEndpoint<_i9zfk072.WhatIfResult>(
    'schedule',
    'whatIf',
    {
      'accessKey': accessKey,
      'workCenterId': workCenterId,
      'extraMachines': extraMachines,
    },
  );

  _ida.Future<List<_i2i6r8ak.ScheduleRun>> history(String accessKey) =>
      caller.callServerEndpoint<List<_i2i6r8ak.ScheduleRun>>(
        'schedule',
        'history',
        {'accessKey': accessKey},
      );
}

/// {@category Endpoint}
class EndpointShop extends _isc.EndpointRef {
  EndpointShop(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'shop';

  /// Creates a workspace and returns its one-time bearer key.
  _ida.Future<_ikodhua5.Shop> create(
    String name,
    String currency,
  ) => caller.callServerEndpoint<_ikodhua5.Shop>(
    'shop',
    'create',
    {
      'name': name,
      'currency': currency,
    },
  );

  _ida.Future<_ikodhua5.Shop> fetch(String accessKey) =>
      caller.callServerEndpoint<_ikodhua5.Shop>(
        'shop',
        'fetch',
        {'accessKey': accessKey},
      );

  _ida.Future<_ikodhua5.Shop> rename(
    String accessKey,
    String name,
  ) => caller.callServerEndpoint<_ikodhua5.Shop>(
    'shop',
    'rename',
    {
      'accessKey': accessKey,
      'name': name,
    },
  );

  /// Fills an empty workspace with a realistic sample shop. Returns the
  /// number of jobs loaded. Returning a value (rather than void) keeps the
  /// HTTP response well-defined for every client.
  _ida.Future<int> loadDemo(String accessKey) => caller.callServerEndpoint<int>(
    'shop',
    'loadDemo',
    {'accessKey': accessKey},
  );
}

/// {@category Endpoint}
class EndpointWorkCenter extends _isc.EndpointRef {
  EndpointWorkCenter(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'workCenter';

  _ida.Future<List<_ikdu04kn.WorkCenter>> list(String accessKey) =>
      caller.callServerEndpoint<List<_ikdu04kn.WorkCenter>>(
        'workCenter',
        'list',
        {'accessKey': accessKey},
      );

  _ida.Future<_ikdu04kn.WorkCenter> save(
    String accessKey,
    _ikdu04kn.WorkCenter center,
  ) => caller.callServerEndpoint<_ikdu04kn.WorkCenter>(
    'workCenter',
    'save',
    {
      'accessKey': accessKey,
      'center': center,
    },
  );

  _ida.Future<bool> remove(
    String accessKey,
    int id,
  ) => caller.callServerEndpoint<bool>(
    'workCenter',
    'remove',
    {
      'accessKey': accessKey,
      'id': id,
    },
  );
}

/// {@category Endpoint}
class EndpointWorkspace extends _isc.EndpointRef {
  EndpointWorkspace(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'workspace';

  _ida.Future<List<_imttog6f.WorkspaceAccess>> list(String token) =>
      caller.callServerEndpoint<List<_imttog6f.WorkspaceAccess>>(
        'workspace',
        'list',
        {'token': token},
      );

  _ida.Future<_imttog6f.WorkspaceAccess> create(
    String token,
    String name,
    String currency,
    bool withSample,
  ) => caller.callServerEndpoint<_imttog6f.WorkspaceAccess>(
    'workspace',
    'create',
    {
      'token': token,
      'name': name,
      'currency': currency,
      'withSample': withSample,
    },
  );

  _ida.Future<_imttog6f.WorkspaceAccess> claim(
    String token,
    String accessKey,
  ) => caller.callServerEndpoint<_imttog6f.WorkspaceAccess>(
    'workspace',
    'claim',
    {
      'token': token,
      'accessKey': accessKey,
    },
  );

  /// Resolves a scoped key without an account, so the client can show the
  /// correct role for a shared key. It never echoes the key.
  _ida.Future<_imttog6f.WorkspaceAccess> access(String accessKey) =>
      caller.callServerEndpoint<_imttog6f.WorkspaceAccess>(
        'workspace',
        'access',
        {'accessKey': accessKey},
      );

  _ida.Future<List<_iclqc65o.MemberInfo>> members(
    String token,
    int shopId,
  ) => caller.callServerEndpoint<List<_iclqc65o.MemberInfo>>(
    'workspace',
    'members',
    {
      'token': token,
      'shopId': shopId,
    },
  );

  _ida.Future<_iclqc65o.MemberInfo> invite(
    String token,
    int shopId,
    String email,
    String role,
  ) => caller.callServerEndpoint<_iclqc65o.MemberInfo>(
    'workspace',
    'invite',
    {
      'token': token,
      'shopId': shopId,
      'email': email,
      'role': role,
    },
  );

  _ida.Future<_iclqc65o.MemberInfo> setRole(
    String token,
    int shopId,
    int userId,
    String role,
  ) => caller.callServerEndpoint<_iclqc65o.MemberInfo>(
    'workspace',
    'setRole',
    {
      'token': token,
      'shopId': shopId,
      'userId': userId,
      'role': role,
    },
  );

  _ida.Future<bool> removeMember(
    String token,
    int shopId,
    int userId,
  ) => caller.callServerEndpoint<bool>(
    'workspace',
    'removeMember',
    {
      'token': token,
      'shopId': shopId,
      'userId': userId,
    },
  );
}

class Client extends _isc.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _isc.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_isc.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
    _i85jenna.Client? httpClientOverride,
  }) : super(
         host,
         _il2as5qe.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
         httpClientOverride: httpClientOverride,
       ) {
    auth = EndpointAuth(this);
    job = EndpointJob(this);
    schedule = EndpointSchedule(this);
    shop = EndpointShop(this);
    workCenter = EndpointWorkCenter(this);
    workspace = EndpointWorkspace(this);
  }

  late final EndpointAuth auth;

  late final EndpointJob job;

  late final EndpointSchedule schedule;

  late final EndpointShop shop;

  late final EndpointWorkCenter workCenter;

  late final EndpointWorkspace workspace;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'auth': auth,
    'job': job,
    'schedule': schedule,
    'shop': shop,
    'workCenter': workCenter,
    'workspace': workspace,
  };

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup => {};
}
