import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme/takt_theme.dart';
import '../widgets/common.dart';

class EntryScreen extends StatefulWidget {
  const EntryScreen({super.key, required this.state});

  final AppState state;

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  final _name = TextEditingController();
  final _key = TextEditingController();
  int _mode = 0;
  String _currency = 'USD';
  bool _withSample = true;
  String? _localError;

  @override
  void dispose() {
    _name.dispose();
    _key.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() => _localError = null);

    if (_mode == 0) {
      if (_name.text.trim().isEmpty) {
        setState(() => _localError = 'Give the workspace a name.');
        return;
      }
      await widget.state.createWorkspace(
        _name.text,
        _currency,
        withSample: _withSample,
      );
    } else {
      if (_key.text.trim().isEmpty) {
        setState(() => _localError = 'Paste the workspace key.');
        return;
      }
      await widget.state.openWorkspace(_key.text);
    }
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
                vertical: wide ? 52 : 26,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1160),
                  child: wide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 6, child: _narrative(wide: true)),
                            const SizedBox(width: 80),
                            Expanded(flex: 5, child: _form()),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _narrative(wide: false),
                            const SizedBox(height: 34),
                            _form(),
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

  Widget _narrative({required bool wide}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Wordmark(size: 30),
        SizedBox(height: wide ? 44 : 30),
        Text(
          'Your shop is\npromising more\nthan it can make.',
          style: TaktType.display.copyWith(
            fontSize: wide ? 44 : 34,
            height: 1.04,
          ),
        ),
        const SizedBox(height: 20),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Text(
            'Takt schedules finite capacity — real machines, real changeovers — '
            'then explains every late job with the work center that caused it. '
            'No implementation project. No dashboard of meaningless numbers.',
            style: TaktType.body.copyWith(fontSize: 15, height: 1.55),
          ),
        ),
        SizedBox(height: wide ? 42 : 28),
        _principle(
          '01',
          'Finite capacity',
          'Every operation waits for a machine. Changeover time is charged, '
              'not wished away.',
        ),
        _principle(
          '02',
          'Causal verdicts',
          'A late job names the step, the queue, and the load that produced '
              'the delay.',
        ),
        _principle(
          '03',
          'Capacity experiments',
          'Add a machine to the constraint and see the exact delta before you '
              'spend anything.',
        ),
        SizedBox(height: wide ? 46 : 30),
        Container(
          padding: const EdgeInsets.only(left: 12),
          decoration: const BoxDecoration(
            border: Border(left: BorderSide(color: TaktColors.lineStrong)),
          ),
          child: Text(
            'Built for high-mix, low-volume shops that have outgrown a '
            'spreadsheet but will never survive a six-month APS rollout.',
            style: TaktType.small.copyWith(fontSize: 12, height: 1.5),
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

  Widget _form() {
    final busy = widget.state.loading;
    final banner = _localError ?? widget.state.error;

    return TaktPanel(
      padding: const EdgeInsets.all(26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Workspace', style: TaktType.headline.copyWith(fontSize: 20)),
          const SizedBox(height: 6),
          Text(
            'A workspace holds one shop: its machines, jobs and schedule.',
            style: TaktType.small,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _tab('New', 0),
              const SizedBox(width: 18),
              _tab('Open with key', 1),
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
            const SizedBox(height: 16),
          ],
          if (_mode == 0) ...[
            const FieldLabel('Shop name'),
            TextField(
              controller: _name,
              style: inputStyle,
              textInputAction: TextInputAction.next,
              decoration: taktInput(hint: 'e.g. Calder Precision'),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            const FieldLabel('Currency'),
            Row(
              children: [
                for (final code in const ['USD', 'GBP', 'EUR']) ...[
                  _currencyButton(code),
                  const SizedBox(width: 8),
                ],
              ],
            ),
            const SizedBox(height: 16),
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
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
          ] else ...[
            const FieldLabel('Workspace key'),
            TextField(
              controller: _key,
              style: TaktType.mono.copyWith(fontSize: 12.5),
              decoration: taktInput(hint: 'XXXXX-XXXXX-XXXXX-XXXXX'),
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 10),
            Text(
              'The key is the only credential. It was shown when the workspace '
              'was created.',
              style: TaktType.small.copyWith(fontSize: 11.5),
            ),
          ],
          const SizedBox(height: 22),
          TaktButton(
            label: _mode == 0 ? 'Create workspace' : 'Open workspace',
            onPressed: busy ? null : _submit,
            busy: busy,
            expand: true,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(Icons.lock_outline, size: 12, color: TaktColors.faint),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'No account, no email. Keep the key safe — it is the '
                  'workspace.',
                  style: TaktType.small.copyWith(fontSize: 11),
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
      onTap: () => setState(() {
        _mode = index;
        _localError = null;
      }),
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
