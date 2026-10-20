import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Takt's visual language is a drafting sheet, not a SaaS dashboard:
/// warm paper, graphite rules, one oxide accent reserved for lateness.
abstract final class TaktColors {
  static const paper = Color(0xFFF2F0E9);
  static const surface = Color(0xFFFCFBF7);
  static const ink = Color(0xFF14160F);
  static const inkSoft = Color(0xFF3B3E34);
  static const muted = Color(0xFF70746A);
  static const faint = Color(0xFF9A9D92);
  static const line = Color(0xFFDAD6CA);
  static const lineStrong = Color(0xFFB9B4A4);
  static const oxide = Color(0xFFA63D28);
  static const oxideWash = Color(0xFFF6E6E0);
  static const teal = Color(0xFF1D574F);
  static const tealWash = Color(0xFFE3EDE9);
  static const amber = Color(0xFF8F6412);
  static const amberWash = Color(0xFFF6EDD9);
  static const graphite = Color(0xFF262A22);
  static const rail = Color(0xFFEAE7DD);
}

abstract final class TaktSpace {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
  static const huge = 48.0;
}

abstract final class TaktRadius {
  static const tight = 3.0;
  static const normal = 5.0;
  static const loose = 10.0;
}

abstract final class TaktType {
  static TextStyle get display => GoogleFonts.spaceGrotesk(
    fontSize: 40,
    height: 1.05,
    fontWeight: FontWeight.w600,
    letterSpacing: -1.4,
    color: TaktColors.ink,
  );

  static TextStyle get headline => GoogleFonts.spaceGrotesk(
    fontSize: 24,
    height: 1.15,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
    color: TaktColors.ink,
  );

  static TextStyle get title => GoogleFonts.spaceGrotesk(
    fontSize: 17,
    height: 1.3,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    color: TaktColors.ink,
  );

  static TextStyle get body => GoogleFonts.spaceGrotesk(
    fontSize: 14.5,
    height: 1.5,
    fontWeight: FontWeight.w400,
    color: TaktColors.inkSoft,
  );

  static TextStyle get bodyStrong => GoogleFonts.spaceGrotesk(
    fontSize: 14.5,
    height: 1.5,
    fontWeight: FontWeight.w500,
    color: TaktColors.ink,
  );

  static TextStyle get small => GoogleFonts.spaceGrotesk(
    fontSize: 12.5,
    height: 1.4,
    fontWeight: FontWeight.w400,
    color: TaktColors.muted,
  );

  /// Uppercase, tracked-out labels. Mono keeps them from feeling decorative.
  static TextStyle get label => GoogleFonts.ibmPlexMono(
    fontSize: 10,
    height: 1.2,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.1,
    color: TaktColors.muted,
  );

  static TextStyle get mono => GoogleFonts.ibmPlexMono(
    fontSize: 12.5,
    height: 1.35,
    fontWeight: FontWeight.w400,
    color: TaktColors.inkSoft,
    fontFeatures: const [FontFeature.tabularFigures()],
  );

  static TextStyle get monoStrong => GoogleFonts.ibmPlexMono(
    fontSize: 13,
    height: 1.35,
    fontWeight: FontWeight.w600,
    color: TaktColors.ink,
    fontFeatures: const [FontFeature.tabularFigures()],
  );

  static TextStyle get figure => GoogleFonts.ibmPlexMono(
    fontSize: 30,
    height: 1,
    fontWeight: FontWeight.w500,
    letterSpacing: -1,
    color: TaktColors.ink,
    fontFeatures: const [FontFeature.tabularFigures()],
  );

  static TextStyle get figureSmall => GoogleFonts.ibmPlexMono(
    fontSize: 19,
    height: 1,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.4,
    color: TaktColors.ink,
    fontFeatures: const [FontFeature.tabularFigures()],
  );
}

ThemeData taktTheme() {
  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
  );

  return base.copyWith(
    scaffoldBackgroundColor: TaktColors.paper,
    canvasColor: TaktColors.paper,
    dividerColor: TaktColors.line,
    colorScheme: const ColorScheme.light(
      primary: TaktColors.ink,
      onPrimary: TaktColors.surface,
      secondary: TaktColors.teal,
      onSecondary: TaktColors.surface,
      surface: TaktColors.surface,
      onSurface: TaktColors.ink,
      error: TaktColors.oxide,
      onError: TaktColors.surface,
      outline: TaktColors.lineStrong,
    ),
    textTheme: GoogleFonts.spaceGroteskTextTheme(base.textTheme).apply(
      bodyColor: TaktColors.inkSoft,
      displayColor: TaktColors.ink,
    ),
    splashFactory: InkRipple.splashFactory,
    highlightColor: Colors.transparent,
    dividerTheme: const DividerThemeData(
      color: TaktColors.line,
      thickness: 1,
      space: 1,
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: TaktColors.graphite,
        borderRadius: BorderRadius.circular(TaktRadius.tight),
      ),
      textStyle: TaktType.mono.copyWith(color: TaktColors.surface),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    ),
    scrollbarTheme: ScrollbarThemeData(
      thickness: WidgetStateProperty.all(6),
      radius: const Radius.circular(3),
      thumbColor: WidgetStateProperty.all(TaktColors.lineStrong),
    ),
  );
}
