import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/takt_theme.dart';

enum Tone { neutral, teal, oxide, amber }

Color toneColor(Tone tone) {
  switch (tone) {
    case Tone.teal:
      return TaktColors.teal;
    case Tone.oxide:
      return TaktColors.oxide;
    case Tone.amber:
      return TaktColors.amber;
    case Tone.neutral:
      return TaktColors.inkSoft;
  }
}

Color toneWash(Tone tone) {
  switch (tone) {
    case Tone.teal:
      return TaktColors.tealWash;
    case Tone.oxide:
      return TaktColors.oxideWash;
    case Tone.amber:
      return TaktColors.amberWash;
    case Tone.neutral:
      return TaktColors.rail;
  }
}

/// "2h 10m", "45m", "3h". Mirrors the server's diagnosis formatting.
String formatMinutes(int minutes) {
  final negative = minutes < 0;
  final value = minutes.abs();
  final hours = value ~/ 60;
  final rest = value % 60;
  final text = hours == 0
      ? '${rest}m'
      : rest == 0
      ? '${hours}h'
      : '${hours}h ${rest}m';
  return negative ? '-$text' : text;
}

const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

String formatDate(DateTime date) {
  final local = date.toLocal();
  return '${local.day} ${_months[local.month - 1]}';
}

String formatDateLong(DateTime date) {
  final local = date.toLocal();
  return '${local.day} ${_months[local.month - 1]} ${local.year}';
}

String formatClock(DateTime date) {
  final local = date.toLocal();
  return '${local.hour.toString().padLeft(2, '0')}:'
      '${local.minute.toString().padLeft(2, '0')}';
}

String formatOffset(DateTime anchor, int minute) {
  final moment = anchor.toLocal().add(Duration(minutes: minute));
  final day = (minute ~/ (24 * 60)) + 1;
  return 'D$day · ${formatClock(moment)}';
}

class TaktMark extends StatelessWidget {
  const TaktMark({super.key, this.size = 30, this.accent = TaktColors.oxide});

  final double size;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _MarkPainter(accent: accent),
    );
  }
}

class _MarkPainter extends CustomPainter {
  const _MarkPainter({required this.accent});

  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final unit = size.width / 32;
    final barHeight = 5.2 * unit;
    final radius = Radius.circular(1.2 * unit);

    final ink = Paint()..color = TaktColors.ink;
    final accentPaint = Paint()..color = accent;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(2 * unit, 5 * unit, 28 * unit, barHeight),
        radius,
      ),
      ink,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(2 * unit, 13.4 * unit, 18 * unit, barHeight),
        radius,
      ),
      ink,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(2 * unit, 21.8 * unit, 28 * unit, barHeight),
        radius,
      ),
      accentPaint,
    );

    // The constraint notch: a single tick that interrupts the long bar.
    canvas.drawRect(
      Rect.fromLTWH(22 * unit, 21.8 * unit, 2 * unit, barHeight),
      Paint()..color = TaktColors.paper,
    );
  }

  @override
  bool shouldRepaint(covariant _MarkPainter oldDelegate) =>
      oldDelegate.accent != accent;
}

class Wordmark extends StatelessWidget {
  const Wordmark({super.key, this.size = 30, this.light = false});

  final double size;
  final bool light;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TaktMark(size: size),
        SizedBox(width: size * 0.34),
        Text(
          'TAKT',
          style: TaktType.label.copyWith(
            fontSize: size * 0.52,
            letterSpacing: size * 0.085,
            color: light ? TaktColors.surface : TaktColors.ink,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key, this.color, this.trailing});

  final String text;
  final Color? color;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text.toUpperCase(),
          style: TaktType.label.copyWith(color: color ?? TaktColors.muted),
        ),
        if (trailing != null) ...[
          const SizedBox(width: TaktSpace.sm),
          trailing!,
        ],
      ],
    );
  }
}

class TaktPanel extends StatelessWidget {
  const TaktPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(TaktSpace.xl),
    this.color = TaktColors.surface,
    this.borderColor = TaktColors.line,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(TaktRadius.normal),
      ),
      child: child,
    );
  }
}

enum ButtonTone { primary, secondary, ghost, danger, inverse }

