import 'package:calculadora/logic/calculator.dart';
import 'package:flutter_test/flutter_test.dart';

String run(String e) => format(evaluate(e));

void main() {
  test('precedencia, negativos y paréntesis', () {
    expect(run('2+3*4'), '14');
    expect(run('(2+3)*4'), '20');
    expect(run('5*-3'), '-15');
    expect(run('-(2+3'), '-5'); // paréntesis sin cerrar
    expect(run('2(3)'), '6');
    expect(run('10-2-3'), '5');
    expect(run('8/2/2'), '2');
  });

  test('decimales sin ruido de coma flotante', () {
    expect(run('0.1+0.2'), '0.3');
    expect(run('1/3'), '0.333333333333');
    expect(run('5.'), '5');
    expect(run('.5*2'), '1');
    expect(run('2.5*2'), '5');
  });

  test('porcentaje', () {
    expect(run('50%'), '0.5');
    expect(run('10%50'), '5');
    expect(run('200*10%'), '20');
  });

  test('encadenar con resultados en notación científica', () {
    final big = run('100000000000*100000000000');
    expect(run('$big/100000000000'), '100000000000');
    expect(run('${run('1/10000000')}*10000000'), '1');
  });

  test('errores', () {
    expect(() => evaluate('5/0'), throwsA(isA<CalcError>()));
    expect(() => evaluate('5/(2-2)'), throwsA(isA<CalcError>()));
    expect(() => evaluate('5+'), throwsFormatException);
    expect(() => evaluate('1.2.3'), throwsFormatException);
    expect(() => evaluate(''), throwsFormatException);
  });

  test('reglas de entrada', () {
    expect(insertOperator('', '+'), '');
    expect(insertOperator('', '-'), '-');
    expect(insertOperator('5+', '*'), '5*');
    expect(insertOperator('5*', '-'), '5*-');
    expect(insertOperator('5*-', '+'), '5+');
    expect(insertOperator('(', '*'), '(');
    expect(insertOperator('5', '%'), '5%');
    expect(insertOperator('5+', '%'), '5+');
    expect(insertDigit('1.2', '.'), '1.2');
    expect(insertDigit('1+', '.'), '1+0.');
    expect(insertDigit('(2)', '3'), '(2)*3');
    expect(insertParenthesis(''), '(');
    expect(insertParenthesis('(2'), '(2)');
    expect(insertParenthesis('2'), '2*(');
    expect(insertParenthesis('2+'), '2+(');
  });
}
