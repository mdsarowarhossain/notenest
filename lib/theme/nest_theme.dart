import 'package:flutter/material.dart';

/// ---------------------------------------------------------------------------
/// NoteNest design tokens — "Ballpoint & Highlighter"
///
/// The palette is taken from the things a student actually writes with:
/// blue ballpoint ink, a yellow highlighter, a red correction pen and the
/// coloured index tabs of a subject divider.
/// ---------------------------------------------------------------------------
class NestColor {
  NestColor._();

  // Surfaces
  static const paper = Color(0xFFEDEFF3); // cool page grey
  static const paperDeep = Color(0xFFE1E6EE); // shadowed page
  static const card = Color(0xFFFFFFFF);
  static const rule = Color(0xFFDCE1E9); // ruled line

  // Ink
  static const ink = Color(0xFF151A24);
  static const inkSoft = Color(0xFF5B667A);
  static const inkFaint = Color(0xFF98A2B3);

  // Writing instruments
  static const pen = Color(0xFF243E8C); // ballpoint blue — primary
  static const penDeep = Color(0xFF16295F);
  static const highlight = Color(0xFFFFE45E); // highlighter yellow
  static const redPen = Color(0xFFD62839); // important / destructive
  static const mint = Color(0xFF1F8A6B); // done / synced

  /// Index-tab colours for subjects.
  static const tabs = <Color>[
    Color(0xFFFFE45E),
    Color(0xFFFF9BB3),
    Color(0xFF7ED9A6),
    Color(0xFF7EC4F2),
    Color(0xFFB9A6F2),
    Color(0xFFFFB067),
  ];

  /// Opacity helper that stays valid across Flutter versions.
  static Color o(Color c, double opacity) =>
      c.withAlpha((opacity.clamp(0, 1) * 255).round());
}

/// Typeface roles. Leave these null to use the platform default, or add
/// `google_fonts` and set them (see NEXT_STEPS.md).
class NestFont {
  NestFont._();
  static const String? display = null; // suggestion: 'Fraunces'
  static const String? body = null; // suggestion: 'Manrope'
  static const String? mono = null; // suggestion: 'IBM Plex Mono'
}

class NestRadius {
  NestRadius._();
  static const card = 20.0;
  static const tile = 16.0;
  static const chip = 12.0;
  static const tab = 20.0;
}

/// Small uppercase utility labels ("STEP 02 / 03", "SUBJECTS", note counts).
/// This is the printed-index voice of the interface.
const TextStyle nestEyebrow = TextStyle(
  fontFamily: NestFont.mono,
  fontSize: 11,
  fontWeight: FontWeight.w700,
  letterSpacing: 1.6,
  color: NestColor.inkFaint,
);

ThemeData nestTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: NestColor.pen,
    brightness: Brightness.light,
  ).copyWith(
    primary: NestColor.pen,
    onPrimary: Colors.white,
    secondary: NestColor.highlight,
    onSecondary: NestColor.ink,
    surface: NestColor.card,
    onSurface: NestColor.ink,
    error: NestColor.redPen,
  );

  const text = TextTheme(
    displaySmall: TextStyle(
      fontFamily: NestFont.display,
      fontSize: 30,
      height: 1.15,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.6,
      color: NestColor.ink,
    ),
    headlineSmall: TextStyle(
      fontFamily: NestFont.display,
      fontSize: 22,
      height: 1.2,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.3,
      color: NestColor.ink,
    ),
    titleMedium: TextStyle(
      fontFamily: NestFont.body,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: NestColor.ink,
    ),
    titleSmall: TextStyle(
      fontFamily: NestFont.body,
      fontSize: 14.5,
      fontWeight: FontWeight.w600,
      color: NestColor.ink,
    ),
    bodyMedium: TextStyle(
      fontFamily: NestFont.body,
      fontSize: 14.5,
      height: 1.45,
      color: NestColor.inkSoft,
    ),
    bodySmall: TextStyle(
      fontFamily: NestFont.body,
      fontSize: 12.5,
      height: 1.4,
      color: NestColor.inkSoft,
    ),
    labelSmall: nestEyebrow,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    textTheme: text,
    fontFamily: NestFont.body,
    scaffoldBackgroundColor: NestColor.paper,
    splashFactory: InkSparkle.splashFactory,
    dividerTheme: const DividerThemeData(
      color: NestColor.rule,
      thickness: 1,
      space: 1,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: NestColor.paper,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: NestColor.ink),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: NestColor.pen,
        foregroundColor: Colors.white,
        minimumSize: const Size(0, 54),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NestRadius.tile),
        ),
        textStyle: const TextStyle(
          fontSize: 15.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    ),
  );
}
