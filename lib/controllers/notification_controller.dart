import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:medicine/models/medicine_notification.dart';
import 'package:medicine/providers/notification_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationController extends GetxController {
  @override
  onInit() {
    super.onInit();
    NotificationProvider().initPermission();
    checkAndroidNotificationPermission();
    checkAndroidScheduleExactAlarmPermission();
  }

  Future<void> checkAndroidNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      if (kDebugMode) print('Requesting notification permission...');
      final res = await Permission.notification.request();
      if (kDebugMode) print('Notification permission ${res.isGranted ? '' : 'not '}granted.');
    }
  }

  Future<void> checkAndroidScheduleExactAlarmPermission() async {
    final status = await Permission.scheduleExactAlarm.status;
    if (kDebugMode) print('Schedule exact alarm permission: $status.');
    if (status.isDenied) {
      if (kDebugMode) print('Requesting schedule exact alarm permission...');
      final res = await Permission.scheduleExactAlarm.request();
      if (kDebugMode) print('Schedule exact alarm permission ${res.isGranted ? '' : 'not'} granted.');
    }
  }

  Future<void> createMedicineNotification({required PushNotification notification}) async {
    await NotificationProvider().notify(notification: notification);
  }

  Future<void> createMedicineNotificationScheduled({required PushNotification notification}) async {
    await NotificationProvider().schedule(notification: notification);
  }

  Future<void> cancelScheduledNotification({required int id}) async {
    await NotificationProvider().cancel(id: id);
  }
}
