import 'dart:math' as math;

/// Deterministic finite-capacity scheduler for a job shop.
///
/// The model is deliberately small and explicit:
/// * every job is a chain of operations that must run in sequence,
/// * operations run on a work center made of [SolverWorkCenter.machines]
///   identical parallel machines,
/// * a machine pays a flat changeover when it switches to another job.
///
/// The search is a list-scheduling construction followed by simulated
/// annealing over the dispatch order. It is heuristic, not exact: job shop
/// scheduling with changeovers is NP-hard, so the product promise is a good
/// schedule *plus a defensible explanation*, never a claim of optimality.
class SolverWorkCenter {
  const SolverWorkCenter({
    required this.id,
    required this.name,
    this.code = '',
    required this.machines,
    required this.changeoverMinutes,
  });

  final int id;
  final String name;
  final String code;
  final int machines;
  final int changeoverMinutes;
}

class SolverOperation {
  const SolverOperation({
    required this.id,
    required this.workCenterId,
    required this.setupMinutes,
    required this.runMinutes,
  });

  final int id;
  final int workCenterId;
  final int setupMinutes;

  /// Total run time for the whole job quantity, in minutes.
  final int runMinutes;
}

class SolverJob {
  const SolverJob({
    required this.id,
    required this.code,
    required this.title,
    required this.dueMinute,
    required this.releaseMinute,
    required this.priority,
    required this.operations,
  });

  final int id;
  final String code;
  final String title;
  final int dueMinute;
  final int releaseMinute;

  /// 1 = standard, 2 = high, 3 = critical.
  final int priority;
  final List<SolverOperation> operations;
}

class SolverInput {
  const SolverInput({
    required this.jobs,
    required this.workCenters,
    required this.seed,
    this.iterations = 0,
  });

  final List<SolverJob> jobs;
  final List<SolverWorkCenter> workCenters;
  final int seed;

  /// Zero selects an iteration budget scaled to the problem size.
  final int iterations;
}

class PlacedOp {
  const PlacedOp({
    required this.jobId,
    required this.operationId,
    required this.workCenterId,
    required this.machineIndex,
    required this.startMinute,
    required this.endMinute,
    required this.queueMinutes,
    required this.changeoverMinutes,
    required this.sequenceOnMachine,
    required this.jobIndex,
    required this.opIndex,
  });

  final int jobId;
  final int operationId;
  final int workCenterId;
  final int machineIndex;
  final int startMinute;
  final int endMinute;
  final int queueMinutes;
  final int changeoverMinutes;
  final int sequenceOnMachine;
  final int jobIndex;
  final int opIndex;
}

class SolverResult {
  const SolverResult({
    required this.placed,
    required this.makespan,
    required this.totalTardinessMinutes,
    required this.tardyJobs,
    required this.onTimeJobs,
    required this.objective,
    required this.jobFinishMinutes,
    required this.jobTardinessMinutes,
    required this.jobQueueMinutes,
    required this.workCenterBusyMinutes,
    required this.workCenterQueueMinutes,
    required this.order,
    required this.seed,
  });

  final List<PlacedOp> placed;
  final int makespan;
  final int totalTardinessMinutes;
  final int tardyJobs;
  final int onTimeJobs;
  final double objective;

  /// Keyed by job id.
  final Map<int, int> jobFinishMinutes;
  final Map<int, int> jobTardinessMinutes;
  final Map<int, int> jobQueueMinutes;

  /// Keyed by work center id.
  final Map<int, int> workCenterBusyMinutes;
  final Map<int, int> workCenterQueueMinutes;

  /// Job ids in dispatch order.
  final List<int> order;
  final int seed;
}

class TaktSolver {
  const TaktSolver();

