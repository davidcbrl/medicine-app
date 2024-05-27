import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:medicine/controllers/auth_controller.dart';
import 'package:medicine/controllers/route_controller.dart';
import 'package:medicine/providers/notification_provider.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation(DateTime.now().timeZoneName));
  await NotificationProvider().init();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final RouteController _routeController = Get.put(RouteController(), permanent: true);
  final AuthController _authController = Get.put(AuthController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) return getWeb(context);
    return getApp();
  }

  GetMaterialApp getApp() {
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
      onGenerateInitialRoutes: (initialRouteName) => _routeController.onGenerateInitialRoutes(
        initialRouteName: initialRouteName,
        isAuthenticated: _authController.isAuthenticated(),
      ),
      onGenerateRoute: (settings) => _routeController.onGenerateRoute(
        settings: settings,
      ),
    );
  }

  Container getWeb(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: const Color(0xFF3A3A3A),
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 400,
            height: MediaQuery.of(context).size.height - 40,
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: Color(0xFF662C91),
                  blurRadius: 10,
                  spreadRadius: 5,
                ),
              ],
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                width: 10,
                color: const Color(0xFF000000),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: getApp()
            ),
          ),
        ],
      ),
    );
  }
}
