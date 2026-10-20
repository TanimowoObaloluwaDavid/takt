import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:takt_client/takt_client.dart';

import '../state/app_state.dart';
import '../theme/takt_theme.dart';
import '../widgets/common.dart';

Future<bool> showJobEditor(
  BuildContext context,
  AppState state, {
  JobBundle? bundle,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierColor: TaktColors.ink.withValues(alpha: 0.3),
    builder: (_) => _JobEditorDialog(state: state, bundle: bundle),
  );
  return result ?? false;
}

class _JobEditorDialog extends StatefulWidget {
  const _JobEditorDialog({required this.state, this.bundle});

  final AppState state;
  final JobBundle? bundle;

  @override
  State<_JobEditorDialog> createState() => _JobEditorDialogState();
}

class _JobEditorDialogState extends State<_JobEditorDialog> {
  late final TextEditingController _code;
  late final TextEditingController _title;
  late final TextEditingController _customer;
  late final TextEditingController _quantity;

  late DateTime _due;
  late DateTime _release;
  late int _priority;
  late List<_StepDraft> _steps;

  String? _error;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final existing = widget.bundle;
    final now = DateTime.now();

    _code = TextEditingController(
      text: existing?.job.code ?? _nextCode(),
    );
    _title = TextEditingController(text: existing?.job.title ?? '');
    _customer = TextEditingController(text: existing?.job.customer ?? '');
    _quantity = TextEditingController(
      text: (existing?.job.quantity ?? 1).toString(),
    );

    _due =
        existing?.job.dueAt ??
        DateTime(now.year, now.month, now.day, 17).add(const Duration(days: 7));
    _release =
        existing?.job.releaseAt ?? DateTime(now.year, now.month, now.day, 8);
    _priority = existing?.job.priority ?? 1;

