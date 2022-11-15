import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:medicine/controllers/route_controller.dart';
import 'package:medicine/pages/medicines/alarm_page.dart';
import 'package:medicine/pages/medicines/medicines_page.dart';
import 'package:medicine/widgets/custom_page_widget.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  int pageIndex;

  HomePage({super.key, this.pageIndex = 0});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  GetStorage box = GetStorage();
  PageController pageController = PageController();
  RouteController routeController = Get.put(RouteController(), permanent: true);

  @override
  void initState() {
    pageController = PageController(initialPage: widget.pageIndex);
    routeController.pageIndex.value = widget.pageIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageWidget(
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        pageSnapping: false,
        onPageChanged: (index) {
          routeController.pageIndex.value = index;
        },
        children: const [
          MedicinesPage(),
          AlarmPage(),
          MedicinesPage(),
        ],
      ),
      bottomBar: Obx(
        () => BottomNavigationBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          elevation: 10,
          currentIndex: routeController.pageIndex.value,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Theme.of(context).colorScheme.secondary,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.medication_outlined),
              label: 'Meus Remédios',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.hourglass_top_outlined),
              label: 'Alarmes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.medication_outlined),
              label: 'Meus Remedios',
            ),
          ],
          onTap: (index) {
            routeController.pageIndex.value = index;
            pageController.jumpToPage(index);
          },
        ),
      ),
    );
  }
}
