import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme/takt_theme.dart';
import '../widgets/common.dart';

/// The front door. Accounts own workspaces; a key can still open one without
/// an account, which keeps the demo path frictionless and makes the role model
/// visible: the key decides what you can write.
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, required this.state});

  final AppState state;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _key = TextEditingController();

  int _mode = 0;
  bool _showPassword = false;
  bool _guestOpen = false;
  String? _localError;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    _key.dispose();
    super.dispose();
  }

  Future<void> _submitAccount() async {
    FocusScope.of(context).unfocus();
    setState(() => _localError = null);

    final email = _email.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      setState(() => _localError = 'Enter the email you signed up with.');
      return;
    }
    if (_password.text.isEmpty) {
      setState(() => _localError = 'Enter your password.');
      return;
    }

    if (_mode == 0) {
      await widget.state.login(email, _password.text);
      return;
    }

    if (_name.text.trim().isEmpty) {
      setState(() => _localError = 'Tell us what to call you.');
      return;
    }
    if (_password.text.length < 10) {
      setState(
        () => _localError = 'Use at least 10 characters for your password.',
      );
      return;
    }
    if (_password.text != _confirm.text) {
      setState(() => _localError = 'Those passwords do not match.');
      return;
    }
    await widget.state.register(_name.text, email, _password.text);
  }

  Future<void> _openKey() async {
    FocusScope.of(context).unfocus();
    setState(() => _localError = null);
    if (_key.text.trim().isEmpty) {
      setState(() => _localError = 'Paste the workspace key.');
      return;
    }
    await widget.state.openWorkspace(_key.text);
  }

  void _setMode(int mode) {
    if (_mode == mode) return;
    widget.state.clearMessages();
    setState(() {
      _mode = mode;
      _guestOpen = false;
      _localError = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 980;
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: wide ? 64 : 22,
                vertical: wide ? 46 : 26,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1160),
                  child: wide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 6, child: _narrative(wide: true)),
                            const SizedBox(width: 76),
                            Expanded(flex: 5, child: _form(wide: true)),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _compactHeader(),
                            const SizedBox(height: 26),
                            _form(wide: false),
                            const SizedBox(height: 30),
                            _narrative(wide: false),
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

  Widget _compactHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Wordmark(size: 28),
        const SizedBox(height: 22),
        Text(
          'The schedule is a claim.\nTakt shows the evidence.',
          style: TaktType.display.copyWith(fontSize: 33, height: 1.04),
        ),
        const SizedBox(height: 12),
        Text(
          'Finite capacity, causal verdicts, and a real what-if — for shops '
          'that have outgrown a spreadsheet.',
          style: TaktType.body.copyWith(fontSize: 14, height: 1.5),
        ),
      ],
    );
  }

  Widget _narrative({required bool wide}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (wide)
          Row(
            children: [
              const Wordmark(size: 30),
              const Spacer(),
              StatusChip(label: 'Flutterbytes × Serverpod', tone: Tone.neutral),
            ],
          ),
        if (wide) SizedBox(height: wide ? 58 : 30),
        if (wide) ...[
          Text(
            'The schedule is a claim.\nTakt shows the evidence.',
            style: TaktType.display.copyWith(
              fontSize: 46,
              height: 1.03,
            ),
          ),
          const SizedBox(height: 20),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 470),
            child: Text(
              'Finite capacity, real changeovers, and a diagnosis that names '
              'the queue behind every late job. Takt does not just tell you '
              'what is late; it tells you why.',
              style: TaktType.body.copyWith(fontSize: 15, height: 1.55),
            ),
          ),
          SizedBox(height: wide ? 40 : 26),
          _principle(
            '01',
            'The constraint is real',
            'Every operation waits for a machine. Changeover time is charged, '
                'not wished away.',
          ),
          _principle(
            '02',
            'The diagnosis is causal',
            'A late job names the step, the queue, and the load that produced '
                'the delay.',
          ),
          _principle(
            '03',
            'The experiment is isolated',
            'Add a machine to one work center and see the exact delta — before '
                'you spend anything.',
          ),
        ],
        if (wide) ...[
          const SizedBox(height: 36),
          Container(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
            decoration: BoxDecoration(
              border: Border.all(color: TaktColors.line),
              color: TaktColors.surface.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(TaktRadius.normal),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TaktMark(size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Accounts are optional for trying Takt.',
                        style: TaktType.bodyStrong.copyWith(fontSize: 13),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'A workspace key opens the app without an email. '
                        'An account adds multiple workspaces, roles, and team '
                        'management.',
                        style: TaktType.small.copyWith(
                          fontSize: 11.5,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
        SizedBox(height: wide ? 40 : 24),
        Text(
          'FINITE CAPACITY / EXPLAINED',
          style: TaktType.label.copyWith(
            fontSize: 9,
            color: TaktColors.faint,
            letterSpacing: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _principle(String number, String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 34,
            child: Text(
              number,
              style: TaktType.mono.copyWith(
                fontSize: 11,
                color: TaktColors.faint,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TaktType.title.copyWith(fontSize: 14)),
                const SizedBox(height: 3),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Text(
                    body,
                    style: TaktType.small.copyWith(height: 1.45),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _form({required bool wide}) {
    final busy = widget.state.loading;
    final banner = _localError ?? widget.state.error;

    return TaktPanel(
      padding: EdgeInsets.all(wide ? 28 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account',
                      style: TaktType.headline.copyWith(fontSize: 22),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'One account. Every shop you can see.',
                      style: TaktType.small,
                    ),
                  ],
                ),
              ),
              Text(
                '${_mode == 0 ? '01' : '02'} / 02',
                style: TaktType.mono.copyWith(
                  fontSize: 10,
                  color: TaktColors.faint,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              _tab('Sign in', 0),
              const SizedBox(width: 20),
              _tab('Create account', 1),
            ],
          ),
          const SizedBox(height: 20),
          if (banner != null) ...[
            TaktBanner(
              message: banner,
              tone: Tone.oxide,
              onDismiss: _localError != null
                  ? () => setState(() => _localError = null)
                  : widget.state.clearMessages,
            ),
            const SizedBox(height: 15),
          ],
          if (_mode == 1) ...[
            const FieldLabel('Your name'),
            TextField(
              controller: _name,
              style: inputStyle,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.name],
              decoration: taktInput(hint: 'e.g. Alex Chen'),
            ),
            const SizedBox(height: 14),
          ],
          const FieldLabel('Email'),
          TextField(
            controller: _email,
            style: inputStyle,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.email],
            autocorrect: false,
            decoration: taktInput(hint: 'you@shop.com'),
          ),
          const SizedBox(height: 14),
          const FieldLabel('Password'),
          TextField(
            controller: _password,
            style: TaktType.mono.copyWith(fontSize: 12.5),
            obscureText: !_showPassword,
            enableSuggestions: false,
            autocorrect: false,
            textInputAction: _mode == 0
                ? TextInputAction.done
                : TextInputAction.next,
            autofillHints: [
              _mode == 0 ? AutofillHints.password : AutofillHints.newPassword,
            ],
            onSubmitted: _mode == 0 ? (_) => _submitAccount() : null,
            decoration: taktInput(hint: 'At least 10 characters').copyWith(
              suffixIcon: IconButton(
                onPressed: () => setState(() => _showPassword = !_showPassword),
                icon: Icon(
                  _showPassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 16,
                  color: TaktColors.faint,
                ),
                tooltip: _showPassword ? 'Hide password' : 'Show password',
              ),
            ),
          ),
          if (_mode == 1) ...[
            const SizedBox(height: 14),
            const FieldLabel('Confirm password'),
            TextField(
              controller: _confirm,
              style: TaktType.mono.copyWith(fontSize: 12.5),
              obscureText: !_showPassword,
              enableSuggestions: false,
              autocorrect: false,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submitAccount(),
              decoration: taktInput(hint: 'Repeat your password'),
            ),
            const SizedBox(height: 9),
            Text(
              'Argon2id-hashed on the server. No password reset yet — keep it '
              'somewhere safe.',
              style: TaktType.small.copyWith(fontSize: 11, height: 1.45),
            ),
          ],
          const SizedBox(height: 20),
          TaktButton(
            label: _mode == 0 ? 'Sign in' : 'Create account',
            onPressed: busy ? null : _submitAccount,
            busy: busy,
            expand: true,
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'OR',
                  style: TaktType.label.copyWith(
                    fontSize: 8.5,
                    color: TaktColors.faint,
                  ),
                ),
              ),
              const Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 16),
          if (!_guestOpen)
            TaktButton(
              label: 'Open with a workspace key',
              icon: Icons.key_outlined,
              tone: ButtonTone.secondary,
              onPressed: busy
                  ? null
                  : () {
                      widget.state.clearMessages();
                      setState(() {
                        _guestOpen = true;
                        _localError = null;
                      });
                    },
              expand: true,
            )
          else ...[
            const FieldLabel('Workspace key'),
            TextField(
              controller: _key,
              style: TaktType.mono.copyWith(fontSize: 12.5),
              decoration: taktInput(hint: 'XXXXX-XXXXX-XXXXX-XXXXX'),
              onSubmitted: (_) => _openKey(),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TaktButton(
                    label: 'Open workspace',
                    onPressed: busy ? null : _openKey,
                    busy: busy,
                    tone: ButtonTone.secondary,
                  ),
                ),
                const SizedBox(width: 8),
                TaktButton(
                  label: 'Cancel',
                  tone: ButtonTone.ghost,
                  onPressed: busy
                      ? null
                      : () {
                          widget.state.clearMessages();
                          setState(() {
                            _guestOpen = false;
                            _localError = null;
                          });
                        },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'No account needed. The key carries its role — a viewer key '
              'cannot write.',
              style: TaktType.small.copyWith(fontSize: 11, height: 1.45),
            ),
          ],
          const SizedBox(height: 18),
          Row(
            children: [
              const Icon(
                Icons.shield_outlined,
                size: 12,
                color: TaktColors.faint,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Sessions are revocable. Workspace keys are bearer '
                  'credentials; never post them publicly.',
                  style: TaktType.small.copyWith(fontSize: 10.5, height: 1.4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tab(String label, int index) {
    final active = _mode == index;
    return InkWell(
      onTap: () => _setMode(index),
      child: Container(
        padding: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: active ? TaktColors.ink : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: TaktType.body.copyWith(
            fontSize: 13,
            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
            color: active ? TaktColors.ink : TaktColors.muted,
          ),
        ),
      ),
    );
  }
}
