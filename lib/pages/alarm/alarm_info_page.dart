import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medicine/controllers/chat_controller.dart';
import 'package:medicine/controllers/alarm_controller.dart';
import 'package:medicine/models/alarm_type.dart';
import 'package:medicine/models/weekday_type.dart';
import 'package:medicine/widgets/custom_avatar_widget.dart';
import 'package:medicine/widgets/custom_button_widget.dart';
import 'package:medicine/widgets/custom_multiselect_item_widget.dart';
import 'package:medicine/widgets/custom_option_field_widget.dart';
import 'package:medicine/widgets/custom_page_widget.dart';
import 'package:medicine/widgets/custom_select_item_widget.dart';
import 'package:medicine/widgets/custom_stepper_widget.dart';
import 'package:medicine/widgets/custom_text_button_widget.dart';

class AlarmInfoPage extends StatefulWidget {
  const AlarmInfoPage({super.key});

  @override
  State<AlarmInfoPage> createState() => _AlarmInfoPageState();
}

class _AlarmInfoPageState extends State<AlarmInfoPage> {
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
            current: 2,
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
              controller: alarmController.infoPageController,
              children: const [
                AlarmInfoTypeView(),
                AlarmInfoTimeView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AlarmInfoTypeView extends StatefulWidget {
  const AlarmInfoTypeView({super.key});
  @override
  State<AlarmInfoTypeView> createState() => _AlarmInfoTypeViewState();
}
class _AlarmInfoTypeViewState extends State<AlarmInfoTypeView> {
  @override
  Widget build(BuildContext context) {
    final AlarmController alarmController = Get.find();
    List<AlarmType> alarmTypeList = AlarmType.getAlarmTypeList();
    return Column(
      children: [
        Text(
          'Como será o alarme?',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Toque para selecionar um tipo de recorrência',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(
                  height: 5,
                ),
                ...alarmTypeList.map(
                  (AlarmType alarmType) => Column(
                    children: [
                      CustomSelectItemWidget(
                        label: alarmType.name,
                        icon: Icon(
                          Icons.chevron_right_rounded,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 20,
                        ),
                        selected: alarmType.id == alarmController.alarmType.value.id,
                        onPressed: () {
                          setState(() {
                            alarmController.alarmType.value = alarmType;
                            if (alarmType.id == 2) {
                              alarmController.timeList.value = [const TimeOfDay(hour: 0, minute: 0)];
                            }
                          });
                        },
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        CustomButtonWidget(
          label: 'Próximo',
          onPressed: () {
            alarmController.infoPageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
          },
        ),
        const SizedBox(
          height: 5,
        ),
        CustomTextButtonWidget(
          label: 'Voltar ao remédio',
          onPressed: () {
            Get.back();
          },
        ),
      ],
    );
  }
}

class AlarmInfoTimeView extends StatefulWidget {
  const AlarmInfoTimeView({super.key});
  @override
  State<AlarmInfoTimeView> createState() => _AlarmInfoTimeViewState();
}
class _AlarmInfoTimeViewState extends State<AlarmInfoTimeView> {
  String hintText = '';
  @override
  Widget build(BuildContext context) {
    final AlarmController alarmController = Get.find();
    List<WeekdayType> weekdayTypeList = WeekdayType.getWeekdayTypeList();
    return Column(
      children: [
        Text(
          _getAlarmTypeLabel(alarmController.alarmType.value.id),
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(
          height: 20,
        ),
        if (hintText.isNotEmpty) ...[
          Text(
            hintText,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(
            height: 5,
          ),
        ],
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getTimePickerLabel(alarmController.alarmType.value.id),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(
                  height: 5,
                ),
                ...alarmController.timeList.map(
                  (TimeOfDay time) {
                    String timeValueLabel = _getTimeValueLabel(alarmController.alarmType.value.id, time);
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: CustomOptionFieldWidget(
                            placeholder: 'Ex: 00:00',
                            value: timeValueLabel,
                            onPressed: () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                                builder: (BuildContext context, Widget? child) {
                                  return MediaQuery(
                                    data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                    child: child!,
                                  );
                                },
                              );
                              if (pickedTime != null) {
                                setState(() {
                                  timeValueLabel = _getTimeValueLabel(alarmController.alarmType.value.id, pickedTime);
                                  alarmController.timeList[alarmController.timeList.indexOf(time)] = pickedTime;
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        if (alarmController.timeList.length > 1) ...[
                          InkWell(
                            onTap: () {
                              setState(() {
                                alarmController.timeList.remove(time);
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.tertiary,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.close_rounded,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ],
                    );
                 },
                ),
                if (alarmController.alarmType.value.id == 1) ...[
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomSelectItemWidget(
                        label: 'Adicionar outro horário',
                        onPressed: () {
                          setState(() {
                            alarmController.timeList.add(const TimeOfDay(hour: 0, minute: 0));
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Toque para selecionar os dias da semana',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: (weekdayTypeList.length * 60) > MediaQuery.of(context).size.width ? const EdgeInsets.symmetric(horizontal: 40) : null,
                    child: Column(
                      children: [
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            ...weekdayTypeList.map(
                              (WeekdayType weekdayType) => CustomMultiselectItemWidget(
                                label: weekdayType.name,
                                selected: alarmController.weekdayTypeList.map((WeekdayType element) => element.id).contains(weekdayType.id),
                                onPressed: () {
                                  setState(() {
                                    if (alarmController.weekdayTypeList.map((WeekdayType element) => element.id).contains(weekdayType.id)) {
                                      alarmController.weekdayTypeList.removeWhere((WeekdayType element) => element.id == weekdayType.id);
                                      return;
                                    }
                                    alarmController.weekdayTypeList.add(weekdayType);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomSelectItemWidget(
                        label: 'Todos os dias',
                        onPressed: () {
                          setState(() {
                            if (alarmController.weekdayTypeList.length == 7) {
                              alarmController.weekdayTypeList.clear();
                              return;
                            }
                            alarmController.weekdayTypeList.clear();
                            alarmController.weekdayTypeList.addAll(weekdayTypeList);
                          });
                        },
                      ),
                    ],
                  ),
                ],
                if (alarmController.alarmType.value.id == 2) ...[
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Escolha a data de início para o alarme',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  CustomOptionFieldWidget(
                    placeholder: 'Ex: 01/01/2023',
                    value: DateFormat('dd/MM/yyyy').format(alarmController.startDate.value),
                    onPressed: () async {
                      DateTime? startDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (startDate != null) {
                        setState(() {
                          alarmController.startDate.value = startDate;
                        });
                      }
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        CustomButtonWidget(
          label: 'Continuar para confirmação',
          onPressed: () {
            if ((alarmController.alarmType.value.id == 1) && alarmController.weekdayTypeList.isEmpty) {
              setState(() {
                hintText = 'Selecione os dias da semana para continuar';
              });
              return;
            }
            if ((alarmController.alarmType.value.id == 2) && alarmController.timeList.first.hour == 0) {
              setState(() {
                hintText = 'Escolha um intervalo de horas maior que 0 para continuar';
              });
              return;
            }
            Get.toNamed('/alarm/review');
          },
        ),
        const SizedBox(
          height: 5,
        ),
        CustomTextButtonWidget(
          label: 'Voltar',
          onPressed: () {
            alarmController.infoPageController.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
          },
        ),
      ],
    );
  }
  String _getAlarmTypeLabel(int alarmTypeId) {
    if (alarmTypeId == 1) return 'Qual será o horário do alarme?';
    if (alarmTypeId == 2) return 'Qual será o intervalo do alarme?';
    return 'O tipo do alarme não foi selecionado';
  }
  String _getTimePickerLabel(int alarmTypeId) {
    if (alarmTypeId == 1) return 'Toque para escolher um horário';
    if (alarmTypeId == 2) return 'Toque para escolher um intervalo';
    return 'O tipo do alarme não foi selecionado';
  }
  String _getTimeValueLabel(int alarmTypeId, TimeOfDay time) {
    String hour = time.hour.toString().padLeft(2, '0');
    String minute = time.minute.toString().padLeft(2, '0');
    if (alarmTypeId == 1) return '$hour:$minute';
    if (alarmTypeId == 2) return '$hour:$minute em $hour:$minute';
    return 'O tipo do alarme não foi selecionado';
  }
}
