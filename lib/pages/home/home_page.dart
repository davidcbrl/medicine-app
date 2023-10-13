import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:medicine/controllers/alarm_controller.dart';
import 'package:medicine/controllers/auth_controller.dart';
import 'package:medicine/controllers/chat_controller.dart';
import 'package:medicine/controllers/notification_controller.dart';
import 'package:medicine/controllers/route_controller.dart';
import 'package:medicine/models/alarm.dart';
import 'package:medicine/models/medicine_notification.dart';
import 'package:medicine/widgets/custom_avatar_widget.dart';
import 'package:medicine/widgets/custom_empty_widget.dart';
import 'package:medicine/widgets/custom_list_item_widget.dart';
import 'package:medicine/widgets/custom_loading_widget.dart';
import 'package:medicine/widgets/custom_page_widget.dart';
import 'package:medicine/widgets/custom_select_item_widget.dart';
import 'package:medicine/widgets/custom_text_button_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  RouteController routeController = Get.find();
  AuthController authController = Get.find();
  NotificationController notificationController = Get.put(NotificationController(), permanent: true);
  ChatController chatController = Get.put(ChatController(), permanent: true);
  AlarmController alarmController = Get.put(AlarmController(), permanent: true);
  final ScrollController _scrollController = ScrollController();

  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    alarmController.get(selectedDate: selectedDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageWidget(
      hasPadding: false,
      hasBackgroundImage: true,
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomAvatarWidget(
                  image: Image.asset(
                    'assets/img/ben.png',
                    width: 50,
                  ),
                  label: 'Tio Ben',
                ),
                CustomSelectItemWidget(
                  label: 'Falar com meu \nresponsável',
                  image: Image.asset(
                    'assets/img/whatsapp.png',
                    width: 30,
                  ),
                  onPressed: () => chatController.launchWhatsapp(),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          CalendarCarousel<Event>(
            height: MediaQuery.of(context).size.height * 0.175,
            locale: 'pt-br',
            showHeader: true,
            headerMargin: EdgeInsets.zero,
            headerTextStyle: Theme.of(context).textTheme.bodyMedium,
            showHeaderButton: true,
            leftButtonIcon: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(
                Icons.chevron_left_rounded,
                color: Theme.of(context).colorScheme.secondary,
                size: 25,
              ),
            ),
            rightButtonIcon: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(
                Icons.chevron_right_rounded,
                color: Theme.of(context).colorScheme.secondary,
                size: 25,
              ),
            ),
            weekFormat: true,
            daysHaveCircularBorder: true,
            showWeekDays: true,
            weekDayFormat: WeekdayFormat.short,
            weekdayTextStyle: Theme.of(context).textTheme.bodyMedium,
            weekendTextStyle: Theme.of(context).textTheme.labelMedium,
            daysTextStyle: Theme.of(context).textTheme.labelMedium,
            dayButtonColor: Theme.of(context).colorScheme.tertiary,
            todayTextStyle: Theme.of(context).textTheme.titleSmall,
            todayButtonColor: Theme.of(context).colorScheme.tertiary,
            todayBorderColor: Theme.of(context).colorScheme.primary,
            selectedDayTextStyle: Theme.of(context).textTheme.displayMedium,
            selectedDayButtonColor: Theme.of(context).colorScheme.primary,
            selectedDayBorderColor: Theme.of(context).colorScheme.primary,
            minSelectedDate: selectedDate.subtract(const Duration(days: 30)),
            maxSelectedDate: selectedDate.add(const Duration(days: 30)),
            selectedDateTime: selectedDate,
            onDayPressed: (DateTime date, List<Event> events) async {
              setState(() {
                selectedDate = date;
              });
              await alarmController.get(selectedDate: selectedDate);
            },
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Obx(
              () => LazyLoadScrollView(
                isLoading: alarmController.loading.value,
                scrollOffset: 10,
                onEndOfPage: () => () {},
                child: RefreshIndicator(
                  onRefresh: () => alarmController.get(selectedDate: selectedDate),
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      if (alarmController.status.isLoading) ...[
                        CustomLoadingWidget(
                          loading: alarmController.status.isLoading,
                        ),
                      ],
                      if (alarmController.status.isEmpty) ...[
                        const CustomEmptyWidget(
                          label: 'Nenhum alarme',
                        ),
                      ],
                      if (alarmController.status.isError) ...[
                        CustomEmptyWidget(
                          label: alarmController.status.errorMessage ?? 'Erro inesperado',
                        ),
                      ],
                      if (alarmController.status.isSuccess) ...[
                        Text(
                          'Toque em um alarme abaixo para tomar o remédio',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ..._buildWidgetList(),
                        const SizedBox(
                          height: 100,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => notificationController.createMedicineNotification(
                    MedicineNotification(
                      id: 0,
                      title: 'Hora de tomar seu remédio',
                      image: 'asset://assets/img/background.png',
                      payload: {
                        'json': jsonEncode(
                          Alarm(
                            id: 0,
                            name: 'Vitamina B12',
                            alarmTypeId: 1,
                            doseTypeId: 1,
                            quantity: 15,
                            time: '12:00',
                            times: ['12:00'],
                            weekdayTypeIds: [],
                          ).toJson(),
                        ),
                      }
                    ),
                  ),
                  child: SizedBox(
                    width: 100,
                    child: Column(
                      children: [
                        Icon(
                          Icons.alarm_rounded,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 25,
                        ),
                        Text(
                          'Testar alarme',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => _newOptionsBottomSheet(context),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      Icons.add_rounded,
                      color: Theme.of(context).colorScheme.tertiary,
                      size: 30,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => _settingsBottomSheet(context),
                  child: SizedBox(
                    width: 100,
                    child: Column(
                      children: [
                        Icon(
                          Icons.settings_outlined,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 25,
                        ),
                        Text(
                          'Opções',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildWidgetList() {
    List<Alarm> list = [];
    for (Alarm alarm in alarmController.alarmList) {
      for (String time in alarm.times) {
        alarm.time = time;
        list.add(Alarm.fromJson(alarm.toJson()));
      }
    }
    list.sort((a, b) {
      int valueA = int.parse(a.time!.split(':')[0]);
      int valueB = int.parse(b.time!.split(':')[0]);
      return valueA.compareTo(valueB);
    });
    return list.map((Alarm alarm) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: CustomListItemWidget(
          label: alarm.name,
          prefixLabel: alarm.time,
          icon: Icon(
            Icons.chevron_right_rounded,
            color: Theme.of(context).colorScheme.secondary,
            size: 20,
          ),
          border: Border.all(
            color: Theme.of(context).colorScheme.tertiary,
            width: 1,
          ),
          onPressed: () => _alarmOptionsBottomSheet(context, alarm),
        ),
      );
    }).toList();
  }

  void _alarmOptionsBottomSheet(BuildContext context, Alarm alarm) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'O que deseja fazer?',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        CustomSelectItemWidget(
                          label: 'Alarmar agora para tomar remédio',
                          icon: Icon(
                            Icons.chevron_right_rounded,
                            color: Theme.of(context).colorScheme.secondary,
                            size: 20,
                          ),
                          onPressed: () async {
                            Get.back();
                            await notificationController.createMedicineNotification(
                              MedicineNotification(
                                id: alarm.id ?? 0,
                                title: 'Hora de tomar seu remédio',
                                body: alarm.name,
                                image: 'asset://assets/img/background.png',
                                largeIcon: 'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
                                payload: {
                                  'json': jsonEncode(alarm.toJson()),
                                },
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        CustomSelectItemWidget(
                          label: 'Editar alarme',
                          icon: Icon(
                            Icons.chevron_right_rounded,
                            color: Theme.of(context).colorScheme.secondary,
                            size: 20,
                          ),
                          onPressed: () {
                            alarmController.select(alarm);
                            Get.back();
                            Get.toNamed('/alarm/medicine');
                          },
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        CustomSelectItemWidget(
                          label: 'Remover alarme',
                          icon: Icon(
                            Icons.chevron_right_rounded,
                            color: Theme.of(context).colorScheme.secondary,
                            size: 20,
                          ),
                          onPressed: () {
                            Get.back();
                            _removeConfirmationBottomSheet(context, alarm);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextButtonWidget(
                  label: 'Voltar',
                  onPressed: () {
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _removeConfirmationBottomSheet(BuildContext context, Alarm alarm) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'Tem certeza que deseja remover esse alarme?',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: CustomSelectItemWidget(
                      label: 'Sim',
                      icon: Icon(
                        Icons.chevron_right_rounded,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 20,
                      ),
                      onPressed: () async {
                        await alarmController.remove(id: alarm.id);
                        await notificationController.cancelScheduledNotifications(id: alarm.id);
                        Get.back();
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextButtonWidget(
                  label: 'Não, voltar',
                  onPressed: () {
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _newOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'O que deseja fazer?',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: CustomSelectItemWidget(
                      label: 'Criar alarme para remédio',
                      icon: Icon(
                        Icons.chevron_right_rounded,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 20,
                      ),
                      onPressed: () {
                        alarmController.clear();
                        Get.back();
                        Get.toNamed('/alarm/medicine');
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextButtonWidget(
                  label: 'Voltar',
                  onPressed: () {
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _settingsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'Opções',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: CustomSelectItemWidget(
                      label: 'Sair do app',
                      icon: Icon(
                        Icons.chevron_right_rounded,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 20,
                      ),
                      onPressed: () {
                        authController.logout();
                        Get.back();
                        Get.offAllNamed('/auth');
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextButtonWidget(
                  label: 'Voltar',
                  onPressed: () {
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
