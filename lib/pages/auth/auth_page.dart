import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine/controllers/auth_controller.dart';
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
              Image.asset(
                'assets/img/logo.png',
                height: 80,
              ),
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
                        CustomTextFieldWidget(
                          controller: emailController,
                          label: 'Qual é o seu e-mail?',
                          placeholder: 'tio@ben.com',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Escreva o seu e-mail para entrar';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              formKey.currentState!.validate();
                            }
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
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              formKey.currentState!.validate();
                            }
                          },
                        ),
                        CustomTextButtonWidget(
                          label: 'Esqueci minha senha',
                          style: Theme.of(context).textTheme.titleSmall,
                          onPressed: () {},
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
                      Get.offAllNamed('/home');
                      return;
                    }
                    if (authController.status.isError && context.mounted) {
                      _authErrorBottomSheet(context, authController);
                      return;
                    }
                  }
                },
              ),
            ],
          ),
      ),
    );
  }

  void _authErrorBottomSheet(BuildContext context, AuthController authController) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
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
                    label: authController.status.errorMessage ?? 'Erro inesperado',
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
          ),
        );
      },
    );
  }
}
