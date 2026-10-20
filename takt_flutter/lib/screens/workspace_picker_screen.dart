import 'package:flutter/material.dart';
import 'package:takt_client/takt_client.dart';

import '../state/app_state.dart';
import '../theme/takt_theme.dart';
import '../widgets/common.dart';

/// Shown to a signed-in person who has left a workspace or has no workspace
/// yet. It is also where a legacy full-access key is claimed into the account.
class WorkspacePickerScreen extends StatefulWidget {
  const WorkspacePickerScreen({super.key, required this.state});

  final AppState state;

  @override
  State<WorkspacePickerScreen> createState() => _WorkspacePickerScreenState();
}

class _WorkspacePickerScreenState extends State<WorkspacePickerScreen> {
  final _name = TextEditingController();
  final _key = TextEditingController();
  String _currency = 'USD';
  bool _withSample = true;
  String? _localError;

  @override
  void dispose() {
    _name.dispose();
    _key.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    FocusScope.of(context).unfocus();
    setState(() => _localError = null);
    if (_name.text.trim().isEmpty) {
      setState(() => _localError = 'Give the workspace a name.');
      return;
    }
    await widget.state.createWorkspace(
      _name.text,
      _currency,
      withSample: _withSample,
    );
  }

  Future<void> _claim() async {
    FocusScope.of(context).unfocus();
    setState(() => _localError = null);
    if (_key.text.trim().isEmpty) {
      setState(() => _localError = 'Paste the full-access workspace key.');
      return;
    }
    await widget.state.claimWorkspace(_key.text);
  }

