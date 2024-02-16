import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine/pages/auth/auth_page.dart';
import 'package:medicine/pages/auth/auth_password_page.dart';
import 'package:medicine/pages/home/home_page.dart';
import 'package:medicine/pages/notification/notification_page.dart';
import 'package:medicine/pages/alarm/alarm_info_page.dart';
import 'package:medicine/pages/alarm/alarm_medicine_page.dart';
import 'package:medicine/pages/alarm/alarm_review_page.dart';
import 'package:medicine/pages/user/user_register_page.dart';
import 'package:medicine/pages/user/user_info_page.dart';
import 'package:medicine/providers/notification_provider.dart';

class RouteController extends GetxController {
  static const String authRoute = '/auth';
  static const String authPasswordRoute = '/auth/password';
  static const String homeRoute = '/home';
  static const String notificationRoute = '/notification';
  static const String alarmMedicineRoute = '/alarm/medicine';
  static const String alarmInfoRoute = '/alarm/info';
  static const String alarmReviewRoute = '/alarm/review';
  static const String userRegisterRoute = '/user/register';
  static const String userInfoRoute = '/user/info';

  List<Route<dynamic>> onGenerateInitialRoutes({required String initialRouteName, bool isAuthenticated = false}) {
    List<Route<dynamic>> pageStack = [];
    pageStack.add(
      MaterialPageRoute(
        builder: (_) => !isAuthenticated ? const AuthPage() : const HomePage(),
      ),
    );
    if (initialRouteName == notificationRoute && NotificationProvider.initialAction != null) {
      pageStack.add(
        MaterialPageRoute(
          builder: (_) => NotificationPage(
            receivedAction: NotificationProvider.initialAction!,
          ),
        ),
      );
    }
    return pageStack;
  }

  Route<dynamic>? onGenerateRoute({required RouteSettings settings}) {
    switch (settings.name) {
      case authRoute:
        return MaterialPageRoute(
          builder: (_) => const AuthPage(),
        );
      case authPasswordRoute:
        return MaterialPageRoute(
          builder: (_) => const AuthPasswordPage(),
        );
      case homeRoute:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
        );
      case notificationRoute:
        ReceivedAction receivedAction = settings.arguments as ReceivedAction;
        return MaterialPageRoute(
          builder: (_) => NotificationPage(
            receivedAction: receivedAction,
          ),
        );
      case alarmMedicineRoute:
        return CustomMaterialPageRoute(
          builder: (_) => const AlarmMedicinePage(),
          settings: settings,
        );
      case alarmInfoRoute:
        return CustomMaterialPageRoute(
          builder: (_) => const AlarmInfoPage(),
          settings: settings,
        );
      case alarmReviewRoute:
        return CustomMaterialPageRoute(
          builder: (_) => const AlarmReviewPage(),
          settings: settings,
        );
      case userRegisterRoute:
        return CustomMaterialPageRoute(
          builder: (_) => const UserRegisterPage(),
          settings: settings,
        );
      case userInfoRoute:
        return CustomMaterialPageRoute(
          builder: (_) => const UserInfoPage(),
          settings: settings,
        );
    }
    return null;
  }
}

class CustomMaterialPageRoute<T> extends MaterialPageRoute<T> {
  CustomMaterialPageRoute({
    required super.builder,
    required RouteSettings super.settings,
  });

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (settings.name == '/home') {
      return child;
    }
    return CupertinoPageTransition(
      primaryRouteAnimation: animation,
      secondaryRouteAnimation: secondaryAnimation,
      linearTransition: true,
      child: child,
    );
  }
}
