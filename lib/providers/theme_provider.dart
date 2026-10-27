import 'package:calculadora/shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  final PreferenciasUsuario _prefs;
  bool _isDarkmode;

  ThemeProvider(this._prefs) : _isDarkmode = _prefs.isDarkmode;

  bool get isDarkmode => _isDarkmode;
  ThemeMode get themeMode => _isDarkmode ? ThemeMode.dark : ThemeMode.light;

  void toggle() {
    _isDarkmode = !_isDarkmode;
    _prefs.isDarkmode = _isDarkmode;
    notifyListeners();
  }
}
