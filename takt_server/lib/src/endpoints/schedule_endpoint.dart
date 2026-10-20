import 'package:serverpod/serverpod.dart';

import '../access/access.dart';
import '../generated/protocol.dart';
import '../services/planner_service.dart';

class ScheduleEndpoint extends Endpoint {
  static const _planner = PlannerService();

  /// Runs the solver, stores the run, and returns the full snapshot.
  Future<ScheduleSnapshot> solve(
    Session session,
    String accessKey, {
    int? seed,
  }) async {
    final shop = await requireShop(session, accessKey);
    return _planner.solve(session, shop, seed: seed);
  }

  /// Re-solves with extra machines on one work center and reports the delta.
  /// Both runs share a seed, so the comparison isolates the capacity change.
  Future<WhatIfResult> whatIf(
    Session session,
    String accessKey, {
    required int workCenterId,
    required int extraMachines,
  }) async {
    final shop = await requireShop(session, accessKey);
    return _planner.whatIf(
      session,
      shop,
      workCenterId: workCenterId,
      extraMachines: extraMachines,
    );
  }

  Future<List<ScheduleRun>> history(Session session, String accessKey) async {
    final shop = await requireShop(session, accessKey);
    return _planner.history(session, shop);
  }
}
