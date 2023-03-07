import 'package:flutter/material.dart';

class CustomTextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String placeholder;
  final Icon? icon;
  final bool hideText;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final Function(String)? onChanged;
  final bool readOnly;
  final dynamic onTap;

  const CustomTextFieldWidget({
    super.key, 
    required this.controller,
    required this.label,
    required this.placeholder,
    this.icon,
    this.onChanged,
    this.hideText = false,
    this.validator,
    this.keyboardType,
    this.onTap,
    this.readOnly = false
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
        TextFormField(
          onChanged: onChanged,
          readOnly: readOnly,
          enabled: !readOnly,
          onTap: onTap,
          controller: controller,
          style: Theme.of(context).textTheme.labelMedium,
          obscureText: hideText,
          validator: validator,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(left: 20),
            hintText: placeholder,
            hintStyle: Theme.of(context).textTheme.bodyMedium,
            filled: true,
            fillColor: readOnly ? Theme.of(context).colorScheme.background : Theme.of(context).colorScheme.tertiary,
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: icon,
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.tertiary,
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.tertiary,
                width: 2,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
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
