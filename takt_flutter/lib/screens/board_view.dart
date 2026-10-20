import 'package:flutter/material.dart';
import 'package:takt_client/takt_client.dart';

import '../state/app_state.dart';
import '../theme/takt_theme.dart';
import '../widgets/common.dart';
import '../widgets/what_if_dialog.dart';
import 'job_detail.dart';

class BoardView extends StatefulWidget {
  const BoardView({
    super.key,
    required this.state,
    required this.onNavigate,
  });

  final AppState state;
  final void Function(int index) onNavigate;

  @override
  State<BoardView> createState() => _BoardViewState();
}

class _BoardViewState extends State<BoardView> {
  bool _showOnTime = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 820;
        final state = widget.state;
        final snapshot = state.snapshot;
        final diagnosis = snapshot?.diagnosis;

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            wide ? 30 : 16,
            wide ? 28 : 18,
            wide ? 30 : 16,
            48,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _header(wide),
              const SizedBox(height: 20),
              if (state.scheduleStale && snapshot != null) ...[
                TaktBanner(
                  message:
                      'Shop data changed since this run. The verdict below '
                      'is out of date — run the solver again.',
                  tone: Tone.amber,
                ),
                const SizedBox(height: 14),
              ],
              if (snapshot == null || diagnosis == null)
                _startPanel(wide)
              else ...[
                _verdictStrip(diagnosis, wide),
                const SizedBox(height: 16),
                _constraintPanel(diagnosis, wide),
                const SizedBox(height: 26),
                _lateSection(diagnosis, wide),
                const SizedBox(height: 26),
                _capacityLedger(snapshot, diagnosis, wide),
                const SizedBox(height: 26),
                _onTimeSection(diagnosis, wide, snapshot.run.horizonStart),
                const SizedBox(height: 26),
                _runFoot(snapshot.run),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _header(bool wide) {
    final state = widget.state;
    final run = state.snapshot?.run;

    final title = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel('The board'),
        const SizedBox(height: 8),
        Text(
          'What this shop can actually deliver.',
          style: TaktType.headline.copyWith(fontSize: wide ? 26 : 21),
        ),
        const SizedBox(height: 6),
        Text(
          state.hasJobs
              ? '${state.bundles.length} jobs · '
                    '${state.workCenters.length} work centers · '
                    '${state.bundles.fold<int>(0, (sum, bundle) => sum + bundle.operations.length)} routing steps'
              : 'No jobs yet.',
          style: TaktType.small,
        ),
      ],
    );

    final action = Column(
      crossAxisAlignment: wide
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.stretch,
      children: [
        TaktButton(
          label: 'Run solver',
          icon: Icons.play_arrow_rounded,
          busy: state.solving,
          expand: !wide,
          onPressed: state.canWrite && state.hasJobs && !state.solving
              ? state.solve
              : null,
        ),
        if (run != null) ...[
          const SizedBox(height: 7),
          Text(
            'last run ${formatDate(run.createdAt)} · '
            '${formatClock(run.createdAt)} · seed ${run.seed}',
            style: TaktType.mono.copyWith(
              fontSize: 10,
              color: TaktColors.faint,
            ),
          ),
        ],
      ],
    );

