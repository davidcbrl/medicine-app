import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:medicine/controllers/route_controller.dart';
import 'package:medicine/providers/notification_provider.dart';

void main() async {
  await GetStorage.init();
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
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF662C91),
          secondary: Color(0xFF3A3A3A),
          tertiary: Color(0xFFF0F0F0),
          background: Color(0xFFFFFFFF),
        ),
      ),
      navigatorKey: MyApp.navigatorKey,
      onGenerateInitialRoutes: _routeController.onGenerateInitialRoutes,
      onGenerateRoute: _routeController.onGenerateRoute,
    );
  }
}
