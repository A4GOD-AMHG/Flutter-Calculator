import 'package:calculadora/logic/calculator.dart' as calc;
import 'package:flutter/material.dart';

/// Estado de la pantalla: texto, cursor y resultado. Las reglas de cálculo
/// viven en `logic/calculator.dart`.
class CalcProvider with ChangeNotifier {
  final controller = TextEditingController();
  final focusNode = FocusNode();

  bool showResult = true;
  String? error;
  bool _justEvaluated = false;

  String get input => controller.text;

  double get inputFontSize {
    final length = input.length;
    if (length < 8) return 56;
    if (length < 12) return 46;
    if (length < 16) return 38;
    return 30;
  }

  /// Resultado en vivo; vacío si la expresión está incompleta o es un número suelto.
  String get preview {
    if (!showResult) return '';
    try {
      final result = calc.format(calc.evaluate(input));
      return result == input ? '' : result;
    } catch (_) {
      return '';
    }
  }

  /// Sustituye la selección (o inserta en el cursor) con lo que devuelva [change].
  void _edit(String Function(String left) change, {bool deleting = false}) {
    final text = controller.text;
    final sel = controller.selection;
    final start = sel.isValid ? sel.start.clamp(0, text.length) : text.length;
    final end = sel.isValid ? sel.end.clamp(0, text.length) : text.length;
    var left = text.substring(0, start);
    final right = text.substring(end);

    if (deleting && start == end && left.isNotEmpty) {
      left = left.substring(0, left.length - 1);
    } else if (!deleting) {
      left = change(left);
    }
    controller.value = TextEditingValue(
      text: left + right,
      selection: TextSelection.collapsed(offset: left.length),
    );
    error = null;
    showResult = true;
    _justEvaluated = false;
    notifyListeners();
  }

  void allClear() {
    controller.clear();
    error = null;
    showResult = false;
    _justEvaluated = false;
    notifyListeners();
  }

  void delete() => _edit((left) => left, deleting: true);

  void addDigit(String digit) {
    // Tras "=", un número nuevo empieza otra operación; un operador la encadena.
    if (_justEvaluated) controller.clear();
    _edit((left) => calc.insertDigit(left, digit));
  }

  void addOperator(String op) => _edit((left) => calc.insertOperator(left, op));

  void parenthesisBehavior() => _edit(calc.insertParenthesis);

  void equal() {
    if (input.isEmpty) return;
    try {
      final result = calc.format(calc.evaluate(input));
      controller.value = TextEditingValue(
        text: result,
        selection: TextSelection.collapsed(offset: result.length),
      );
      _justEvaluated = true;
      showResult = false;
      error = null;
    } on calc.CalcError catch (e) {
      error = e.message;
    } on FormatException {
      error = 'Expresión incompleta';
    }
    notifyListeners();
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }
}
