import 'package:get/get.dart';
import 'package:medicine/pages/home/home_page.dart';

final routes = [
  GetPage(
    name: '/home',
    page: () => const HomePage(),
  ),
];

getRoutes() {
  return List.of(routes);
}