  Future<void> _openShared() async {
    FocusScope.of(context).unfocus();
    setState(() => _localError = null);
    if (_key.text.trim().isEmpty) {
      setState(() => _localError = 'Paste a workspace key.');
      return;
    }
    await widget.state.openWorkspace(_key.text);
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final user = state.user;
    final banner = _localError ?? state.error ?? state.notice;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 940;
            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                wide ? 46 : 20,
                wide ? 28 : 18,
                wide ? 46 : 20,
                46,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _header(state, user, wide),
                      SizedBox(height: wide ? 40 : 28),
                      if (banner != null) ...[
                        TaktBanner(
                          message: banner,
                          tone: state.error != null || _localError != null
                              ? Tone.oxide
                              : Tone.teal,
                          onDismiss: _localError != null
                              ? () => setState(() => _localError = null)
                              : state.clearMessages,
                        ),
                        const SizedBox(height: 18),
                      ],
                      if (wide)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 6, child: _left(state)),
                            const SizedBox(width: 22),
                            Expanded(flex: 5, child: _createPanel(state)),
                          ],
                        )
                      else ...[
                        _left(state),
                        const SizedBox(height: 18),
                        _createPanel(state),
                      ],
                      const SizedBox(height: 28),
                      Row(
                        children: [
                          const Icon(
                            Icons.lock_outline,
                            size: 12,
                            color: TaktColors.faint,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Workspaces are isolated. The key you choose here '
                              'is the only door into its shop.',
                              style: TaktType.small.copyWith(fontSize: 10.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _header(AppState state, AuthUser? user, bool wide) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Wordmark(size: 28),
            const Spacer(),
            if (user != null) _accountChip(state, user, wide),
          ],
        ),
        SizedBox(height: wide ? 42 : 28),
        const SectionLabel('Workspaces'),
        const SizedBox(height: 8),
        Text(
          user == null ? 'Choose a workspace.' : 'Where are you working?',
          style: TaktType.headline.copyWith(fontSize: wide ? 30 : 24),
        ),
        const SizedBox(height: 6),
        Text(
          user == null
              ? 'Open a shop to start scheduling.'
              : 'Signed in as ${user.displayName}. Open an existing shop or '
                    'start a new one.',
          style: TaktType.small,
        ),
      ],
    );
  }

  Widget _accountChip(AppState state, AuthUser user, bool wide) {
    final initials = user.displayName
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0].toUpperCase())
        .join();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 27,
          height: 27,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: TaktColors.ink,
            borderRadius: BorderRadius.circular(TaktRadius.tight),
          ),
          child: Text(
            initials.isEmpty ? '?' : initials,
            style: TaktType.mono.copyWith(
              fontSize: 9,
              color: TaktColors.surface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (wide) ...[
          const SizedBox(width: 9),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.displayName,
                style: TaktType.bodyStrong.copyWith(fontSize: 12),
              ),
              Text(
                user.email,
                style: TaktType.small.copyWith(fontSize: 10),
              ),
            ],
          ),
        ],
        const SizedBox(width: 8),
        IconButton(
          onPressed: state.signOut,
          icon: const Icon(Icons.logout, size: 16),
          color: TaktColors.muted,
          tooltip: 'Sign out',
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }

  Widget _left(AppState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TaktPanel(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _panelHeader(
                label: 'Your workspaces',
                title: state.workspaces.isEmpty
                    ? 'No workspaces yet'
                    : '${state.workspaces.length} available',
              ),
              const Divider(height: 1),
              if (state.workspaces.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Create a workspace on the right, or claim an existing '
                    'full-access key below.',
                    style: TaktType.body.copyWith(fontSize: 13),
                  ),
                )
              else
                for (
                  var index = 0;
                  index < state.workspaces.length;
                  index++
                ) ...[
                  if (index > 0) const Divider(height: 1),
                  _workspaceRow(state, state.workspaces[index]),
                ],
            ],
          ),
        ),
        const SizedBox(height: 18),
        TaktPanel(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _panelHeader(
                label: 'Join with a key',
                title: 'Claim or open an existing shop',
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const FieldLabel('Workspace key'),
                    TextField(
                      controller: _key,
                      style: TaktType.mono.copyWith(fontSize: 12.5),
                      decoration: taktInput(
                        hint: 'XXXXX-XXXXX-XXXXX-XXXXX',
                      ),
                      onSubmitted: (_) => _claim(),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TaktButton(
                            label: 'Claim full-access key',
                            tone: ButtonTone.secondary,
                            busy: state.loading,
                            onPressed: state.loading ? null : _claim,
                          ),
                        ),
                        const SizedBox(width: 8),
                        TaktButton(
                          label: 'Open shared',
                          tone: ButtonTone.ghost,
                          onPressed: state.loading ? null : _openShared,
                        ),
                      ],
                    ),
                    const SizedBox(height: 9),
                    Text(
                      'Claim adds the workspace to your account as its owner. '
                      'Open shared uses a viewer or editor key once, without '
                      'adding it to your list.',
                      style: TaktType.small.copyWith(
                        fontSize: 11,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _workspaceRow(AppState state, WorkspaceAccess workspace) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 13, 12, 13),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: TaktColors.paper,
              border: Border.all(color: TaktColors.line),
              borderRadius: BorderRadius.circular(TaktRadius.tight),
            ),
            child: Text(
              workspace.name.trim().isEmpty
                  ? '?'
                  : workspace.name.trim()[0].toUpperCase(),
              style: TaktType.title.copyWith(fontSize: 14),
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workspace.name,
                  style: TaktType.bodyStrong.copyWith(fontSize: 13.5),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${workspace.currency}  ·  ${_roleLabel(workspace.role)}',
                  style: TaktType.small.copyWith(fontSize: 10.5),
                ),
              ],
            ),
          ),
          StatusChip(
            label: _roleLabel(workspace.role),
            tone: _roleTone(workspace.role),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: state.loading
                ? null
                : () => state.switchWorkspace(workspace.shopId),
            icon: const Icon(Icons.arrow_forward, size: 15),
            color: TaktColors.ink,
            tooltip: 'Open ${workspace.name}',
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }

  Widget _createPanel(AppState state) {
    return TaktPanel(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _panelHeader(
            label: 'New workspace',
            title: 'Start a clean shop',
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const FieldLabel('Workspace name'),
                TextField(
                  controller: _name,
                  style: inputStyle,
                  textInputAction: TextInputAction.next,
                  decoration: taktInput(hint: 'e.g. Calder Precision'),
                ),
                const SizedBox(height: 14),
                const FieldLabel('Currency'),
                Row(
                  children: [
                    for (final code in const ['USD', 'GBP', 'EUR']) ...[
                      _currencyButton(code),
                      const SizedBox(width: 8),
                    ],
                  ],
                ),
                const SizedBox(height: 14),
                InkWell(
                  onTap: () => setState(() => _withSample = !_withSample),
                  borderRadius: BorderRadius.circular(TaktRadius.tight),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: Checkbox(
                          value: _withSample,
                          onChanged: (value) =>
                              setState(() => _withSample = value ?? true),
                          side: const BorderSide(color: TaktColors.lineStrong),
                          activeColor: TaktColors.ink,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Text(
                          'Load a realistic sample shop',
                          style: TaktType.body.copyWith(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                TaktButton(
                  label: 'Create workspace',
                  onPressed: state.loading ? null : _create,
                  busy: state.loading,
                  expand: true,
                ),
                const SizedBox(height: 10),
                Text(
                  'You will be the owner. Invite editors and viewers from '
                  'Setup once the shop exists.',
                  style: TaktType.small.copyWith(fontSize: 10.5, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _panelHeader({
    required String label,
    required String title,
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 12, 13),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionLabel(label),
                const SizedBox(height: 5),
                Text(title, style: TaktType.title.copyWith(fontSize: 15)),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }

  Widget _currencyButton(String code) {
    final active = _currency == code;
    return InkWell(
      onTap: () => setState(() => _currency = code),
      borderRadius: BorderRadius.circular(TaktRadius.tight),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: active ? TaktColors.ink : Colors.transparent,
          border: Border.all(
            color: active ? TaktColors.ink : TaktColors.line,
          ),
          borderRadius: BorderRadius.circular(TaktRadius.tight),
        ),
        child: Text(
          code,
          style: TaktType.mono.copyWith(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: active ? TaktColors.surface : TaktColors.inkSoft,
          ),
        ),
      ),
    );
  }
}

String _roleLabel(String role) => switch (role) {
  'owner' => 'Owner',
  'editor' => 'Editor',
  'viewer' => 'Viewer',
  _ => role,
};

Tone _roleTone(String role) => switch (role) {
  'owner' => Tone.teal,
  'editor' => Tone.neutral,
  'viewer' => Tone.amber,
  _ => Tone.neutral,
};
