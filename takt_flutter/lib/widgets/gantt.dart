import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:takt_client/takt_client.dart';

import '../theme/takt_theme.dart';
import 'common.dart';

class GanttChart extends StatefulWidget {
  const GanttChart({
    super.key,
    required this.snapshot,
    this.onOpTap,
  });

  final ScheduleSnapshot snapshot;
  final void Function(ScheduledOp op, Job job)? onOpTap;

  @override
  State<GanttChart> createState() => _GanttChartState();
}

class _GanttChartState extends State<GanttChart> {
  static const _labelWidth = 158.0;
  static const _rulerHeight = 30.0;
  static const _dayMinutes = 1440;
  static const _minRowHeight = 42.0;
  static const _maxRowHeight = 64.0;

  final _ruler = ScrollController();
  final _chart = ScrollController();
  bool _syncing = false;
  double? _scaleOverride;

  @override
  void initState() {
    super.initState();
    _chart.addListener(_followChart);
  }

  @override
  void didUpdateWidget(covariant GanttChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.snapshot.run.id != widget.snapshot.run.id) {
      _scaleOverride = null;
    }
  }

  @override
  void dispose() {
    _chart.removeListener(_followChart);
    _chart.dispose();
    _ruler.dispose();
    super.dispose();
  }

  void _followChart() {
    if (_syncing || !_chart.hasClients || !_ruler.hasClients) return;
    _syncing = true;
    _ruler.jumpTo(
      _chart.offset.clamp(0.0, _ruler.position.maxScrollExtent),
    );
    _syncing = false;
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = widget.snapshot;
    final centers = List<WorkCenter>.of(snapshot.workCenters)
      ..sort((a, b) => a.code.compareTo(b.code));
    final jobsById = <int, Job>{
      for (final job in snapshot.jobs)
        if (job.id != null) job.id!: job,
    };

    final lanes = <_Lane>[];
    for (final center in centers) {
      var highestMachine = 0;
      for (final op in snapshot.scheduledOps) {
        if (op.workCenterId == center.id) {
          highestMachine = math.max(highestMachine, op.machineIndex);
        }
      }
      final count = math.max(
        math.max(1, center.machines),
        highestMachine + 1,
      );
      for (var machine = 0; machine < count; machine++) {
        lanes.add(_Lane(center: center, machine: machine));
      }
    }

    final opsByLane = <String, List<ScheduledOp>>{};
    for (final op in snapshot.scheduledOps) {
      final key = '${op.workCenterId}:${op.machineIndex}';
      opsByLane.putIfAbsent(key, () => []).add(op);
    }
    for (final list in opsByLane.values) {
      list.sort((a, b) => a.startMinute.compareTo(b.startMinute));
    }

    var maxMinute = 0;
    for (final op in snapshot.scheduledOps) {
      maxMinute = math.max(maxMinute, op.endMinute);
    }
    if (maxMinute <= 0) maxMinute = _dayMinutes;
    final days = (maxMinute / _dayMinutes).ceil().clamp(1, 90);
    final totalMinutes = days * _dayMinutes;
    return LayoutBuilder(
      builder: (context, constraints) {
        final viewport = constraints.maxWidth.isFinite
            ? math.max(0.0, constraints.maxWidth - _labelWidth - 1)
            : 1100.0;
        final fit = (viewport / totalMinutes).clamp(0.12, 1.0);
        final scale = _scaleOverride ?? fit;
        final chartWidth = math.max(totalMinutes * scale, 640.0);
        final rowViewport = constraints.maxHeight.isFinite
            ? math.max(0.0, constraints.maxHeight - _rulerHeight - 96)
            : _minRowHeight * lanes.length;
        final rowHeight = lanes.isEmpty
            ? _minRowHeight
            : (rowViewport / lanes.length)
                  .clamp(_minRowHeight, _maxRowHeight)
                  .toDouble();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _toolbar(scale),
            const Divider(height: 1),
            SizedBox(
              height: _rulerHeight,
              child: Row(
                children: [
                  SizedBox(
                    width: _labelWidth,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2, top: 10),
                      child: Text('WORK CENTER', style: TaktType.label),
                    ),
                  ),
                  Expanded(
                    child: ClipRect(
                      child: SingleChildScrollView(
                        controller: _ruler,
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        child: SizedBox(
                          width: chartWidth,
                          height: _rulerHeight,
                          child: _rulerRow(days, scale),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: _labelWidth,
                      child: Column(
                        children: [
                          for (final lane in lanes) _laneLabel(lane, rowHeight),
                        ],
                      ),
                    ),
                    VerticalDivider(
                      width: 1,
                      thickness: 1,
                      color: TaktColors.line,
                    ),
                    Expanded(
                      child: ClipRect(
                        child: SingleChildScrollView(
                          controller: _chart,
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: chartWidth,
                            height: lanes.length * rowHeight,
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: CustomPaint(
                                    painter: _GridPainter(
                                      days: days,
                                      dayWidth: _dayMinutes * scale,
                                      rowHeight: rowHeight,
                                      rows: lanes.length,
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    for (final lane in lanes)
                                      _laneRow(
                                        lane,
                                        opsByLane['${lane.center.id}:${lane.machine}'] ??
                                            const [],
                                        jobsById,
                                        rowHeight,
                                        scale,
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _toolbar(double scale) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TaktSpace.md),
      child: Row(
        children: [
          _legendSwatch(TaktColors.teal, 'On time'),
          const SizedBox(width: TaktSpace.lg),
          _legendSwatch(TaktColors.oxide, 'Late'),
          const SizedBox(width: TaktSpace.lg),
          _legendSwatch(TaktColors.lineStrong, 'Queue', thin: true),
          const Spacer(),
          Text('SCALE', style: TaktType.label),
          SizedBox(
            width: 140,
            child: SliderTheme(
              data: SliderThemeData(
                trackHeight: 2,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                activeTrackColor: TaktColors.ink,
                inactiveTrackColor: TaktColors.line,
                thumbColor: TaktColors.ink,
              ),
              child: Slider(
                value: scale,
                min: 0.12,
                max: 1.0,
                onChanged: (value) => setState(() => _scaleOverride = value),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendSwatch(Color color, String label, {bool thin = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: thin ? 2 : 9,
          color: color,
        ),
        const SizedBox(width: 6),
        Text(label, style: TaktType.small.copyWith(fontSize: 11.5)),
      ],
    );
  }

  Widget _rulerRow(int days, double scale) {
    return Stack(
      children: [
        for (var day = 0; day < days; day++)
          Positioned(
            left: day * _dayMinutes * scale + 7,
            top: 10,
            child: Text(
              'DAY ${day + 1}',
              style: TaktType.label.copyWith(fontSize: 9),
            ),
          ),
      ],
    );
  }

  Widget _laneLabel(_Lane lane, double rowHeight) {
    return Container(
      height: rowHeight,
      padding: const EdgeInsets.only(left: 2, right: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: TaktColors.line)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lane.center.code,
                  style: TaktType.monoStrong.copyWith(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  lane.center.machines > 1
                      ? '${lane.center.name} · M${lane.machine + 1}'
                      : lane.center.name,
                  style: TaktType.small.copyWith(fontSize: 10.5),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _laneRow(
    _Lane lane,
    List<ScheduledOp> ops,
    Map<int, Job> jobsById,
    double rowHeight,
    double scale,
  ) {
    return SizedBox(
      height: rowHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (final op in ops) _bar(op, jobsById[op.jobId], rowHeight, scale),
        ],
      ),
    );
  }

  Widget _bar(ScheduledOp op, Job? job, double rowHeight, double scale) {
    final left = op.startMinute * scale;
    final width = math.max(5.0, (op.endMinute - op.startMinute) * scale);
    final changeoverWidth = math.min(width, op.changeoverMinutes * scale);
    final color = op.isTardy ? TaktColors.oxide : TaktColors.teal;
    final queue = op.queueMinutes;

    final label = job == null
        ? 'Job ${op.jobId}'
        : '${job.code} · ${job.title}\n'
              '${formatMinutes(op.endMinute - op.startMinute)} on '
              '${formatMinutes(op.queueMinutes)} queue';

    return Positioned(
      left: left,
      top: (rowHeight - 22) / 2,
      width: width,
      height: 22,
      child: Tooltip(
        message: label,
        waitDuration: const Duration(milliseconds: 350),
        child: GestureDetector(
          onTap: job == null ? null : () => widget.onOpTap?.call(op, job),
          child: MouseRegion(
            cursor: job == null ? MouseCursor.defer : SystemMouseCursors.click,
            child: Stack(
              children: [
                if (queue > 0)
                  Positioned(
                    left: 0,
                    bottom: -4,
                    width: math.max(2.0, queue * scale),
                    height: 2,
                    child: const ColoredBox(color: TaktColors.lineStrong),
                  ),
                Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: width > 8
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: Stack(
                            children: [
                              if (changeoverWidth > 0)
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  bottom: 0,
                                  width: changeoverWidth,
                                  child: ColoredBox(
                                    color: TaktColors.ink.withValues(
                                      alpha: 0.28,
                                    ),
                                  ),
                                ),
                              if (width > 44 && job != null)
                                Positioned(
                                  left: changeoverWidth + 5,
                                  top: 4,
                                  right: 4,
                                  child: Text(
                                    job.code,
                                    maxLines: 1,
                                    overflow: TextOverflow.clip,
                                    style: TaktType.mono.copyWith(
                                      fontSize: 9.5,
                                      height: 1.2,
                                      fontWeight: FontWeight.w600,
                                      color: TaktColors.surface,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Lane {
  const _Lane({required this.center, required this.machine});

  final WorkCenter center;
  final int machine;
}

class _GridPainter extends CustomPainter {
  const _GridPainter({
    required this.days,
    required this.dayWidth,
    required this.rowHeight,
    required this.rows,
  });

  final int days;
  final double dayWidth;
  final double rowHeight;
  final int rows;

  @override
  void paint(Canvas canvas, Size size) {
    final dayPaint = Paint()
      ..color = TaktColors.line
      ..strokeWidth = 1;
    final rowPaint = Paint()
      ..color = TaktColors.line.withValues(alpha: 0.65)
      ..strokeWidth = 1;

    for (var day = 0; day <= days; day++) {
      final x = day * dayWidth;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), dayPaint);
      if (day < days) {
        for (var quarter = 1; quarter < 4; quarter++) {
          final qx = x + dayWidth * quarter / 4;
          canvas.drawLine(
            Offset(qx, 0),
            Offset(qx, size.height),
            Paint()
              ..color = TaktColors.line.withValues(alpha: 0.35)
              ..strokeWidth = 1,
          );
        }
      }
    }

    for (var row = 0; row <= rows; row++) {
      final y = row * rowHeight;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), rowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) {
    return oldDelegate.days != days ||
        oldDelegate.dayWidth != dayWidth ||
        oldDelegate.rows != rows;
  }
}
