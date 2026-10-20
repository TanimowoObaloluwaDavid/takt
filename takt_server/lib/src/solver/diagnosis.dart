import 'solver.dart';

/// Turns a solved schedule into a causal account of why each job lands where
/// it does. This is the product: a red bar is not an explanation.
class JobVerdict {
  const JobVerdict({
    required this.jobId,
    required this.code,
    required this.title,
    required this.dueMinute,
    required this.finishMinute,
    required this.tardinessMinutes,
    required this.queueMinutes,
    required this.bindingWorkCenterId,
    required this.bindingWorkCenterName,
    required this.bindingQueueMinutes,
    required this.explanation,
    required this.chain,
    required this.isTardy,
  });

  final int jobId;
  final String code;
  final String title;
  final int dueMinute;
  final int finishMinute;
  final int tardinessMinutes;
  final int queueMinutes;
  final int bindingWorkCenterId;
  final String bindingWorkCenterName;
  final int bindingQueueMinutes;
  final String explanation;
  final List<String> chain;
  final bool isTardy;
}

class ShopVerdict {
  const ShopVerdict({
    required this.onTimeJobs,
    required this.tardyJobs,
    required this.totalTardinessMinutes,
    required this.makespanMinutes,
    required this.bottleneckWorkCenterId,
    required this.bottleneckWorkCenterName,
    required this.bottleneckUtilization,
    required this.bottleneckQueueMinutes,
    required this.jobs,
  });

  final int onTimeJobs;
  final int tardyJobs;
  final int totalTardinessMinutes;
  final int makespanMinutes;
  final int bottleneckWorkCenterId;
  final String bottleneckWorkCenterName;
  final double bottleneckUtilization;
  final int bottleneckQueueMinutes;
  final List<JobVerdict> jobs;
}

ShopVerdict buildDiagnosis({
  required SolverInput input,
  required SolverResult result,
}) {
  final workCenterById = <int, SolverWorkCenter>{
    for (final wc in input.workCenters) wc.id: wc,
  };
  final bottleneckId = _bottleneckWorkCenterId(input, result);
  final bottleneck = workCenterById[bottleneckId];
  final bottleneckUtilization = _utilization(
    bottleneckId,
    input,
    result,
  );

  final verdicts = <JobVerdict>[];

  for (final job in input.jobs) {
    final finish = result.jobFinishMinutes[job.id] ?? 0;
    final tardiness = result.jobTardinessMinutes[job.id] ?? 0;
    final queue = result.jobQueueMinutes[job.id] ?? 0;

    final jobOps = result.placed.where((op) => op.jobId == job.id).toList()
      ..sort((a, b) => a.opIndex.compareTo(b.opIndex));

    var binding = jobOps.isEmpty ? null : jobOps.first;
    for (final op in jobOps) {
      if (binding == null || op.queueMinutes > binding.queueMinutes) {
        binding = op;
      }
    }

    final bindingWcId = binding?.workCenterId ?? (bottleneckId);
    final bindingWc = workCenterById[bindingWcId];
    final bindingQueue = binding?.queueMinutes ?? 0;
    final bindingName = bindingWc?.name ?? 'Unassigned';
    final bindingUtilization = _utilization(bindingWcId, input, result);
    final slack = job.dueMinute - finish;

    final explanation = _explain(
      isTardy: tardiness > 0,
      tardiness: tardiness,
      slack: slack,
      bindingQueue: bindingQueue,
      bindingName: bindingName,
      bindingUtilization: bindingUtilization,
    );

    final chain = <String>[];
    for (final op in jobOps) {
      final defined = _operationOf(job, op.operationId);
      final wc = workCenterById[op.workCenterId];
      final line = StringBuffer();
      if (op.operationId == binding?.operationId && tardiness > 0) {
        line.write('▸ ');
      }
      final label = (wc?.code.isNotEmpty ?? false)
          ? wc!.code
          : (wc?.name ?? '—');
      line.write(label);
      line.write(' · queued ${formatMinutes(op.queueMinutes)}');
      if (op.changeoverMinutes > 0) {
        line.write(' · changeover ${formatMinutes(op.changeoverMinutes)}');
      }
      if (defined != null) {
        if (defined.setupMinutes > 0) {
          line.write(' · setup ${formatMinutes(defined.setupMinutes)}');
        }
        line.write(' · run ${formatMinutes(defined.runMinutes)}');
      }
      chain.add(line.toString());
    }

    verdicts.add(
      JobVerdict(
        jobId: job.id,
        code: job.code,
        title: job.title,
        dueMinute: job.dueMinute,
        finishMinute: finish,
        tardinessMinutes: tardiness,
        queueMinutes: queue,
        bindingWorkCenterId: bindingWcId,
        bindingWorkCenterName: bindingName,
        bindingQueueMinutes: bindingQueue,
        explanation: explanation,
        chain: chain,
        isTardy: tardiness > 0,
      ),
    );
  }

  verdicts.sort((a, b) {
    if (a.isTardy != b.isTardy) return a.isTardy ? -1 : 1;
    if (a.isTardy && b.isTardy) {
      final byTardiness = b.tardinessMinutes.compareTo(a.tardinessMinutes);
      if (byTardiness != 0) return byTardiness;
    }
    return a.finishMinute.compareTo(b.finishMinute);
  });

  return ShopVerdict(
    onTimeJobs: result.onTimeJobs,
    tardyJobs: result.tardyJobs,
    totalTardinessMinutes: result.totalTardinessMinutes,
    makespanMinutes: result.makespan,
    bottleneckWorkCenterId: bottleneckId,
    bottleneckWorkCenterName: bottleneck?.name ?? '—',
    bottleneckUtilization: bottleneckUtilization,
    bottleneckQueueMinutes: result.workCenterQueueMinutes[bottleneckId] ?? 0,
    jobs: verdicts,
  );
}

