import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../state/app_state.dart';
import '../theme/takt_theme.dart';
import '../widgets/common.dart';
import 'board_view.dart';
import 'jobs_view.dart';
import 'schedule_view.dart';
import 'setup_view.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.state});

  final AppState state;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  static const _destinations = [
    _Destination('Board', Icons.view_week_outlined),
    _Destination('Schedule', Icons.view_timeline_outlined),
    _Destination('Jobs', Icons.list_alt_outlined),
    _Destination('Setup', Icons.tune),
  ];

  @override
  Widget build(BuildContext context) {
    final state = widget.state;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 1000;
          final views = [
            BoardView(state: state, onNavigate: _go),
            ScheduleView(state: state),
            JobsView(state: state),
            SetupView(state: state),
          ];

          if (wide) {
            return Row(
              children: [
                _rail(state),
                Expanded(
                  child: Column(
                    children: [
                      _bannerArea(state, EdgeInsets.fromLTRB(24, 16, 24, 0)),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 1500),
                            child: SizedBox.expand(
                              child: IndexedStack(
                                index: _index,
                                children: views,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return Column(
            children: [
              _topBar(state),
              _bannerArea(state, const EdgeInsets.fromLTRB(14, 10, 14, 0)),
              Expanded(
                child: IndexedStack(index: _index, children: views),
              ),
              _bottomNav(),
            ],
          );
        },
      ),
    );
  }

  void _go(int index) {
    if (_index == index) return;
    setState(() => _index = index);
  }

  Widget _rail(AppState state) {
    return Container(
      width: 236,
      decoration: const BoxDecoration(
        color: TaktColors.rail,
        border: Border(right: BorderSide(color: TaktColors.line)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 24, 18, 0),
            child: const Wordmark(size: 26),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 26, 18, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionLabel('Workspace'),
                const SizedBox(height: 6),
                Text(
                  state.shop?.name ?? '',
                  style: TaktType.title.copyWith(fontSize: 15),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    StatusChip(
                      label: state.roleName,
                      tone: _shellRoleTone(state.role),
                      filled: true,
                    ),
                    if (state.isSignedIn) ...[
                      const SizedBox(width: 7),
                      Flexible(
                        child: Text(
                          state.user?.displayName ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TaktType.small.copyWith(fontSize: 10),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 10),
                _keyLine(state),
              ],
            ),
          ),
          const SizedBox(height: 26),
          for (var index = 0; index < _destinations.length; index++)
            _railItem(index),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 12, 18, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(height: 20),
                const SizedBox(height: 4),
                _accountBlock(state),
                const SizedBox(height: 18),
                Text(
                  'TAKT / 0.2',
                  style: TaktType.label.copyWith(
                    fontSize: 9,
                    color: TaktColors.faint,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Finite-capacity heuristic scheduler.',
                  style: TaktType.small.copyWith(fontSize: 10.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _keyLine(AppState state) {
    return InkWell(
      borderRadius: BorderRadius.circular(TaktRadius.tight),
      onTap: () => _copyKey(state),
      child: Tooltip(
        message: 'Copy ${state.isOwner ? 'full-access' : 'scoped'} key',
        child: Row(
          children: [
            const Icon(Icons.key_outlined, size: 12, color: TaktColors.faint),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                state.isOwner ? 'Full-access key' : '${state.roleName} key',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TaktType.mono.copyWith(
                  fontSize: 9.5,
                  color: TaktColors.muted,
                ),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.copy_rounded, size: 10, color: TaktColors.faint),
          ],
        ),
      ),
    );
  }

  Widget _railItem(int index) {
    final active = _index == index;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _go(index),
        hoverColor: TaktColors.surface.withValues(alpha: 0.5),
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: active ? TaktColors.ink : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          padding: const EdgeInsets.only(left: 20, right: 16),
          child: Row(
            children: [
              Icon(
                _destinations[index].icon,
                size: 15,
                color: active ? TaktColors.ink : TaktColors.muted,
              ),
              const SizedBox(width: 11),
              Text(
                _destinations[index].label,
                style: TaktType.body.copyWith(
                  fontSize: 13.5,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                  color: active ? TaktColors.ink : TaktColors.muted,
                ),
              ),
              const Spacer(),
              Text(
                '0${index + 1}',
                style: TaktType.mono.copyWith(
                  fontSize: 9,
                  color: active ? TaktColors.ink : TaktColors.faint,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topBar(AppState state) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 10, 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: TaktColors.line)),
      ),
      child: Row(
        children: [
          const Wordmark(size: 22),
          const SizedBox(width: 12),
          Container(width: 1, height: 18, color: TaktColors.line),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              state.shop?.name ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TaktType.body.copyWith(
                fontSize: 12.5,
                color: TaktColors.muted,
              ),
            ),
          ),
          _accountButton(state),
          IconButton(
            onPressed: () => _copyKey(state),
            icon: const Icon(Icons.key_outlined, size: 17),
            color: TaktColors.muted,
            tooltip: 'Copy ${state.isOwner ? 'full-access' : 'scoped'} key',
          ),
        ],
      ),
    );
  }

  Widget _bottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: TaktColors.surface,
        border: Border(top: BorderSide(color: TaktColors.line)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            for (var index = 0; index < _destinations.length; index++)
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _go(index),
                    child: SizedBox(
                      height: 56,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 18,
                            height: 2,
                            color: _index == index
                                ? TaktColors.ink
                                : Colors.transparent,
                          ),
                          const SizedBox(height: 7),
                          Icon(
                            _destinations[index].icon,
                            size: 17,
                            color: _index == index
                                ? TaktColors.ink
                                : TaktColors.muted,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            _destinations[index].label,
                            style: TaktType.mono.copyWith(
                              fontSize: 9,
                              fontWeight: _index == index
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: _index == index
                                  ? TaktColors.ink
                                  : TaktColors.muted,
                            ),
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
    );
  }

  Widget _accountBlock(AppState state) {
    final name = state.user?.displayName ?? 'Guest access';
    final detail = state.user?.email ?? 'Workspace key only';
    return Row(
      children: [
        Container(
          width: 26,
          height: 26,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: state.isSignedIn ? TaktColors.ink : TaktColors.paper,
            border: Border.all(
              color: state.isSignedIn ? TaktColors.ink : TaktColors.line,
            ),
            borderRadius: BorderRadius.circular(TaktRadius.tight),
          ),
          child: state.isSignedIn
              ? Text(
                  _initials(name),
                  style: TaktType.mono.copyWith(
                    fontSize: 8.5,
                    color: TaktColors.surface,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : const Icon(
                  Icons.person_outline,
                  size: 14,
                  color: TaktColors.muted,
                ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TaktType.bodyStrong.copyWith(fontSize: 11.5),
              ),
              Text(
                detail,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TaktType.small.copyWith(fontSize: 9.5),
              ),
            ],
          ),
        ),
        _accountButton(state),
      ],
    );
  }

  Widget _accountButton(AppState state) {
    return PopupMenuButton<String>(
      tooltip: 'Account',
      onSelected: (value) => _accountAction(state, value),
      position: PopupMenuPosition.under,
      itemBuilder: (context) => [
        if (state.isSignedIn)
          const PopupMenuItem(
            value: 'account',
            child: Text('Account & people'),
          ),
        if (state.isSignedIn)
          const PopupMenuItem(
            value: 'switch',
            child: Text('Switch workspace'),
          ),
        PopupMenuItem(
          value: 'auth',
          child: Text(
            state.isSignedIn ? 'Sign out' : 'Sign in or create account',
          ),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(
          Icons.more_horiz,
          size: 16,
          color: TaktColors.muted,
        ),
      ),
    );
  }

  Future<void> _accountAction(AppState state, String value) async {
    switch (value) {
      case 'account':
        _go(3);
      case 'switch':
        await state.leaveWorkspace();
      case 'auth':
        await state.signOut();
    }
  }

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

  Widget _bannerArea(AppState state, EdgeInsets padding) {
    final message = state.error ?? state.notice;
    final readOnly = !state.canWrite;
    if (!state.offline && !readOnly && message == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: padding,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (state.offline)
                TaktBanner(
                  message:
                      'No network connection. The last loaded plan is still '
                      'readable; reconnect to save or re-run.',
                  tone: Tone.amber,
                  action: TextButton(
                    onPressed: () {
                      state.retry();
                    },
                    child: Text(
                      'RETRY',
                      style: TaktType.mono.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: TaktColors.amber,
                      ),
                    ),
                  ),
                ),
              if (state.offline && (readOnly || message != null))
                const SizedBox(height: 8),
              if (readOnly)
                const TaktBanner(
                  message:
                      'View-only access. You can inspect every board and '
                      'schedule; edits and solves are disabled.',
                  tone: Tone.amber,
                ),
              if (readOnly && message != null) const SizedBox(height: 8),
              if (message != null)
                TaktBanner(
                  message: message,
                  tone: state.error != null ? Tone.oxide : Tone.teal,
                  onDismiss: state.clearMessages,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _copyKey(AppState state) async {
    await Clipboard.setData(ClipboardData(text: state.accessKey));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          state.isOwner ? 'Full-access key copied' : 'Scoped key copied',
          style: TaktType.mono.copyWith(fontSize: 12),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: TaktColors.graphite,
        width: 280,
      ),
    );
  }
}

Tone _shellRoleTone(String role) => switch (role) {
  'owner' => Tone.teal,
  'viewer' => Tone.amber,
  _ => Tone.neutral,
};

class _Destination {
  const _Destination(this.label, this.icon);

  final String label;
  final IconData icon;
}
