import 'package:flutter/material.dart';
import 'package:takt_client/takt_client.dart';

import '../state/app_state.dart';
import '../theme/takt_theme.dart';
import '../widgets/common.dart';
import '../widgets/what_if_dialog.dart';

Future<void> showJobDetail(
  BuildContext context,
  AppState state,
  JobDiagnosis verdict,
) {
  return showDialog<void>(
    context: context,
    barrierColor: TaktColors.ink.withValues(alpha: 0.3),
    builder: (_) => _JobDetailDialog(state: state, verdict: verdict),
  );
}

class _JobDetailDialog extends StatelessWidget {
  const _JobDetailDialog({required this.state, required this.verdict});

  final AppState state;
  final JobDiagnosis verdict;

  @override
  Widget build(BuildContext context) {
    final snapshot = state.snapshot;
    final horizon = snapshot?.run.horizonStart ?? DateTime.now();
    Job? job;
    if (snapshot != null) {
      for (final candidate in snapshot.jobs) {
        if (candidate.id == verdict.jobId) {
          job = candidate;
          break;
        }
      }
    }
    final ops =
        snapshot?.scheduledOps
            .where((op) => op.jobId == verdict.jobId)
            .toList() ??
        const <ScheduledOp>[];
    ops.sort((a, b) => a.startMinute.compareTo(b.startMinute));

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(18),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 700,
          maxHeight: MediaQuery.sizeOf(context).height * 0.88,
        ),
        child: TaktPanel(
          padding: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 22, 24, 18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SectionLabel('Job verdict'),
                          const SizedBox(height: 8),
                          Text(
                            verdict.code,
                            style: TaktType.monoStrong.copyWith(fontSize: 15),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            verdict.title.isEmpty
                                ? 'Untitled job'
                                : verdict.title,
                            style: TaktType.headline.copyWith(fontSize: 22),
                          ),
                          if (job != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              [
                                if (job.customer.isNotEmpty) job.customer,
                                'qty ${job.quantity}',
                                'due ${formatDateLong(job.dueAt)}',
                                'priority ${job.priority}',
                              ].join(' · '),
                              style: TaktType.small,
                            ),
                          ],
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, size: 17),
                      color: TaktColors.muted,
                      tooltip: 'Close',
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 22, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _verdictBlock(context, horizon),
                      const SizedBox(height: 22),
                      const SectionLabel('Where the time went'),
                      const SizedBox(height: 12),
                      _chain(),
                      if (ops.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        const SectionLabel('Placed on the floor'),
                        const SizedBox(height: 10),
                        _timings(horizon, ops),
                      ],
                    ],
                  ),
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
                child: Row(
                  children: [
                    if (verdict.bindingWorkCenterId > 0)
                      TaktButton(
                        label:
                            'Test capacity at ${verdict.bindingWorkCenterName}',
                        tone: ButtonTone.secondary,
                        icon: Icons.science_outlined,
                        onPressed: () {
                          Navigator.of(context).pop();
                          showWhatIf(
                            context,
                            state,
                            workCenterId: verdict.bindingWorkCenterId,
                            workCenterName: verdict.bindingWorkCenterName,
                          );
                        },
                      ),
                    const Spacer(),
                    TaktButton(
                      label: 'Close',
                      tone: ButtonTone.ghost,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _verdictBlock(BuildContext context, DateTime horizon) {
    final late = verdict.tardinessMinutes > 0;
    final tone = late ? TaktColors.oxide : TaktColors.teal;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 3,
          height: 74,
          color: tone,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    late
                        ? '+${formatMinutes(verdict.tardinessMinutes)}'
                        : 'On time',
                    style: late
                        ? TaktType.figure.copyWith(color: tone)
                        : TaktType.headline.copyWith(color: tone),
                  ),
                  const SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      late
                          ? 'PAST THE PROMISED DATE'
                          : 'WITHIN THE PROMISED DATE',
                      style: TaktType.label.copyWith(
                        fontSize: 9,
                        color: tone,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 9),
              Text(
                verdict.explanation,
                style: TaktType.body.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text(
                'Finishes ${formatOffset(horizon, verdict.finishMinute)} · '
                'due ${formatOffset(horizon, verdict.dueMinute)}',
                style: TaktType.mono.copyWith(fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _chain() {
    if (verdict.chain.isEmpty) {
      return Text('No routing steps were placed.', style: TaktType.small);
    }

    return Column(
      children: [
        for (var index = 0; index < verdict.chain.length; index++)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 18,
                  child: Column(
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        margin: const EdgeInsets.only(top: 6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index == 0
                              ? TaktColors.ink
                              : TaktColors.lineStrong,
                        ),
                      ),
                      if (index != verdict.chain.length - 1)
                        Expanded(
                          child: Container(
                            width: 1,
                            margin: const EdgeInsets.symmetric(vertical: 3),
                            color: TaktColors.line,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _chainStep(verdict.chain[index]),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _chainStep(String line) {
    final parts = line.replaceFirst('▸ ', '').split(' · ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          parts.first,
          style: TaktType.monoStrong.copyWith(fontSize: 12.5),
        ),
        if (parts.length > 1) ...[
          const SizedBox(height: 2),
          Text(
            parts.skip(1).join('  ·  '),
            style: TaktType.mono.copyWith(
              fontSize: 11,
              color: TaktColors.muted,
            ),
          ),
        ],
      ],
    );
  }

  Widget _timings(DateTime horizon, List<ScheduledOp> ops) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: TaktColors.line),
        borderRadius: BorderRadius.circular(TaktRadius.normal),
      ),
      child: Column(
        children: [
          for (var index = 0; index < ops.length; index++) ...[
            if (index > 0) const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: 62,
                    child: Text(
                      'M${ops[index].machineIndex + 1}',
                      style: TaktType.label,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${formatOffset(horizon, ops[index].startMinute)} → '
                      '${formatOffset(horizon, ops[index].endMinute)}',
                      style: TaktType.mono.copyWith(fontSize: 11.5),
                    ),
                  ),
                  Text(
                    ops[index].queueMinutes > 0
                        ? 'waited ${formatMinutes(ops[index].queueMinutes)}'
                        : 'no wait',
                    style: TaktType.mono.copyWith(
                      fontSize: 10.5,
                      color: ops[index].queueMinutes > 0
                          ? TaktColors.oxide
                          : TaktColors.muted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
