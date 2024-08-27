import 'package:flutter/material.dart';

class CustomMultiselectItemWidget extends StatelessWidget {
  final String label;
  final Function() onPressed;
  final bool selected;
  final double? width;
  final double? height;

  const CustomMultiselectItemWidget({
    super.key,
    required this.label,
    required this.onPressed,
    this.selected = false,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: selected ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.tertiary,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.tertiary,
            width: 1,
          ),
        ),
        width: width ?? 60,
        height: height ?? 50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: selected ? Theme.of(context).textTheme.titleSmall : Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
      ),
    );
  }
}
