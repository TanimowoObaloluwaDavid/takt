import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:takt_client/takt_client.dart';

import '../state/app_state.dart';
import '../theme/takt_theme.dart';
import '../widgets/common.dart';

class SetupView extends StatelessWidget {
  const SetupView({super.key, required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final shop = state.shop;
    if (shop == null) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 900;

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
              const SectionLabel('Setup'),
              const SizedBox(height: 8),
              Text(
                'The shop behind the schedule.',
                style: TaktType.headline.copyWith(fontSize: wide ? 26 : 21),
              ),
              const SizedBox(height: 6),
              Text(
                'Capacity is defined here. The solver never invents a machine.',
                style: TaktType.small,
              ),
              const SizedBox(height: 22),
              TaktPanel(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _panelHeader(
                      label: 'Workspace',
                      title: shop.name,
                      action: TaktButton(
                        label: 'Rename',
                        tone: ButtonTone.ghost,
                        onPressed: () => _rename(context),
                      ),
                    ),
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        children: [
                          _kv('Workspace key', KeyChip(value: shop.accessKey)),
                          _kv(
                            'Currency',
                            Text(shop.currency, style: TaktType.mono),
                          ),
                          _kv(
                            'Calendar',
                            Text(
                              'Continuous time · shifts not modeled',
                              style: TaktType.mono,
                            ),
                          ),
                          _kv(
                            'Created',
                            Text(
                              formatDateLong(shop.createdAt),
                              style: TaktType.mono,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
                      color: TaktColors.amberWash,
                      child: Text(
                        'The key is a bearer credential, not an account. Anyone '
                        'holding it can read and edit this workspace. Do not '
                        'post it publicly.',
                        style: TaktType.small.copyWith(fontSize: 11.5),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              TaktPanel(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _panelHeader(
                      label: 'Work centers',
                      title: state.hasWorkCenters
                          ? '${state.workCenters.length} groups · '
                                '${state.workCenters.fold<int>(0, (sum, center) => sum + center.machines)} machines'
                          : 'No capacity defined',
                      action: TaktButton(
                        label: 'Add',
                        icon: Icons.add,
                        tone: ButtonTone.secondary,
                        onPressed: () => _editCenter(context),
                      ),
                    ),
                    const Divider(height: 1),
                    if (state.workCenters.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(22),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'A work center is a group of identical parallel '
                                'machines that can perform the same operation.',
                                style: TaktType.body.copyWith(fontSize: 13),
                              ),
                            ),
                            const SizedBox(width: 12),
                            TaktButton(
                              label: 'Add work center',
                              tone: ButtonTone.secondary,
                              onPressed: () => _editCenter(context),
                            ),
                          ],
                        ),
                      )
                    else
                      for (
                        var index = 0;
                        index < state.workCenters.length;
                        index++
                      ) ...[
                        if (index > 0) const Divider(height: 1),
                        _centerRow(context, state.workCenters[index]),
                      ],
                  ],
                ),
              ),
              const SizedBox(height: 18),
              TaktPanel(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _panelHeader(
                      label: 'Sample data',
                      title: state.hasJobs
                          ? '${state.bundles.length} jobs in this workspace'
                          : state.hasWorkCenters
                          ? '${state.workCenters.length} work centers, no jobs'
                          : 'Start from a realistic shop',
                    ),
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.all(18),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              state.hasJobs || state.hasWorkCenters
                                  ? 'The sample loader only fills an empty '
                                        'workspace. Delete the existing jobs '
                                        'and work centers first if you want to '
                                        'reset.'
                                  : 'Fourteen jobs, seven work centers, and a '
                                        'deliberate single-machine constraint on '
                                        'CNC-02. Every row goes through the same '
                                        'solver as your own data.',
                              style: TaktType.body.copyWith(fontSize: 13),
                            ),
                          ),
                          const SizedBox(width: 14),
                          TaktButton(
                            label: state.hasJobs || state.hasWorkCenters
                                ? 'Load sample'
                                : 'Load sample shop',
                            tone: ButtonTone.secondary,
                            busy: state.loading,
                            onPressed: state.hasJobs || state.hasWorkCenters
                                ? null
                                : state.loadSample,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              TaktPanel(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _panelHeader(
                      label: 'Session',
                      title: 'This device',
                    ),
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.all(18),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Signing out forgets the key on this device. The '
                              'workspace and its runs stay on the server.',
                              style: TaktType.body.copyWith(fontSize: 13),
                            ),
                          ),
                          const SizedBox(width: 14),
                          TaktButton(
                            label: 'Sign out',
                            tone: ButtonTone.danger,
                            onPressed: state.signOut,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _panelHeader({
    required String label,
    required String title,
    Widget? action,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 14, 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionLabel(label),
                const SizedBox(height: 6),
                Text(title, style: TaktType.title.copyWith(fontSize: 16)),
              ],
            ),
          ),
          if (action != null) ...[
            const SizedBox(width: 10),
            action,
          ],
        ],
      ),
    );
  }

  Widget _kv(String label, Widget value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 150,
            child: Text(label.toUpperCase(), style: TaktType.label),
          ),
          Expanded(
            child: Align(alignment: Alignment.centerLeft, child: value),
          ),
        ],
      ),
    );
  }

  Widget _centerRow(BuildContext context, WorkCenter center) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 10, 12),
      child: Row(
        children: [
          SizedBox(
            width: 82,
            child: Text(
              center.code,
              style: TaktType.monoStrong.copyWith(fontSize: 11.5),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  center.name,
                  style: TaktType.bodyStrong.copyWith(fontSize: 13.5),
                ),
                if (center.notes.isNotEmpty)
                  Text(
                    center.notes,
                    style: TaktType.small.copyWith(fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 86,
            child: Text(
              '${center.machines} × machine',
              style: TaktType.mono.copyWith(fontSize: 10.5),
            ),
          ),
          SizedBox(
            width: 92,
            child: Text(
              '${center.changeoverMinutes}m change',
              style: TaktType.mono.copyWith(fontSize: 10.5),
            ),
          ),
          IconButton(
            onPressed: () => _editCenter(context, center: center),
            icon: const Icon(Icons.edit_outlined, size: 15),
            color: TaktColors.muted,
            tooltip: 'Edit ${center.code}',
            visualDensity: VisualDensity.compact,
          ),
          IconButton(
            onPressed: () => _deleteCenter(context, center),
            icon: const Icon(Icons.delete_outline, size: 15),
            color: TaktColors.faint,
            tooltip: 'Delete ${center.code}',
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }

  Future<void> _rename(BuildContext context) async {
    final controller = TextEditingController(text: state.shop?.name ?? '');
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: TaktColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TaktRadius.normal),
          side: const BorderSide(color: TaktColors.line),
        ),
        title: Text('Rename workspace', style: TaktType.title),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: inputStyle,
          decoration: taktInput(hint: 'Shop name'),
          onSubmitted: (value) => Navigator.of(dialogContext).pop(value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              'Cancel',
              style: TaktType.mono.copyWith(color: TaktColors.muted),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(controller.text),
            child: Text(
              'Save',
              style: TaktType.mono.copyWith(color: TaktColors.ink),
            ),
          ),
        ],
      ),
    );
    controller.dispose();
    if (result == null || result.trim().isEmpty) return;
    await state.renameWorkspace(result);
  }

  Future<void> _editCenter(
    BuildContext context, {
    WorkCenter? center,
  }) async {
    await showDialog<void>(
      context: context,
      barrierColor: TaktColors.ink.withValues(alpha: 0.3),
      builder: (_) => _WorkCenterDialog(state: state, center: center),
    );
  }

  Future<void> _deleteCenter(BuildContext context, WorkCenter center) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: TaktColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TaktRadius.normal),
          side: const BorderSide(color: TaktColors.line),
        ),
        title: Text('Delete ${center.code}?', style: TaktType.title),
        content: Text(
          'The work center is removed only if no routing step uses it.',
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

    if (confirmed != true) return;
    await state.deleteWorkCenter(center.id!);
  }
}

