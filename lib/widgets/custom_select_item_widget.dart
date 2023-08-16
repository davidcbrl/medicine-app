import 'package:flutter/material.dart';

class CustomSelectItemWidget extends StatelessWidget {
  final String label;
  final Function() onPressed;
  final Widget? image;
  final Icon? icon;
  final bool selected;

  const CustomSelectItemWidget({
    super.key,
    required this.label,
    required this.onPressed,
    this.image,
    this.icon,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: selected ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.tertiary,
        borderRadius: BorderRadius.circular(30),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: selected ? Theme.of(context).textTheme.displayMedium : Theme.of(context).textTheme.labelMedium,
              ),
              if (image != null) ...[
                const SizedBox(
                  width: 10,
                ),
                image ?? Container(),
              ],
              if (icon != null) ...[
                const SizedBox(
                  width: 10,
                ),
                icon ?? Container(),
              ],
              if (selected) ...[
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Selecionado',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