    final operations = existing?.operations ?? const <Operation>[];
    if (operations.isEmpty) {
      _steps = [
        _StepDraft(
          workCenterId: widget.state.workCenters.isEmpty
              ? null
              : widget.state.workCenters.first.id,
        ),
      ];
    } else {
      _steps = [
        for (final op in operations)
          _StepDraft(
            workCenterId: op.workCenterId,
            setup: op.setupMinutes,
            run: op.unitRunMinutes,
            description: op.description,
          ),
      ];
    }
  }

  @override
  void dispose() {
    _code.dispose();
    _title.dispose();
    _customer.dispose();
    _quantity.dispose();
    for (final step in _steps) {
      step.dispose();
    }
    super.dispose();
  }

  String _nextCode() {
    var highest = 1000;
    for (final bundle in widget.state.bundles) {
      final match = RegExp(r'(\d+)$').firstMatch(bundle.job.code);
      final number = match == null ? null : int.tryParse(match.group(1)!);
      if (number != null && number > highest) highest = number;
    }
    return 'J-${highest + 1}';
  }

  Future<void> _pickDate({required bool due}) async {
    final current = due ? _due : _release;
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      helpText: due ? 'Promised delivery' : 'Material release',
    );
    if (picked == null) return;
    setState(() {
      if (due) {
        _due = DateTime(picked.year, picked.month, picked.day, 17);
      } else {
        _release = DateTime(picked.year, picked.month, picked.day, 8);
      }
    });
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    setState(() => _error = null);

    final code = _code.text.trim();
    if (code.isEmpty) {
      setState(() => _error = 'Every job needs a reference.');
      return;
    }
    final quantity = int.tryParse(_quantity.text.trim());
    if (quantity == null || quantity < 1) {
      setState(() => _error = 'Quantity must be a whole number of at least 1.');
      return;
    }
    if (_steps.isEmpty) {
      setState(() => _error = 'Add at least one routing step.');
      return;
    }

    final operations = <Operation>[];
    for (var index = 0; index < _steps.length; index++) {
      final step = _steps[index];
      if (step.workCenterId == null) {
        setState(() => _error = 'Pick a work center for every step.');
        return;
      }
      final setup = int.tryParse(step.setup.text.trim()) ?? 0;
      final run = double.tryParse(step.run.text.trim()) ?? 0;
      if (setup < 0 || run < 0) {
        setState(() => _error = 'Times cannot be negative.');
        return;
      }
      operations.add(
        Operation(
          jobId: widget.bundle?.job.id ?? 0,
          sequence: (index + 1) * 10,
          workCenterId: step.workCenterId!,
          setupMinutes: setup,
          unitRunMinutes: run,
          description: step.description.text.trim(),
        ),
      );
    }

    final job = Job(
      id: widget.bundle?.job.id,
      shopId: widget.state.shop!.id!,
      code: code,
      title: _title.text.trim(),
      customer: _customer.text.trim(),
      quantity: quantity,
      dueAt: _due,
      releaseAt: _release,
      priority: _priority,
      notes: widget.bundle?.job.notes ?? '',
    );

    setState(() => _saving = true);
    final ok = await widget.state.saveJob(
      JobBundle(job: job, operations: operations),
    );
    if (!mounted) return;

    if (ok) {
      Navigator.of(context).pop(true);
      return;
    }

    setState(() {
      _saving = false;
      _error = widget.state.error ?? 'Could not save the job.';
    });
  }

  Future<void> _delete() async {
    final id = widget.bundle?.job.id;
    if (id == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: TaktColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TaktRadius.normal),
          side: const BorderSide(color: TaktColors.line),
        ),
        title: Text(
          'Delete ${widget.bundle!.job.code}?',
          style: TaktType.title,
        ),
        content: Text(
          'The job and its routing are removed. Past schedule runs are kept.',
          style: TaktType.body.copyWith(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(
              'Cancel',
              style: TaktType.mono.copyWith(color: TaktColors.muted),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(
              'Delete',
              style: TaktType.mono.copyWith(color: TaktColors.oxide),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;
    setState(() => _saving = true);
    final ok = await widget.state.deleteJob(id);
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        _saving = false;
        _error = widget.state.error ?? 'Could not delete the job.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.bundle != null;
    final noCenters = widget.state.workCenters.isEmpty;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 780,
          maxHeight: MediaQuery.sizeOf(context).height * 0.9,
        ),
        child: TaktPanel(
          padding: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 18, 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SectionLabel(editing ? 'Edit job' : 'New job'),
                          const SizedBox(height: 7),
                          Text(
                            editing
                                ? '${widget.bundle!.job.code} · ${widget.bundle!.job.title}'
                                : 'Add work to the floor.',
                            style: TaktType.headline.copyWith(fontSize: 21),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(false),
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
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (noCenters) ...[
                        const TaktBanner(
                          message:
                              'Add a work center before creating a job. '
                              'Every routing step needs a real machine group.',
                          tone: Tone.amber,
                        ),
                        const SizedBox(height: 16),
                      ],
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const FieldLabel('Reference'),
                                TextField(
                                  controller: _code,
                                  style: TaktType.mono.copyWith(
                                    fontSize: 13,
                                    color: TaktColors.ink,
                                  ),
                                  decoration: taktInput(hint: 'J-1055'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const FieldLabel('Quantity'),
                                TextField(
                                  controller: _quantity,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  style: TaktType.mono.copyWith(
                                    fontSize: 13,
                                    color: TaktColors.ink,
                                  ),
                                  decoration: taktInput(hint: '1'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const FieldLabel('Title'),
                      TextField(
                        controller: _title,
                        style: inputStyle,
                        decoration: taktInput(hint: 'e.g. Hydraulic manifold'),
                      ),
                      const SizedBox(height: 14),
                      const FieldLabel('Customer'),
                      TextField(
                        controller: _customer,
                        style: inputStyle,
                        decoration: taktInput(hint: 'Optional'),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const FieldLabel('Promised delivery'),
                                _dateButton(
                                  date: _due,
                                  onTap: () => _pickDate(due: true),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const FieldLabel('Material release'),
                                _dateButton(
                                  date: _release,
                                  onTap: () => _pickDate(due: false),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const FieldLabel('Priority'),
                      Row(
                        children: [
                          _priorityButton(1, 'Standard'),
                          const SizedBox(width: 8),
                          _priorityButton(2, 'High'),
                          const SizedBox(width: 8),
                          _priorityButton(3, 'Critical'),
                        ],
                      ),
                      const SizedBox(height: 22),
                      Row(
                        children: [
                          const SectionLabel('Routing'),
                          const Spacer(),
                          Text(
                            '${_steps.length} steps',
                            style: TaktType.small.copyWith(fontSize: 11),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Column(
                        children: [
                          for (
                            var index = 0;
                            index < _steps.length;
                            index++
                          ) ...[
                            if (index > 0) const SizedBox(height: 10),
                            _stepCard(index),
                          ],
                        ],
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TaktButton(
                          label: 'Add routing step',
                          tone: ButtonTone.secondary,
                          icon: Icons.add,
                          onPressed: noCenters
                              ? null
                              : () => setState(() {
                                  _steps.add(
                                    _StepDraft(
                                      workCenterId:
                                          widget.state.workCenters.first.id,
                                    ),
                                  );
                                }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_error != null) ...[
                      TaktBanner(message: _error!, tone: Tone.oxide),
                      const SizedBox(height: 10),
                    ],
                    Row(
                      children: [
                        if (editing)
                          TaktButton(
                            label: 'Delete',
                            tone: ButtonTone.danger,
                            onPressed: _saving ? null : _delete,
                          ),
                        const Spacer(),
                        TaktButton(
                          label: 'Cancel',
                          tone: ButtonTone.ghost,
                          onPressed: _saving
                              ? null
                              : () => Navigator.of(context).pop(false),
                        ),
                        const SizedBox(width: 8),
                        TaktButton(
                          label: editing ? 'Save changes' : 'Create job',
                          busy: _saving,
                          onPressed: _saving ? null : _save,
                        ),
                      ],
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

  Widget _dateButton({required DateTime date, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TaktRadius.tight),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: TaktColors.surface,
          border: Border.all(color: TaktColors.line),
          borderRadius: BorderRadius.circular(TaktRadius.tight),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              size: 13,
              color: TaktColors.muted,
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                formatDateLong(date),
                style: TaktType.mono.copyWith(
                  fontSize: 11.5,
                  color: TaktColors.ink,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              formatClock(date),
              style: TaktType.mono.copyWith(
                fontSize: 10.5,
                color: TaktColors.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _priorityButton(int value, String label) {
    final active = _priority == value;
    return InkWell(
      onTap: () => setState(() => _priority = value),
      borderRadius: BorderRadius.circular(TaktRadius.tight),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
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
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            color: active ? TaktColors.surface : TaktColors.inkSoft,
          ),
        ),
      ),
    );
  }

  Widget _stepCard(int index) {
    final step = _steps[index];
    final centers = widget.state.workCenters;
    final validSelection = centers.any(
      (center) => center.id == step.workCenterId,
    );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: TaktColors.line),
        borderRadius: BorderRadius.circular(TaktRadius.normal),
        color: TaktColors.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              SizedBox(
                width: 26,
                child: Text(
                  ((index + 1) * 10).toString(),
                  style: TaktType.mono.copyWith(
                    fontSize: 10,
                    color: TaktColors.faint,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: TaktColors.line),
                    borderRadius: BorderRadius.circular(TaktRadius.tight),
                    color: TaktColors.paper,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      isExpanded: true,
                      value: validSelection ? step.workCenterId : null,
                      hint: Text('Work center', style: TaktType.small),
                      style: TaktType.body.copyWith(
                        fontSize: 13,
                        color: TaktColors.ink,
                      ),
                      icon: const Icon(
                        Icons.expand_more,
                        size: 16,
                        color: TaktColors.muted,
                      ),
                      items: [
                        for (final center in centers)
                          DropdownMenuItem<int>(
                            value: center.id,
                            child: Text(
                              '${center.code} · ${center.name}',
                              overflow: TextOverflow.ellipsis,
                              style: TaktType.body.copyWith(fontSize: 13),
                            ),
                          ),
                      ],
                      onChanged: centers.isEmpty
                          ? null
                          : (value) => setState(
                              () => step.workCenterId = value,
                            ),
                    ),
                  ),
                ),
              ),
              if (_steps.length > 1)
                IconButton(
                  onPressed: () => setState(() {
                    final removed = _steps.removeAt(index);
                    removed.dispose();
                  }),
                  icon: const Icon(Icons.remove_circle_outline, size: 16),
                  color: TaktColors.muted,
                  tooltip: 'Remove step',
                  visualDensity: VisualDensity.compact,
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _numberField(
                  controller: step.setup,
                  label: 'Setup',
                  suffix: 'min',
                  integer: true,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _numberField(
                  controller: step.run,
                  label: 'Run / unit',
                  suffix: 'min',
                  integer: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: step.description,
            style: TaktType.body.copyWith(fontSize: 13),
            decoration: taktInput(hint: 'What happens at this step'),
          ),
        ],
      ),
    );
  }

  Widget _numberField({
    required TextEditingController controller,
    required String label,
    required String suffix,
    required bool integer,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: !integer),
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          integer ? RegExp(r'[0-9]') : RegExp(r'[0-9.]'),
        ),
      ],
      style: TaktType.mono.copyWith(fontSize: 12.5, color: TaktColors.ink),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TaktType.label.copyWith(fontSize: 9.5),
        suffixText: suffix,
        suffixStyle: TaktType.mono.copyWith(
          fontSize: 10,
          color: TaktColors.faint,
        ),
        isDense: true,
        filled: true,
        fillColor: TaktColors.paper,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 11,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(TaktRadius.tight)),
          borderSide: BorderSide(color: TaktColors.line),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(TaktRadius.tight)),
          borderSide: BorderSide(color: TaktColors.line),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(TaktRadius.tight)),
          borderSide: BorderSide(color: TaktColors.ink),
        ),
      ),
    );
  }
}

class _StepDraft {
  _StepDraft({
    this.workCenterId,
    int setup = 0,
    double run = 1,
    String description = '',
  }) : setup = TextEditingController(text: setup.toString()),
       run = TextEditingController(text: _trim(run)),
       description = TextEditingController(text: description);

  int? workCenterId;
  final TextEditingController setup;
  final TextEditingController run;
  final TextEditingController description;

  static String _trim(double value) {
    if (value == value.roundToDouble()) return value.round().toString();
    return value.toString();
  }

  void dispose() {
    setup.dispose();
    run.dispose();
    description.dispose();
  }
}
