import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:medicine/controllers/notification_controller.dart';
import 'package:medicine/controllers/route_controller.dart';
import 'package:medicine/pages/medicines/alarm_page.dart';
import 'package:medicine/pages/medicines/medicines_page.dart';
import 'package:medicine/utilities/functions.dart';
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
  NotificationController notificationController = Get.put(NotificationController(), permanent: true);

  @override
  void initState() {
    pageController = PageController(initialPage: widget.pageIndex);
    routeController.pageIndex.value = widget.pageIndex;
    _requestNotificationPermission(context);
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
      floating: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: '1',
              tooltip: 'New medicine notification',
              backgroundColor: Theme.of(context).colorScheme.primary,
              onPressed: () => notificationController.createMedicineNotification(),
              child: const Icon(
                Icons.alarm_outlined,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 20),
            FloatingActionButton(
              heroTag: '2',
              tooltip: 'New medicine notification scheduled',
              backgroundColor: Theme.of(context).colorScheme.primary,
              onPressed: () async {
                NotificationWeekAndTime? pickedSchedule = await pickSchedule(context);
                if (pickedSchedule != null) {
                  notificationController.createMedicineNotificationScheduled(pickedSchedule);
                }
              },
              child: const Icon(
                Icons.alarm_add_outlined,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 20),
            FloatingActionButton(
              heroTag: '3',
              tooltip: 'Cancel scheduled notifications',
              backgroundColor: Theme.of(context).colorScheme.primary,
              onPressed: () => notificationController.cancelScheduledNotifications(),
              child: const Icon(
                Icons.alarm_off_outlined,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
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

  void _requestNotificationPermission(BuildContext context) {
    AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) {
        if (!isAllowed) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Allow Notifications'),
              content: const Text('Our app would like to send you notifications'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Don\'t Allow',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => AwesomeNotifications().requestPermissionToSendNotifications().then(
                    (_) => Navigator.pop(context),
                  ),
                  child: const Text(
                    'Allow',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
