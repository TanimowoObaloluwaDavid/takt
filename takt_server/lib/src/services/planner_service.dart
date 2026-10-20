import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../solver/diagnosis.dart';
import '../solver/solver.dart';

/// Bridges persisted shop data to the pure solver, then stores the result.
class PlannerService {
  const PlannerService();

  static const _solver = TaktSolver();

  Future<ScheduleSnapshot> solve(
    Session session,
    Shop shop, {
    int? seed,
  }) async {
    final chosenSeed = seed ?? DateTime.now().millisecondsSinceEpoch % 100000;
    final built = await _buildInput(session, shop, seed: chosenSeed);
    final result = _solver.solve(built.input);
    final verdict = buildDiagnosis(input: built.input, result: result);

    final run = ScheduleRun(
      shopId: shop.id!,
      createdAt: DateTime.now(),
      seed: result.seed,
      horizonStart: built.horizon,
      onTimeJobs: verdict.onTimeJobs,
      tardyJobs: verdict.tardyJobs,
      totalTardinessMinutes: verdict.totalTardinessMinutes,
      makespanMinutes: verdict.makespanMinutes,
      objective: result.objective,
      bottleneckWorkCenterId: verdict.bottleneckWorkCenterId,
      bottleneckUtilization: verdict.bottleneckUtilization,
    );

    final insertedRuns = await ScheduleRun.db.insert(session, [run]);
    final savedRun = insertedRuns.first;

    final rows = <ScheduledOp>[
      for (final placed in result.placed)
        ScheduledOp(
          runId: savedRun.id!,
          jobId: placed.jobId,
          operationId: placed.operationId,
          workCenterId: placed.workCenterId,
          machineIndex: placed.machineIndex,
          startMinute: placed.startMinute,
          endMinute: placed.endMinute,
          queueMinutes: placed.queueMinutes,
          changeoverMinutes: placed.changeoverMinutes,
          sequenceOnMachine: placed.sequenceOnMachine,
          isTardy: (result.jobTardinessMinutes[placed.jobId] ?? 0) > 0,
        ),
    ];
    final savedOps = await ScheduledOp.db.insert(session, rows);

    return ScheduleSnapshot(
      run: savedRun,
      scheduledOps: savedOps,
      diagnosis: _toModel(verdict, savedRun.id!),
      jobs: built.jobs,
      workCenters: built.workCenters,
    );
  }

  Future<WhatIfResult> whatIf(
    Session session,
    Shop shop, {
    required int workCenterId,
    required int extraMachines,
  }) async {
    final latestRun = await ScheduleRun.db.findFirstRow(
      session,
      where: (t) => t.shopId.equals(shop.id!),
      orderBy: (t) => t.createdAt.desc(),
    );
    final comparisonSeed = latestRun?.seed ?? 90210;
    final workCenters = await WorkCenter.db.find(
      session,
      where: (t) => t.shopId.equals(shop.id!),
    );

    WorkCenter? target;
    for (final center in workCenters) {
      if (center.id == workCenterId) {
        target = center;
        break;
      }
    }
    if (target == null) {
      throw TaktException(message: 'That work center is not in this shop.');
    }

    final baseline = _solver.solve(
      (await _buildInput(session, shop, seed: comparisonSeed)).input,
    );
    final scenario = _solver.solve(
      (await _buildInput(
        session,
        shop,
        seed: comparisonSeed,
        extraMachines: {workCenterId: extraMachines},
      )).input,
    );

    return WhatIfResult(
      workCenterName: target.name,
      extraMachines: extraMachines,
      baselineTardyJobs: baseline.tardyJobs,
      scenarioTardyJobs: scenario.tardyJobs,
      baselineTardinessMinutes: baseline.totalTardinessMinutes,
      scenarioTardinessMinutes: scenario.totalTardinessMinutes,
      savedTardinessMinutes:
          baseline.totalTardinessMinutes - scenario.totalTardinessMinutes,
      jobsSaved: baseline.tardyJobs - scenario.tardyJobs,
    );
  }

  Future<List<ScheduleRun>> history(
    Session session,
    Shop shop, {
    int limit = 12,
  }) async {
    final runs = await ScheduleRun.db.find(
      session,
      where: (t) => t.shopId.equals(shop.id!),
      orderBy: (t) => t.createdAt,
      limit: limit,
    );
    return runs.reversed.toList();
  }

