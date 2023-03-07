import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine/controllers/route_controller.dart';
import 'package:medicine/providers/notification_provider.dart';

void main() async {
  await NotificationProvider.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final RouteController _routeController = RouteController();

  @override
  void initState() {
    NotificationProvider.listen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Medicine',
      theme: ThemeData(
        fontFamily: 'Manrope',
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF662C91),
          secondary: Color(0xFF3A3A3A),
          secondaryContainer: Color(0xFF7C7C7C),
          tertiary: Color(0xFFF0F0F0),
          background: Color(0xFFFFFFFF),
          error: Color(0xFFEB5757),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            color: Color(0xFF662C91),
            fontSize: 40,
            fontWeight: FontWeight.w900,
          ),
          titleSmall: TextStyle(
            color: Color(0xFF662C91),
            fontSize: 15,
            fontWeight: FontWeight.w900,
          ),
          labelMedium: TextStyle(
            color: Color(0xFF3A3A3A),
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
          bodyMedium: TextStyle(
            color: Color(0xFF3A3A3A),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          bodySmall: TextStyle(
            color: Color(0xFFEB5757),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          displayMedium: TextStyle(
            color: Color(0xFFF0F0F0),
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      navigatorKey: MyApp.navigatorKey,
      onGenerateInitialRoutes: _routeController.onGenerateInitialRoutes,
      onGenerateRoute: _routeController.onGenerateRoute,
    );
  }
}
