import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:get/get.dart';
import 'package:medicine/controllers/alarm_controller.dart';
import 'package:medicine/controllers/auth_controller.dart';
import 'package:medicine/controllers/notification_controller.dart';
import 'package:medicine/controllers/setting_controller.dart';
import 'package:medicine/models/alarm.dart';
import 'package:medicine/models/medicine_notification.dart';
import 'package:medicine/models/weekday_type.dart';
import 'package:medicine/widgets/custom_bottom_sheet_widget.dart';
import 'package:medicine/widgets/custom_empty_widget.dart';
import 'package:medicine/widgets/custom_header_widget.dart';
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
  AuthController authController = Get.find();
  NotificationController notificationController = Get.put(NotificationController(), permanent: true);
  AlarmController alarmController = Get.put(AlarmController(), permanent: true);
  SettingController settingController = Get.put(SettingController(), permanent: true);
  final ScrollController _scrollController = ScrollController();

  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return CustomPageWidget(
      hasPadding: false,
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: CustomHeaderWidget(),
          ),
          const SizedBox(
            height: 10,
          ),
          _buildCalendarCarouselBySetting(context),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => alarmController.get(selectedDate: selectedDate),
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  alarmController.obx(
                    (state) => Column(
                      children: [
                        Text(
                          'Toque em um alarme abaixo para tomar o remédio',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ..._buildWidgetList(),
                      ],
                    ),
                    onLoading: CustomLoadingWidget(
                      loading: alarmController.loading.value,
                    ),
                    onEmpty: alarmController.welcome.value
                      ? _welcomeMessage(context)
                      : const CustomEmptyWidget(
                        label: 'Nenhum alarme para esse dia',
                      ),
                    onError: (error) => CustomEmptyWidget(
                      label: alarmController.status.errorMessage ?? 'Erro inesperado',
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                ],
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
                  onTap: () => _testOptionsBottomSheet(context),
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

  CalendarCarousel<Event> _buildCalendarCarouselBySetting(BuildContext context) {
    switch (settingController.get(name: 'calendar')) {
      case '2':
        return _customCircularCalendarCarouselWidget(context);
      case '1':
      default:
        return _customRetangularCalendarCarouselWidget(context);
    }
  }

  CalendarCarousel<Event> _customRetangularCalendarCarouselWidget(BuildContext context) {
    return CalendarCarousel<Event>(
      height: MediaQuery.of(context).size.height * 0.15,
      locale: 'pt-br',
      showHeader: true,
      pageScrollPhysics: const AlwaysScrollableScrollPhysics(),
      customGridViewPhysics: const AlwaysScrollableScrollPhysics(),
      headerMargin: EdgeInsets.zero,
      headerTextStyle: Theme.of(context).textTheme.bodyMedium,
      weekFormat: true,
      showWeekDays: false,
      minSelectedDate: selectedDate.subtract(const Duration(days: 30)),
      maxSelectedDate: selectedDate.add(const Duration(days: 30)),
      selectedDateTime: selectedDate,
      daysHaveCircularBorder: false,
      dayButtonColor: Colors.transparent,
      todayBorderColor: Colors.transparent,
      todayButtonColor: Colors.transparent,
      selectedDayBorderColor: Colors.transparent,
      selectedDayButtonColor: Colors.transparent,
      customDayBuilder: _buildCalendarCarouselDayWidget,
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
      onDayPressed: (DateTime date, List<Event> events) async {
        setState(() {
          selectedDate = date;
        });
        await alarmController.get(selectedDate: selectedDate);
      },
    );
  }

  CalendarCarousel<Event> _customCircularCalendarCarouselWidget(BuildContext context) {
    return CalendarCarousel<Event>(
      height: MediaQuery.of(context).size.height * 0.175,
      locale: 'pt-br',
      showHeader: true,
      pageScrollPhysics: const AlwaysScrollableScrollPhysics(),
      customGridViewPhysics: const AlwaysScrollableScrollPhysics(),
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
    );
  }

  Container _buildCalendarCarouselDayWidget(bool isSelectable, int index, bool isSelectedDay, bool isToday, bool isPrevMonthDay, TextStyle textStyle, bool isNextMonthDay, bool isThisMonthDay, DateTime day) {
    List<WeekdayType> weekdayTypeList = WeekdayType.getWeekdayTypeListStartingOnModay();
    return Container(
      width: 50,
      decoration: BoxDecoration(
        color: isSelectedDay ? Theme.of(context).colorScheme.primary : isToday ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.tertiary,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 1,
          color: isToday || isSelectedDay ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.tertiary,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            weekdayTypeList[day.weekday-1].name,
            style: isSelectedDay ? Theme.of(context).textTheme.displayMedium : isToday ? Theme.of(context).textTheme.titleSmall : Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            day.day.toString(),
            style: isSelectedDay ? Theme.of(context).textTheme.displayMedium : isToday ? Theme.of(context).textTheme.titleSmall : Theme.of(context).textTheme.labelMedium,
          ),
        ],
      ),
    );
  }

  Widget _welcomeMessage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Text(
            'Seja bem-vindo!',
            style: Theme.of(context).textTheme.labelMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'Vamos criar seu primeiro alarme para remédio? Toque no botão "+" da barra inferior para começar!',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'Quando terminar, o seu alarme aparecerá aqui na tela inicial',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildWidgetList() {
    alarmController.alarmList.sort((a, b) {
      int valueA = int.parse(a.time!.split(':')[0]);
      int valueB = int.parse(b.time!.split(':')[0]);
      return valueA.compareTo(valueB);
    });
    return alarmController.alarmList.map((Alarm alarm) {
      String status = _getAlarmStatus(alarm);
      String? label = alarm.time?.split(':').take(2).join(':');
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            if (status == 'pendente') ...[
              CustomListItemWidget(
                prefixLabel: label,
                label: alarm.name,
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
            ],
            if (status == 'tomado') ...[
              CustomListItemWidget(
                prefixLabel: label,
                label: alarm.name,
                suffixLabel: 'Tomado',
                color: Theme.of(context).colorScheme.surface,
                icon: Icon(
                  Icons.chevron_right_rounded,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 20,
                ),
                border: Border.all(
                  color: Theme.of(context).colorScheme.tertiary,
                  width: 1,
                ),
                onPressed: () {},
              ),
            ],
            if (status == 'atrasado') ...[
              CustomListItemWidget(
                prefixLabel: label,
                label: alarm .name,
                suffixLabel: 'Atrasado',
                color: Theme.of(context).colorScheme.tertiary,
                icon: Icon(
                  Icons.chevron_right_rounded,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 20,
                ),
                border: Border.all(
                  color: Theme.of(context).colorScheme.error,
                  width: 1,
                ),
                onPressed: () => _alarmOptionsBottomSheet(context, alarm),
              ),
            ],
          ],
        ),
      );
    }).toList();
  }

  String _getAlarmStatus(Alarm alarm) {
    DateTime now = DateTime.now();
    DateTime asd = DateTime.parse('${alarm.date} ${alarm.time}');
    if (asd.isBefore(now) && alarm.taken == null) return 'atrasado';
    if (alarm.taken != null) return 'tomado';
    return 'pendente';
  }

  void _alarmOptionsBottomSheet(BuildContext context, Alarm alarm) {
    CustomBottomSheetWidget.show(
      context: context,
      height: (MediaQuery.of(context).size.height * 0.175) + (60 * 3),
      body: Column(
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
                    onPressed: () async {
                      Get.back();
                      await notificationController.createMedicineNotification(
                        notification: PushNotification(
                          id: alarm.id ?? UniqueKey().hashCode,
                          title: 'Hora de tomar seu remédio',
                          body: alarm.name,
                          payload: jsonEncode(alarm.toJson()),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  CustomSelectItemWidget(
                    label: 'Editar alarme',
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
                    onPressed: () {
                      Get.back();
                      _removeCheckBottomSheet(context, alarm);
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
    );
  }

  void _removeCheckBottomSheet(BuildContext context, Alarm alarm) {
    CustomBottomSheetWidget.show(
      context: context,
      height: (MediaQuery.of(context).size.height * 0.175) + (60 * 1),
      body: Column(
        children: [
          Text(
            'Tem certeza que deseja remover esse alarme?',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: CustomSelectItemWidget(
                label: 'Sim',
                onPressed: () async {
                  await alarmController.remove(id: alarm.id!);
                  if (alarmController.status.isSuccess) {
                    await notificationController.cancelScheduledNotification(id: alarm.id!);
                    if (notificationController.status.isSuccess && context.mounted) {
                      Get.back();
                      return;
                    }
                    if (notificationController.status.isError && context.mounted) {
                      _removeErrorBottomSheet(context, 'A remoção do horário foi realizada com sucesso, porém, o alarme não pôde ser desativado.');
                      return;
                    }
                  }
                  if (alarmController.status.isError && context.mounted) {
                    _removeErrorBottomSheet(context, alarmController.status.errorMessage);
                    return;
                  }
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
    );
  }

  void _removeErrorBottomSheet(BuildContext context, String? message) {
    CustomBottomSheetWidget.show(
      context: context,
      height: MediaQuery.of(context).size.height * 0.45,
      body: Column(
        children: [
          Text(
            'Ops!',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: CustomEmptyWidget(
              label: message ?? 'Erro inesperado',
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
    );
  }

  void _testOptionsBottomSheet(BuildContext context) {
    CustomBottomSheetWidget.show(
      context: context,
      height: (MediaQuery.of(context).size.height * 0.175) + (60 * 2),
      body: Column(
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
                    label: 'Alarme em 10s',
                    onPressed: () {
                      notificationController.createMedicineNotificationScheduled(
                        notification: PushNotification(
                          id: UniqueKey().hashCode,
                          title: 'Hora de tomar seu remédio',
                          body: 'Vitamina B12',
                          date: DateTime.now().add(const Duration(seconds: 10)),
                          payload: jsonEncode(
                            Alarm(
                              id: UniqueKey().hashCode,
                              name: 'Vitamina B12',
                              times: ['12:00'],
                              observation: 'Tomar com bastante água',
                              taken: DateTime.now().toString(),
                            ).toJson(),
                          ),
                        ),
                      );
                      Get.back();
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  CustomSelectItemWidget(
                    label: 'Alarme imediato',
                    onPressed: () {
                      notificationController.createMedicineNotification(
                        notification: PushNotification(
                          id: UniqueKey().hashCode,
                          title: 'Hora de tomar seu remédio',
                          body: 'Vitamina B12',
                          payload: jsonEncode(
                            Alarm(
                              id: UniqueKey().hashCode,
                              name: 'Vitamina B12',
                              times: ['12:00'],
                              observation: 'Tomar com bastante água',
                              taken: DateTime.now().toString(),
                            ).toJson(),
                          ),
                        ),
                      );
                      Get.back();
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
    );
  }

  void _newOptionsBottomSheet(BuildContext context) {
    CustomBottomSheetWidget.show(
      context: context,
      height: (MediaQuery.of(context).size.height * 0.175) + (60 * 1),
      body: Column(
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
    );
  }

  void _settingsBottomSheet(BuildContext context) {
    CustomBottomSheetWidget.show(
      context: context,
      height: (MediaQuery.of(context).size.height * 0.175) + (60 * 3),
      body: Column(
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
              child: Column(
                children: [
                  CustomSelectItemWidget(
                    label: 'Editar informações pessoais',
                    onPressed: () {
                      Get.back();
                      Get.toNamed('/user/info');
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  CustomSelectItemWidget(
                    label: 'Customizar aparência do app',
                    onPressed: () {
                      Get.back();
                      Get.toNamed('/theme');
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  CustomSelectItemWidget(
                    label: 'Sair do app',
                    onPressed: () {
                      Get.back();
                      _logoutCheckBottomSheet(context);
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
    );
  }

  void _logoutCheckBottomSheet(BuildContext context) {
    CustomBottomSheetWidget.show(
      context: context,
      height: (MediaQuery.of(context).size.height * 0.175) + (60 * 2),
      body: Column(
        children: [
          Text(
            'Tem certeza que deseja sair do app?',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            'Todos os seus alarmes serão desativados até você entrar novamente',
            style: Theme.of(context).textTheme.labelMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: CustomSelectItemWidget(
                label: 'Sim',
                onPressed: () async {
                  await authController.logout();
                  if (authController.status.isSuccess) {
                    await notificationController.cancelAllScheduledNotifications();
                    if (notificationController.status.isSuccess) {
                      Get.offAllNamed('/auth');
                      return;
                    }
                    if (notificationController.status.isError && context.mounted) {
                      _logoutErrorBottomSheet(context, 'Você saiu do app, porém, um ou mais alarmes não puderam ser desativados.');
                      return;
                    }
                  }
                  if (authController.status.isError && context.mounted) {
                    _logoutErrorBottomSheet(context, authController.status.errorMessage);
                    return;
                  }
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
    );
  }

  void _logoutErrorBottomSheet(BuildContext context, String? message) {
    CustomBottomSheetWidget.show(
      context: context,
      height: MediaQuery.of(context).size.height * 0.45,
      body: Column(
        children: [
          Text(
            'Ops!',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: CustomEmptyWidget(
              label: message ?? 'Erro inesperado',
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
    );
  }
}
