import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:medicine/main.dart';
import 'package:http/http.dart' as http;

class NotificationProvider {
  static ReceivedAction? initialAction;

  static Future<void> init() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'alerts',
          channelName: 'Alertas',
          channelDescription: 'Alertas',
          groupAlertBehavior: GroupAlertBehavior.All,
          importance: NotificationImportance.High,
          // defaultPrivacy: NotificationPrivacy.Private,
          defaultColor: const Color(0xFF662C91),
          ledColor: const Color(0xFF662C91),
          defaultRingtoneType: DefaultRingtoneType.Alarm,
          playSound: true,
          // onlyAlertOnce: true,
          // locked: true,
          enableVibration: true,
          // criticalAlerts: true,
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
        '/notification',
        (route) => (route.settings.name != '/notification') || route.isFirst,
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

  static Future<bool> displayNotificationRationale({required BuildContext context}) async {
    bool userAuthorized = false;
    if (kIsWeb) {
      await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text(
              'Atenção',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 20
                ),
                Text(
                  'As notificações não estão disponíveis na versão de navegador, somente via aplicativo.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text(
                  'OK',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          );
        },
      );
      return userAuthorized;
    }
    await showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text(
            'Permitir notificações',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 20
              ),
              Text(
                'Para que os alarmes funcionem corretamente, permita o envio de notificações',
                style: Theme.of(context).textTheme.bodyMedium,
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

  static Future<List<NotificationPermission>> requestUserPermissions({
    required BuildContext context,
    required String? channelKey,
    required List<NotificationPermission> permissionList,
  }) async {
    if (!await AwesomeNotifications().requestPermissionToSendNotifications()) {
      return [];
    }

    List<NotificationPermission> permissionsAllowed = await AwesomeNotifications().checkPermissionList(
      channelKey: channelKey,
      permissions: permissionList,
    );

    if (permissionsAllowed.length == permissionList.length) {
      return permissionsAllowed;
    }

    List<NotificationPermission> permissionsNeeded = permissionList.toSet().difference(
      permissionsAllowed.toSet(),
    ).toList();

    List<NotificationPermission> lockedPermissions = await AwesomeNotifications().shouldShowRationaleToRequest(
      channelKey: channelKey,
      permissions: permissionsNeeded,
    );

    if (lockedPermissions.isEmpty) {
      await AwesomeNotifications().requestPermissionToSendNotifications(
        channelKey: channelKey,
        permissions: permissionsNeeded,
      );
      permissionsAllowed = await AwesomeNotifications().checkPermissionList(
        channelKey: channelKey,
        permissions: permissionsNeeded,
      );
    } else if (context.mounted) {
      await showDialog(
        context: context,
        builder: (BuildContext ctx) => AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Text(
            'Permitir recursos extras',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Para que os alarmes funcionem corretamente, precisamos que permita os recursos a seguir:',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                lockedPermissions.join(', ').replaceAll('NotificationPermission.', ''),
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: Text(
                'Não permitir',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              )
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                await AwesomeNotifications().requestPermissionToSendNotifications(
                  channelKey: channelKey,
                  permissions: lockedPermissions,
                );
                permissionsAllowed = await AwesomeNotifications().checkPermissionList(
                  channelKey: channelKey,
                  permissions: lockedPermissions,
                );
              },
              child: Text(
                'Permitir',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return permissionsAllowed;
  }

  static Future<void> create({
    required NotificationContent content,
    List<NotificationActionButton>? actions,
    NotificationSchedule? schedule,
  }) async {
    BuildContext context = MyApp.navigatorKey.currentContext!;

    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed && context.mounted) isAllowed = await displayNotificationRationale(context: context);
    if (!isAllowed) return;

    if (context.mounted) {
      await requestUserPermissions(
        context: context,
        channelKey: 'alerts',
        permissionList: [
          NotificationPermission.Alert,
          NotificationPermission.Sound,
          // NotificationPermission.Badge,
          NotificationPermission.Light,
          NotificationPermission.Vibration,
          NotificationPermission.PreciseAlarms,
          // NotificationPermission.CriticalAlert,
          // NotificationPermission.OverrideDnD,
        ],
      );
    }

    await AwesomeNotifications().createNotification(
      content: content,
      actionButtons: actions,
      schedule: schedule,
    );
  }

  static Future<void> cancel({int? id}) async {
    if (id != null) {
      await AwesomeNotifications().cancelSchedule(id);
      return;
    }

    await AwesomeNotifications().cancelAllSchedules();
  }

  static Future<void> reset() async {
    await AwesomeNotifications().resetGlobalBadge();
  }
}
