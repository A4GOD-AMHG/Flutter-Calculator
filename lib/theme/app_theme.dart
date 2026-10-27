import 'package:flutter/material.dart';

/// Paleta única de la app; los widgets usan roles del ColorScheme.
class AppTheme {
  static const _seed = Color(0xFF3D7BFF);

  static ThemeData light = _build(Brightness.light);
  static ThemeData dark = _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: brightness,
    );
    return ThemeData(
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }
}
