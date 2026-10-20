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
                      action: state.canWrite
                          ? TaktButton(
                              label: 'Rename',
                              tone: ButtonTone.ghost,
                              onPressed: () => _rename(context),
                            )
                          : null,
                    ),
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        children: [
                          _kv(
                            state.isOwner ? 'Full-access key' : 'Scoped key',
                            KeyChip(value: state.accessKey),
                          ),
                          _kv(
                            'Your role',
                            StatusChip(
                              label: state.roleName,
                              tone: _roleTone(state.role),
                              filled: true,
                            ),
                          ),
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
                      color: state.isOwner
                          ? TaktColors.amberWash
                          : TaktColors.rail,
                      child: Text(
                        state.isOwner
                            ? 'This is the full-access key. It bypasses roles, '
                                  'so do not use it as a viewer link. Share '
                                  'scoped keys from People. Never post it '
                                  'publicly.'
                            : state.isViewer
                            ? 'This is a scoped, view-only key. The server '
                                  'rejects writes even if the interface is '
                                  'bypassed. Do not post it publicly.'
                            : 'This is a scoped key. The server enforces its '
                                  'role on every write. Do not post it '
                                  'publicly.',
                        style: TaktType.small.copyWith(fontSize: 11.5),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              _PeoplePanel(state: state),
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
                      action: state.canWrite
                          ? TaktButton(
                              label: 'Add',
                              icon: Icons.add,
                              tone: ButtonTone.secondary,
                              onPressed: () => _editCenter(context),
                            )
                          : null,
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
                            if (state.canWrite) ...[
                              const SizedBox(width: 12),
                              TaktButton(
                                label: 'Add work center',
                                tone: ButtonTone.secondary,
                                onPressed: () => _editCenter(context),
                              ),
                            ],
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
                        _centerRow(context, state, state.workCenters[index]),
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
                          if (state.canWrite) ...[
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
                      label: 'Account',
                      title: state.user?.displayName ?? 'Guest access',
                    ),
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _kv(
                            'Signed in as',
                            Text(
                              state.user?.email ??
                                  'No account — using a workspace key',
                              style: TaktType.mono.copyWith(fontSize: 11.5),
                            ),
                          ),
                          _kv(
                            'Role here',
                            StatusChip(
                              label: state.roleName,
                              tone: _roleTone(state.role),
                              filled: true,
                            ),
                          ),
                          if (state.isSignedIn)
                            _kv(
                              'Session',
                              Text(
                                'Revocable · 30-day token',
                                style: TaktType.mono.copyWith(fontSize: 11.5),
                              ),
                            ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              if (state.isSignedIn)
                                TaktButton(
                                  label: 'Change password',
                                  tone: ButtonTone.secondary,
                                  onPressed: () => _changePassword(context),
                                ),
                              const Spacer(),
                              TaktButton(
                                label: state.isSignedIn
                                    ? 'Sign out'
                                    : 'Forget key',
                                tone: ButtonTone.danger,
                                onPressed: state.signOut,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            state.isSignedIn
                                ? 'Signing out revokes this session and forgets '
                                      'the active key on this device. The '
                                      'workspace and its schedule stay on the '
                                      'server.'
                                : 'This device remembers the key so it can '
                                      'reopen the shop. Sign in to own '
                                      'workspaces and manage people.',
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

  Widget _centerRow(
    BuildContext context,
    AppState state,
    WorkCenter center,
  ) {
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
          if (state.canWrite) ...[
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

  Future<void> _changePassword(BuildContext context) async {
    await showDialog<bool>(
      context: context,
      barrierColor: TaktColors.ink.withValues(alpha: 0.3),
      builder: (_) => _PasswordDialog(state: state),
    );
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

class _PeoplePanel extends StatefulWidget {
  const _PeoplePanel({required this.state});

  final AppState state;

  @override
  State<_PeoplePanel> createState() => _PeoplePanelState();
}

class _PeoplePanelState extends State<_PeoplePanel> {
  @override
  void initState() {
    super.initState();
    if (widget.state.isAccountWorkspace && widget.state.members.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.state.loadMembers();
      });
    }
  }

  Future<void> _invite() async {
    final invited = await showDialog<MemberInfo>(
      context: context,
      barrierColor: TaktColors.ink.withValues(alpha: 0.3),
      builder: (_) => _InviteDialog(state: widget.state),
    );
    if (invited == null || !mounted) return;
    await showDialog<void>(
      context: context,
      barrierColor: TaktColors.ink.withValues(alpha: 0.3),
      builder: (_) => _InviteKeyDialog(member: invited),
    );
  }

  Future<void> _remove(MemberInfo member) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: TaktColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TaktRadius.normal),
          side: const BorderSide(color: TaktColors.line),
        ),
        title: Text('Remove access?', style: TaktType.title),
        content: Text(
          '${member.displayName} will immediately lose access to this '
          'workspace. Their workspace key stops working.',
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
              'Remove',
              style: TaktType.mono.copyWith(color: TaktColors.oxide),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await widget.state.removeMember(member.userId);
  }

  Future<void> _copyKey(MemberInfo member) async {
    await Clipboard.setData(ClipboardData(text: member.accessKey));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${member.displayName}\'s scoped key copied',
          style: TaktType.mono.copyWith(fontSize: 12),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: TaktColors.graphite,
        width: 320,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final owner = state.canManageTeam;

    return TaktPanel(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 14, 14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionLabel('People'),
                      const SizedBox(height: 6),
                      Text(
                        state.isAccountWorkspace
                            ? state.members.isEmpty
                                  ? 'No one else has access'
                                  : '${state.members.length} with access'
                            : 'Accounts and roles',
                        style: TaktType.title.copyWith(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                if (owner)
                  TaktButton(
                    label: 'Add person',
                    icon: Icons.person_add_alt_1_outlined,
                    tone: ButtonTone.secondary,
                    onPressed: _invite,
                  ),
              ],
            ),
          ),
          const Divider(height: 1),
          if (!state.isSignedIn)
            Padding(
              padding: const EdgeInsets.all(18),
              child: Text(
                'You are using a workspace key without an account. Sign in '
                'as the owner to invite people and assign editor or viewer '
                'roles.',
                style: TaktType.body.copyWith(fontSize: 13, height: 1.5),
              ),
            )
          else if (!state.isAccountWorkspace)
            Padding(
              padding: const EdgeInsets.all(18),
              child: Text(
                'This shop is open through a shared key, not your account '
                'workspace list. Open it from the picker or claim the owner '
                'key to see and manage people.',
                style: TaktType.body.copyWith(fontSize: 13, height: 1.5),
              ),
            )
          else if (state.membersLoading && state.members.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 1.5),
                ),
              ),
            )
          else if (state.members.isEmpty)
            Padding(
              padding: const EdgeInsets.all(18),
              child: Text(
                'No members found. Invite an existing Takt account as an '
                'editor or viewer.',
                style: TaktType.body.copyWith(fontSize: 13),
              ),
            )
          else
            for (var index = 0; index < state.members.length; index++) ...[
              if (index > 0) const Divider(height: 1),
              _memberRow(state, owner, state.members[index]),
            ],
          if (state.isAccountWorkspace && !owner)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(18, 11, 18, 11),
              color: TaktColors.rail,
              child: Text(
                'Only the workspace owner can invite people or change roles. '
                'Scoped keys are hidden from non-owners.',
                style: TaktType.small.copyWith(fontSize: 11),
              ),
            ),
        ],
      ),
    );
  }

  Widget _memberRow(AppState state, bool owner, MemberInfo member) {
    final canManage = owner && member.role != 'owner';
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 11, 8, 11),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: TaktColors.paper,
              border: Border.all(color: TaktColors.line),
              borderRadius: BorderRadius.circular(TaktRadius.tight),
            ),
            child: Text(
              _initials(member.displayName),
              style: TaktType.mono.copyWith(
                fontSize: 9,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        member.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TaktType.bodyStrong.copyWith(fontSize: 13),
                      ),
                    ),
                    if (member.role == 'owner') ...[
                      const SizedBox(width: 6),
                      Text(
                        'you',
                        style: TaktType.label.copyWith(
                          fontSize: 8,
                          color: TaktColors.faint,
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  member.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TaktType.small.copyWith(fontSize: 10.5),
                ),
              ],
            ),
          ),
          StatusChip(
            label: _roleLabel(member.role),
            tone: _roleTone(member.role),
            filled: true,
          ),
          if (canManage && member.accessKey.isNotEmpty)
            IconButton(
              onPressed: () => _copyKey(member),
              icon: const Icon(Icons.key_outlined, size: 15),
              color: TaktColors.muted,
              tooltip: 'Copy ${member.displayName}\'s scoped key',
              visualDensity: VisualDensity.compact,
            ),
          if (canManage)
            PopupMenuButton<String>(
              tooltip: 'Manage ${member.displayName}',
              onSelected: (value) async {
                if (value == 'remove') {
                  await _remove(member);
                } else {
                  await state.setMemberRole(member.userId, value);
                }
              },
              itemBuilder: (context) => [
                if (member.role == 'viewer')
                  const PopupMenuItem(
                    value: 'editor',
                    child: Text('Make editor'),
                  )
                else
                  const PopupMenuItem(
                    value: 'viewer',
                    child: Text('Make viewer'),
                  ),
                const PopupMenuDivider(),
                const PopupMenuItem(
                  value: 'remove',
                  child: Text('Remove access'),
                ),
              ],
              child: const Padding(
                padding: EdgeInsets.all(7),
                child: Icon(
                  Icons.more_vert,
                  size: 16,
                  color: TaktColors.muted,
                ),
              ),
            )
          else
            const SizedBox(width: 6),
        ],
      ),
    );
  }
}

