import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:medicine/providers/notification_provider.dart';

class NotificationController {

  Future<void> createMedicineNotification() async {
    await NotificationProvider.create(
      content: NotificationContent(
        id: -1,
        channelKey: 'alerts',
        title: 'Tomar remédio agora!',
        body: '25 gotas - Paracetamol 100mg',
        bigPicture: 'asset://assets/img/notification_map.png',
        notificationLayout: NotificationLayout.BigPicture,
      ),
      actions: [
        NotificationActionButton(
          key: 'REDIRECT',
          label: 'Tomar agora',
        ),
        NotificationActionButton(
          key: 'REPLY',
          label: 'Adiar',
          requireInputText: true,
          actionType: ActionType.SilentAction,
        ),
        NotificationActionButton(
          key: 'DISMISS',
          label: 'Já tomei',
          actionType: ActionType.DismissAction,
          isDangerousOption: true,
        ),
      ],
    );
  }

  Future<void> createMedicineNotificationScheduled() async {
    await NotificationProvider.create(
      content: NotificationContent(
        id: -1,
        channelKey: 'alerts',
        title: 'Tomar remédio agendado!',
        body: '6/6 horas - Paracetamol 100mg',
        bigPicture: 'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png',
        largeIcon: 'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
        notificationLayout: NotificationLayout.BigPicture,
        locked: true,
        wakeUpScreen: true,
        criticalAlert: true,
        autoDismissible: false,
        payload: {
          'notificationId': '1234567890'
        },
      ),
      actions: [
        NotificationActionButton(
          key: 'REDIRECT',
          label: 'Tomar agora',
        ),
        NotificationActionButton(
          key: 'REPLY',
          label: 'Adiar',
          requireInputText: true,
          actionType: ActionType.SilentAction,
        ),
        NotificationActionButton(
          key: 'DISMISS',
          label: 'Já tomei',
          actionType: ActionType.DismissAction,
          isDangerousOption: true,
        ),
      ],
      schedule: NotificationCalendar.fromDate(
        date: DateTime.now().add(
          const Duration(seconds: 10),
        ),
      ),
    );
  }

  Future<void> cancelScheduledNotifications() async {
    await NotificationProvider.cancel();
  }

  Future<void> resetBadgeCounter() async {
    await NotificationProvider.reset();
  }
}
