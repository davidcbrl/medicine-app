import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:medicine/main.dart';
import 'package:http/http.dart' as http;

class NotificationProvider {
  static ReceivedAction? initialAction;

  static Future<void> init() async {
    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'alerts',
          channelName: 'Alertas',
          channelDescription: 'Alertas',
          groupAlertBehavior: GroupAlertBehavior.Children,
          importance: NotificationImportance.High,
          defaultPrivacy: NotificationPrivacy.Private,
          defaultColor: const Color(0xFF662C91),
          ledColor: const Color(0xFF662C91),
          playSound: true,
          onlyAlertOnce: true,
          locked: true,
          enableVibration: true,
          criticalAlerts: true,
        ),
      ],
      debug: true,
    );
    initialAction = await AwesomeNotifications().getInitialNotificationAction(
      removeFromActionEvents: false,
    );
  }

  static void listen() {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
    );
  }

  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    if(receivedAction.actionType == ActionType.SilentAction || receivedAction.actionType == ActionType.SilentBackgroundAction) {
      if (kDebugMode) print('Mensagem enviada via notificação: "${receivedAction.buttonKeyInput}"');
      await executeLongTaskInBackground();
    } else {
      MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
        '/alarm',
        (route) => (route.settings.name != '/alarm') || route.isFirst,
        arguments: receivedAction
      );
    }
  }

  static Future<void> executeLongTaskInBackground() async {
    if (kDebugMode) print("Tarefa em segundo plano iniciada");
    await Future.delayed(const Duration(seconds: 4));
    final url = Uri.parse("http://google.com");
    final re = await http.get(url);
    if (kDebugMode) print(re.body);
    if (kDebugMode) print("Tarefa em segundo plano finalizada");
  }

  static Future<bool> displayNotificationRationale() async {
    bool userAuthorized = false;
    BuildContext context = MyApp.navigatorKey.currentContext!;
    await showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text(
            'Permitir notificações',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              SizedBox(
                height: 20
              ),
              Text(
                'Permita que o aplicativo envie notificações',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text(
                'Não permitir',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                userAuthorized = true;
                Navigator.of(ctx).pop();
              },
              child: Text(
                'Permitir',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
    return userAuthorized && await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  static Future<void> create({
    required NotificationContent content,
    List<NotificationActionButton>? actions,
    NotificationSchedule? schedule,
  }) async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) isAllowed = await displayNotificationRationale();
    if (!isAllowed) return;

    await AwesomeNotifications().createNotification(
      content: content,
      actionButtons: actions,
      schedule: schedule,
    );
  }

  static Future<void> cancel() async {
    await AwesomeNotifications().cancelAllSchedules();
  }

  static Future<void> reset() async {
    await AwesomeNotifications().resetGlobalBadge();
  }
}
