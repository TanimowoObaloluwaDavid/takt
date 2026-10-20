import 'package:flutter/material.dart';
import 'package:takt_client/takt_client.dart';

import '../state/app_state.dart';
import '../theme/takt_theme.dart';
import '../widgets/common.dart';
import '../widgets/gantt.dart';
import 'job_detail.dart';

class ScheduleView extends StatelessWidget {
  const ScheduleView({super.key, required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 820;
        final snapshot = state.snapshot;
        final padding = EdgeInsets.fromLTRB(
          wide ? 30 : 16,
          wide ? 28 : 18,
          wide ? 30 : 16,
          wide ? 22 : 12,
        );

        return Padding(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionLabel('Schedule'),
                        const SizedBox(height: 8),
                        Text(
                          'Every minute, placed.',
                          style: TaktType.headline.copyWith(
                            fontSize: wide ? 26 : 21,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          snapshot == null
                              ? 'Run the solver to place the work.'
                              : '${snapshot.scheduledOps.length} operations on '
                                    '${snapshot.workCenters.length} work centers · '
                                    '${formatMinutes(snapshot.run.makespanMinutes)} makespan',
                          style: TaktType.small,
                        ),
                      ],
                    ),
                  ),
                  if (wide && snapshot != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'HORIZON ${formatDateLong(snapshot.run.horizonStart)}',
                          style: TaktType.label,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'seed ${snapshot.run.seed}',
                          style: TaktType.mono.copyWith(
                            fontSize: 10,
                            color: TaktColors.faint,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 18),
              if (state.scheduleStale && snapshot != null) ...[
                TaktBanner(
                  message:
                      'This schedule predates your latest edits. Run the '
                      'solver to replace it.',
                  tone: Tone.amber,
                ),
                const SizedBox(height: 12),
              ],
              Expanded(
                child: snapshot == null
                    ? _empty()
                    : TaktPanel(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                        child: GanttChart(
                          snapshot: snapshot,
                          onOpTap: (op, job) => _showOp(
                            context,
                            snapshot,
                            op,
                            job,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _empty() {
    return EmptyState(
      title: 'No schedule yet.',
      body:
          'The solver places every operation on a real machine, charges '
          'changeover, and records where the waiting happened. Run it once to '
          'see the floor.',
      action: TaktButton(
        label: 'Run solver',
        icon: Icons.play_arrow_rounded,
        busy: state.solving,
        onPressed: state.hasJobs && !state.solving ? state.solve : null,
      ),
    );
  }

  void _showOp(
    BuildContext context,
    ScheduleSnapshot snapshot,
    ScheduledOp op,
    Job job,
  ) {
    JobDiagnosis? verdict;
    for (final candidate in snapshot.diagnosis.jobs) {
      if (candidate.jobId == op.jobId) {
        verdict = candidate;
        break;
      }
    }

    WorkCenter? center;
    for (final candidate in snapshot.workCenters) {
      if (candidate.id == op.workCenterId) {
        center = candidate;
        break;
      }
    }

    showDialog<void>(
      context: context,
      barrierColor: TaktColors.ink.withValues(alpha: 0.25),
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(18),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: TaktPanel(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionLabel('Scheduled operation'),
                const SizedBox(height: 8),
                Text(
                  job.code,
                  style: TaktType.monoStrong.copyWith(fontSize: 12),
                ),
                const SizedBox(height: 2),
                Text(
                  job.title,
                  style: TaktType.headline.copyWith(fontSize: 19),
                ),
                const SizedBox(height: 4),
                Text(
                  '${center?.name ?? 'Work center'} · '
                  'machine ${op.machineIndex + 1}',
                  style: TaktType.small,
                ),
                const SizedBox(height: 18),
                _row(
                  'Starts',
                  formatOffset(snapshot.run.horizonStart, op.startMinute),
                ),
                _row(
                  'Ends',
                  formatOffset(snapshot.run.horizonStart, op.endMinute),
                ),
                _row('Duration', formatMinutes(op.endMinute - op.startMinute)),
                _row('Waited', formatMinutes(op.queueMinutes)),
                if (op.changeoverMinutes > 0)
                  _row('Changeover', formatMinutes(op.changeoverMinutes)),
                const SizedBox(height: 18),
                Row(
                  children: [
                    if (verdict != null)
                      TaktButton(
                        label: 'Open job verdict',
                        tone: ButtonTone.secondary,
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                          showJobDetail(context, state, verdict!);
                        },
                      ),
                    const Spacer(),
                    TaktButton(
                      label: 'Close',
                      tone: ButtonTone.ghost,
                      onPressed: () => Navigator.of(dialogContext).pop(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 94,
            child: Text(label.toUpperCase(), style: TaktType.label),
          ),
          Expanded(
            child: Text(
              value,
              style: TaktType.mono.copyWith(fontSize: 12.5),
            ),
          ),
        ],
      ),
    );
  }
}
