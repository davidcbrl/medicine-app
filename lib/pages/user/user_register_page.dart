import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:medicine/controllers/user_controller.dart';
import 'package:medicine/widgets/custom_bottom_sheet_widget.dart';
import 'package:medicine/widgets/custom_button_widget.dart';
import 'package:medicine/widgets/custom_empty_widget.dart';
import 'package:medicine/widgets/custom_loading_widget.dart';
import 'package:medicine/widgets/custom_page_widget.dart';
import 'package:medicine/widgets/custom_text_button_widget.dart';
import 'package:medicine/widgets/custom_text_field_widget.dart';

class UserRegisterPage extends StatefulWidget {
  const UserRegisterPage({super.key});

  @override
  State<UserRegisterPage> createState() => _UserRegisterPageState();
}

class _UserRegisterPageState extends State<UserRegisterPage> {
  final UserController userController = Get.put(UserController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    TextEditingController nameController = TextEditingController(text: '');
    TextEditingController phoneController = TextEditingController(text: '');
    TextEditingController emailController = TextEditingController(text: '');
    TextEditingController passwordController = TextEditingController(text: '');
    TextEditingController confirmationController = TextEditingController(text: '');
    return CustomPageWidget(
      body: Obx(
        () => userController.loading.value
        ? CustomLoadingWidget(
            loading: userController.loading.value,
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
                          height: 20,
                        ),
                        Text(
                          'Criar nova conta',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
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
                          height: 10,
                        ),
                        CustomTextFieldWidget(
                          controller: phoneController,
                          label: 'Qual é o seu contato?',
                          placeholder: '(99) 99999-9999',
                          formatters: [
                            MaskTextInputFormatter(
                              mask: '(##) #####-####',
                              filter: { "#": RegExp(r'[0-9]') },
                              type: MaskAutoCompletionType.lazy,
                            ),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Escreva o seu contato para se cadastrar';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextFieldWidget(
                          controller: emailController,
                          label: 'Qual é o seu e-mail?',
                          placeholder: 'tio@ben.com',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Escreva o seu e-mail para se cadastrar';
                            }
                            RegExp regex = RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*$');
                            if (!regex.hasMatch(value)) {
                              return 'Email inválido, verifique a formatação';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
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
                            RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                            if (!regex.hasMatch(value)) {
                              return 'Senha inválida, verifique as regras de criação de senha abaixo';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
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
                            if (value.isNotEmpty && value != passwordController.text) {
                              return 'A senha e a confirmação precisam ser iguais para se cadastrar';
                            }
                            return null;
                          },
                        ),
                        CustomTextButtonWidget(
                          label: 'Regras de criação de senha',
                          style: Theme.of(context).textTheme.titleSmall,
                          onPressed: () {
                            _passwordRulesBottomSheet(context);
                          },
                        ),
                        const SizedBox(
                          height: 40,
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
                    userController.name.value = nameController.text;
                    userController.phone.value = phoneController.text;
                    userController.email.value = emailController.text;
                    userController.password.value = passwordController.text;
                    await userController.save();
                    if (userController.status.isSuccess && context.mounted) {
                      _userRegisterSuccessBottomSheet(context, userController);
                      return;
                    }
                    if (userController.status.isError && context.mounted) {
                      _userRegisterErrorBottomSheet(context, userController);
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
  
  void _passwordRulesBottomSheet(BuildContext context) {
    CustomBottomSheetWidget.show(
      context: context,
      height: MediaQuery.of(context).size.height * 0.3,
      body: Column(
        children: [
          Text(
            'Sua senha deve conter:',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  'No minimo 8 caracteres',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                Text(
                  'No minimo 1 caractere maiusculo e 1 caractere minusculo',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                Text(
                  'No minimo 1 caractere numerico',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                Text(
                  'No minimo 1 caractere especial',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          CustomTextButtonWidget(
            label: 'Ok, entendi',
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  void _userRegisterSuccessBottomSheet(BuildContext context, UserController userController) {
    CustomBottomSheetWidget.show(
      context: context,
      height: MediaQuery.of(context).size.height * 0.45,
      body: Column(
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
                  width: MediaQuery.of(context).size.height * 0.15,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          CustomTextButtonWidget(
            label: 'Ok, voltar para login',
            onPressed: () {
              Get.offAllNamed('/auth');
            },
          ),
        ],
      )
    );
  }

  void _userRegisterErrorBottomSheet(BuildContext context, UserController userController) {
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
              label: userController.status.errorMessage ?? 'Erro inesperado',
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