class _WorkCenterDialog extends StatefulWidget {
  const _WorkCenterDialog({required this.state, this.center});

  final AppState state;
  final WorkCenter? center;

  @override
  State<_WorkCenterDialog> createState() => _WorkCenterDialogState();
}

class _WorkCenterDialogState extends State<_WorkCenterDialog> {
  late final TextEditingController _name;
  late final TextEditingController _code;
  late final TextEditingController _machines;
  late final TextEditingController _changeover;
  late final TextEditingController _notes;

  String? _error;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final center = widget.center;
    _name = TextEditingController(text: center?.name ?? '');
    _code = TextEditingController(text: center?.code ?? '');
    _machines = TextEditingController(text: (center?.machines ?? 1).toString());
    _changeover = TextEditingController(
      text: (center?.changeoverMinutes ?? 0).toString(),
    );
    _notes = TextEditingController(text: center?.notes ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _code.dispose();
    _machines.dispose();
    _changeover.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Give the work center a name.');
      return;
    }
    final machines = int.tryParse(_machines.text.trim()) ?? 0;
    if (machines < 1) {
      setState(() => _error = 'At least one machine is required.');
      return;
    }

    final center = WorkCenter(
      id: widget.center?.id,
      shopId: widget.state.shop!.id!,
      name: name,
      code: _code.text.trim(),
      machines: machines,
      changeoverMinutes: int.tryParse(_changeover.text.trim()) ?? 0,
      notes: _notes.text.trim(),
    );

