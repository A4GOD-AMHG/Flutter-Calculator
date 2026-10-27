import 'package:calculadora/providers/calc_provider.dart';
import 'package:calculadora/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final calc = context.watch<CalcProvider>();
    final theme = context.watch<ThemeProvider>();
    final colors = Theme.of(context).colorScheme;
    final error = calc.error;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.15),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 8, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    tooltip: theme.isDarkmode ? 'Modo claro' : 'Modo oscuro',
                    onPressed: theme.toggle,
                    icon: Icon(
                      theme.isDarkmode
                          ? Icons.light_mode_outlined
                          : Icons.dark_mode_outlined,
                    ),
                  ),
                  PopupMenuButton<int>(
                    tooltip: 'Más opciones',
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 1, child: Text('Acerca de')),
                    ],
                    onSelected: (_) => _showAbout(context),
                  ),
                ],
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: TextField(
                  decoration: const InputDecoration.collapsed(hintText: '0'),
                  readOnly: true,
                  autofocus: true,
                  showCursor: true,
                  controller: calc.controller,
                  focusNode: calc.focusNode,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: calc.inputFontSize,
                    fontWeight: FontWeight.w300,
                  ),
                  cursorWidth: 2,
                  cursorColor: colors.primary,
                  cursorRadius: const Radius.circular(20),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  child: Text(
                    error ?? calc.preview,
                    key: ValueKey(error ?? calc.preview),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 24,
                      color: error != null
                          ? colors.error
                          : colors.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Información', textAlign: TextAlign.center),
        children: [
          const ListTile(
            leading: Icon(Icons.phone),
            title: Text('Alexis Manuel Hurtado García'),
            subtitle: Text('+53 55529865'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}
