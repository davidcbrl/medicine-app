import 'package:flutter/material.dart';

class CustomEmptyWidget extends StatelessWidget {
  final String label;
  final double? size;

  const CustomEmptyWidget({
    super.key,
    required this.label,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/img/empty.png',
          height: size ?? 150,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
