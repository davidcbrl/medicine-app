import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomStepperWidget extends StatelessWidget {
  final List<CustomStepperStep> steps;
  final int current;

  const CustomStepperWidget({
    super.key,
    required this.steps,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(
              steps.length,
              (index) => Row(
                children: [
                  if (index > 0) ...[
                    Container(
                      width: (kIsWeb ? 360 : MediaQuery.of(context).size.width) / steps.length,
                      height: 2.5,
                      color: (index + 1) <= current ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.tertiary,
                    ),
                  ],
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (index + 1) <= current ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.tertiary,
                    ),
                    child: Icon(
                      steps[index].icon,
                      color: (index + 1) <= current ? Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.secondary,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CustomStepperStep {
  final IconData icon;
  final String label;

  const CustomStepperStep({
    required this.icon,
    required this.label,
  });
}