  /// Solves [input] and returns a fully placed schedule.
  ///
  /// Running twice with the same seed returns an identical result.
  SolverResult solve(SolverInput input) {
    if (input.jobs.isEmpty) {
      return SolverResult(
        placed: const [],
        makespan: 0,
        totalTardinessMinutes: 0,
        tardyJobs: 0,
        onTimeJobs: 0,
        objective: 0,
        jobFinishMinutes: const {},
        jobTardinessMinutes: const {},
        jobQueueMinutes: const {},
        workCenterBusyMinutes: const {},
        workCenterQueueMinutes: const {},
        order: const [],
        seed: input.seed,
      );
    }

    final rules = <List<int>>[
      _eddOrder(input),
      _priorityOrder(input),
      _sptOrder(input),
      _slackOrder(input),
    ];

    var bestOrder = rules.first;
    var best = _simulate(bestOrder, input);
    for (final rule in rules.skip(1)) {
      final candidate = _simulate(rule, input);
      if (candidate.objective < best.objective) {
        best = candidate;
        bestOrder = rule;
      }
    }

    final budget = input.iterations > 0
        ? input.iterations
        : math.min(2600, 250 + input.jobs.length * 45);

    if (budget > 0 && input.jobs.length > 1) {
      final refined = _anneal(
        initialOrder: bestOrder,
        initial: best,
        input: input,
        budget: budget,
      );
      if (refined.result.objective < best.objective) {
        best = refined.result;
        bestOrder = refined.order;
      }
    }

    return SolverResult(
      placed: best.placed,
      makespan: best.makespan,
      totalTardinessMinutes: best.totalTardinessMinutes,
      tardyJobs: best.tardyJobs,
      onTimeJobs: best.onTimeJobs,
      objective: best.objective,
      jobFinishMinutes: best.jobFinishMinutes,
      jobTardinessMinutes: best.jobTardinessMinutes,
      jobQueueMinutes: best.jobQueueMinutes,
      workCenterBusyMinutes: best.workCenterBusyMinutes,
      workCenterQueueMinutes: best.workCenterQueueMinutes,
      order: List.unmodifiable(bestOrder),
      seed: input.seed,
    );
  }

  _Annealed _anneal({
    required List<int> initialOrder,
    required _Simulation initial,
    required SolverInput input,
    required int budget,
  }) {
    final random = math.Random(input.seed);
    var currentOrder = List<int>.of(initialOrder);
    var current = initial;
    var bestOrder = List<int>.of(currentOrder);
    var best = current;

    final startTemp = math.max(2.0, best.objective * 0.03);

    for (var i = 0; i < budget; i++) {
      if (input.jobs.length < 2) break;

      final candidateOrder = List<int>.of(currentOrder);
      final from = random.nextInt(candidateOrder.length);
      var to = random.nextInt(candidateOrder.length);
      if (from == to) {
        to = (to + 1) % candidateOrder.length;
      }
      final moved = candidateOrder.removeAt(from);
      candidateOrder.insert(to, moved);

      final candidate = _simulate(candidateOrder, input);
      final delta = candidate.objective - current.objective;
      final progress = i / budget;
      final temperature = math.max(0.5, startTemp * (1 - progress));

      final accept =
          delta <= 0 || random.nextDouble() < math.exp(-delta / temperature);
      if (accept) {
        current = candidate;
        currentOrder = candidateOrder;
      }
      if (candidate.objective < best.objective) {
        best = candidate;
        bestOrder = candidateOrder;
      }
    }

    return _Annealed(order: bestOrder, result: best);
  }

  _Simulation _simulate(List<int> order, SolverInput input) {
    final workCenters = input.workCenters;
    final wcIndex = <int, int>{
      for (var i = 0; i < workCenters.length; i++) workCenters[i].id: i,
    };

    final availability = <List<int>>[
      for (final wc in workCenters)
        List<int>.filled(math.max(1, wc.machines), 0),
    ];
    final lastJob = <List<int>>[
      for (final wc in workCenters)
        List<int>.filled(math.max(1, wc.machines), -1),
    ];
    final machineSequence = <List<int>>[
      for (final wc in workCenters)
        List<int>.filled(math.max(1, wc.machines), 0),
    ];

    final placed = <PlacedOp>[];
    final jobFinish = <int, int>{};
    final jobQueue = <int, int>{};
    final jobTardiness = <int, int>{};
    final busy = <int, int>{};
    final queued = <int, int>{};

    var makespan = 0;
    var tardy = 0;
    var onTime = 0;
    var unweightedTardiness = 0;
    var weightedTardiness = 0.0;

    for (final jobIndex in order) {
      final job = input.jobs[jobIndex];
      var ready = job.releaseMinute;
      var queueTotal = 0;

      for (var opIndex = 0; opIndex < job.operations.length; opIndex++) {
        final op = job.operations[opIndex];
        final wi = wcIndex[op.workCenterId];
        if (wi == null) continue;

        final wc = workCenters[wi];
        final parallelism = math.max(1, wc.machines);

        var bestMachine = 0;
        var bestEnd = 1 << 62;
        var bestStart = 0;
        var bestChangeover = 0;

        for (var m = 0; m < parallelism; m++) {
          final switching = lastJob[wi][m] != -1 && lastJob[wi][m] != jobIndex;
          final changeover = switching ? wc.changeoverMinutes : 0;
          final setupStart = math.max(ready, availability[wi][m]);
          final end = setupStart + changeover + op.setupMinutes + op.runMinutes;
          if (end < bestEnd) {
            bestEnd = end;
            bestMachine = m;
            bestStart = setupStart;
            bestChangeover = changeover;
          }
        }

        final queue = bestStart - ready;
        placed.add(
          PlacedOp(
            jobId: job.id,
            operationId: op.id,
            workCenterId: wc.id,
            machineIndex: bestMachine,
            startMinute: bestStart,
            endMinute: bestEnd,
            queueMinutes: math.max(0, queue),
            changeoverMinutes: bestChangeover,
            sequenceOnMachine: machineSequence[wi][bestMachine],
            jobIndex: jobIndex,
            opIndex: opIndex,
          ),
        );

        availability[wi][bestMachine] = bestEnd;
        lastJob[wi][bestMachine] = jobIndex;
        machineSequence[wi][bestMachine]++;

        busy[wc.id] = (busy[wc.id] ?? 0) + (bestEnd - bestStart);
        queued[wc.id] = (queued[wc.id] ?? 0) + math.max(0, queue);
        queueTotal += math.max(0, queue);
        ready = bestEnd;
        if (bestEnd > makespan) makespan = bestEnd;
      }

      jobFinish[job.id] = ready;
      jobQueue[job.id] = queueTotal;

      final lateBy = math.max(0, ready - job.dueMinute);
      jobTardiness[job.id] = lateBy;
      unweightedTardiness += lateBy;
      weightedTardiness += lateBy * math.max(1, job.priority);
      if (lateBy > 0) {
        tardy++;
      } else {
        onTime++;
      }
    }

    // Tardiness dominates; makespan only breaks ties.
    final objective = weightedTardiness + makespan * 0.05;

    return _Simulation(
      placed: placed,
      makespan: makespan,
      totalTardinessMinutes: unweightedTardiness,
      tardyJobs: tardy,
      onTimeJobs: onTime,
      objective: objective,
      jobFinishMinutes: jobFinish,
      jobTardinessMinutes: jobTardiness,
      jobQueueMinutes: jobQueue,
      workCenterBusyMinutes: busy,
      workCenterQueueMinutes: queued,
    );
  }

