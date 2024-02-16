import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:medicine/controllers/user_controller.dart';
import 'package:medicine/widgets/custom_bottom_sheet_widget.dart';
import 'package:medicine/widgets/custom_button_widget.dart';
import 'package:medicine/widgets/custom_empty_widget.dart';
import 'package:medicine/widgets/custom_image_picker_widget.dart';
import 'package:medicine/widgets/custom_loading_widget.dart';
import 'package:medicine/widgets/custom_page_widget.dart';
import 'package:medicine/widgets/custom_stepper_widget.dart';
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
    return CustomPageWidget(
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Text(
                'Criar nova conta',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: PageView(
                  controller: userController.registerPageController,
                  children: const [
                    UserRegisterDataView(),
                    UserRegisterBuddyView(),
                    UserRegisterPasswordView(),
                  ],
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
      ),
    );
  }
}

class UserRegisterDataView extends StatefulWidget {
  const UserRegisterDataView({super.key});
  @override
  State<UserRegisterDataView> createState() => _UserRegisterDataViewState();
}
class _UserRegisterDataViewState extends State<UserRegisterDataView> {
  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find();
    final formKey = GlobalKey<FormState>();
    TextEditingController nameController = TextEditingController(text: userController.name.value);
    TextEditingController phoneController = TextEditingController(text: userController.phone.value);
    TextEditingController emailController = TextEditingController(text: userController.email.value);
    return Column(
      children: [
        const CustomStepperWidget(
          current: 1,
          steps: [
            CustomStepperStep(
              icon: Icons.person_outline_rounded,
              label: 'Dados',
            ),
            CustomStepperStep(
              icon: Icons.supervisor_account_outlined,
              label: 'Responsável',
            ),
            CustomStepperStep(
              icon: Icons.lock_outline_rounded,
              label: 'Senha',
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          'Será um prazer te conhecer!',
          style: Theme.of(context).textTheme.titleSmall,
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
                  Row(
                    children: [
                      Text(
                        'Foto',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  CustomImagePickerWidget(
                    label: 'Toque para escolher uma foto',
                    image: userController.image.value.isNotEmpty ? base64Decode(userController.image.value) : null,
                    icon: Icon(
                      Icons.image_search_outlined,
                      color: Theme.of(context).colorScheme.secondary,
                      size: 20,
                    ),
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                      final bytes = await image!.readAsBytes();
                      setState(() {
                        userController.image.value = base64Encode(bytes);
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        CustomButtonWidget(
          label: 'Próximo',
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            if (formKey.currentState!.validate()) {
              userController.name.value = nameController.text;
              userController.phone.value = phoneController.text;
              userController.email.value = emailController.text;
              userController.registerPageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
              );
            }
          },
        ),
        const SizedBox(
          height: 5,
        ),
        CustomTextButtonWidget(
          label: 'Já tenho conta, voltar',
          onPressed: () {
            Get.back();
          },
        ),
      ],
    );
  }
}

class UserRegisterBuddyView extends StatelessWidget {
  const UserRegisterBuddyView({super.key});
  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find();
    final formKey = GlobalKey<FormState>();
    TextEditingController nameController = TextEditingController(text: userController.buddy.value.name);
    TextEditingController phoneController = TextEditingController(text: userController.buddy.value.phone);
    return Column(
      children: [
        const CustomStepperWidget(
          current: 2,
          steps: [
            CustomStepperStep(
              icon: Icons.person_outline_rounded,
              label: 'Dados',
            ),
            CustomStepperStep(
              icon: Icons.supervisor_account_outlined,
              label: 'Responsável',
            ),
            CustomStepperStep(
              icon: Icons.lock_outline_rounded,
              label: 'Senha',
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          'Quem é o seu responsável?',
          style: Theme.of(context).textTheme.titleSmall,
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
                    label: 'Qual é o nome do seu responsável?',
                    placeholder: 'Tia May',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Escreva o nome do seu responsável para se cadastrar';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextFieldWidget(
                    controller: phoneController,
                    label: 'Qual é o contato do seu responsável?',
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
                        return 'Escreva o contato do seu responsável para se cadastrar';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        CustomButtonWidget(
          label: 'Próximo',
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            if (formKey.currentState!.validate()) {
              userController.buddy.value.name = nameController.text;
              userController.buddy.value.phone = phoneController.text;
              userController.registerPageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
              );
            }
          },
        ),
        const SizedBox(
          height: 5,
        ),
        CustomTextButtonWidget(
          label: 'Voltar',
          onPressed: () {
            userController.registerPageController.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          },
        ),
      ],
    );
  }
}

class UserRegisterPasswordView extends StatelessWidget {
  const UserRegisterPasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find();
    final formKey = GlobalKey<FormState>();
    TextEditingController passwordController = TextEditingController(text: userController.password.value);
    TextEditingController confirmationController = TextEditingController(text: '');
    return Column(
      children: [
        const CustomStepperWidget(
          current: 3,
          steps: [
            CustomStepperStep(
              icon: Icons.person_outline_rounded,
              label: 'Dados',
            ),
            CustomStepperStep(
              icon: Icons.supervisor_account_outlined,
              label: 'Responsável',
            ),
            CustomStepperStep(
              icon: Icons.lock_outline_rounded,
              label: 'Senha',
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          'Qual será a sua senha?',
          style: Theme.of(context).textTheme.titleSmall,
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
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        CustomButtonWidget(
          label: 'Criar nova conta',
          onPressed: () async {
            FocusManager.instance.primaryFocus?.unfocus();
            if (formKey.currentState!.validate()) {
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
        const SizedBox(
          height: 5,
        ),
        CustomTextButtonWidget(
          label: 'Voltar',
          onPressed: () {
            userController.registerPageController.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          },
        ),
      ],
    );
  }

  void _passwordRulesBottomSheet(BuildContext context) {
    CustomBottomSheetWidget.show(
      context: context,
      height: MediaQuery.of(context).size.height * 0.275,
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
      height: MediaQuery.of(context).size.height * 0.3,
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
