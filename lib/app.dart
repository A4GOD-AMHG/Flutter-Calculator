import 'package:calculadora/providers/theme_provider.dart';
import 'package:calculadora/screens/calc_screen.dart';
import 'package:calculadora/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: context.watch<ThemeProvider>().themeMode,
      home: const CalcScreen(),
    );
  }
}