class _InviteDialog extends StatefulWidget {
  const _InviteDialog({required this.state});

  final AppState state;

  @override
  State<_InviteDialog> createState() => _InviteDialogState();
}

class _InviteDialogState extends State<_InviteDialog> {
  final _email = TextEditingController();
  String _role = 'editor';
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _email.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      setState(() => _error = 'Enter the email on their Takt account.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final member = await widget.state.inviteMember(email, _role);
    if (!mounted) return;
    if (member == null) {
      setState(() {
        _busy = false;
        _error = widget.state.error ?? 'Could not add that person.';
      });
      return;
    }
    Navigator.of(context).pop(member);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: TaktColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TaktRadius.normal),
        side: const BorderSide(color: TaktColors.line),
      ),
      title: Text('Add a person', style: TaktType.title),
      content: SizedBox(
        width: 390,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'They need an existing Takt account. Takt creates a scoped '
                'key for this workspace so their role is enforced.',
                style: TaktType.small.copyWith(fontSize: 11.5, height: 1.45),
              ),
              const SizedBox(height: 16),
              if (_error != null) ...[
                TaktBanner(message: _error!, tone: Tone.oxide),
                const SizedBox(height: 12),
              ],
              const FieldLabel('Email'),
              TextField(
                controller: _email,
                autofocus: true,
                style: inputStyle,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.email],
                decoration: taktInput(hint: 'person@shop.com'),
                onSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 14),
              const FieldLabel('Role'),
              Row(
                children: [
                  _roleButton(
                    'editor',
                    'Editor',
                    'Can edit shops, jobs, and run the solver.',
                  ),
                  const SizedBox(width: 8),
                  _roleButton(
                    'viewer',
                    'Viewer',
                    'Can inspect every board and run what-if.',
                  ),
                ],
              ),
              const SizedBox(height: 9),
              Text(
                _role == 'editor'
                    ? 'Editors can change capacity and jobs. They cannot manage '
                          'people or see other members\' keys.'
                    : 'Viewers can read the plan and explore what-if. They '
                          'cannot save changes or run the solver.',
                style: TaktType.small.copyWith(fontSize: 10.5, height: 1.4),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _busy ? null : () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: TaktType.mono.copyWith(color: TaktColors.muted),
          ),
        ),
        TextButton(
          onPressed: _busy ? null : _submit,
          child: _busy
              ? const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 1.5),
                )
              : Text(
                  'Add person',
                  style: TaktType.mono.copyWith(color: TaktColors.ink),
                ),
        ),
      ],
    );
  }

  Widget _roleButton(String value, String label, String description) {
    final active = _role == value;
    return Expanded(
      child: InkWell(
        onTap: _busy ? null : () => setState(() => _role = value),
        borderRadius: BorderRadius.circular(TaktRadius.tight),
        child: Container(
          padding: const EdgeInsets.fromLTRB(11, 9, 11, 9),
          decoration: BoxDecoration(
            color: active ? TaktColors.tealWash : Colors.transparent,
            border: Border.all(
              color: active ? TaktColors.teal : TaktColors.line,
            ),
            borderRadius: BorderRadius.circular(TaktRadius.tight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TaktType.bodyStrong.copyWith(
                  fontSize: 12,
                  color: active ? TaktColors.teal : TaktColors.ink,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TaktType.small.copyWith(fontSize: 9.5, height: 1.35),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InviteKeyDialog extends StatelessWidget {
  const _InviteKeyDialog({required this.member});

  final MemberInfo member;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: TaktColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TaktRadius.normal),
        side: const BorderSide(color: TaktColors.line),
      ),
      title: Text('Access created', style: TaktType.title),
      content: SizedBox(
        width: 410,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${member.displayName} now has ${_roleLabel(member.role)} '
              'access. This scoped key opens the workspace directly and '
              'carries that role.',
              style: TaktType.body.copyWith(fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: 14),
            KeyChip(value: member.accessKey),
            const SizedBox(height: 10),
            Text(
              'The key is also in their workspace list after sign-in. Removing '
              'them revokes this key immediately.',
              style: TaktType.small.copyWith(fontSize: 10.5, height: 1.45),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Done',
            style: TaktType.mono.copyWith(color: TaktColors.ink),
          ),
        ),
      ],
    );
  }
}

class _PasswordDialog extends StatefulWidget {
  const _PasswordDialog({required this.state});

  final AppState state;

  @override
  State<_PasswordDialog> createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<_PasswordDialog> {
  final _current = TextEditingController();
  final _next = TextEditingController();
  final _confirm = TextEditingController();
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _current.dispose();
    _next.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_current.text.isEmpty) {
      setState(() => _error = 'Enter your current password.');
      return;
    }
    if (_next.text.length < 10) {
      setState(
        () => _error = 'Use at least 10 characters for the new password.',
      );
      return;
    }
    if (_next.text != _confirm.text) {
      setState(() => _error = 'Those new passwords do not match.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final ok = await widget.state.changePassword(_current.text, _next.text);
    if (!mounted) return;
    if (!ok) {
      setState(() {
        _busy = false;
        _error = widget.state.error ?? 'Could not change the password.';
      });
      return;
    }
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: TaktColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TaktRadius.normal),
        side: const BorderSide(color: TaktColors.line),
      ),
      title: Text('Change password', style: TaktType.title),
      content: SizedBox(
        width: 390,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_error != null) ...[
                TaktBanner(message: _error!, tone: Tone.oxide),
                const SizedBox(height: 12),
              ],
              const FieldLabel('Current password'),
              TextField(
                controller: _current,
                autofocus: true,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                style: TaktType.mono.copyWith(fontSize: 12.5),
                decoration: taktInput(hint: 'Current password'),
              ),
              const SizedBox(height: 12),
              const FieldLabel('New password'),
              TextField(
                controller: _next,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                style: TaktType.mono.copyWith(fontSize: 12.5),
                decoration: taktInput(hint: 'At least 10 characters'),
              ),
              const SizedBox(height: 12),
              const FieldLabel('Confirm new password'),
              TextField(
                controller: _confirm,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                style: TaktType.mono.copyWith(fontSize: 12.5),
                decoration: taktInput(hint: 'Repeat the new password'),
                onSubmitted: (_) => _save(),
              ),
              const SizedBox(height: 10),
              Text(
                'Changing the password revokes other sessions. Your current '
                'session stays signed in.',
                style: TaktType.small.copyWith(fontSize: 10.5, height: 1.45),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _busy ? null : () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: TaktType.mono.copyWith(color: TaktColors.muted),
          ),
        ),
        TextButton(
          onPressed: _busy ? null : _save,
          child: _busy
              ? const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 1.5),
                )
              : Text(
                  'Change password',
                  style: TaktType.mono.copyWith(color: TaktColors.ink),
                ),
        ),
      ],
    );
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

String _initials(String name) {
  final parts = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .take(2)
      .map((part) => part[0].toUpperCase())
      .join();
  return parts.isEmpty ? '?' : parts;
}