class TaktButton extends StatelessWidget {
  const TaktButton({
    super.key,
    required this.label,
    this.onPressed,
    this.tone = ButtonTone.primary,
    this.busy = false,
    this.icon,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final ButtonTone tone;
  final bool busy;
  final IconData? icon;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !busy;

    late Color background;
    late Color foreground;
    Color? border;

    switch (tone) {
      case ButtonTone.primary:
        background = TaktColors.ink;
        foreground = TaktColors.surface;
        break;
      case ButtonTone.secondary:
        background = Colors.transparent;
        foreground = TaktColors.ink;
        border = TaktColors.lineStrong;
        break;
      case ButtonTone.ghost:
        background = Colors.transparent;
        foreground = TaktColors.muted;
        break;
      case ButtonTone.danger:
        background = Colors.transparent;
        foreground = TaktColors.oxide;
        border = TaktColors.oxide.withValues(alpha: 0.35);
        break;
      case ButtonTone.inverse:
        background = TaktColors.surface;
        foreground = TaktColors.ink;
        break;
    }

    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(TaktRadius.tight),
        child: InkWell(
          onTap: enabled ? onPressed : null,
          borderRadius: BorderRadius.circular(TaktRadius.tight),
          child: Container(
            height: 38,
            width: expand ? double.infinity : null,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              border: border == null ? null : Border.all(color: border),
              borderRadius: BorderRadius.circular(TaktRadius.tight),
            ),
            child: Row(
              mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (busy)
                  SizedBox(
                    width: 13,
                    height: 13,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.6,
                      valueColor: AlwaysStoppedAnimation(foreground),
                    ),
                  )
                else if (icon != null)
                  Icon(icon, size: 15, color: foreground),
                if (busy || icon != null) const SizedBox(width: 8),
                Text(
                  busy ? 'Working' : label,
                  style: TaktType.mono.copyWith(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                    color: foreground,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.label,
    this.tone = Tone.neutral,
    this.filled = false,
  });

  final String label;
  final Tone tone;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: filled ? toneWash(tone) : Colors.transparent,
        border: Border.all(
          color: filled
              ? toneWash(tone)
              : toneColor(tone).withValues(alpha: 0.32),
        ),
        borderRadius: BorderRadius.circular(TaktRadius.tight),
      ),
      child: Text(
        label.toUpperCase(),
        style: TaktType.label.copyWith(
          fontSize: 9,
          letterSpacing: 0.7,
          color: toneColor(tone),
        ),
      ),
    );
  }
}

class TaktBanner extends StatelessWidget {
  const TaktBanner({
    super.key,
    required this.message,
    this.tone = Tone.oxide,
    this.onDismiss,
    this.action,
  });

  final String message;
  final Tone tone;
  final VoidCallback? onDismiss;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: toneWash(tone),
        border: Border(left: BorderSide(color: toneColor(tone), width: 3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: TaktType.body.copyWith(
                fontSize: 13,
                color: TaktColors.inkSoft,
              ),
            ),
          ),
          if (action != null) ...[
            const SizedBox(width: 10),
            action!,
          ],
          if (onDismiss != null)
            IconButton(
              onPressed: onDismiss,
              icon: const Icon(Icons.close, size: 15),
              color: toneColor(tone),
              tooltip: 'Dismiss',
              visualDensity: VisualDensity.compact,
            ),
        ],
      ),
    );
  }
}

class KeyChip extends StatelessWidget {
  const KeyChip({super.key, required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Copy workspace key',
      child: InkWell(
        borderRadius: BorderRadius.circular(TaktRadius.tight),
        onTap: () async {
          await Clipboard.setData(ClipboardData(text: value));
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Workspace key copied',
                style: TaktType.mono.copyWith(fontSize: 12),
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: TaktColors.graphite,
              width: 260,
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(color: TaktColors.line),
            borderRadius: BorderRadius.circular(TaktRadius.tight),
            color: TaktColors.surface,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: TaktType.mono.copyWith(
                  fontSize: 10.5,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(width: 7),
              const Icon(Icons.copy_rounded, size: 11, color: TaktColors.faint),
            ],
          ),
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    required this.body,
    this.action,
  });

  final String title;
  final String body;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return TaktPanel(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TaktType.headline),
          const SizedBox(height: TaktSpace.sm),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Text(body, style: TaktType.body),
          ),
          if (action != null) ...[
            const SizedBox(height: TaktSpace.lg),
            action!,
          ],
        ],
      ),
    );
  }
}

class MetricCell extends StatelessWidget {
  const MetricCell({
    super.key,
    required this.label,
    required this.value,
    this.caption,
    this.tone = Tone.neutral,
    this.compact = false,
  });

  final String label;
  final String value;
  final String? caption;
  final Tone tone;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: TaktSpace.xl,
        vertical: TaktSpace.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label.toUpperCase(),
            style: TaktType.label.copyWith(fontSize: 9.5),
          ),
          const SizedBox(height: 9),
          Text(
            value,
            style: (compact ? TaktType.figureSmall : TaktType.figure).copyWith(
              color: toneColor(tone),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (caption != null) ...[
            const SizedBox(height: 5),
            Text(caption!, style: TaktType.small),
          ],
        ],
      ),
    );
  }
}

class HairlineRow extends StatelessWidget {
  const HairlineRow({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: TaktColors.line)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0)
                const VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: TaktColors.line,
                ),
              Expanded(child: children[i]),
            ],
          ],
        ),
      ),
    );
  }
}

class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text.toUpperCase(),
        style: TaktType.label.copyWith(fontSize: 9.5),
      ),
    );
  }
}

InputDecoration taktInput({String? hint}) {
  const border = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(TaktRadius.tight)),
    borderSide: BorderSide(color: TaktColors.line),
  );
  return InputDecoration(
    hintText: hint,
    hintStyle: TaktType.body.copyWith(color: TaktColors.faint),
    isDense: true,
    filled: true,
    fillColor: TaktColors.surface,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    border: border,
    enabledBorder: border,
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(TaktRadius.tight)),
      borderSide: BorderSide(color: TaktColors.ink),
    ),
    errorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(TaktRadius.tight)),
      borderSide: BorderSide(color: TaktColors.oxide),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(TaktRadius.tight)),
      borderSide: BorderSide(color: TaktColors.oxide),
    ),
  );
}

TextStyle get inputStyle => TaktType.body.copyWith(color: TaktColors.ink);
