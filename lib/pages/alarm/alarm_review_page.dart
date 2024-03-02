import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medicine/controllers/alarm_controller.dart';
import 'package:medicine/controllers/notification_controller.dart';
import 'package:medicine/models/alarm.dart';
import 'package:medicine/models/medicine_notification.dart';
import 'package:medicine/models/weekday_type.dart';
import 'package:medicine/widgets/custom_bottom_sheet_widget.dart';
import 'package:medicine/widgets/custom_button_widget.dart';
import 'package:medicine/widgets/custom_empty_widget.dart';
import 'package:medicine/widgets/custom_header_widget.dart';
import 'package:medicine/widgets/custom_loading_widget.dart';
import 'package:medicine/widgets/custom_page_widget.dart';
import 'package:medicine/widgets/custom_stepper_widget.dart';
import 'package:medicine/widgets/custom_text_button_widget.dart';
import 'package:medicine/widgets/custom_text_field_widget.dart';

class AlarmReviewPage extends StatefulWidget {
  const AlarmReviewPage({super.key});

  @override
  State<AlarmReviewPage> createState() => _AlarmReviewPageState();
}

class _AlarmReviewPageState extends State<AlarmReviewPage> {
  final AlarmController alarmController = Get.find();

  @override
  Widget build(BuildContext context) {
    return CustomPageWidget(
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const CustomHeaderWidget(),
              const SizedBox(
                height: 20,
              ),
              const CustomStepperWidget(
                current: 3,
                steps: [
                  CustomStepperStep(
                    icon: Icons.medication_outlined,
                    label: 'Remédio',
                  ),
                  CustomStepperStep(
                    icon: Icons.add_alarm_rounded,
                    label: 'Alarme',
                  ),
                  CustomStepperStep(
                    icon: Icons.check_circle_outline_rounded,
                    label: 'Confirmar',
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: PageView(
                  controller: alarmController.reviewPageController,
                  children: const [
                    AlarmReviewObservationView(),
                  ],
                ),
              ),
            ],
          ),
          Obx(
            () => alarmController.loading.value
            ? CustomLoadingWidget(
                loading: alarmController.loading.value,
              )
            : Container(),
          ),
        ],
      ),
    );
  }
}

class AlarmReviewObservationView extends StatelessWidget {
  const AlarmReviewObservationView({super.key});
  @override
  Widget build(BuildContext context) {
    final AlarmController alarmController = Get.find();
    TextEditingController alarmObservationController = TextEditingController(text: alarmController.observation.value);
    return Column(
      children: [
        Text(
          'Confirmar criação do alarme?',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomTextFieldWidget(
                  controller: alarmObservationController,
                  label: 'Deseja adicionar uma observação?',
                  placeholder: 'Ex: Tomar com bastante água',
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    Text(
                      'O alarme será criado para tomar',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      '${alarmController.quantity.value} ${alarmController.doseType.value.name}'.toLowerCase(),
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'de',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      alarmController.name.value,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'de',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      _getTimeValueLabel(alarmController.alarmType.value.id, alarmController.timeList),
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      _getAlarmTypeLabel(alarmController.alarmType.value.id),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    if (alarmController.alarmType.value.id == 1) ...[
                      Text(
                        _getWeekdayTypeLabel(alarmController.weekdayTypeList),
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                    if (alarmController.alarmType.value.id == 2) ...[
                      Text(
                        DateFormat('dd MMMM yyyy, HH:mm').format(alarmController.startDateTime.value),
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        CustomButtonWidget(
          label: 'Confirmar e criar alarme',
          onPressed: () async {
            FocusManager.instance.primaryFocus?.unfocus();
            alarmController.observation.value = alarmObservationController.text;
            await alarmController.save();
            if (alarmController.status.isSuccess) {
              await _scheduleAlarms(alarmController);
              if (context.mounted) {
                _alarmSuccessBottomSheet(context, alarmController);
              }
              return;
            }
            if (alarmController.status.isError && context.mounted) {
              _alarmErrorBottomSheet(context, alarmController);
              return;
            }
          },
        ),
        const SizedBox(
          height: 5,
        ),
        CustomTextButtonWidget(
          label: 'Voltar para alarme',
          onPressed: () {
            Get.back();
          },
        ),
      ],
    );
  }

  Future<void> _scheduleAlarms(AlarmController alarmController) async {
    final NotificationController notificationController = Get.find();
    for (WeekdayType weekday in alarmController.weekdayTypeList) {
      for (TimeOfDay time in alarmController.timeList) {
        String decoratedTime = _decorateTime(time);
        await notificationController.createMedicineNotificationScheduled(
          MedicineNotification(
            id: alarmController.id.value,
            weekday: weekday,
            time: time,
            title: 'Hora de tomar seu remédio',
            body: alarmController.name.value,
            image: 'asset://assets/img/background.png',
            largeIcon: 'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
            payload: {
              'json': jsonEncode(
                Alarm(
                  id: 1,
                  name: alarmController.name.value,
                  image: alarmController.image.value.isNotEmpty ? alarmController.image.value : null,
                  times: [decoratedTime],
                  observation: alarmController.observation.value,
                  taken: alarmController.taken.value,
                ).toJson(),
              ),
            },
          ),
        );
      }
    }
  }

  void _alarmSuccessBottomSheet(BuildContext context, AlarmController authController) {
    CustomBottomSheetWidget.show(
      context: context,
      height: MediaQuery.of(context).size.height * 0.275,
      body: Column(
        children: [
          Text(
            'Alarme para remédio criado com sucesso!',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  'Você receberá uma notificação quando estiver na hora de tomar o remédio, mas você também pode visualizar os alarmes na tela inicial.',
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
            label: 'Ok, voltar para o início',
            onPressed: () {
              Get.offAllNamed('/home');
            },
          ),
        ],
      ),
    );
  }

  void _alarmErrorBottomSheet(BuildContext context, AlarmController alarmController) {
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
              label: alarmController.status.errorMessage ?? 'Erro inesperado',
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

  String _getTimeValueLabel(int alarmTypeId, List<TimeOfDay> times) {
    String label = '';
    for (TimeOfDay time in times) {
      String hour = time.hour.toString().padLeft(2, '0');
      String minute = time.minute.toString().padLeft(2, '0');
      String separator = label == '' ? '' : 'e';
      if (alarmTypeId == 1) label = '$label $separator $hour:$minute';
      if (alarmTypeId == 2) label = '$label $separator $hour:$minute em $hour:$minute';
    }
    return label;
  }
  String _getAlarmTypeLabel(int alarmTypeId) {
    if (alarmTypeId == 1) return 'nos dias';
    if (alarmTypeId == 2) return 'a partir do dia';
    return 'O tipo do alarme não foi selecionado';
  }
  String _getWeekdayTypeLabel(List<WeekdayType> weekdayTypeList) {
    if (weekdayTypeList.length == 7) return 'Todos os dias';
    String label = '';
    for (WeekdayType weekday in weekdayTypeList) {
      String separator = label == '' ? '' : '-';
      label = '$label $separator ${weekday.name}';
    }
    return label;
  }
  String _decorateTime(TimeOfDay time) {
    String hour = time.hour.toString().padLeft(2, '0');
    String minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
