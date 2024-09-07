import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:get/get.dart';
import 'package:medicine/controllers/alarm_controller.dart';
import 'package:medicine/controllers/auth_controller.dart';
import 'package:medicine/controllers/chat_controller.dart';
import 'package:medicine/controllers/notification_controller.dart';
import 'package:medicine/controllers/setting_controller.dart';
import 'package:medicine/controllers/user_controller.dart';
import 'package:medicine/models/alarm.dart';
import 'package:medicine/models/medicine_notification.dart';
import 'package:medicine/widgets/custom_bottom_sheet_widget.dart';
import 'package:medicine/widgets/custom_button_widget.dart';
import 'package:medicine/widgets/custom_calendar_widget.dart';
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
  UserController userController = Get.put(UserController(), permanent: true);
  ChatController chatController = Get.put(ChatController(), permanent: true);
  SettingController settingController = Get.put(SettingController(), permanent: true);
  final ScrollController _scrollController = ScrollController();

  DateTime selectedDate = DateTime.now();
  ValueNotifier<bool> isEmptyMessage = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return CustomPageWidget(
      hasPadding: false,
      body: Stack(
        children: [
          Column(
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
              Obx(
                () => CustomCalendarWidget(
                  style: settingController.calendar.value,
                  selectedDate: selectedDate,
                  onDayPressed: (DateTime date, List<Event> events) async {
                    setState(() {
                      selectedDate = date;
                      isEmptyMessage.value = false;
                    });
                    await alarmController.get(selectedDate: selectedDate);
                    if (alarmController.status.isEmpty) {
                      setState(() {
                        isEmptyMessage.value = true;
                      });
                    }
                  },
                ),
              ),
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
                        onError: (error) => CustomEmptyWidget(
                          label: alarmController.status.errorMessage ?? 'Erro inesperado',
                        ),
                        onEmpty: _emptyMessage(context),
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (!isEmptyMessage.value) ...[
            Positioned(
              bottom: 20,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: CustomButtonWidget(
                  label: 'Criar alarme para remédio',
                  width: MediaQuery.of(context).size.width - (40 * 2),
                  icon: Icon(
                    Icons.add_alarm_rounded,
                    color: settingController.theme.value == 'ThemeMode.dark'
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.tertiary,
                    size: 25,
                  ),
                  onPressed: () {
                    setState(() {
                      isEmptyMessage.value = false;
                    });
                    alarmController.clear();
                    Get.back();
                    Get.toNamed('/alarm/medicine');
                  },
                ),
              ),
            ),
          ],
          if (isEmptyMessage.value) ...[
            Positioned(
              bottom: 20,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: CustomButtonWidget(
                  label: 'Criar alarme para remédio',
                  width: MediaQuery.of(context).size.width - (40 * 2),
                  icon: Icon(
                    Icons.add_alarm_rounded,
                    color: settingController.theme.value == 'ThemeMode.dark'
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.tertiary,
                    size: 25,
                  ),
                  onPressed: () {
                    setState(() {
                      isEmptyMessage.value = false;
                    });
                    alarmController.clear();
                    Get.back();
                    Get.toNamed('/alarm/medicine');
                  },
                ),
              )
              .animate(onPlay: (controller) => controller.repeat())
              .scaleXY(begin: 0.93, end: 1.075, curve: Curves.easeInOut, duration: 1000.ms)
              .then()
              .scaleXY(begin: 1.075, end: 0.93, curve: Curves.easeInOut, duration: 1000.ms)
              .animate(onPlay: (controller) => controller.repeat())
              .shimmer(delay: 3000.ms, duration: 1000.ms),
            ),
          ],
        ],
      ),
    );
  }

  Widget _emptyMessage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          Image.asset(
            'assets/img/background.png',
            width: MediaQuery.of(context).size.width * 0.5,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'Nenhum alarme para hoje, toque no botão abaixo para começar!',
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
                color: settingController.theme.value == 'ThemeMode.dark'
                 ? Theme.of(context).colorScheme.primary
                 : Theme.of(context).colorScheme.tertiary,
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
                color: settingController.theme.value == 'ThemeMode.dark'
                 ? Theme.of(context).colorScheme.primary
                 : Theme.of(context).colorScheme.tertiary,
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
    DateTime alarmDate = DateTime.parse('${alarm.date} ${alarm.time}');
    if (alarmDate.isBefore(now) && alarm.taken == null) return 'atrasado';
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
                    label: 'Tomar remédio agora',
                    onPressed: () async {
                      Get.back();
                      PushNotification notification = PushNotification(
                        id: alarm.id ?? UniqueKey().hashCode,
                        title: 'Hora de tomar seu remédio',
                        body: alarm.name,
                        payload: jsonEncode(alarm.toJson()),
                      );
                      Get.toNamed(
                        '/notification',
                        arguments: jsonDecode(notification.payload ?? '{}'),
                      );
                      return;
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
                      _removeOptionsBottomSheet(context, alarm);
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

  void _removeOptionsBottomSheet(BuildContext context, Alarm alarm) {
    CustomBottomSheetWidget.show(
      context: context,
      height: (MediaQuery.of(context).size.height * 0.175) + (60 * 2),
      body: Column(
        children: [
          Text(
            'Deseja remover somente esse alarme ou remover também as próximas ocorrências?',
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
                    label: 'Remover somente este alarme',
                    onPressed: () {
                      Get.back();
                      _removeCheckBottomSheet(context, alarm, all: false);
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  CustomSelectItemWidget(
                    label: 'Remover este alarme e próximas ocorrências',
                    onPressed: () {
                      Get.back();
                      _removeCheckBottomSheet(context, alarm, all: true);
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          CustomTextButtonWidget(
            label: 'Não remover, voltar',
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  void _removeCheckBottomSheet(BuildContext context, Alarm alarm, {bool all = false}) {
    CustomBottomSheetWidget.show(
      context: context,
      height: (MediaQuery.of(context).size.height * 0.175) + (60 * 1),
      body: Column(
        children: [
          Text(
            'Tem certeza que deseja fazer essa ação?',
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
                  Get.back();
                  List removedIds = await alarmController.remove(id: alarm.id!, selectedDate: selectedDate, all: all);
                  if (alarmController.status.isSuccess) {
                    if (context.mounted) {
                      _removeSuccessBottomSheet(context);
                    }
                    bool allRemoved = true;
                    for (int id in removedIds) {
                      await notificationController.cancelScheduledNotification(id: id);
                      if (notificationController.status.isError && context.mounted) {
                        allRemoved = false;
                      }
                    }
                    if (!allRemoved && context.mounted) {
                      _removeErrorBottomSheet(context, 'A remoção dos horários foi realizada com sucesso, porém, um ou mais alarmes não puderam ser desativados.');
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

  void _removeSuccessBottomSheet(BuildContext context) {
    CustomBottomSheetWidget.show(
      context: context,
      height: MediaQuery.of(context).size.height * 0.275,
      body: Column(
        children: [
          Text(
            'Horários removidos com sucesso!',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  'Os alarmes estão sendo desativadas me segundo plano.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          CustomTextButtonWidget(
            label: 'Ok, voltar',
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
}
