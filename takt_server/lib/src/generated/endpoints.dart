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
import 'package:takt_server/src/generated/shop/job_bundle.dart' as _i7tmw4ip;
import 'package:takt_server/src/generated/shop/work_center.dart' as _i8sj0jqh;
import '../endpoints/job_endpoint.dart' as _i928r2ar;
import '../endpoints/schedule_endpoint.dart' as _iywcnzta;
import '../endpoints/shop_endpoint.dart' as _i4fqeydl;
import '../endpoints/work_center_endpoint.dart' as _iwd01vhf;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'job': _i928r2ar.JobEndpoint()
        ..initialize(
          server,
          'job',
          null,
        ),
      'schedule': _iywcnzta.ScheduleEndpoint()
        ..initialize(
          server,
          'schedule',
          null,
        ),
      'shop': _i4fqeydl.ShopEndpoint()
        ..initialize(
          server,
          'shop',
          null,
        ),
      'workCenter': _iwd01vhf.WorkCenterEndpoint()
        ..initialize(
          server,
          'workCenter',
          null,
        ),
    };
    connectors['job'] = _is.EndpointConnector(
      name: 'job',
      endpoint: endpoints['job']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'accessKey': _is.ParameterDescription(
              name: 'accessKey',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['job'] as _i928r2ar.JobEndpoint).list(
                session,
                params['accessKey'],
              ),
        ),
        'save': _is.MethodConnector(
          name: 'save',
          params: {
            'accessKey': _is.ParameterDescription(
              name: 'accessKey',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'bundle': _is.ParameterDescription(
              name: 'bundle',
              type: _is.getType<_i7tmw4ip.JobBundle>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['job'] as _i928r2ar.JobEndpoint).save(
                session,
                params['accessKey'],
                params['bundle'],
              ),
        ),
        'remove': _is.MethodConnector(
          name: 'remove',
          params: {
            'accessKey': _is.ParameterDescription(
              name: 'accessKey',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['job'] as _i928r2ar.JobEndpoint).remove(
                session,
                params['accessKey'],
                params['id'],
              ),
        ),
      },
    );
    connectors['schedule'] = _is.EndpointConnector(
      name: 'schedule',
      endpoint: endpoints['schedule']!,
      methodConnectors: {
        'solve': _is.MethodConnector(
          name: 'solve',
          params: {
            'accessKey': _is.ParameterDescription(
              name: 'accessKey',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'seed': _is.ParameterDescription(
              name: 'seed',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['schedule'] as _iywcnzta.ScheduleEndpoint).solve(
                    session,
                    params['accessKey'],
                    seed: params['seed'],
                  ),
        ),
        'whatIf': _is.MethodConnector(
          name: 'whatIf',
          params: {
            'accessKey': _is.ParameterDescription(
              name: 'accessKey',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'workCenterId': _is.ParameterDescription(
              name: 'workCenterId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'extraMachines': _is.ParameterDescription(
              name: 'extraMachines',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['schedule'] as _iywcnzta.ScheduleEndpoint).whatIf(
                    session,
                    params['accessKey'],
                    workCenterId: params['workCenterId'],
                    extraMachines: params['extraMachines'],
                  ),
        ),
        'history': _is.MethodConnector(
          name: 'history',
          params: {
            'accessKey': _is.ParameterDescription(
              name: 'accessKey',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['schedule'] as _iywcnzta.ScheduleEndpoint).history(
                    session,
                    params['accessKey'],
                  ),
        ),
      },
    );
    connectors['shop'] = _is.EndpointConnector(
      name: 'shop',
      endpoint: endpoints['shop']!,
      methodConnectors: {
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'name': _is.ParameterDescription(
              name: 'name',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'currency': _is.ParameterDescription(
              name: 'currency',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['shop'] as _i4fqeydl.ShopEndpoint).create(
                session,
                params['name'],
                params['currency'],
              ),
        ),
        'fetch': _is.MethodConnector(
          name: 'fetch',
          params: {
            'accessKey': _is.ParameterDescription(
              name: 'accessKey',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['shop'] as _i4fqeydl.ShopEndpoint).fetch(
                session,
                params['accessKey'],
              ),
        ),
        'rename': _is.MethodConnector(
          name: 'rename',
          params: {
            'accessKey': _is.ParameterDescription(
              name: 'accessKey',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'name': _is.ParameterDescription(
              name: 'name',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['shop'] as _i4fqeydl.ShopEndpoint).rename(
                session,
                params['accessKey'],
                params['name'],
              ),
        ),
        'loadDemo': _is.MethodConnector(
          name: 'loadDemo',
          params: {
            'accessKey': _is.ParameterDescription(
              name: 'accessKey',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['shop'] as _i4fqeydl.ShopEndpoint).loadDemo(
                session,
                params['accessKey'],
              ),
        ),
      },
    );
    connectors['workCenter'] = _is.EndpointConnector(
      name: 'workCenter',
      endpoint: endpoints['workCenter']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'accessKey': _is.ParameterDescription(
              name: 'accessKey',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['workCenter'] as _iwd01vhf.WorkCenterEndpoint)
                      .list(
                        session,
                        params['accessKey'],
                      ),
        ),
        'save': _is.MethodConnector(
          name: 'save',
          params: {
            'accessKey': _is.ParameterDescription(
              name: 'accessKey',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'center': _is.ParameterDescription(
              name: 'center',
              type: _is.getType<_i8sj0jqh.WorkCenter>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['workCenter'] as _iwd01vhf.WorkCenterEndpoint)
                      .save(
                        session,
                        params['accessKey'],
                        params['center'],
                      ),
        ),
        'remove': _is.MethodConnector(
          name: 'remove',
          params: {
            'accessKey': _is.ParameterDescription(
              name: 'accessKey',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['workCenter'] as _iwd01vhf.WorkCenterEndpoint)
                      .remove(
                        session,
                        params['accessKey'],
                        params['id'],
                      ),
        ),
      },
    );
  }
}
