import 'package:flutter/material.dart';

class AppTheme {
  // ── Palette ───────────────────────────────────────────────────
  static const bg = Color(0xFFF5F0EA);         // warm off-white
  static const surface = Color(0xFFFDF9F6);    // near-white card surface
  static const surface2 = Color(0xFFECE7E0);   // slightly tinted
  static const surface3 = Color(0xFFE2DCD4);   // medium tint

  static const text = Color(0xFF2A231E);        // warm near-black
  static const textMute = Color(0xFF6A5E54);    // muted warm gray
  static const textFaint = Color(0xFF92857A);   // faint warm gray

  static const line = Color(0xFFDDD8D1);        // border
  static const lineSoft = Color(0xFFEAE6DF);    // soft border

  static const accent = Color(0xFFB85C38);      // terracotta
  static const accentInk = Color(0xFFFDF8F5);   // text-on-accent
  static const accentSoft = Color(0xFFF2E8E3);  // light accent container
  static const accentMute = Color(0xFFF8F3F0);  // very light accent tint

  static const success = Color(0xFF2E7A50);
  static const warning = Color(0xFF8B6800);
  static const danger = Color(0xFFC0402A);

  // 4-color palette for class initials (cycles by index)
  static const classColors = [
    (bg: Color(0xFFB85C38), fg: Color(0xFFFBF3F1)), // terracotta
    (bg: Color(0xFF167570), fg: Color(0xFFF0FAFA)), // teal
    (bg: Color(0xFF5C40A8), fg: Color(0xFFF3F0FC)), // violet
    (bg: Color(0xFFB88A10), fg: Color(0xFF2A200A)), // mustard
  ];

  // ── Light theme ───────────────────────────────────────────────
  static ThemeData get light {
    const cs = ColorScheme(
      brightness: Brightness.light,
      primary: accent,
      onPrimary: accentInk,
      primaryContainer: accentSoft,
      onPrimaryContainer: Color(0xFF3D1A0A),
      secondary: Color(0xFF7A6558),
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFFEDE4DE),
      onSecondaryContainer: Color(0xFF2D1F16),
      tertiary: Color(0xFF5C6B46),
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFFDCECC3),
      onTertiaryContainer: Color(0xFF192410),
      error: danger,
      onError: Colors.white,
      errorContainer: Color(0xFFFFDAD5),
      onErrorContainer: Color(0xFF410002),
      surface: surface,
      onSurface: text,
      onSurfaceVariant: textMute,
      outline: line,
      outlineVariant: lineSoft,
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: text,
      onInverseSurface: surface,
      inversePrimary: Color(0xFFFFB59A),
      surfaceTint: accent,
      surfaceContainerHighest: surface3,
      surfaceContainerHigh: Color(0xFFE7E2DA),
      surfaceContainer: surface2,
      surfaceContainerLow: Color(0xFFF0EBE4),
      surfaceContainerLowest: bg,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      scaffoldBackgroundColor: bg,
      cardColor: surface,

      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, letterSpacing: -0.5, color: text),
        headlineMedium: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, letterSpacing: -0.3, color: text),
        headlineSmall: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, letterSpacing: -0.2, color: text),
        titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: -0.1, color: text),
        titleMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0, color: text),
        titleSmall: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0, color: text),
        bodyLarge: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, letterSpacing: 0, color: text),
        bodyMedium: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, letterSpacing: 0, color: text),
        bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0, color: textMute),
        labelLarge: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.1, color: text),
        labelMedium: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.4, color: textMute),
        labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, letterSpacing: 0.5, color: textFaint),
      ),

      cardTheme: CardThemeData(
        elevation: 0,
        color: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: lineSoft),
        ),
        margin: EdgeInsets.zero,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: bg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          color: text,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
        iconTheme: IconThemeData(color: text),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: accent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: danger, width: 2),
        ),
        labelStyle: const TextStyle(color: textMute, fontSize: 14),
        hintStyle: const TextStyle(color: textFaint, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: accentInk,
          disabledBackgroundColor: accentSoft,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          minimumSize: const Size(double.infinity, 50),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: accent,
          side: const BorderSide(color: line),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accent,
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: text,
        foregroundColor: bg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
      ),

      chipTheme: ChipThemeData(
        backgroundColor: surface2,
        labelStyle: const TextStyle(fontSize: 12, color: textMute, fontWeight: FontWeight.w500),
        side: const BorderSide(color: line),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      ),

      dividerTheme: const DividerThemeData(
        color: lineSoft,
        thickness: 1,
        space: 0,
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: const TextStyle(
          color: text,
          fontSize: 17,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        ),
        contentTextStyle: const TextStyle(color: textMute, fontSize: 14),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: text,
        contentTextStyle: const TextStyle(color: accentInk),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: accent,
      ),
    );
  }

  // ── Dark theme (minimal — uses seed) ─────────────────────────
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: accent,
        brightness: Brightness.dark,
      );
}
