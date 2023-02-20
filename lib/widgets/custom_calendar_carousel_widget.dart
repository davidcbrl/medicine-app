import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomCalendarCarouselWidget extends StatefulWidget {
  const CustomCalendarCarouselWidget({super.key});

  @override
  State<CustomCalendarCarouselWidget> createState() => _CustomCalendarCarouselWidgetState();
}

class _CustomCalendarCarouselWidgetState extends State<CustomCalendarCarouselWidget> {
  DateTime currentDate = DateTime.now();
  DateTime displayDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          DateFormat('MMMM, yyyy').format(displayDate),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    displayDate = DateTime(displayDate.year, displayDate.month - 1, displayDate.day);
                  });
                },
                child: Container(
                  padding: const EdgeInsets.only(left: 5, top: 5, right: 15, bottom: 5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.chevron_left_rounded,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 20,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Mês anterior',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    displayDate = DateTime(displayDate.year, displayDate.month + 1, displayDate.day);
                  });
                },
                child: Container(
                  padding: const EdgeInsets.only(left: 15, top: 5, right: 5, bottom: 5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Próximo mês',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 60,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ...List.generate(
                DateTime(displayDate.year, displayDate.month, 0).day,
                (index) {
                  bool isToday = (index + 1) == currentDate.day && currentDate.month == displayDate.month;
                  return Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isToday ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.tertiary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        width: 60,
                        height: 60,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Dia',
                              style: isToday ? Theme.of(context).textTheme.displayMedium : Theme.of(context).textTheme.labelMedium,
                            ),
                            Text(
                              '${index + 1}',
                              style: isToday ? Theme.of(context).textTheme.displayMedium : Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
