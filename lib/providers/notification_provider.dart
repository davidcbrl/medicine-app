import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medicine/main.dart';
import 'package:medicine/models/push_notification.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class NotificationProvider {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(android: AndroidInitializationSettings('@mipmap/ic_launcher')),
      onDidReceiveNotificationResponse: notificationCallback,
      onDidReceiveBackgroundNotificationResponse: notificationCallback,
    );
  }

  Future<void> initPermission() async {
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!.requestNotificationsPermission();
  }

  Future<void> notify({required PushNotification notification}) async {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'alarms',
      'Alarmes',
      channelDescription: 'Notificações push de lembrete para os remédios agendados no app.',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      enableVibration: true,
      fullScreenIntent: true,
      ongoing: true,
      playSound: true,
      onlyAlertOnce: false,
      silent: false,
      category: AndroidNotificationCategory.alarm,
      sound: RawResourceAndroidNotificationSound('alarm'),
    );
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    await flutterLocalNotificationsPlugin.show(
      notification.id,
      notification.title,
      notification.body,
      notificationDetails,
      payload: notification.payload,
    );
  }

  Future<void> schedule({required PushNotification notification}) async {
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    final DateTime currentDate = DateTime.now();
    tz.TZDateTime tzDateTime = tz.TZDateTime.from(
      notification.date ?? currentDate,
      tz.getLocation(currentTimeZone)
    );
    if (tzDateTime.isBefore(currentDate)) {
      return;
    }
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'alarms',
      'alarms',
      channelDescription: 'alarms',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      enableVibration: true,
      fullScreenIntent: true,
      ongoing: true,
      playSound: true,
      onlyAlertOnce: false,
      silent: false,
      category: AndroidNotificationCategory.alarm,
      sound: RawResourceAndroidNotificationSound('alarm'),
    );
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    await flutterLocalNotificationsPlugin.zonedSchedule(
      notification.id,
      notification.title,
      notification.body,
      tzDateTime,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      payload: notification.payload,
    );
  }

  Future<List<PushNotification>> getActive() async {
    List<ActiveNotification> list = await flutterLocalNotificationsPlugin.getActiveNotifications();
    if (list.isEmpty) {
      return [];
    }
    return list.map((ActiveNotification notification) => PushNotification(
      id: notification.id!,
      title: notification.title!,
      body: notification.body!,
      payload: notification.payload!,
    )).toList();
  }

  Future<void> cancel({required int id}) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAll() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  @pragma('vm:entry-point')
  static void notificationCallback(NotificationResponse notificationResponse) {
    if (notificationResponse.payload != null) {
      if (kDebugMode) print('Notification payload: ${notificationResponse.payload}');
    }
    MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/notification',
      (route) => (route.settings.name != '/notification') || route.isFirst,
      arguments: jsonDecode(notificationResponse.payload ?? '{}'),
    );
  }
}
