
import 'package:flutter/material.dart';

class AlarmPage extends StatelessWidget {
  const AlarmPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
            const SizedBox(
                height: 20,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    Row(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                            ),
                            child: Image.asset(
                            'assets/img/ben.png',
                            width: 50,
                          ),
                        ),
                        const SizedBox(
                            width: 10,
                        ),
                        Text(
                            'Tio Ben',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                            ),
                        ),
                      ],
                    ),
                    Row(
                        children: [
                            Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.tertiary,
                                    borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                    'Falar com minha família',
                                    style: TextStyle(
                                        color: Theme.of(context).colorScheme.secondary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                    ),
                                ),
                            ),
                        ],
                    ),
                ],
            ),
            const SizedBox(
                height: 20,
            ),
            Text(
                '10:00',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                ),
            ),
        ],
    );
  }
}
