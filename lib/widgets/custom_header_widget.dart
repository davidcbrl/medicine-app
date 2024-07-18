import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine/controllers/chat_controller.dart';
import 'package:medicine/controllers/user_controller.dart';
import 'package:medicine/widgets/custom_avatar_widget.dart';
import 'package:medicine/widgets/custom_loading_widget.dart';
import 'package:medicine/widgets/custom_select_item_widget.dart';

class CustomHeaderWidget extends StatefulWidget {
  const CustomHeaderWidget({super.key});

  @override
  State<CustomHeaderWidget> createState() => _CustomHeaderWidgetState();
}

class _CustomHeaderWidgetState extends State<CustomHeaderWidget> {
  UserController userController = Get.put(UserController(), permanent: true);
  ChatController chatController = Get.put(ChatController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () => CustomAvatarWidget(
                image: userController.image.value.isNotEmpty && userController.image.value != 'null'
                  ? Image.memory(base64Decode(userController.image.value))
                  : Image.asset('assets/img/ben.png'),
                label: userController.name.value.isNotEmpty
                  ? userController.name.value
                  : 'Tio Ben',
              ),
            ),
            Obx(
              () => CustomSelectItemWidget(
                label: userController.buddy.value.name.isNotEmpty 
                  ? userController.buddy.value.name
                  : 'Meu responsável',
                image: Image.asset(
                  'assets/img/whatsapp.png',
                  width: 30,
                ),
                icon: false,
                truncateLabelWithWidth: MediaQuery.of(context).size.width * 0.25,
                onPressed: () => chatController.launchWhatsapp(
                  phone: userController.buddy.value.phone,
                ),
              ),
            ),
          ],
        ),
        Obx(
          () => userController.loading.value
          ? CustomLoadingWidget(
              loading: userController.loading.value,
            )
          : Container(),
        ),
      ],
    );
  }
}
