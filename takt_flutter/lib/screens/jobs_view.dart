import 'package:flutter/material.dart';
import 'package:takt_client/takt_client.dart';

import '../state/app_state.dart';
import '../theme/takt_theme.dart';
import '../widgets/common.dart';
import 'job_editor.dart';

class JobsView extends StatelessWidget {
  const JobsView({super.key, required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 900;

        return Padding(
          padding: EdgeInsets.fromLTRB(
            wide ? 30 : 16,
            wide ? 28 : 18,
            wide ? 30 : 16,
            wide ? 24 : 14,
          ),
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
                        const SectionLabel('Jobs'),
                        const SizedBox(height: 8),
                        Text(
                          'The work on the floor.',
                          style: TaktType.headline.copyWith(
                            fontSize: wide ? 26 : 21,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          state.hasJobs
                              ? 'Tap a job to edit its routing. Changing a '
                                    'routing invalidates the current schedule.'
                              : 'Nothing scheduled yet.',
                          style: TaktType.small,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  TaktButton(
                    label: 'New job',
                    icon: Icons.add,
                    onPressed: state.hasWorkCenters
                        ? () => showJobEditor(context, state)
                        : null,
                  ),
                ],
              ),
              if (!state.hasWorkCenters) ...[
                const SizedBox(height: 14),
                const TaktBanner(
                  message:
                      'Add a work center in Setup before entering jobs — '
                      'every routing step needs a machine group.',
                  tone: Tone.amber,
                ),
              ],
              const SizedBox(height: 18),
              Expanded(
                child: state.bundles.isEmpty
                    ? _empty(context)
                    : TaktPanel(
                        padding: EdgeInsets.zero,
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          itemCount: state.bundles.length,
                          separatorBuilder: (_, _) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final bundle = state.bundles[index];
                            return _JobRow(
                              bundle: bundle,
                              centers: state.workCenters,
                              status: _statusFor(bundle.job.id),
                              wide: wide,
                              onTap: () =>
                                  showJobEditor(context, state, bundle: bundle),
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  _JobStatus _statusFor(int? jobId) {
    if (jobId == null) return _JobStatus.unscheduled;
    final diagnosis = state.snapshot?.diagnosis;
    if (diagnosis == null) return _JobStatus.unscheduled;
    for (final verdict in diagnosis.jobs) {
      if (verdict.jobId == jobId) {
        return verdict.isTardy ? _JobStatus.late : _JobStatus.onTime;
      }
    }
    return _JobStatus.unscheduled;
  }

  Widget _empty(BuildContext context) {
    return EmptyState(
      title: 'No jobs on the floor.',
      body: state.hasWorkCenters
          ? 'Enter a job and its routing, or load the sample shop to see the '
                'solver working on realistic data.'
          : 'Define at least one work center, then enter a job with a routing.',
      action: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TaktButton(
            label: 'New job',
            icon: Icons.add,
            onPressed: state.hasWorkCenters
                ? () => showJobEditor(context, state)
                : null,
          ),
          const SizedBox(width: 10),
          TaktButton(
            label: 'Load sample shop',
            tone: ButtonTone.secondary,
            busy: state.loading,
            onPressed: state.hasJobs || state.hasWorkCenters
                ? null
                : state.loadSample,
          ),
        ],
      ),
    );
  }
}

enum _JobStatus { late, onTime, unscheduled }

class _JobRow extends StatelessWidget {
  const _JobRow({
    required this.bundle,
    required this.centers,
    required this.status,
    required this.wide,
    required this.onTap,
  });

  final JobBundle bundle;
  final List<WorkCenter> centers;
  final _JobStatus status;
  final bool wide;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final job = bundle.job;
    final statusChip = switch (status) {
      _JobStatus.late => const StatusChip(
        label: 'late',
        tone: Tone.oxide,
        filled: true,
      ),
      _JobStatus.onTime => const StatusChip(label: 'on time', tone: Tone.teal),
      _JobStatus.unscheduled => const StatusChip(label: 'not run'),
    };

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        hoverColor: TaktColors.rail.withValues(alpha: 0.6),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: wide ? 14 : 13,
          ),
          child: wide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 86,
                      child: Text(
                        job.code,
                        style: TaktType.monoStrong.copyWith(fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.title.isEmpty ? 'Untitled job' : job.title,
                            style: TaktType.bodyStrong.copyWith(fontSize: 13.5),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (job.customer.isNotEmpty)
                            Text(
                              job.customer,
                              style: TaktType.small.copyWith(fontSize: 11),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 4,
                      child: Text(
                        _routingSummary(),
                        style: TaktType.mono.copyWith(
                          fontSize: 10.5,
                          color: TaktColors.muted,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 128,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'due ${formatDate(job.dueAt)}',
                            style: TaktType.mono.copyWith(fontSize: 10.5),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'qty ${job.quantity} · P${job.priority}',
                            style: TaktType.small.copyWith(fontSize: 10.5),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 74,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: statusChip,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: TaktColors.faint,
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Text(
                          job.code,
                          style: TaktType.monoStrong.copyWith(fontSize: 11.5),
                        ),
                        const Spacer(),
                        statusChip,
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      job.title.isEmpty ? 'Untitled job' : job.title,
                      style: TaktType.bodyStrong.copyWith(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${job.customer.isEmpty ? 'No customer' : job.customer} · '
                      'qty ${job.quantity} · due ${formatDate(job.dueAt)} · '
                      'P${job.priority}',
                      style: TaktType.small.copyWith(fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _routingSummary(),
                      style: TaktType.mono.copyWith(
                        fontSize: 10,
                        color: TaktColors.muted,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  String _routingSummary() {
    if (bundle.operations.isEmpty) return 'No routing';
    final byId = <int, WorkCenter>{
      for (final center in centers)
        if (center.id != null) center.id!: center,
    };
    return bundle.operations
        .map((op) => byId[op.workCenterId]?.code ?? '—')
        .join(' → ');
  }
}
