import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medicine/controllers/chat_controller.dart';
import 'package:medicine/controllers/alarm_controller.dart';
import 'package:medicine/models/weekday_type.dart';
import 'package:medicine/widgets/custom_avatar_widget.dart';
import 'package:medicine/widgets/custom_button_widget.dart';
import 'package:medicine/widgets/custom_page_widget.dart';
import 'package:medicine/widgets/custom_select_item_widget.dart';
import 'package:medicine/widgets/custom_stepper_widget.dart';
import 'package:medicine/widgets/custom_text_button_widget.dart';
import 'package:medicine/widgets/custom_text_field_widget.dart';

class AlarmReviewPage extends StatefulWidget {
  const AlarmReviewPage({super.key});

  @override
  State<AlarmReviewPage> createState() => _AlarmReviewPageState();
}

class _AlarmReviewPageState extends State<AlarmReviewPage> {
  final ChatController chatController = Get.find();
  final AlarmController alarmController = Get.find();

  @override
  Widget build(BuildContext context) {
    return CustomPageWidget(
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
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
                icon: Icons.add_alarm_outlined,
                label: 'Alarme',
              ),
              CustomStepperStep(
                icon: Icons.check_circle_outline_outlined,
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
    );
  }
}

class AlarmReviewObservationView extends StatelessWidget {
  const AlarmReviewObservationView({super.key});
  @override
  Widget build(BuildContext context) {
    final AlarmController alarmController = Get.find();
    TextEditingController alarmObservationController = TextEditingController(text: '');
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
                      '${alarmController.quantity.value} ${alarmController.doseType.value.name}',
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
                      '${_getTimeValueLabel(alarmController.alarmType.value.id, alarmController.time.value)} horas',
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
                        _getWeekdayTypeLabel(alarmController.weekdayTypeIdList),
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                    if (alarmController.alarmType.value.id == 2) ...[
                      Text(
                        DateFormat('dd MMMM yyyy').format(alarmController.startDate.value),
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
          label: 'Confirmar e criar alarme para remédio',
          onPressed: () async {
            FocusManager.instance.primaryFocus?.unfocus();
            alarmController.observation.value = alarmObservationController.text;
            await alarmController.save();
            if (alarmController.status.isSuccess) {
              Get.toNamed('/alarm/finish');
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
  String _getTimeValueLabel(int alarmTypeId, TimeOfDay time) {
    String hour = time.hour.toString().padLeft(2, '0');
    String minute = time.minute.toString().padLeft(2, '0');
    if (alarmTypeId == 1) return '$hour:$minute';
    if (alarmTypeId == 2) return '$hour:$minute em $hour:$minute';
    return 'O tipo do alarme não foi selecionado';
  }
  String _getAlarmTypeLabel(int alarmTypeId) {
    if (alarmTypeId == 1) return 'nos dias';
    if (alarmTypeId == 2) return 'a partir do dia';
    return 'O tipo do alarme não foi selecionado';
  }
  String _getWeekdayTypeLabel(List<int> weekdayTypeIdList) {
    if (weekdayTypeIdList.length == 7) return 'Todos os dias';
    String label = '';
    List<WeekdayType> weekdayTypeList = WeekdayType.getWeekdayTypeList();
    for (int weekday in weekdayTypeIdList) {
      String separator = label == '' ? '' : '-';
      label = '$label $separator ${weekdayTypeList[weekday-1].name}';
    }
    return label;
  }
}
