import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine/controllers/alarm_controller.dart';
import 'package:medicine/controllers/auth_controller.dart';
import 'package:medicine/controllers/notification_controller.dart';
import 'package:medicine/controllers/setting_controller.dart';
import 'package:medicine/controllers/user_controller.dart';
import 'package:medicine/models/alarm.dart';
import 'package:medicine/models/medicine_notification.dart';
import 'package:medicine/widgets/custom_bottom_sheet_widget.dart';
import 'package:medicine/widgets/custom_button_widget.dart';
import 'package:medicine/widgets/custom_empty_widget.dart';
import 'package:medicine/widgets/custom_loading_widget.dart';
import 'package:medicine/widgets/custom_page_widget.dart';
import 'package:medicine/widgets/custom_text_button_widget.dart';
import 'package:medicine/widgets/custom_text_field_widget.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final AuthController authController = Get.find();
  final UserController userController = Get.put(UserController(), permanent: true);
  final AlarmController alarmController = Get.put(AlarmController(), permanent: true);
  final NotificationController notificationController = Get.put(NotificationController(), permanent: true);
  final SettingController settingController = Get.put(SettingController(), permanent: true);
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController(text: authController.email.value);
    TextEditingController passwordController = TextEditingController(text: '');
    return CustomPageWidget(
      body: Obx(
        () => authController.loading.value
        ? CustomLoadingWidget(
            loading: authController.loading.value,
          )
        : Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Obx(
                          () => Image.asset(
                            settingController.theme.value == 'ThemeMode.dark'
                              ? 'assets/img/logo-white-transparent.png'
                              : 'assets/img/logo-purple-transparent.png',
                            height: 60,
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        CustomTextFieldWidget(
                          controller: emailController,
                          label: 'Qual é o seu e-mail?',
                          placeholder: 'tio@ben.com',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Escreva o seu e-mail para entrar';
                            }
                            RegExp regex = RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*$');
                            if (!regex.hasMatch(value)) {
                              return 'Email inválido, verifique a formatação';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomTextFieldWidget(
                          controller: passwordController,
                          label: 'Qual é a sua senha?',
                          placeholder: '*****',
                          hideText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Escreva a sua senha para entrar';
                            }
                            return null;
                          },
                        ),
                        CustomTextButtonWidget(
                          label: 'Esqueci minha senha',
                          style: Theme.of(context).textTheme.titleSmall,
                          onPressed: () async {
                            await authController.reset();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              CustomButtonWidget(
                label: 'Entrar',
                onPressed: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  if (formKey.currentState!.validate()) {
                    authController.email.value = emailController.text;
                    authController.password.value = passwordController.text;
                    await authController.login();
                    if (authController.status.isSuccess) {
                      userController.get();
                      alarmController.get(selectedDate: DateTime.now());
                      Get.offAllNamed('/home');
                      await alarmController.getNextWeek();
                      if (alarmController.status.isSuccess) {
                        bool allScheduled = true;
                        for (Alarm alarm in alarmController.nextWeekAlarmList) {
                          await notificationController.createMedicineNotificationScheduled(
                            notification: PushNotification(
                              id: alarm.id ?? UniqueKey().hashCode,
                              title: 'Hora de tomar seu remédio',
                              body: alarm.name,
                              date: DateTime.parse('${alarm.date} ${alarm.hour}'),
                              payload: jsonEncode(alarm.toJson()),
                            ),
                          );
                          if (notificationController.status.isError && context.mounted) {
                            allScheduled = false;
                          }
                        }
                        if (!allScheduled && context.mounted) {
                          _authErrorBottomSheet(context, 'Você entrou no app, porém, um ou mais alarmes que já estavam criados não puderam ser reagendados.');
                        }
                      }
                      if (alarmController.status.isError && context.mounted) {
                        _authErrorBottomSheet(context, 'Você entrou no app, porém, não foi possível reagendar os alarmes que já estavam criados.');
                      }
                      return;
                    }
                    if (authController.status.isError && context.mounted) {
                      _authErrorBottomSheet(context, authController.status.errorMessage);
                      return;
                    }
                  }
                },
              ),
              CustomTextButtonWidget(
                label: 'Não possui conta? Criar nova conta',
                style: Theme.of(context).textTheme.titleSmall,
                onPressed: () {
                  userController.clear();
                  Get.toNamed('/user/register');
                },
              ),
            ],
          ),
      ),
    );
  }

  void _authErrorBottomSheet(BuildContext context, String? message) {
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
