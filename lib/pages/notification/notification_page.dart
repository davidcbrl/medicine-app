
import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine/controllers/alarm_controller.dart';
import 'package:medicine/models/alarm.dart';
import 'package:medicine/widgets/custom_button_widget.dart';
import 'package:medicine/widgets/custom_header_widget.dart';
import 'package:medicine/widgets/custom_page_widget.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key, required this.receivedAction});

  final ReceivedAction receivedAction;

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  AlarmController alarmController = Get.find();

  @override
  Widget build(BuildContext context) {
    bool hasBigPicture = widget.receivedAction.bigPictureImage != null;
    Map<String, dynamic> payload = jsonDecode(widget.receivedAction.payload!['json'] ?? '{}');
    Alarm alarm = Alarm.fromJson(payload);
    return CustomPageWidget(
      body: Column(
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
                    alarm.time ?? '',
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
                      if (widget.receivedAction.title?.isNotEmpty ?? false) ...[
                        Text(
                          widget.receivedAction.title!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                      Text(
                        alarm.name,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Stack(
                        children: [
                          if (alarm.image != null) ...[
                            FadeInImage(
                              placeholder: const AssetImage('assets/img/placeholder.gif'),
                              image: Image.memory(
                                base64Decode(alarm.image ?? '')
                              ).image,
                              height: MediaQuery.of(context).size.height * 0.4,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                          if (alarm.image == null && hasBigPicture) ...[
                            FadeInImage(
                              placeholder: const AssetImage('assets/img/placeholder.gif'),
                              image: widget.receivedAction.bigPictureImage!,
                              height: MediaQuery.of(context).size.height * 0.4,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ],
                      ),
                      if (alarm.observation != null) ...[
                        Text(
                          alarm.observation ?? '',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(
                          height: 10,
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
            label: 'Pronto, voltar para alarmes',
            onPressed: () {
              alarmController.get(selectedDate: DateTime.now());
              Get.offAllNamed('/home');
              return;
            },
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
