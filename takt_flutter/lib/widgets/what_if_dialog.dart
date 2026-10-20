import 'package:flutter/material.dart';
import 'package:takt_client/takt_client.dart';

import '../state/app_state.dart';
import '../theme/takt_theme.dart';
import 'common.dart';

Future<void> showWhatIf(
  BuildContext context,
  AppState state, {
  required int workCenterId,
  required String workCenterName,
}) {
  return showDialog<void>(
    context: context,
    barrierColor: TaktColors.ink.withValues(alpha: 0.3),
    builder: (_) => _WhatIfDialog(
      state: state,
      workCenterId: workCenterId,
      workCenterName: workCenterName,
    ),
  );
}

class _WhatIfDialog extends StatefulWidget {
  const _WhatIfDialog({
    required this.state,
    required this.workCenterId,
    required this.workCenterName,
  });

  final AppState state;
  final int workCenterId;
  final String workCenterName;

  @override
  State<_WhatIfDialog> createState() => _WhatIfDialogState();
}

class _WhatIfDialogState extends State<_WhatIfDialog> {
  int _extra = 1;
  bool _busy = false;
  WhatIfResult? _result;

  Future<void> _run() async {
    setState(() {
      _busy = true;
      _result = null;
    });
    final result = await widget.state.whatIf(widget.workCenterId, _extra);
    if (!mounted) return;
    setState(() {
      _busy = false;
      _result = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final result = _result;
    final tone = result == null
        ? Tone.neutral
        : result.savedTardinessMinutes > 0
        ? Tone.teal
        : Tone.amber;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(18),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540),
        child: TaktPanel(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionLabel('Capacity experiment'),
              const SizedBox(height: 8),
              Text(
                'What if ${widget.workCenterName}\nhad more capacity?',
                style: TaktType.headline.copyWith(fontSize: 21),
              ),
              const SizedBox(height: 8),
              Text(
                'Both runs use the same seed, so the only difference is the '
                'machine count.',
                style: TaktType.small,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Machines to add',
                    style: TaktType.body.copyWith(fontSize: 13),
                  ),
                  const Spacer(),
                  _stepper(),
                ],
              ),
              const SizedBox(height: 18),
              TaktButton(
                label: 'Run experiment',
                onPressed: _busy ? null : _run,
                busy: _busy,
                expand: true,
                icon: Icons.science_outlined,
              ),
              if (result != null) ...[
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: TaktColors.line),
                    borderRadius: BorderRadius.circular(TaktRadius.normal),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: MetricCell(
                              label: 'Jobs saved',
                              value: result.jobsSaved.abs().toString(),
                              tone: tone,
                              compact: true,
                            ),
                          ),
                          Expanded(
                            child: MetricCell(
                              label: 'Time recovered',
                              value: formatMinutes(
                                result.savedTardinessMinutes.abs(),
                              ),
                              tone: tone,
                              compact: true,
                            ),
                          ),
                          Expanded(
                            child: MetricCell(
                              label: 'Still late',
                              value: result.scenarioTardyJobs.toString(),
                              tone: result.scenarioTardyJobs == 0
                                  ? Tone.teal
                                  : Tone.oxide,
                              compact: true,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          _sentence(result),
                          style: TaktType.body.copyWith(fontSize: 13.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 18),
              Row(
                children: [
                  const Spacer(),
                  TaktButton(
                    label: 'Close',
                    tone: ButtonTone.ghost,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _sentence(WhatIfResult result) {
    if (result.savedTardinessMinutes > 0 && result.jobsSaved > 0) {
      final jobs = result.jobsSaved == 1 ? 'job returns' : 'jobs return';
      return '${result.jobsSaved} $jobs to the promised date. Late time falls '
          'from ${formatMinutes(result.baselineTardinessMinutes)} to '
          '${formatMinutes(result.scenarioTardinessMinutes)}.';
    }
    if (result.savedTardinessMinutes > 0) {
      return 'Late time falls by ${formatMinutes(result.savedTardinessMinutes)}, '
          'but no job crosses its due date. The dates are held by another '
          'constraint.';
    }
    if (result.savedTardinessMinutes < 0) {
      return 'This makes the schedule worse by '
          '${formatMinutes(-result.savedTardinessMinutes)}. More capacity here '
          'just feeds the next bottleneck.';
    }
    return 'No gain. ${widget.workCenterName} is not what is holding these '
        'dates — the constraint is elsewhere in the routing.';
  }

  Widget _stepper() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: TaktColors.line),
        borderRadius: BorderRadius.circular(TaktRadius.tight),
      ),
      child: Row(
        children: [
          _stepButton(
            Icons.remove,
            _extra > 1 ? () => setState(() => _extra--) : null,
          ),
          SizedBox(
            width: 38,
            child: Text(
              '$_extra',
              textAlign: TextAlign.center,
              style: TaktType.monoStrong.copyWith(fontSize: 14),
            ),
          ),
          _stepButton(
            Icons.add,
            _extra < 4 ? () => setState(() => _extra++) : null,
          ),
        ],
      ),
    );
  }

  Widget _stepButton(IconData icon, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 34,
        height: 34,
        child: Icon(
          icon,
          size: 15,
          color: onTap == null ? TaktColors.faint : TaktColors.ink,
        ),
      ),
    );
  }
}
