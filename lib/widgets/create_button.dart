import 'package:flutter/material.dart';

class CreateButton extends StatelessWidget {
  final Color color, textColor;
  final String text;
  final IconData? icon;
  final VoidCallback action;

  const CreateButton({
    super.key,
    required this.color,
    required this.textColor,
    required this.text,
    required this.action,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Material(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: action,
          child: Center(
            child: icon != null
                ? Icon(icon, color: textColor, size: 28, semanticLabel: text)
                : Text(
                    text,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 28,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