  Future<_BuildResult> _buildInput(
    Session session,
    Shop shop, {
    required int seed,
    Map<int, int> extraMachines = const {},
  }) async {
    final centers = await WorkCenter.db.find(
      session,
      where: (t) => t.shopId.equals(shop.id!),
      orderBy: (t) => t.code,
    );
    final jobs = await Job.db.find(
      session,
      where: (t) => t.shopId.equals(shop.id!),
      orderBy: (t) => t.dueAt,
    );

    if (centers.isEmpty) {
      throw TaktException(message: 'Add a work center before solving.');
    }

    final jobIds = jobs.map((j) => j.id).whereType<int>().toSet();
    final operations = jobIds.isEmpty
        ? <Operation>[]
        : await Operation.db.find(
            session,
            where: (t) => t.jobId.inSet(jobIds),
            orderBy: (t) => t.sequence,
          );

    final byJob = <int, List<Operation>>{};
    for (final op in operations) {
      byJob.putIfAbsent(op.jobId, () => []).add(op);
    }

    final schedulable = jobs
        .where((j) => (byJob[j.id] ?? const []).isNotEmpty)
        .toList();

    if (schedulable.isEmpty) {
      throw TaktException(
        message: 'Add a job with at least one routing step before solving.',
      );
    }

    var earliest = schedulable.first.releaseAt;
    for (final job in schedulable) {
      if (job.releaseAt.isBefore(earliest)) earliest = job.releaseAt;
    }
    final horizonDate = earliest.toLocal();
    final horizon = DateTime(
      horizonDate.year,
      horizonDate.month,
      horizonDate.day,
    );

    final solverCenters = <SolverWorkCenter>[];
    for (final center in centers) {
      final extra = extraMachines[center.id] ?? 0;
      solverCenters.add(
        SolverWorkCenter(
          id: center.id!,
          name: center.name,
          code: center.code,
          machines: _clampInt(center.machines + extra, 1, 99),
          changeoverMinutes: center.changeoverMinutes,
        ),
      );
    }

    final solverJobs = <SolverJob>[];
    for (final job in schedulable) {
      final routing = byJob[job.id]!
        ..sort((a, b) => a.sequence.compareTo(b.sequence));
      solverJobs.add(
        SolverJob(
          id: job.id!,
          code: job.code,
          title: job.title,
          dueMinute: job.dueAt.difference(horizon).inMinutes,
          releaseMinute: _clampInt(
            job.releaseAt.difference(horizon).inMinutes,
            0,
            1 << 30,
          ),
          priority: job.priority,
          operations: [
            for (final op in routing)
              SolverOperation(
                id: op.id!,
                workCenterId: op.workCenterId,
                setupMinutes: op.setupMinutes,
                runMinutes: _clampInt(
                  (op.unitRunMinutes * job.quantity).round(),
                  0,
                  1 << 30,
                ),
              ),
          ],
        ),
      );
    }

    return _BuildResult(
      input: SolverInput(
        jobs: solverJobs,
        workCenters: solverCenters,
        seed: seed,
      ),
      jobs: schedulable,
      workCenters: centers,
      horizon: horizon,
    );
  }

  ShopDiagnosis _toModel(ShopVerdict verdict, int runId) {
    return ShopDiagnosis(
      runId: runId,
      onTimeJobs: verdict.onTimeJobs,
      tardyJobs: verdict.tardyJobs,
      totalTardinessMinutes: verdict.totalTardinessMinutes,
      makespanMinutes: verdict.makespanMinutes,
      bottleneckWorkCenterId: verdict.bottleneckWorkCenterId,
      bottleneckWorkCenterName: verdict.bottleneckWorkCenterName,
      bottleneckUtilization: verdict.bottleneckUtilization,
      bottleneckQueueMinutes: verdict.bottleneckQueueMinutes,
      jobs: [
        for (final job in verdict.jobs)
          JobDiagnosis(
            jobId: job.jobId,
            code: job.code,
            title: job.title,
            dueMinute: job.dueMinute,
            finishMinute: job.finishMinute,
            tardinessMinutes: job.tardinessMinutes,
            queueMinutes: job.queueMinutes,
            bindingWorkCenterId: job.bindingWorkCenterId,
            bindingWorkCenterName: job.bindingWorkCenterName,
            bindingQueueMinutes: job.bindingQueueMinutes,
            explanation: job.explanation,
            chain: job.chain,
            isTardy: job.isTardy,
          ),
      ],
    );
  }

  int _clampInt(int value, int low, int high) {
    if (value < low) return low;
    if (value > high) return high;
    return value;
  }
}

class _BuildResult {
  const _BuildResult({
    required this.input,
    required this.jobs,
    required this.workCenters,
    required this.horizon,
  });

  final SolverInput input;
  final List<Job> jobs;
  final List<WorkCenter> workCenters;
  final DateTime horizon;
}
