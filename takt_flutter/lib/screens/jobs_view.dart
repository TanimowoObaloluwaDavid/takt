import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:takt_client/takt_client.dart';

import '../state/app_state.dart';
import '../theme/takt_theme.dart';
import '../widgets/common.dart';
import 'job_editor.dart';

class JobsView extends StatefulWidget {
  const JobsView({super.key, required this.state});

  final AppState state;

  @override
  State<JobsView> createState() => _JobsViewState();
}

class _JobsViewState extends State<JobsView> {
  AppState get state => widget.state;

  final _search = TextEditingController();
  String _query = '';
  _JobStatus? _filter;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<JobBundle> get _visible {
    final query = _query.trim().toLowerCase();
    return state.bundles.where((bundle) {
      if (_filter != null && _statusFor(bundle.job.id) != _filter) {
        return false;
      }
      if (query.isEmpty) return true;
      final haystack =
          '${bundle.job.code} ${bundle.job.title} ${bundle.job.customer}'
              .toLowerCase();
      return haystack.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visible;
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
                              ? state.canWrite
                                    ? 'Tap a job to edit its routing. Changing '
                                          'a routing invalidates the current '
                                          'schedule.'
                                    : 'Inspect the queue and statuses. Editing '
                                          'requires an editor key.'
                              : 'Nothing scheduled yet.',
                          style: TaktType.small,
                        ),
                      ],
                    ),
                  ),
                  if (wide) ...[
                    if (state.hasJobs) ...[
                      TaktButton(
                        label: 'Copy CSV',
                        icon: Icons.table_chart_outlined,
                        tone: ButtonTone.secondary,
                        onPressed: visible.isEmpty
                            ? null
                            : () => _copyCsv(context, visible),
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (state.canWrite)
                      TaktButton(
                        label: 'New job',
                        icon: Icons.add,
                        onPressed: state.hasWorkCenters
                            ? () => showJobEditor(context, state)
                            : null,
                      ),
                  ],
                ],
              ),
              if (!wide && (state.hasJobs || state.canWrite)) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (state.hasJobs)
                      Expanded(
                        child: TaktButton(
                          label: 'Copy CSV',
                          icon: Icons.table_chart_outlined,
                          tone: ButtonTone.secondary,
                          onPressed: visible.isEmpty
                              ? null
                              : () => _copyCsv(context, visible),
                        ),
                      ),
                    if (state.hasJobs && state.canWrite)
                      const SizedBox(width: 8),
                    if (state.canWrite)
                      Expanded(
                        child: TaktButton(
                          label: 'New job',
                          icon: Icons.add,
                          onPressed: state.hasWorkCenters
                              ? () => showJobEditor(context, state)
                              : null,
                        ),
                      ),
                  ],
                ),
              ],
              if (!state.hasWorkCenters) ...[
                const SizedBox(height: 14),
                const TaktBanner(
                  message:
                      'Add a work center in Setup before entering jobs — '
                      'every routing step needs a machine group.',
                  tone: Tone.amber,
                ),
              ],
              if (state.hasJobs) ...[
                const SizedBox(height: 14),
                if (wide)
                  Row(
                    children: [
                      Expanded(child: _searchField()),
                      const SizedBox(width: 12),
                      _filterBar(),
                    ],
                  )
                else ...[
                  _searchField(),
                  const SizedBox(height: 9),
                  _filterBar(),
                ],
              ],
              const SizedBox(height: 18),
              Expanded(
                child: state.bundles.isEmpty
                    ? _empty(context)
                    : visible.isEmpty
                    ? _noMatches()
                    : TaktPanel(
                        padding: EdgeInsets.zero,
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          itemCount: visible.length,
                          separatorBuilder: (_, _) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final bundle = visible[index];
                            return _JobRow(
                              bundle: bundle,
                              centers: state.workCenters,
                              status: _statusFor(bundle.job.id),
                              wide: wide,
                              onTap: () {
                                if (state.canWrite) {
                                  showJobEditor(context, state, bundle: bundle);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'View-only access. Ask the owner for '
                                        'an editor key to change this job.',
                                        style: TaktType.mono.copyWith(
                                          fontSize: 12,
                                        ),
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: TaktColors.graphite,
                                      width: 360,
                                    ),
                                  );
                                }
                              },
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

  Widget _searchField() {
    return TextField(
      controller: _search,
      style: TaktType.body.copyWith(fontSize: 13),
      decoration: taktInput(hint: 'Search code, title, or customer').copyWith(
        isDense: true,
        prefixIcon: const Icon(
          Icons.search,
          size: 17,
          color: TaktColors.faint,
        ),
        suffixIcon: _query.isEmpty
            ? null
            : IconButton(
                onPressed: () {
                  _search.clear();
                  setState(() => _query = '');
                },
                icon: const Icon(Icons.close, size: 15),
                color: TaktColors.muted,
                tooltip: 'Clear search',
                visualDensity: VisualDensity.compact,
              ),
      ),
      onChanged: (value) => setState(() => _query = value),
    );
  }

  Widget _filterBar() {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        _filterChip('All', null),
        _filterChip('Late', _JobStatus.late),
        _filterChip('On time', _JobStatus.onTime),
        _filterChip('Not run', _JobStatus.unscheduled),
      ],
    );
  }

  Widget _filterChip(String label, _JobStatus? value) {
    final active = _filter == value;
    return InkWell(
      onTap: () => setState(() => _filter = value),
      borderRadius: BorderRadius.circular(TaktRadius.tight),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: active ? TaktColors.ink : Colors.transparent,
          border: Border.all(
            color: active ? TaktColors.ink : TaktColors.line,
          ),
          borderRadius: BorderRadius.circular(TaktRadius.tight),
        ),
        child: Text(
          label,
          style: TaktType.mono.copyWith(
            fontSize: 9.5,
            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
            color: active ? TaktColors.surface : TaktColors.inkSoft,
          ),
        ),
      ),
    );
  }

  Widget _noMatches() {
    return EmptyState(
      title: 'No jobs match.',
      body:
          'Nothing in this workspace matches the current search and status '
          'filter.',
      action: TaktButton(
        label: 'Clear filters',
        tone: ButtonTone.ghost,
        onPressed: () {
          _search.clear();
          setState(() {
            _query = '';
            _filter = null;
          });
        },
      ),
    );
  }

  Future<void> _copyCsv(
    BuildContext context,
    List<JobBundle> bundles,
  ) async {
    final rows = <String>[
      'Code,Title,Customer,Quantity,Due,Status',
      for (final bundle in bundles)
        [
          bundle.job.code,
          bundle.job.title,
          bundle.job.customer,
          bundle.job.quantity.toString(),
          formatDateLong(bundle.job.dueAt),
          _statusLabel(_statusFor(bundle.job.id)),
        ].map(_csvCell).join(','),
    ];
    await Clipboard.setData(ClipboardData(text: rows.join('\r\n')));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${bundles.length} jobs copied as CSV',
          style: TaktType.mono.copyWith(fontSize: 12),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: TaktColors.graphite,
        width: 320,
      ),
    );
  }

  String _csvCell(String value) {
    final escaped = value.replaceAll('"', '""');
    return escaped.contains(RegExp(r'[",\r\n]')) ? '"$escaped"' : escaped;
  }

  String _statusLabel(_JobStatus status) => switch (status) {
    _JobStatus.late => 'late',
    _JobStatus.onTime => 'on time',
    _JobStatus.unscheduled => 'not run',
  };

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
      body: !state.canWrite
          ? 'There are no jobs in this workspace. An editor or owner can add '
                'the first job and its routing.'
          : state.hasWorkCenters
          ? 'Enter a job and its routing, or load the sample shop to see the '
                'solver working on realistic data.'
          : 'Define at least one work center, then enter a job with a routing.',
      action: state.canWrite
          ? Row(
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
            )
          : null,
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
