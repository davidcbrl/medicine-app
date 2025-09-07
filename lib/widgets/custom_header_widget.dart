import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine/controllers/auth_controller.dart';
import 'package:medicine/controllers/chat_controller.dart';
import 'package:medicine/controllers/notification_controller.dart';
import 'package:medicine/controllers/setting_controller.dart';
import 'package:medicine/controllers/user_controller.dart';
import 'package:medicine/providers/firebase_provider.dart';
import 'package:medicine/widgets/custom_avatar_widget.dart';
import 'package:medicine/widgets/custom_bottom_sheet_widget.dart';
import 'package:medicine/widgets/custom_empty_widget.dart';
import 'package:medicine/widgets/custom_loading_widget.dart';
import 'package:medicine/widgets/custom_select_item_widget.dart';
import 'package:medicine/widgets/custom_text_button_widget.dart';

class CustomHeaderWidget extends StatefulWidget {
  const CustomHeaderWidget({super.key});

  @override
  State<CustomHeaderWidget> createState() => _CustomHeaderWidgetState();
}

class _CustomHeaderWidgetState extends State<CustomHeaderWidget> {
  UserController userController = Get.put(UserController(), permanent: true);
  ChatController chatController = Get.put(ChatController(), permanent: true);
  SettingController settingController = Get.put(SettingController(), permanent: true);
  AuthController authController = Get.put(AuthController(), permanent: true);
  NotificationController notificationController = Get.put(NotificationController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () => Image.asset(
                settingController.theme.value == 'ThemeMode.dark'
                  ? 'assets/img/logo-white-transparent.png'
                  : 'assets/img/logo-purple-transparent.png',
                height: 30,
              ),
            ),
            Row(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () => _whatsappBottomSheet(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Image.asset(
                      settingController.theme.value == 'ThemeMode.dark'
                        ? 'assets/img/whatsapp-icon-white.png'
                        : 'assets/img/whatsapp-icon-black.png',
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () => _settingsBottomSheet(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      Icons.settings_outlined,
                      color: Theme.of(context).colorScheme.secondary,
                      size: 25,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () {
                    FirebaseProvider.instance.log(name: 'custom_header_user_info');
                    Get.toNamed('/user/info');
                  },
                  child: Obx(
                    () => CustomAvatarWidget(
                      borderColor: Theme.of(context).colorScheme.tertiary,
                      image: userController.image.value.isNotEmpty
                        ? userController.image.value
                        : 'assets/img/ben.png',
                    ),
                  ),
                ),
              ],
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

  void _whatsappBottomSheet(BuildContext context) {
    FirebaseProvider.instance.log(name: 'custom_header_whatsapp');
    CustomBottomSheetWidget.show(
      context: context,
      height: (MediaQuery.of(context).size.height * 0.175) + (60 * 2),
      body: Column(
        children: [
          Text(
            'Falar com o responsável',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            'Deseja entrar em contato com o responsável por whatsapp?',
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
                onPressed: () {
                  FirebaseProvider.instance.log(name: 'custom_header_whatsapp_check_yes');
                  Get.back();
                  try {
                    chatController.launchWhatsapp(
                      phone: userController.buddy.value.phone,
                    );
                  } catch (error) {
                    _whatsappErrorBottomSheet(context, 'Não foi possível abrir o whatsapp');
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
              FirebaseProvider.instance.log(name: 'custom_header_whatsapp_check_no');
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  void _whatsappErrorBottomSheet(BuildContext context, String? message) {
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
              FirebaseProvider.instance.log(name: 'custom_header_whatsapp_error_back');
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  void _settingsBottomSheet(BuildContext context) {
    FirebaseProvider.instance.log(name: 'custom_header_settings');
    CustomBottomSheetWidget.show(
      context: context,
      height: (MediaQuery.of(context).size.height * 0.175) + (60 * 2),
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
                    label: 'Customizar aparência do app',
                    onPressed: () {
                      FirebaseProvider.instance.log(name: 'custom_header_settings_theme');
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
                      FirebaseProvider.instance.log(name: 'custom_header_settings_logout');
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
              FirebaseProvider.instance.log(name: 'custom_header_settings_back');
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
                  FirebaseProvider.instance.log(name: 'custom_header_logout_check_yes');
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
                    Get.offAllNamed('/auth');
                    _logoutErrorBottomSheet(context, 'Falha ao realizar logout, você será direcionado para o login por segurança.');
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
              FirebaseProvider.instance.log(name: 'custom_header_logout_check_no');
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
              FirebaseProvider.instance.log(name: 'custom_header_logout_error_back');
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}
