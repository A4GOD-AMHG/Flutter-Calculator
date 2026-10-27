/// Lógica pura de la calculadora (sin Flutter) para poder probarla aislada.
library;

/// Error de cálculo que se puede mostrar al usuario.
class CalcError implements Exception {
  final String message;
  const CalcError(this.message);

  @override
  String toString() => message;
}

final _number = RegExp(r'(\d+\.?\d*|\.\d+)(e[+-]?\d+)?');
final _trailingOperators = RegExp(r'[-+*/]+$');
const _operators = '+-*/';

bool _endsWithOperator(String s) =>
    s.isNotEmpty && _operators.contains(s[s.length - 1]);

/// Evalúa [expression] con precedencia normal, `-` unario, `x%` = x/100,
/// multiplicación implícita (`2(3)`, `10%50`) y paréntesis sin cerrar.
///
/// Lanza [CalcError] en división entre 0 y [FormatException] si la
/// expresión está incompleta o mal formada.
double evaluate(String expression) {
  final parser = _Parser(expression.replaceAll(' ', ''));
  final value = parser.parseExpression();
  if (!parser.done) throw const FormatException('Expresión inválida');
  if (!value.isFinite) throw const CalcError('Resultado demasiado grande');
  return value;
}

/// Formatea un resultado quitando ruido de coma flotante (0.1+0.2 → 0.3).
String format(double value) {
  final v = double.parse(value.toStringAsPrecision(12));
  if (v == v.truncateToDouble() && v.abs() < 1e15) return v.toInt().toString();
  final s = v.toString();
  return s.endsWith('.0') ? s.substring(0, s.length - 2) : s;
}

/// Devuelve el texto a la izquierda del cursor tras pulsar un operador
/// (`+ - * / %`). Sustituye el operador anterior en vez de encadenarlos.
String insertOperator(String left, String op) {
  if (op == '%') {
    final ok =
        left.isNotEmpty &&
        !_endsWithOperator(left) &&
        !left.endsWith('(') &&
        !left.endsWith('%');
    return ok ? '$left%' : left;
  }
  if (left.isEmpty || left.endsWith('(')) return op == '-' ? '$left-' : left;
  if (!_endsWithOperator(left)) return '$left$op';
  // Permite números negativos tras * o /: "5*-3".
  if (op == '-' && (left.endsWith('*') || left.endsWith('/'))) return '$left-';
  final stripped = left.replaceFirst(_trailingOperators, '');
  if (stripped.isEmpty || stripped.endsWith('(')) return left;
  return '$stripped$op';
}

/// Inserta un dígito o el punto decimal, evitando "1.2.3" y añadiendo `*`
/// tras `)` o `%`.
String insertDigit(String left, String digit) {
  final implicitMul = left.endsWith(')') || left.endsWith('%');
  if (digit == '.') {
    final token = left.split(RegExp(r'[-+*/()%]')).last;
    if (token.contains('.')) return left;
    if (implicitMul) return '$left*0.';
    return token.isEmpty ? '${left}0.' : '$left.';
  }
  return implicitMul ? '$left*$digit' : '$left$digit';
}

/// Comportamiento del botón `( )`: cierra si hay un paréntesis abierto y
/// lo anterior es un operando; si no, abre (con `*` implícito tras un número).
String insertParenthesis(String left) {
  final open = '('.allMatches(left).length - ')'.allMatches(left).length;
  final afterOperand =
      left.isNotEmpty && !_endsWithOperator(left) && !left.endsWith('(');
  if (afterOperand && open > 0) return '$left)';
  if (afterOperand) return '$left*(';
  return '$left(';
}

class _Parser {
  final String s;
  int pos = 0;
  _Parser(this.s);

  bool get done => pos == s.length;
  String? get _peek => done ? null : s[pos];

  bool _eat(String c) {
    if (_peek == c) {
      pos++;
      return true;
    }
    return false;
  }

  // "2(3)", "(2)3", "10%50"; nunca entre dos números ("1.2.3" es inválido).
  bool get _implicitMultiplication {
    if (done || pos == 0) return false;
    if (_peek == '(') return true;
    final prev = s[pos - 1];
    return (prev == ')' || prev == '%') &&
        _number.matchAsPrefix(s, pos) != null;
  }

  // expression := term (('+' | '-') term)*
  double parseExpression() {
    var v = _parseTerm();
    while (true) {
      if (_eat('+')) {
        v += _parseTerm();
      } else if (_eat('-')) {
        v -= _parseTerm();
      } else {
        return v;
      }
    }
  }

  // term := factor (('*' | '/' | implícito) factor)*
  double _parseTerm() {
    var v = _parseFactor();
    while (true) {
      if (_eat('*')) {
        v *= _parseFactor();
      } else if (_eat('/')) {
        final d = _parseFactor();
        if (d == 0) throw const CalcError('No se puede dividir entre 0');
        v /= d;
      } else if (_implicitMultiplication) {
        v *= _parseFactor();
      } else {
        return v;
      }
    }
  }

  // factor := ('-' | '+') factor | primary '%'*
  double _parseFactor() {
    if (_eat('-')) return -_parseFactor();
    if (_eat('+')) return _parseFactor();
    var v = _parsePrimary();
    while (_eat('%')) {
      v /= 100;
    }
    return v;
  }

  // primary := number | '(' expression ')'?  (paréntesis sin cerrar al final)
  double _parsePrimary() {
    if (_eat('(')) {
      final v = parseExpression();
      if (!_eat(')') && !done) throw const FormatException('Falta )');
      return v;
    }
    final m = done ? null : _number.matchAsPrefix(s, pos);
    if (m == null) throw const FormatException('Se esperaba un número');
    pos = m.end;
    return double.parse(m[0]!);
  }
}
