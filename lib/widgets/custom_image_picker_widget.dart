import 'dart:convert';

import 'package:flutter/material.dart';

class CustomImagePickerWidget extends StatelessWidget {
  final String label;
  final Function() onPressed;
  final Icon? icon;
  final String? image;

  const CustomImagePickerWidget({
    super.key, 
    required this.label,
    required this.onPressed,
    this.icon,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
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
                            child: image!.contains('http')
                              ? Image.network(image!)
                              : Image.memory(base64Decode(image!)),
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
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
