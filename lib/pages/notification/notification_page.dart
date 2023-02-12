
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine/controllers/chat_controller.dart';
import 'package:medicine/widgets/custom_avatar_widget.dart';
import 'package:medicine/widgets/custom_button_widget.dart';
import 'package:medicine/widgets/custom_page_widget.dart';
import 'package:medicine/widgets/custom_select_item_widget.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key, required this.receivedAction}): super(key: key);

  final ReceivedAction receivedAction;

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  ChatController chatController = Get.find();

  @override
  Widget build(BuildContext context) {
    bool hasBigPicture = widget.receivedAction.bigPictureImage != null;
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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    '10:00',
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
                      if (widget.receivedAction.body?.isNotEmpty ?? false) ...[
                        Text(
                          widget.receivedAction.body!,
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                      Stack(
                        children: [
                          if (hasBigPicture) ...[
                            FadeInImage(
                              placeholder: const AssetImage('assets/img/placeholder.gif'),
                              image: widget.receivedAction.bigPictureImage!,
                              height: MediaQuery.of(context).size.height * 0.4,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          CustomButtonWidget(
            label: 'Já tomei',
            onPressed: () {
              Get.offAllNamed('/home');
              return;
            },
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'A próxima dose será em 6 horas',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
