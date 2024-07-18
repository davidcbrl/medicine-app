import 'package:flutter/material.dart';

class CustomSelectItemWidget extends StatelessWidget {
  final String label;
  final Function() onPressed;
  final Widget? image;
  final bool icon;
  final bool selected;
  final double? truncateLabelWithWidth;

  const CustomSelectItemWidget({
    super.key,
    required this.label,
    required this.onPressed,
    this.image,
    this.icon = true,
    this.selected = false,
    this.truncateLabelWithWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: selected ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.tertiary,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: selected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.tertiary,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (truncateLabelWithWidth == null) ...[
                Text(
                  label,
                  style: selected ? Theme.of(context).textTheme.titleSmall : Theme.of(context).textTheme.labelMedium,
                ),
              ],
              if (truncateLabelWithWidth != null) ...[
                SizedBox(
                  width: truncateLabelWithWidth,
                  child: Text(
                    label,
                    style: selected ? Theme.of(context).textTheme.titleSmall : Theme.of(context).textTheme.labelMedium,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
              if (image != null) ...[
                const SizedBox(
                  width: 10,
                ),
                image ?? Container(),
              ],
              Row(
                children: [
                  if (selected) ...[
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Selecionado',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                  if (icon) ...[
                    const SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: selected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
                      size: 20,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
