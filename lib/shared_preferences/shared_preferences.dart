import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {
  static final PreferenciasUsuario _instancia = PreferenciasUsuario._internal();

  factory PreferenciasUsuario() => _instancia;

  PreferenciasUsuario._internal();

  SharedPreferences? _prefs;

  Future<void> initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Por defecto oscuro, como la app original.
  bool get isDarkmode => _prefs?.getBool('isDarkmode') ?? true;

  set isDarkmode(bool value) => _prefs?.setBool('isDarkmode', value);
}
