import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:get/get.dart';
import 'package:medicine/models/medicine_notification.dart';
import 'package:medicine/providers/notification_provider.dart';

class NotificationController extends GetxController {

  Future<void> createMedicineNotification(MedicineNotification notification) async {
    await NotificationProvider.create(
      content: NotificationContent(
        id: -1,
        channelKey: 'alerts',
        title: notification.title,
        body: notification.body,
        bigPicture: notification.image,
        largeIcon: notification.largeIcon,
        notificationLayout: NotificationLayout.BigPicture,
        payload: notification.payload,
      ),
      actions: [
        NotificationActionButton(
          key: 'REDIRECT',
          label: 'Tomar agora',
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

  Future<void> createMedicineNotificationScheduled(MedicineNotification notification) async {
    await NotificationProvider.create(
      content: NotificationContent(
        id: -1,
        channelKey: 'alerts',
        title: notification.title,
        body: notification.body,
        bigPicture: notification.image,
        largeIcon: notification.largeIcon,
        notificationLayout: NotificationLayout.BigPicture,
        // category: NotificationCategory.Alarm,
        // locked: true,
        // wakeUpScreen: true,
        // criticalAlert: true,
        // autoDismissible: false,
        displayOnForeground: true,
        displayOnBackground: true,
        payload: notification.payload,
      ),
      schedule: notification.fixedDate != null
        ? NotificationCalendar.fromDate(
            date: notification.fixedDate!,
          )
        : NotificationCalendar(
            hour: notification.time!.hour,
            minute: notification.time!.minute,
            weekday: notification.weekday!.id,
            // allowWhileIdle: true,
            // repeats: true,
          ),
      actions: [
        NotificationActionButton(
          key: 'REDIRECT',
          label: 'Tomar agora',
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

  Future<void> cancelScheduledNotifications({int? id}) async {
    await NotificationProvider.cancel(id: id);
  }

  Future<void> resetBadgeCounter() async {
    await NotificationProvider.reset();
  }
}