    if (wide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(child: title),
          const SizedBox(width: 24),
          action,
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title,
        const SizedBox(height: 16),
        action,
      ],
    );
  }

  Widget _startPanel(bool wide) {
    final state = widget.state;
    final noCenters = !state.hasWorkCenters;
    final noJobs = !state.hasJobs;

    final primary = noJobs
        ? TaktButton(
            label: noCenters ? 'Load sample shop' : 'Add a job',
            icon: noCenters ? Icons.auto_awesome_motion_outlined : Icons.add,
            busy: state.loading,
            onPressed: state.canWrite
                ? () {
                    if (noCenters) {
                      state.loadSample();
                    } else {
                      widget.onNavigate(2);
                    }
                  }
                : null,
          )
        : TaktButton(
            label: 'Run the solver',
            icon: Icons.play_arrow_rounded,
            busy: state.solving,
            onPressed: state.canWrite ? state.solve : null,
          );

    return TaktPanel(
      padding: EdgeInsets.all(wide ? 28 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel('Start here'),
          const SizedBox(height: 9),
          Text(
            'Three steps to a real answer.',
            style: TaktType.headline.copyWith(fontSize: wide ? 24 : 21),
          ),
          const SizedBox(height: 7),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Text(
              'Takt schedules only what you have entered. The sample is a '
              'realistic shop, not a simulated result — you can replace every '
              'row and get the same engine.',
              style: TaktType.body,
            ),
          ),
          const SizedBox(height: 24),
          _step(
            number: '01',
            title: 'Define work centers',
            detail: state.hasWorkCenters
                ? '${state.workCenters.length} groups, '
                      '${state.workCenters.fold<int>(0, (sum, center) => sum + center.machines)} machines'
                : 'No capacity defined yet',
            done: state.hasWorkCenters,
            action: TaktButton(
              label: state.hasWorkCenters ? 'Manage' : 'Add',
              tone: ButtonTone.ghost,
              onPressed: () => widget.onNavigate(3),
            ),
          ),
          const Divider(height: 22),
          _step(
            number: '02',
            title: 'Enter jobs and routings',
            detail: state.hasJobs
                ? '${state.bundles.length} jobs with '
                      '${state.bundles.fold<int>(0, (sum, bundle) => sum + bundle.operations.length)} operations'
                : 'No jobs yet',
            done: state.hasJobs,
            action: TaktButton(
              label: state.hasJobs ? 'Review' : 'Add',
              tone: ButtonTone.ghost,
              onPressed: () => widget.onNavigate(2),
            ),
          ),
          const Divider(height: 22),
          _step(
            number: '03',
            title: 'Run the solver and read the verdict',
            detail: state.snapshot == null
                ? 'Not run yet'
                : 'Last run ${formatClock(state.snapshot!.run.createdAt)}',
            done: state.snapshot != null,
            action: primary,
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              const Icon(Icons.info_outline, size: 13, color: TaktColors.faint),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  'Scheduling is deterministic for a given seed. The same data '
                  'and seed always produce the same schedule.',
                  style: TaktType.small.copyWith(fontSize: 11.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _step({
    required String number,
    required String title,
    required String detail,
    required bool done,
    required Widget action,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 32,
          child: Text(
            number,
            style: TaktType.mono.copyWith(
              fontSize: 11,
              color: done ? TaktColors.teal : TaktColors.faint,
              fontWeight: done ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TaktType.title.copyWith(fontSize: 14)),
              const SizedBox(height: 2),
              Text(detail, style: TaktType.small.copyWith(fontSize: 11.5)),
            ],
          ),
        ),
        const SizedBox(width: 12),
        action,
      ],
    );
  }

  Widget _verdictStrip(ShopDiagnosis diagnosis, bool wide) {
    final total = diagnosis.onTimeJobs + diagnosis.tardyJobs;
    final cells = <Widget>[
      MetricCell(
        label: 'On time',
        value: '${diagnosis.onTimeJobs} / $total',
        caption: 'jobs',
        tone: diagnosis.tardyJobs == 0 ? Tone.teal : Tone.neutral,
      ),
      MetricCell(
        label: 'Late',
        value: diagnosis.tardyJobs.toString(),
        caption: diagnosis.tardyJobs == 1 ? 'job' : 'jobs',
        tone: diagnosis.tardyJobs > 0 ? Tone.oxide : Tone.neutral,
      ),
      MetricCell(
        label: 'Lost time',
        value: formatMinutes(diagnosis.totalTardinessMinutes),
        caption: 'across all jobs',
        tone: diagnosis.totalTardinessMinutes > 0 ? Tone.oxide : Tone.neutral,
      ),
      MetricCell(
        label: 'Constraint',
        value: diagnosis.bottleneckWorkCenterName,
        caption: '${(diagnosis.bottleneckUtilization * 100).round()}% loaded',
        compact: true,
      ),
    ];

    if (wide) {
      return TaktPanel(
        padding: EdgeInsets.zero,
        child: HairlineRow(children: cells),
      );
    }

    return TaktPanel(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: cells[0]),
              const VerticalDivider(
                width: 1,
                thickness: 1,
                color: TaktColors.line,
              ),
              Expanded(child: cells[1]),
            ],
          ),
          const Divider(height: 1),
          Row(
            children: [
              Expanded(child: cells[2]),
              const VerticalDivider(
                width: 1,
                thickness: 1,
                color: TaktColors.line,
              ),
              Expanded(child: cells[3]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _constraintPanel(ShopDiagnosis diagnosis, bool wide) {
    final percent = (diagnosis.bottleneckUtilization * 100).round();
    final queue = diagnosis.bottleneckQueueMinutes;
    final sentence = queue > 0
        ? 'Jobs spent ${formatMinutes(queue)} waiting here in this run. '
              'This is the capacity that decides your dates.'
        : 'No job waited here in this run — but it still carries the '
              'highest load in the shop.';

    final left = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'THE CONSTRAINT',
          style: TaktType.label.copyWith(
            color: TaktColors.surface.withValues(alpha: 0.55),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          diagnosis.bottleneckWorkCenterName,
          style: TaktType.headline.copyWith(
            fontSize: wide ? 30 : 24,
            color: TaktColors.surface,
          ),
        ),
        const SizedBox(height: 8),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Text(
            sentence,
            style: TaktType.body.copyWith(
              fontSize: 13.5,
              color: TaktColors.surface.withValues(alpha: 0.72),
            ),
          ),
        ),
      ],
    );

    final right = Column(
      crossAxisAlignment: wide
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$percent',
              style: TaktType.figure.copyWith(
                fontSize: wide ? 44 : 36,
                color: TaktColors.surface,
              ),
            ),
            Text(
              '%',
              style: TaktType.mono.copyWith(
                fontSize: 16,
                color: TaktColors.surface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
        Text(
          'OF AVAILABLE TIME',
          style: TaktType.label.copyWith(
            color: TaktColors.surface.withValues(alpha: 0.55),
          ),
        ),
        const SizedBox(height: 16),
        TaktButton(
          label: 'Test +1 machine',
          tone: ButtonTone.inverse,
          icon: Icons.science_outlined,
          expand: !wide,
          onPressed: widget.state.scheduleStale
              ? null
              : () => showWhatIf(
                  context,
                  widget.state,
                  workCenterId: diagnosis.bottleneckWorkCenterId,
                  workCenterName: diagnosis.bottleneckWorkCenterName,
                ),
        ),
      ],
    );

    return Container(
      padding: EdgeInsets.all(wide ? 26 : 20),
      decoration: BoxDecoration(
        color: TaktColors.graphite,
        borderRadius: BorderRadius.circular(TaktRadius.normal),
      ),
      child: wide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: left),
                const SizedBox(width: 28),
                right,
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                left,
                const SizedBox(height: 20),
                right,
              ],
            ),
    );
  }

  Widget _capacityLedger(
    ScheduleSnapshot snapshot,
    ShopDiagnosis diagnosis,
    bool wide,
  ) {
    final makespan = snapshot.run.makespanMinutes <= 0
        ? 1
        : snapshot.run.makespanMinutes;
    final loads = <_CenterLoad>[];
    final byId = <int, _CenterLoad>{};
    for (final center in snapshot.workCenters) {
      final id = center.id;
      if (id == null) continue;
      final load = _CenterLoad(center);
      byId[id] = load;
      loads.add(load);
    }
    for (final op in snapshot.scheduledOps) {
      final load = byId[op.workCenterId];
      if (load == null) continue;
      load.busy += op.endMinute - op.startMinute;
      load.queue += op.queueMinutes;
      load.operations += 1;
    }
    loads.sort(
      (a, b) => b.utilization(makespan).compareTo(a.utilization(makespan)),
    );

    Widget heading(String label, {TextAlign align = TextAlign.left}) => Text(
      label,
      textAlign: align,
      style: TaktType.label,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const SectionLabel('The load'),
            const Spacer(),
            if (wide)
              Text(
                'busy time ÷ machine time',
                style: TaktType.small.copyWith(fontSize: 10.5),
              ),
          ],
        ),
        const SizedBox(height: 10),
        TaktPanel(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                child: Row(
                  children: [
                    Expanded(child: heading('WORK CENTER')),
                    if (wide) ...[
                      SizedBox(
                        width: 40,
                        child: heading('OPS', align: TextAlign.right),
                      ),
                      const SizedBox(width: 12),
                    ],
                    SizedBox(
                      width: wide ? 200 : 118,
                      child: heading('LOAD'),
                    ),
                    SizedBox(
                      width: wide ? 90 : 62,
                      child: heading('QUEUE', align: TextAlign.right),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              for (var index = 0; index < loads.length; index++) ...[
                if (index > 0) const Divider(height: 1),
                _loadRow(loads[index], diagnosis, makespan, wide),
              ],
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Queue is total wait across all operations. Load is the capacity signal.',
          style: TaktType.small.copyWith(fontSize: 10.5),
        ),
      ],
    );
  }

  Widget _loadRow(
    _CenterLoad load,
    ShopDiagnosis diagnosis,
    int makespan,
    bool wide,
  ) {
    final utilization = load.utilization(makespan);
    final binding = load.center.id == diagnosis.bottleneckWorkCenterId;
    final percent = (utilization * 100).round();

    return Container(
      color: binding ? TaktColors.oxideWash : null,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: wide ? 62 : 54,
                  child: Text(
                    load.center.code,
                    style: TaktType.monoStrong.copyWith(
                      fontSize: 11.5,
                      color: binding ? TaktColors.oxide : TaktColors.ink,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    load.center.name,
                    style: TaktType.small.copyWith(fontSize: 11),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (wide) ...[
                  const SizedBox(width: 8),
                  Text(
                    '${load.center.machines}×',
                    style: TaktType.mono.copyWith(
                      fontSize: 10,
                      color: TaktColors.faint,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (wide) ...[
            SizedBox(
              width: 40,
              child: Text(
                '${load.operations}',
                textAlign: TextAlign.right,
                style: TaktType.mono.copyWith(
                  fontSize: 10,
                  color: TaktColors.faint,
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          SizedBox(
            width: wide ? 200 : 118,
            child: Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(1),
                    child: SizedBox(
                      height: 5,
                      child: Stack(
                        children: [
                          const Positioned.fill(
                            child: ColoredBox(color: TaktColors.line),
                          ),
                          FractionallySizedBox(
                            widthFactor: utilization.clamp(0.0, 1.0).toDouble(),
                            heightFactor: 1,
                            alignment: Alignment.centerLeft,
                            child: ColoredBox(
                              color: binding
                                  ? TaktColors.oxide
                                  : TaktColors.teal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 7),
                SizedBox(
                  width: 34,
                  child: Text(
                    '$percent%',
                    textAlign: TextAlign.right,
                    style: TaktType.mono.copyWith(
                      fontSize: 10,
                      color: binding ? TaktColors.oxide : TaktColors.ink,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: wide ? 90 : 62,
            child: Text(
              formatMinutes(load.queue),
              textAlign: TextAlign.right,
              style: TaktType.mono.copyWith(
                fontSize: 10.5,
                color: load.queue > 0 ? TaktColors.muted : TaktColors.faint,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _lateSection(ShopDiagnosis diagnosis, bool wide) {
    final late = diagnosis.jobs.where((job) => job.isTardy).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const SectionLabel('Late jobs'),
            const SizedBox(width: 9),
            StatusChip(
              label: '${late.length}',
              tone: Tone.oxide,
              filled: true,
            ),
            const Spacer(),
            if (late.isNotEmpty)
              Text('worst first', style: TaktType.small.copyWith(fontSize: 11)),
          ],
        ),
        const SizedBox(height: 10),
        if (late.isEmpty)
          TaktPanel(
            color: TaktColors.tealWash,
            borderColor: TaktColors.teal.withValues(alpha: 0.28),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  size: 20,
                  color: TaktColors.teal,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Every job lands on time.',
                        style: TaktType.title.copyWith(color: TaktColors.teal),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'No promised date is missed in this run. Test the '
                        'constraint anyway to see how much headroom you have.',
                        style: TaktType.small,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        else
          TaktPanel(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (var index = 0; index < late.length; index++) ...[
                  if (index > 0) const Divider(height: 1),
                  _LateJobRow(
                    verdict: late[index],
                    onTap: () => showJobDetail(
                      context,
                      widget.state,
                      late[index],
                    ),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }

  Widget _onTimeSection(
    ShopDiagnosis diagnosis,
    bool wide,
    DateTime horizon,
  ) {
    final onTime = diagnosis.jobs.where((job) => !job.isTardy).toList();
    if (onTime.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const SectionLabel('On time'),
            const SizedBox(width: 9),
            StatusChip(
              label: '${onTime.length}',
              tone: Tone.teal,
              filled: true,
            ),
            const Spacer(),
            TaktButton(
              label: _showOnTime ? 'Hide' : 'Show',
              tone: ButtonTone.ghost,
              onPressed: () => setState(() => _showOnTime = !_showOnTime),
            ),
          ],
        ),
        if (_showOnTime) ...[
          const SizedBox(height: 10),
          TaktPanel(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (var index = 0; index < onTime.length; index++) ...[
                  if (index > 0) const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 82,
                          child: Text(
                            onTime[index].code,
                            style: TaktType.monoStrong.copyWith(fontSize: 11.5),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            onTime[index].title,
                            style: TaktType.body.copyWith(fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (wide) ...[
                          const SizedBox(width: 12),
                          Text(
                            'finishes '
                            '${formatOffset(horizon, onTime[index].finishMinute)}',
                            style: TaktType.mono.copyWith(
                              fontSize: 10.5,
                              color: TaktColors.muted,
                            ),
                          ),
                        ],
                        const SizedBox(width: 12),
                        const StatusChip(
                          label: 'on time',
                          tone: Tone.teal,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _runFoot(ScheduleRun run) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Makespan ${formatMinutes(run.makespanMinutes)} · '
            'objective ${run.objective.toStringAsFixed(0)} · '
            'seed ${run.seed}',
            style: TaktType.mono.copyWith(
              fontSize: 10,
              color: TaktColors.faint,
            ),
          ),
        ),
        Text(
          'Deterministic heuristic · not a proof of optimality',
          style: TaktType.small.copyWith(fontSize: 10.5),
        ),
      ],
    );
  }
}

class _LateJobRow extends StatelessWidget {
  const _LateJobRow({required this.verdict, required this.onTap});

  final JobDiagnosis verdict;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        hoverColor: TaktColors.rail.withValues(alpha: 0.6),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 700;

            final identity = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  verdict.code,
                  style: TaktType.monoStrong.copyWith(fontSize: 11.5),
                ),
                const SizedBox(height: 2),
                Text(
                  verdict.title,
                  style: TaktType.bodyStrong.copyWith(fontSize: 13.5),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            );

            final tardiness = Column(
              crossAxisAlignment: wide
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '+${formatMinutes(verdict.tardinessMinutes)}',
                  style: TaktType.monoStrong.copyWith(
                    fontSize: 16,
                    color: TaktColors.oxide,
                  ),
                ),
                Text(
                  'PAST DUE',
                  style: TaktType.label.copyWith(
                    fontSize: 8,
                    color: TaktColors.oxide,
                  ),
                ),
              ],
            );

            if (!wide) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 2, height: 40, color: TaktColors.oxide),
                    const SizedBox(width: 12),
                    Expanded(child: identity),
                    const SizedBox(width: 10),
                    tardiness,
                  ],
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 14, 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(width: 2, height: 42, color: TaktColors.oxide),
                  const SizedBox(width: 14),
                  Expanded(flex: 3, child: identity),
                  const SizedBox(width: 18),
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          verdict.explanation,
                          style: TaktType.body.copyWith(fontSize: 13),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'binding · ${verdict.bindingWorkCenterName} · '
                          '${formatMinutes(verdict.bindingQueueMinutes)} queued',
                          style: TaktType.mono.copyWith(
                            fontSize: 10,
                            color: TaktColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  tardiness,
                  const SizedBox(width: 10),
                  const Icon(
                    Icons.arrow_outward,
                    size: 13,
                    color: TaktColors.faint,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CenterLoad {
  _CenterLoad(this.center);

  final WorkCenter center;
  int busy = 0;
  int queue = 0;
  int operations = 0;

  double utilization(int makespan) {
    final machines = center.machines < 1 ? 1 : center.machines;
    final capacity = makespan * machines;
    if (capacity <= 0) return 0;
    return busy / capacity;
  }
}