  List<int> _eddOrder(SolverInput input) {
    final order = List<int>.generate(input.jobs.length, (i) => i);
    order.sort((a, b) {
      final byDue = input.jobs[a].dueMinute.compareTo(input.jobs[b].dueMinute);
      if (byDue != 0) return byDue;
      return _priority(input.jobs[b]).compareTo(_priority(input.jobs[a]));
    });
    return order;
  }

  List<int> _priorityOrder(SolverInput input) {
    final order = List<int>.generate(input.jobs.length, (i) => i);
    order.sort((a, b) {
      final byPriority = _priority(
        input.jobs[b],
      ).compareTo(_priority(input.jobs[a]));
      if (byPriority != 0) return byPriority;
      return input.jobs[a].dueMinute.compareTo(input.jobs[b].dueMinute);
    });
    return order;
  }

  List<int> _sptOrder(SolverInput input) {
    final order = List<int>.generate(input.jobs.length, (i) => i);
    order.sort((a, b) {
      final byWork = _totalWork(input.jobs[a]).compareTo(
        _totalWork(input.jobs[b]),
      );
      if (byWork != 0) return byWork;
      return input.jobs[a].dueMinute.compareTo(input.jobs[b].dueMinute);
    });
    return order;
  }

  /// Least slack first: due date minus remaining work.
  List<int> _slackOrder(SolverInput input) {
    final order = List<int>.generate(input.jobs.length, (i) => i);
    order.sort((a, b) {
      final slackA = input.jobs[a].dueMinute - _totalWork(input.jobs[a]);
      final slackB = input.jobs[b].dueMinute - _totalWork(input.jobs[b]);
      return slackA.compareTo(slackB);
    });
    return order;
  }

  int _priority(SolverJob job) => job.priority < 1 ? 1 : job.priority;

  int _totalWork(SolverJob job) {
    var total = job.releaseMinute;
    for (final op in job.operations) {
      total += op.setupMinutes + op.runMinutes;
    }
    return total;
  }
}

class _Simulation {
  const _Simulation({
    required this.placed,
    required this.makespan,
    required this.totalTardinessMinutes,
    required this.tardyJobs,
    required this.onTimeJobs,
    required this.objective,
    required this.jobFinishMinutes,
    required this.jobTardinessMinutes,
    required this.jobQueueMinutes,
    required this.workCenterBusyMinutes,
    required this.workCenterQueueMinutes,
  });

  final List<PlacedOp> placed;
  final int makespan;
  final int totalTardinessMinutes;
  final int tardyJobs;
  final int onTimeJobs;
  final double objective;
  final Map<int, int> jobFinishMinutes;
  final Map<int, int> jobTardinessMinutes;
  final Map<int, int> jobQueueMinutes;
  final Map<int, int> workCenterBusyMinutes;
  final Map<int, int> workCenterQueueMinutes;
}

class _Annealed {
  const _Annealed({required this.order, required this.result});

  final List<int> order;
  final _Simulation result;
}
