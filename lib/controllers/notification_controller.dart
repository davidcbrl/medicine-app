import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:medicine/models/medicine_notification.dart';
import 'package:medicine/providers/notification_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationController extends GetxController with StateMixin {
  var loading = false.obs;

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
    try {
      loading.value = true;
      change([], status: RxStatus.loading());
      await NotificationProvider().notify(notification: notification);
      change([], status: RxStatus.success());
      loading.value = false;
    } catch (error) {
      if (kDebugMode) print(error);
      change([], status: RxStatus.error('Falha ao disparar notificação'));
      loading.value = false;
    }
  }

  Future<void> createMedicineNotificationScheduled({required PushNotification notification}) async {
    try {
      loading.value = true;
      change([], status: RxStatus.loading());
      await NotificationProvider().schedule(notification: notification);
      change([], status: RxStatus.success());
      loading.value = false;
    } catch (error) {
      if (kDebugMode) print(error);
      change([], status: RxStatus.error('Falha ao agendar notificações'));
      loading.value = false;
    }
  }

  Future<void> cancelScheduledNotification({required int id}) async {
    try {
      loading.value = true;
      change([], status: RxStatus.loading());
      await NotificationProvider().cancel(id: id);
      change([], status: RxStatus.success());
      loading.value = false;
    } catch (error) {
      if (kDebugMode) print(error);
      change([], status: RxStatus.error('Falha ao cancelar notificação'));
      loading.value = false;
    }
  }

  Future<void> cancelAllScheduledNotifications() async {
    try {
      loading.value = true;
      change([], status: RxStatus.loading());
      await NotificationProvider().cancelAll();
      change([], status: RxStatus.success());
      loading.value = false;
    } catch (error) {
      if (kDebugMode) print(error);
      change([], status: RxStatus.error('Falha ao cancelar as notificações'));
      loading.value = false;
    }
  }

  Future<void> enableAllScheduledNotifications({required List<PushNotification> notifications}) async {
    try {
      loading.value = true;
      change([], status: RxStatus.loading());
      for (PushNotification notification in notifications) {
        await createMedicineNotificationScheduled(notification: notification);
      }
      change([], status: RxStatus.success());
      loading.value = false;
    } catch (error) {
      if (kDebugMode) print(error);
      change([], status: RxStatus.error('Falha ao reagendar as notificações'));
      loading.value = false;
    }
  }
}
