import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:medicine/models/weekday_type.dart';

class CustomCalendarWidget extends StatelessWidget {
  final String style;
  final DateTime selectedDate;
  final Function(DateTime, List<Event>) onDayPressed;

  const CustomCalendarWidget({
    super.key,
    required this.style,
    required this.selectedDate,
    required this.onDayPressed,
  });

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case '2':
        return _customCircularCalendarCarouselWidget(context);
      case '1':
      default:
        return _customRetangularCalendarCarouselWidget(context);
    }
  }

  CalendarCarousel<Event> _customCircularCalendarCarouselWidget(BuildContext context) {
    return CalendarCarousel<Event>(
      height: MediaQuery.of(context).size.height * 0.175,
      locale: 'pt-br',
      showHeader: true,
      pageScrollPhysics: const AlwaysScrollableScrollPhysics(),
      customGridViewPhysics: const AlwaysScrollableScrollPhysics(),
      headerMargin: EdgeInsets.zero,
      headerTextStyle: Theme.of(context).textTheme.bodyMedium,
      showHeaderButton: true,
      leftButtonIcon: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Icon(
          Icons.chevron_left_rounded,
          color: Theme.of(context).colorScheme.secondary,
          size: 25,
        ),
      ),
      rightButtonIcon: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Icon(
          Icons.chevron_right_rounded,
          color: Theme.of(context).colorScheme.secondary,
          size: 25,
        ),
      ),
      weekFormat: true,
      daysHaveCircularBorder: true,
      showWeekDays: true,
      weekDayFormat: WeekdayFormat.short,
      weekdayTextStyle: Theme.of(context).textTheme.bodyMedium,
      weekendTextStyle: Theme.of(context).textTheme.labelMedium,
      daysTextStyle: Theme.of(context).textTheme.labelMedium,
      dayButtonColor: Theme.of(context).colorScheme.tertiary,
      todayTextStyle: Theme.of(context).textTheme.titleSmall,
      todayButtonColor: Theme.of(context).colorScheme.tertiary,
      todayBorderColor: Theme.of(context).colorScheme.primary,
      selectedDayTextStyle: Theme.of(context).textTheme.displayMedium,
      selectedDayButtonColor: Theme.of(context).colorScheme.primary,
      selectedDayBorderColor: Theme.of(context).colorScheme.primary,
      minSelectedDate: selectedDate.subtract(const Duration(days: 30)),
      maxSelectedDate: selectedDate.add(const Duration(days: 30)),
      selectedDateTime: selectedDate,
      onDayPressed: onDayPressed,
    );
  }

  CalendarCarousel<Event> _customRetangularCalendarCarouselWidget(BuildContext context) {
    return CalendarCarousel<Event>(
      height: MediaQuery.of(context).size.height * 0.15,
      locale: 'pt-br',
      showHeader: true,
      pageScrollPhysics: const AlwaysScrollableScrollPhysics(),
      customGridViewPhysics: const AlwaysScrollableScrollPhysics(),
      headerMargin: EdgeInsets.zero,
      headerTextStyle: Theme.of(context).textTheme.bodyMedium,
      weekFormat: true,
      showWeekDays: false,
      minSelectedDate: selectedDate.subtract(const Duration(days: 30)),
      maxSelectedDate: selectedDate.add(const Duration(days: 30)),
      selectedDateTime: selectedDate,
      daysHaveCircularBorder: false,
      dayButtonColor: Colors.transparent,
      todayBorderColor: Colors.transparent,
      todayButtonColor: Colors.transparent,
      selectedDayBorderColor: Colors.transparent,
      selectedDayButtonColor: Colors.transparent,
      customDayBuilder: (bool isSelectable, int index, bool isSelectedDay, bool isToday, bool isPrevMonthDay, TextStyle textStyle, bool isNextMonthDay, bool isThisMonthDay, DateTime day) {
        List<WeekdayType> weekdayTypeList = WeekdayType.getWeekdayTypeListStartingOnModay();
        return Container(
          width: 50,
          decoration: BoxDecoration(
            color: isSelectedDay ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.tertiary,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 1,
              color: isToday || isSelectedDay ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.tertiary,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                weekdayTypeList[day.weekday-1].name,
                style: isSelectedDay ? Theme.of(context).textTheme.displayMedium : isToday ? Theme.of(context).textTheme.titleSmall : Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                day.day.toString(),
                style: isSelectedDay ? Theme.of(context).textTheme.displayMedium : isToday ? Theme.of(context).textTheme.titleSmall : Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
        );
      },
      leftButtonIcon: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Icon(
          Icons.chevron_left_rounded,
          color: Theme.of(context).colorScheme.secondary,
          size: 25,
        ),
      ),
      rightButtonIcon: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Icon(
          Icons.chevron_right_rounded,
          color: Theme.of(context).colorScheme.secondary,
          size: 25,
        ),
      ),
      onDayPressed: onDayPressed,
    );
  }
}
