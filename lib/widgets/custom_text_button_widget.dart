import 'package:flutter/material.dart';

class CustomTextButtonWidget extends StatelessWidget {
  final String label;
  final Function() onPressed;
  final TextStyle? style;

  const CustomTextButtonWidget({
    super.key,
    required this.label,
    required this.onPressed,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: WidgetStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(
            horizontal: 20,
          ),
        ),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: style ?? Theme.of(context).textTheme.labelMedium,
      ),
    );
  }
}
