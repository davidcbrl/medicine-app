import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
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

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    TextEditingController emailController = TextEditingController(text: userController.email.value);
    TextEditingController nameController = TextEditingController(text: userController.name.value);
    TextEditingController phoneController = TextEditingController(text: userController.phone.value);
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
                                label: 'Toque para escolher ${userController.image.value.isNotEmpty ? '\n' : ''}uma foto',
                                image: userController.image.value.isNotEmpty ? base64Decode(userController.image.value) : null,
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
                            if (userController.image.value.isNotEmpty) ...[
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
                          icon: Icon(
                            Icons.chevron_right_rounded,
                            color: Theme.of(context).colorScheme.secondary,
                            size: 20,
                          ),
                          onPressed: () {},
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
                    await userController.save();
                    if (userController.status.isSuccess && context.mounted) {
                      _userInfoSuccessBottomSheet(context, userController);
                      return;
                    }
                    if (userController.status.isError && context.mounted) {
                      _userInfoErrorBottomSheet(context, userController);
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

  void _userInfoSuccessBottomSheet(BuildContext context, UserController userController) {
    CustomBottomSheetWidget.show(
      context: context,
      height: MediaQuery.of(context).size.height * 0.2,
      body: Column(
        children: [
          Text(
            'Informações salvas com sucesso!',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  ':)',
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
            label: 'Ok, voltar para o início',
            onPressed: () {
              Get.offAllNamed('/home');
            },
          ),
        ],
      ),
    );
  }

  void _userInfoErrorBottomSheet(BuildContext context, UserController userController) {
    CustomBottomSheetWidget.show(
      context: context,
      height: MediaQuery.of(context).size.height * 0.4,
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
