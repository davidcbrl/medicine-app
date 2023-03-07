import 'package:flutter/material.dart';

class CustomListItemWidget extends StatelessWidget {
  final String label;
  final Function() onPressed;
  final String buttonLabel;
  final String? prefixLabel;
  final String? description;

  const CustomListItemWidget({
    super.key,
    required this.label,
    required this.onPressed,
    required this.buttonLabel,
    this.prefixLabel,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                if (prefixLabel != null) ...[
                  Text(
                    prefixLabel ?? '',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                ],
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Text(
                          label,
                          style: Theme.of(context).textTheme.labelMedium,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      if (description != null) ...[
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  description ?? '',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Text(
                  buttonLabel,
                  textAlign: TextAlign.end,
                  style: Theme.of(context).textTheme.titleSmall,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
