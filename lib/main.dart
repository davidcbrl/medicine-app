import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:medicine/controllers/route_controller.dart';
import 'package:medicine/providers/notification_provider.dart';
import 'package:medicine/routes/routes.dart';

void main() async {
  await GetStorage.init();
  await NotificationProvider.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    NotificationProvider.listen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF662C91),
          secondary: Color(0xFF3A3A3A),
          tertiary: Color(0xFFF0F0F0),
          background: Color(0xFFFFFFFF),
        ),
      ),
      navigatorKey: MyApp.navigatorKey,
      getPages: getRoutes(),
      initialRoute: '/home',
      initialBinding: BindingsBuilder(
        () => Get.put<RouteController>(RouteController()),
      ),
    );
  }
}
