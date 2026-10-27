import 'package:calculadora/providers/calc_provider.dart';
import 'package:calculadora/widgets/create_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GridViewButtons extends StatelessWidget {
  final List<String> allButtons;
  const GridViewButtons({super.key, required this.allButtons});

  static const _symbols = {'/': '÷', '*': '×', '-': '−'};

  @override
  Widget build(BuildContext context) {
    final calcs = context.read<CalcProvider>();
    final colors = Theme.of(context).colorScheme;
    const columns = 4;
    final rows = (allButtons.length / columns).ceil();

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 16),
      child: LayoutBuilder(
        // Ajusta las celdas al espacio disponible para que nunca se recorte.
        builder: (context, constraints) => GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: allButtons.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            childAspectRatio:
                (constraints.maxWidth / columns) /
                (constraints.maxHeight / rows),
          ),
          itemBuilder: (context, index) {
            final label = allButtons[index];
            final text = _symbols[label] ?? label;
            switch (label) {
              case 'AC':
                return CreateButton(
                  color: colors.tertiaryContainer,
                  textColor: colors.onTertiaryContainer,
                  text: text,
                  action: calcs.allClear,
                );
              case '( )':
                return CreateButton(
                  color: colors.secondaryContainer,
                  textColor: colors.onSecondaryContainer,
                  text: text,
                  action: calcs.parenthesisBehavior,
                );
              case '%':
              case '/':
              case '*':
              case '-':
              case '+':
                return CreateButton(
                  color: colors.secondaryContainer,
                  textColor: colors.onSecondaryContainer,
                  text: text,
                  action: () => calcs.addOperator(label),
                );
              case 'DEL':
                return CreateButton(
                  color: colors.surfaceContainerHighest,
                  textColor: colors.onSurface,
                  text: 'Borrar',
                  icon: Icons.backspace_outlined,
                  action: calcs.delete,
                );
              case '=':
                return CreateButton(
                  color: colors.primary,
                  textColor: colors.onPrimary,
                  text: text,
                  action: calcs.equal,
                );
              default:
                return CreateButton(
                  color: colors.surfaceContainerHighest,
                  textColor: colors.onSurface,
                  text: text,
                  action: () => calcs.addDigit(label),
                );
            }
          },
        ),
      ),
    );
  }
}
