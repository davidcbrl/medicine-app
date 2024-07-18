import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomImagePickerWidget extends StatelessWidget {
  final String label;
  final Function() onPressed;
  final Icon? icon;
  final Uint8List? image;

  const CustomImagePickerWidget({
    super.key, 
    required this.label,
    required this.onPressed,
    this.icon,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    if (image != null) ...[
                      SizedBox(
                        height: 80,
                        width: 80,
                        child: Image.memory(image!),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                    Text(
                      label,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              if (icon != null) ...[
                const SizedBox(
                  width: 10,
                ),
                icon ?? Container(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
