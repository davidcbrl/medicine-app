
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine/controllers/alarm_controller.dart';
import 'package:medicine/controllers/notification_controller.dart';
import 'package:medicine/models/alarm.dart';
import 'package:medicine/widgets/custom_bottom_sheet_widget.dart';
import 'package:medicine/widgets/custom_button_widget.dart';
import 'package:medicine/widgets/custom_empty_widget.dart';
import 'package:medicine/widgets/custom_header_widget.dart';
import 'package:medicine/widgets/custom_loading_widget.dart';
import 'package:medicine/widgets/custom_page_widget.dart';
import 'package:medicine/widgets/custom_text_button_widget.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key, required this.data});

  final Object? data;

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  AlarmController alarmController = Get.find();
  NotificationController notificationController = Get.find();

  @override
  Widget build(BuildContext context) {
    Alarm alarm = Alarm.fromJson(widget.data as Map<String, dynamic>);
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
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        alarm.times.first.split(':').take(2).join(':'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Hora de tomar seu remédio',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            alarm.name,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Stack(
                            children: [
                              FadeInImage(
                                placeholder: const AssetImage('assets/img/placeholder.gif'),
                                image: alarm.image != null && alarm.image != 'null'
                                  ? Image.memory(base64Decode(alarm.image!)).image
                                  : Image.asset('assets/img/background.png').image,
                                height: MediaQuery.of(context).size.height * 0.4,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                          if (alarm.observation != null) ...[
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              alarm.observation ?? '',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              CustomButtonWidget(
                label: alarm.taken == null ? 'Pronto, marcar como tomado' : 'Já tomado, voltar',
                onPressed: () async {
                  if (alarm.id != null && alarm.taken == null) {
                    await alarmController.take(id: alarm.id!);
                    if (alarmController.status.isError && context.mounted) {
                      _alarmErrorBottomSheet(context, alarmController.status.errorMessage);
                      return;
                    }
                  }
                  Get.offAllNamed('/home');
                  return;
                },
              ),
              const SizedBox(
                height: 10,
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

  void _alarmErrorBottomSheet(BuildContext context, String? message) {
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
