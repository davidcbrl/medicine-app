import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:medicine/providers/notification_provider.dart';
import 'package:medicine/utilities/functions.dart';

class NotificationController {

  Future<void> createMedicineNotification() async {
    await NotificationProvider.create(
      content: NotificationContent(
        id: createUniqueId(),
        channelKey: 'basic_channel',
        title: 'Tomar remédio agora!',
        body: '25 gotas - Paracetamol 100mg',
        bigPicture: 'asset://assets/img/notification_map.png',
        notificationLayout: NotificationLayout.BigPicture,
      ),
    );
  }

  Future<void> createMedicineNotificationScheduled(NotificationWeekAndTime notificationSchedule) async {
    await NotificationProvider.create(
      content: NotificationContent(
        id: createUniqueId(),
        channelKey: 'scheduled_channel',
        title: 'Tomar remédio agendado!',
        body: '6/6 horas - Paracetamol 100mg',
        notificationLayout: NotificationLayout.Default,
        category: NotificationCategory.Alarm,
        locked: true,
        wakeUpScreen: true,
        criticalAlert: true,
        autoDismissible: false,
      ),
      actions: [
        NotificationActionButton(
          key: 'REDIRECT',
          label: 'Tomar',
        ),
        NotificationActionButton(
          key: 'MARK_DONE',
          label: 'Já tomei',
          actionType: ActionType.DismissAction,
          isDangerousOption: true,
        ),
      ],
      schedule: NotificationCalendar(
        weekday: notificationSchedule.dayOfTheWeek,
        hour: notificationSchedule.timeOfDay.hour,
        minute: notificationSchedule.timeOfDay.minute,
        second: 0,
        millisecond: 0,
        repeats: true,
      ),
    );
  }

  Future<void> cancelScheduledNotifications() async {
    await NotificationProvider.cancel();
  }
}
