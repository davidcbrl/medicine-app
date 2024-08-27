import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:medicine/controllers/cloud_controller.dart';
import 'package:medicine/controllers/user_controller.dart';
import 'package:medicine/widgets/custom_bottom_sheet_widget.dart';
import 'package:medicine/widgets/custom_button_widget.dart';
import 'package:medicine/widgets/custom_empty_widget.dart';
import 'package:medicine/widgets/custom_header_widget.dart';
import 'package:medicine/widgets/custom_image_picker_widget.dart';
import 'package:medicine/widgets/custom_loading_widget.dart';
import 'package:medicine/widgets/custom_page_widget.dart';
import 'package:medicine/widgets/custom_select_item_widget.dart';
import 'package:medicine/widgets/custom_text_button_widget.dart';
import 'package:medicine/widgets/custom_text_field_widget.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  UserController userController = Get.find();
  CloudController cloudController = Get.put(CloudController(), permanent: true);
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController(text: userController.email.value);
    TextEditingController nameController = TextEditingController(text: userController.name.value);
    TextEditingController phoneController = TextEditingController(text: userController.phone.value);
    bool hasImage = userController.image.value.isNotEmpty;
    return CustomPageWidget(
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const CustomHeaderWidget(),
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
                        Text(
                          'Informações pessoais',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(
                          height: 20,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: CustomImagePickerWidget(
                                label: 'Toque para escolher ${hasImage ? '\n' : ''}uma foto',
                                image: hasImage ? userController.image.value : null,
                                icon: Icon(
                                  Icons.image_search_outlined,
                                  color: Theme.of(context).colorScheme.secondary,
                                  size: 20,
                                ),
                                onPressed: () async {
                                  final ImagePicker picker = ImagePicker();
                                  final XFile? image = await picker.pickImage(
                                    source: ImageSource.gallery,
                                    imageQuality: 10,
                                  );
                                  final bytes = await image!.readAsBytes();
                                  setState(() {
                                    userController.image.value = base64Encode(bytes);
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            if (hasImage) ...[
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    userController.image.value = '';
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.tertiary,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Icon(
                                    Icons.close_rounded,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextFieldWidget(
                          readOnly: true,
                          controller: emailController,
                          label: 'E-mail (somente leitura)',
                          placeholder: 'tio@ben.com',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextFieldWidget(
                          controller: nameController,
                          label: 'Nome',
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
                          label: 'Contato',
                          placeholder: '(99) 99999-9999',
                          keyboardType: TextInputType.number,
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
                        Row(
                          children: [
                            Text(
                              'Senha',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        CustomSelectItemWidget(
                          label: 'Toque para alterar senha',
                          onPressed: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            _userPasswordBottomSheet(context, userController);
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              'Responsável',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        CustomSelectItemWidget(
                          label: 'Toque para alterar o responsável',
                          onPressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            _userBuddyInfoBottomSheet(context, userController);
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
                height: 20,
              ),
              CustomButtonWidget(
                label: 'Salvar informações pessoais',
                onPressed: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  if (formKey.currentState!.validate()) {
                    userController.name.value = nameController.text;
                    userController.phone.value = phoneController.text;
                    userController.email.value = emailController.text;
                    if (userController.image.value.isNotEmpty && !userController.image.value.contains('http')) {
                      String imageName = '${userController.id.value.toString()}_image.png';
                      String? cdnImage = await cloudController.uploadAsset(
                        type: AssetType.image,
                        name: imageName,
                        base64Asset: userController.image.value,
                      );
                      if (cloudController.status.isError && context.mounted) {
                        _userInfoErrorBottomSheet(context, cloudController.status.errorMessage);
                        return;
                      }
                      userController.image.value = cdnImage ?? userController.image.value;
                    } 
                    await userController.save();
                    if (userController.status.isSuccess && context.mounted) {
                      _userInfoSuccessBottomSheet(context, userController);
                      return;
                    }
                    if (userController.status.isError && context.mounted) {
                      _userInfoErrorBottomSheet(context, userController.status.errorMessage);
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
                  userController.get();
                  Get.back();
                },
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

  void _userPasswordBottomSheet(BuildContext context, UserController userController) {
    final passwordFormKey = GlobalKey<FormState>();
    TextEditingController currentPasswordController = TextEditingController(text: '');
    TextEditingController newPasswordController = TextEditingController(text: '');
    TextEditingController confirmationController = TextEditingController(text: '');
    CustomBottomSheetWidget.show(
      context: context,
      height: (MediaQuery.of(context).size.height * 0.2) + (60 * 7),
      scroll: true,
      keyboard: true,
      body: Column(
        children: [
          Text(
            'Alterar senha',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Form(
              key: passwordFormKey,
              child: Column(
                children: [
                  CustomTextFieldWidget(
                    controller: currentPasswordController,
                    label: 'Escreva a senha atual a ser alterada:',
                    placeholder: '*****',
                    hideText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Escreva uma senha para alterar';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextFieldWidget(
                    controller: newPasswordController,
                    label: 'Defina nova senha para acessar o app:',
                    placeholder: '*****',
                    hideText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Escreva uma senha para alterar';
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
                    label: 'Repita a nova senha para confirmar:',
                    placeholder: '*****',
                    hideText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Escreva a confirmação da senha para alterar';
                      }
                      if (value.isNotEmpty && value != newPasswordController.text) {
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
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          CustomButtonWidget(
            label: 'Confirmar alteração de senha',
            onPressed: () async {
              FocusManager.instance.primaryFocus?.unfocus();
              if (passwordFormKey.currentState!.validate()) {
                Get.back();
                await userController.passwordReset(
                  currentPassword: currentPasswordController.text,
                  newPassword: newPasswordController.text,
                );
                if (userController.status.isSuccess && context.mounted) {
                  _userInfoSuccessBottomSheet(context, userController, password: true);
                  return;
                }
                if (userController.status.isError && context.mounted) {
                  _userInfoErrorBottomSheet(context, userController.status.errorMessage);
                  return;
                }
              }
            },
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

  void _userBuddyInfoBottomSheet(BuildContext context, UserController userController) {
    final buddyFormKey = GlobalKey<FormState>();
    TextEditingController buddyNameController = TextEditingController(text: userController.buddy.value.name);
    TextEditingController buddyPhoneController = TextEditingController(text: userController.buddy.value.phone);
    CustomBottomSheetWidget.show(
      context: context,
      height: (MediaQuery.of(context).size.height * 0.175) + (60 * 5),
      scroll: true,
      keyboard: true,
      body: Column(
        children: [
          Text(
            'Responsável',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Form(
              key: buddyFormKey,
              child: Column(
                children: [
                  CustomTextFieldWidget(
                    controller: buddyNameController,
                    label: 'Nome do responsável',
                    placeholder: 'Tia May',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Escreva o nome do seu responsável para alterar';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextFieldWidget(
                    controller: buddyPhoneController,
                    label: 'Contato do responsável',
                    placeholder: '(99) 99999-9999',
                    keyboardType: TextInputType.number,
                    formatters: [
                      MaskTextInputFormatter(
                        mask: '(##) #####-####',
                        filter: { "#": RegExp(r'[0-9]') },
                        type: MaskAutoCompletionType.lazy,
                      ),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Escreva o contato do seu responsável para alterar';
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
          const SizedBox(
            height: 20,
          ),
          CustomButtonWidget(
            label: 'Confirmar informações do responsável',
            onPressed: () async {
              FocusManager.instance.primaryFocus?.unfocus();
              if (buddyFormKey.currentState!.validate()) {
                userController.buddy.value.name = buddyNameController.text;
                userController.buddy.value.phone = buddyPhoneController.text;
                Get.back();
              }
            },
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

  void _userInfoSuccessBottomSheet(BuildContext context, UserController userController, {bool password = false}) {
    CustomBottomSheetWidget.show(
      context: context,
      height: MediaQuery.of(context).size.height * 0.275,
      body: Column(
        children: [
          Text(
            !password ? 'Informações salvas com sucesso!' : 'Senha alterada com sucesso!',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  '[ Mensagem amigável ]',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          if (!password) ...[
            CustomTextButtonWidget(
              label: 'Ok, voltar para o início',
              onPressed: () {
                Get.offAllNamed('/home');
              },
            ),
          ],
          if (password) ...[
            CustomTextButtonWidget(
              label: 'Ok, voltar',
              onPressed: () {
                Get.back();
              },
            ),
          ],
        ],
      ),
    );
  }

  void _userInfoErrorBottomSheet(BuildContext context, String? message) {
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