String _explain({
  required bool isTardy,
  required int tardiness,
  required int slack,
  required int bindingQueue,
  required String bindingName,
  required double bindingUtilization,
}) {
  final loadPercent = (bindingUtilization * 100).round();
  if (!isTardy) {
    final slackText = slack > 0 ? formatMinutes(slack) : 'no';
    if (bindingQueue <= 0) {
      return 'On time with $slackText to spare. '
          'Nothing waited at a machine.';
    }
    return 'On time with $slackText to spare. '
        'The longest wait was ${formatMinutes(bindingQueue)} at $bindingName.';
  }

  if (bindingQueue <= 0) {
    return '${formatMinutes(tardiness)} late, but no step waited for a '
        'machine. The routing itself is longer than the time available.';
  }

  final share = ((bindingQueue / tardiness) * 100).clamp(0, 100).round();
  if (share >= 55) {
    return '$share% of the ${formatMinutes(tardiness)} delay is queue time '
        'at $bindingName, which is running at $loadPercent% load.';
  }
  return 'Late by ${formatMinutes(tardiness)}. Most of it is spread across '
      'the routing; the worst single wait is ${formatMinutes(bindingQueue)} '
      'at $bindingName ($loadPercent% load).';
}

int _bottleneckWorkCenterId(SolverInput input, SolverResult result) {
  var bestId = input.workCenters.isEmpty ? 0 : input.workCenters.first.id;
  var bestScore = -1.0;
  var bestQueue = -1;

  for (final wc in input.workCenters) {
    final utilization = _utilization(wc.id, input, result);
    final queue = result.workCenterQueueMinutes[wc.id] ?? 0;
    if (utilization > bestScore ||
        (utilization == bestScore && queue > bestQueue)) {
      bestScore = utilization;
      bestQueue = queue;
      bestId = wc.id;
    }
  }
  return bestId;
}

double _utilization(int workCenterId, SolverInput input, SolverResult result) {
  if (result.makespan <= 0) return 0;
  SolverWorkCenter? wc;
  for (final candidate in input.workCenters) {
    if (candidate.id == workCenterId) {
      wc = candidate;
      break;
    }
  }
  if (wc == null) return 0;
  final busy = result.workCenterBusyMinutes[workCenterId] ?? 0;
  final capacity = result.makespan * (wc.machines < 1 ? 1 : wc.machines);
  if (capacity <= 0) return 0;
  return busy / capacity;
}

SolverOperation? _operationOf(SolverJob job, int operationId) {
  for (final op in job.operations) {
    if (op.id == operationId) return op;
  }
  return null;
}

/// "2h 10m" style, always compact.
String formatMinutes(int minutes) {
  final negative = minutes < 0;
  final value = minutes.abs();
  final hours = value ~/ 60;
  final rest = value % 60;
  final text = hours == 0
      ? '${rest}m'
      : rest == 0
      ? '${hours}h'
      : '${hours}h ${rest}m';
  return negative ? '-$text' : text;
}
