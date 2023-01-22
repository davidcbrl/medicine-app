import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:medicine/pages/home/home_page.dart';
import 'package:medicine/pages/medicines/alarm_page.dart';
import 'package:medicine/providers/notification_provider.dart';

class RouteController {
  static const String homeRoute = '/home';
  static const String alarmRoute = '/alarm';

  List<Route<dynamic>> onGenerateInitialRoutes(String initialRouteName) {
    List<Route<dynamic>> pageStack = [];
    pageStack.add(
      MaterialPageRoute(
        builder: (_) => const HomePage(),
      ),
    );
    if (initialRouteName == alarmRoute && NotificationProvider.initialAction != null) {
      pageStack.add(
        MaterialPageRoute(
          builder: (_) => AlarmPage(
            receivedAction: NotificationProvider.initialAction!
          ),
        ),
      );
    }
    return pageStack;
  }

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
        );
      case alarmRoute:
        ReceivedAction receivedAction = settings.arguments as ReceivedAction;
        return MaterialPageRoute(
          builder: (_) => AlarmPage(
            receivedAction: receivedAction,
          ),
        );
    }
    return null;
  }
}
