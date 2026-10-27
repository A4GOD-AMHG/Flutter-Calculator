import 'package:calculadora/widgets/grid_view_buttons.dart';
import 'package:calculadora/widgets/header.dart';
import 'package:flutter/material.dart';

class CalcScreen extends StatelessWidget {
  const CalcScreen({super.key});

  static const allButtons = [
    'AC', '( )', '%', '/', //
    '7', '8', '9', '*', //
    '4', '5', '6', '-', //
    '1', '2', '3', '+', //
    '0', '.', 'DEL', '=',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // Limita el ancho en tablet/escritorio para que no se deforme.
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 480),
          child: const Column(
            children: [
              Expanded(flex: 2, child: Header()),
              Expanded(flex: 3, child: GridViewButtons(allButtons: allButtons)),
            ],
          ),
        ),
      ),
    );
  }
}
