import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:medicine/controllers/notification_controller.dart';
import 'package:medicine/controllers/route_controller.dart';
import 'package:medicine/widgets/custom_page_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GetStorage box = GetStorage();
  RouteController routeController = Get.put(RouteController(), permanent: true);
  NotificationController notificationController = Get.put(NotificationController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return CustomPageWidget(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Meus remédios',
            ),
          ],
        ),
      ),
      floating: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 20),
            FloatingActionButton(
              heroTag: '1',
              tooltip: 'Create New notification',
              backgroundColor: Theme.of(context).colorScheme.primary,
              onPressed: () => notificationController.createMedicineNotification(),
              child: Icon(
                Icons.outgoing_mail,
                color: Theme.of(context).colorScheme.tertiaryContainer,
              ),
            ),
            const SizedBox(width: 10),
            FloatingActionButton(
              heroTag: '2',
              tooltip: 'Schedule New notification',
              backgroundColor: Theme.of(context).colorScheme.primary,
              onPressed: () => notificationController.createMedicineNotificationScheduled(),
              child: Icon(
                Icons.access_time_outlined,
                color: Theme.of(context).colorScheme.tertiaryContainer,
              ),
            ),
            const SizedBox(width: 10),
            FloatingActionButton(
              heroTag: '3',
              tooltip: 'Reset badge counter',
              backgroundColor: Theme.of(context).colorScheme.primary,
              onPressed: () => notificationController.resetBadgeCounter(),
              child: Icon(
                Icons.exposure_zero,
                color: Theme.of(context).colorScheme.tertiaryContainer,
              ),
            ),
            const SizedBox(width: 10),
            FloatingActionButton(
              heroTag: '4',
              tooltip: 'Cancel all notifications',
              backgroundColor: Theme.of(context).colorScheme.primary,
              onPressed: () => notificationController.cancelScheduledNotifications(),
              child: Icon(
                Icons.delete_forever,
                color: Theme.of(context).colorScheme.tertiaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
