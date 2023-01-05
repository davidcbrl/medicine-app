import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:medicine/main.dart';

class NotificationProvider {

  static Future<void> init() async {
    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic Notifications',
          channelDescription: 'Basic Notifications Description',
          defaultColor: Colors.teal,
          importance: NotificationImportance.High,
          channelShowBadge: true,
        ),
        NotificationChannel(
          channelKey: 'scheduled_channel',
          channelName: 'Scheduled Notifications',
          channelDescription: 'Scheduled Notifications Description',
          defaultColor: Colors.teal,
          importance: NotificationImportance.High,
          defaultRingtoneType: DefaultRingtoneType.Alarm,
          playSound: true,
          locked: true,
          enableVibration: true,
          criticalAlerts: true,
          onlyAlertOnce: false,
        ),
      ],
      debug: true,
    );
  }

  static void listen() {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );
  }

  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
    if (kDebugMode) {
      print('Notification Created on ${receivedNotification.channelKey}');
    }
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
    if (kDebugMode) {
      print('Notification Displayed on ${receivedNotification.channelKey}');
    }
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
    if (kDebugMode) {
      print('Notification Dismissed on ${receivedAction.channelKey}');
    }
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    if (kDebugMode) {
      print('Notification Acted on ${receivedAction.channelKey}');
    }
    MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/home',
      (Route route) => (route.settings.name != '/home') || route.isFirst,
      arguments: {'pageIndex': 1},
    );
  }

  static Future<void> create({
    required NotificationContent content,
    List<NotificationActionButton>? actions,
    NotificationSchedule? schedule,
  }) async {
    await AwesomeNotifications().createNotification(
      content: content,
      actionButtons: actions,
      schedule: schedule,
    );
  }

  static Future<void> cancel() async {
    await AwesomeNotifications().cancelAllSchedules();
  }

}
