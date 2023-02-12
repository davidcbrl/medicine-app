import 'package:flutter/material.dart';

class CustomTextButtonWidget extends StatelessWidget {
  final String label;
  final Function() onPressed;

  const CustomTextButtonWidget({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.labelMedium,
      ),
    );
  }
}
