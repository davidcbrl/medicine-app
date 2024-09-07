import 'package:flutter/material.dart';

class CustomButtonWidget extends StatelessWidget {
  final String label;
  final Function() onPressed;
  final Icon? icon;
  final double width;
  final TextAlign? labelAlignment;

  const CustomButtonWidget({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.width = double.infinity,
    this.labelAlignment = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(
            Theme.of(context).colorScheme.primary,
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.displayMedium,
              textAlign: labelAlignment ?? TextAlign.start,
            ),
            if (icon != null) ...[
              const SizedBox(
                width: 10,
              ),
              icon!,
            ],
          ],
        ),
      ),
    );
  }
}
