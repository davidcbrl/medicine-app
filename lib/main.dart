import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:medicine/controllers/route_controller.dart';
import 'package:medicine/routes/routes.dart';

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Manrope',
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF662C91),
          secondary: Color(0xFF3A3A3A),
          tertiary: Color(0xFFF0F0F0),
          background: Color(0xFFFFFFFF),
        ),
      ),
      initialRoute: '/home',
      initialBinding: BindingsBuilder(() => Get.put<RouteController>(RouteController())),
      getPages: getRoutes(),
    );
  }
}
