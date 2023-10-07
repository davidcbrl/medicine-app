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
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: style ?? Theme.of(context).textTheme.labelMedium,
      ),
    );
  }
}
