import 'package:flutter/material.dart';

class CustomOptionFieldWidget extends StatelessWidget {
  final String label;
  final String placeholder;
  final Function() onPressed;
  final String? value;

  const CustomOptionFieldWidget({
    super.key,
    required this.label,
    required this.placeholder,
    required this.onPressed,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary,
            borderRadius: BorderRadius.circular(30),
          ),
          child: InkWell(
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      value == null ? placeholder : value ?? '',
                      style: value == null ? Theme.of(context).textTheme.bodyMedium : Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.chevron_right_outlined,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
