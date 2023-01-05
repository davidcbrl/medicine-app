import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine/controllers/route_controller.dart';
import 'package:medicine/pages/home/home_page.dart';

final routes = [
  GetPage(
    name: '/home',
    page: () => HomePage(),
    binding: BindingsBuilder(
      () => Get.put<PageController>(
        PageController(initialPage: Get.find<RouteController>().pageIndex.value),
      ),
    ),
  ),
];

getRoutes() {
  return List.of(routes);
}
