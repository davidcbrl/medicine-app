import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine/controllers/auth_controller.dart';
import 'package:medicine/widgets/custom_button_widget.dart';
import 'package:medicine/widgets/custom_empty_widget.dart';
import 'package:medicine/widgets/custom_loading_widget.dart';
import 'package:medicine/widgets/custom_page_widget.dart';
import 'package:medicine/widgets/custom_text_button_widget.dart';
import 'package:medicine/widgets/custom_text_field_widget.dart';

class AuthPasswordPage extends StatefulWidget {
  const AuthPasswordPage({super.key});

  @override
  State<AuthPasswordPage> createState() => _AuthPasswordPageState();
}

class _AuthPasswordPageState extends State<AuthPasswordPage> {
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    TextEditingController emailController = TextEditingController(text: authController.email.value);
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
                              return 'Escreva o seu e-mail para receber sua nova senha';
                            }
                            return null;
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
                label: 'Receber nova senha',
                onPressed: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  if (formKey.currentState!.validate()) {
                    authController.email.value = emailController.text;
                    await authController.reset();
                    if (authController.status.isSuccess) {
                      Get.back();
                      return;
                    }
                    if (authController.status.isError && context.mounted) {
                      _passwordResetErrorBottomSheet(context, authController);
                      return;
                    }
                  }
                },
              ),
              CustomTextButtonWidget(
                label: 'Lembrei minha senha, voltar',
                style: Theme.of(context).textTheme.titleSmall,
                onPressed: () {
                  Get.back();
                },
              ),
            ],
          ),
      ),
    );
  }

  void _passwordResetErrorBottomSheet(BuildContext context, AuthController authController) {
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
