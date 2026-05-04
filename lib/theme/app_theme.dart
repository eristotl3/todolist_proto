import 'package:flutter/material.dart';

class AppTheme {
  static const _seedColor = Color(0xFF4F6AF5);

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: _seedColor,
        brightness: Brightness.light,
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: _seedColor,
        brightness: Brightness.dark,
      );
}