    setState(() => _saving = true);
    final ok = await widget.state.saveWorkCenter(center);
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop();
    } else {
      setState(() {
        _saving = false;
        _error = widget.state.error ?? 'Could not save the work center.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.center != null;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(18),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: TaktPanel(
          padding: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 18, 16, 14),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SectionLabel(
                            editing ? 'Edit work center' : 'New work center',
                          ),
                          const SizedBox(height: 6),
                          Text(
                            editing ? widget.center!.code : 'Add capacity',
                            style: TaktType.headline.copyWith(fontSize: 20),
                          ),
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
              Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_error != null) ...[
                      TaktBanner(message: _error!, tone: Tone.oxide),
                      const SizedBox(height: 14),
                    ],
                    const FieldLabel('Name'),
                    TextField(
                      controller: _name,
                      style: inputStyle,
                      decoration: taktInput(hint: 'e.g. CNC Mill 1'),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const FieldLabel('Code'),
                              TextField(
                                controller: _code,
                                style: TaktType.mono.copyWith(
                                  fontSize: 13,
                                  color: TaktColors.ink,
                                ),
                                decoration: taktInput(hint: 'CNC-01'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const FieldLabel('Machines'),
                              TextField(
                                controller: _machines,
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
                    const FieldLabel('Changeover (minutes)'),
                    TextField(
                      controller: _changeover,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: TaktType.mono.copyWith(
                        fontSize: 13,
                        color: TaktColors.ink,
                      ),
                      decoration: taktInput(hint: '0'),
                    ),
                    const SizedBox(height: 14),
                    const FieldLabel('Notes'),
                    TextField(
                      controller: _notes,
                      style: inputStyle,
                      decoration: taktInput(hint: 'Optional capability note'),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Changeover is charged whenever a machine switches to a '
                      'different job.',
                      style: TaktType.small.copyWith(fontSize: 11),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
                child: Row(
                  children: [
                    const Spacer(),
                    TaktButton(
                      label: 'Cancel',
                      tone: ButtonTone.ghost,
                      onPressed: _saving
                          ? null
                          : () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 8),
                    TaktButton(
                      label: editing ? 'Save changes' : 'Add work center',
                      busy: _saving,
                      onPressed: _saving ? null : _save,
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
}
