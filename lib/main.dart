import 'package:calculadora/app.dart';
import 'package:calculadora/providers/calc_provider.dart';
import 'package:calculadora/shared_preferences/shared_preferences.dart';
import 'package:calculadora/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CalcProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)),
      ],
      child: const MyApp(),
    ),
  );
}
