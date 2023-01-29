import 'package:flutter/material.dart';

class CustomAvatarWidget extends StatelessWidget {
  final Image image;
  final String label;

  const CustomAvatarWidget({
    super.key,
    required this.image,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          child: image,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }
}
