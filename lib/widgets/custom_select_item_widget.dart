import 'package:flutter/material.dart';

class CustomSelectItemWidget extends StatelessWidget {
  final String label;
  final Function() onPressed;
  final Widget? image;

  const CustomSelectItemWidget({
    super.key,
    required this.label,
    required this.onPressed,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: InkWell(
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  if (image != null) ...[
                    const SizedBox(
                      width: 10,
                    ),
                    image ?? Container(),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
