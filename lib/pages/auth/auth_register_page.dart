import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine/controllers/auth_controller.dart';
import 'package:medicine/widgets/custom_button_widget.dart';
import 'package:medicine/widgets/custom_empty_widget.dart';
import 'package:medicine/widgets/custom_loading_widget.dart';
import 'package:medicine/widgets/custom_page_widget.dart';
import 'package:medicine/widgets/custom_text_button_widget.dart';
import 'package:medicine/widgets/custom_text_field_widget.dart';

class AuthRegisterPage extends StatefulWidget {
  const AuthRegisterPage({super.key});

  @override
  State<AuthRegisterPage> createState() => _AuthRegisterPageState();
}

class _AuthRegisterPageState extends State<AuthRegisterPage> {
  final AuthController authController = Get.put(AuthController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    TextEditingController nameController = TextEditingController(text: authController.name.value);
    TextEditingController phoneController = TextEditingController(text: authController.phone.value);
    TextEditingController emailController = TextEditingController(text: authController.email.value);
    TextEditingController passwordController = TextEditingController(text: authController.password.value);
    TextEditingController confirmationController = TextEditingController(text: authController.confirmation.value);
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
                height: 20,
              ),
              Text(
                'Cadastro',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        CustomTextFieldWidget(
                          controller: nameController,
                          label: 'Qual é o seu nome?',
                          placeholder: 'Tio Ben',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Escreva o seu nome para se cadastrar';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomTextFieldWidget(
                          controller: phoneController,
                          label: 'Qual é o seu contato?',
                          placeholder: '(99) 99999-9999',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Escreva o seu contato para se cadastrar';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomTextFieldWidget(
                          controller: emailController,
                          label: 'Qual é o seu e-mail?',
                          placeholder: 'tio@ben.com',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Escreva o seu e-mail para se cadastrar';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomTextFieldWidget(
                          controller: passwordController,
                          label: 'Defina uma senha para acessar o app:',
                          placeholder: '*****',
                          hideText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Escreva uma senha para se cadastrar';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomTextFieldWidget(
                          controller: confirmationController,
                          label: 'Repita a senha para confirmar:',
                          placeholder: '*****',
                          hideText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Escreva a confirmação da senha para se cadastrar';
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
                label: 'Criar nova conta',
                onPressed: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  if (formKey.currentState!.validate()) {
                    authController.name.value = nameController.text;
                    authController.phone.value = phoneController.text;
                    authController.email.value = emailController.text;
                    authController.password.value = passwordController.text;
                    authController.confirmation.value = confirmationController.text;
                    await authController.register();
                    if (authController.status.isSuccess && context.mounted) {
                      _authRegisterSuccessBottomSheet(context, authController);
                      return;
                    }
                    if (authController.status.isError && context.mounted) {
                      _authRegisterErrorBottomSheet(context, authController);
                      return;
                    }
                  }
                },
              ),
              CustomTextButtonWidget(
                label: 'Já tenho conta, voltar',
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

  void _authRegisterSuccessBottomSheet(BuildContext context, AuthController authController) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.background,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'Cadastro realizado com sucesso!',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Agora basta entrar no app utilizando seu e-mail e a senha que você definiu, para começar a criar seus alarmes!',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      Image.asset(
                        'assets/img/success.gif',
                        width: 150,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextButtonWidget(
                  label: 'Ok, voltar',
                  onPressed: () {
                    Get.offAllNamed('/auth');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _authRegisterErrorBottomSheet(BuildContext context, AuthController authController) {
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
