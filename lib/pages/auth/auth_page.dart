import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine/controllers/auth_controller.dart';
import 'package:medicine/controllers/user_controller.dart';
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

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    TextEditingController emailController = TextEditingController(text: authController.email.value);
    TextEditingController passwordController = TextEditingController(text: authController.password.value);
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
                        Image.asset(
                          'assets/img/logo.png',
                          height: 80,
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
                      Get.offAllNamed('/home');
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
