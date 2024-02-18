import 'package:flutter/material.dart';

class CustomEmptyWidget extends StatelessWidget {
  final String label;
  final double? size;
  final bool showIcon;

  const CustomEmptyWidget({
    super.key,
    required this.label,
    this.size,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 10,
        ),
        if (showIcon) ...[
          Image.asset(
            'assets/img/empty.png',
            height: size ?? 125,
          ),
        ],
      ],
    );
  }
}
