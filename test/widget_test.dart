import 'package:calculadora/app.dart';
import 'package:calculadora/providers/calc_provider.dart';
import 'package:calculadora/providers/theme_provider.dart';
import 'package:calculadora/shared_preferences/shared_preferences.dart';
import 'package:calculadora/widgets/grid_view_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('suma, encadena y avisa de división entre 0', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = PreferenciasUsuario();
    await prefs.initPrefs();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CalcProvider()),
          ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)),
        ],
        child: const MyApp(),
      ),
    );
    Future<void> tap(String label) async {
      await tester.tap(
        find.descendant(
          of: find.byType(GridViewButtons),
          matching: find.text(label),
        ),
      );
      await tester.pump();
    }

    final calc = tester.element(find.byType(TextField)).read<CalcProvider>();

    for (final k in ['7', '+', '3', '=']) {
      await tap(k);
    }
    expect(calc.input, '10');
    for (final k in ['×', '2', '=']) {
      await tap(k);
    }
    expect(calc.input, '20');
    await tap('5'); // número nuevo tras "=" empieza de cero
    expect(calc.input, '5');
    for (final k in ['÷', '0', '=']) {
      await tap(k);
    }
    await tester.pumpAndSettle();
    expect(find.text('No se puede dividir entre 0'), findsOneWidget);
    expect(calc.input, '5/0');
  });
}
