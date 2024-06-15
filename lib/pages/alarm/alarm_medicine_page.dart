import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medicine/controllers/alarm_controller.dart';
import 'package:medicine/models/dose_type.dart';
import 'package:medicine/widgets/custom_button_widget.dart';
import 'package:medicine/widgets/custom_header_widget.dart';
import 'package:medicine/widgets/custom_image_picker_widget.dart';
import 'package:medicine/widgets/custom_page_widget.dart';
import 'package:medicine/widgets/custom_select_item_widget.dart';
import 'package:medicine/widgets/custom_stepper_widget.dart';
import 'package:medicine/widgets/custom_text_button_widget.dart';
import 'package:medicine/widgets/custom_text_field_widget.dart';

class AlarmMedicinePage extends StatefulWidget {
  const AlarmMedicinePage({super.key});

  @override
  State<AlarmMedicinePage> createState() => _AlarmMedicinePageState();
}

class _AlarmMedicinePageState extends State<AlarmMedicinePage> {
  final AlarmController alarmController = Get.find();

  @override
  Widget build(BuildContext context) {
    return CustomPageWidget(
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const CustomHeaderWidget(),
          const SizedBox(
            height: 20,
          ),
          const CustomStepperWidget(
            current: 1,
            steps: [
              CustomStepperStep(
                icon: Icons.medication_outlined,
                label: 'Remédio',
              ),
              CustomStepperStep(
                icon: Icons.add_alarm_rounded,
                label: 'Alarme',
              ),
              CustomStepperStep(
                icon: Icons.check_circle_outline_rounded,
                label: 'Confirmar',
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: PageView(
              controller: alarmController.medicinePageController,
              children: const [
                AlarmMedicineNameView(),
                AlarmMedicineTypeView(),
                AlarmMedicineQuantityView(),
                AlarmMedicineImageView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AlarmMedicineNameView extends StatelessWidget {
  const AlarmMedicineNameView({super.key});
  @override
  Widget build(BuildContext context) {
    final AlarmController alarmController = Get.find();
    final formKey = GlobalKey<FormState>();
    TextEditingController medicineNameController = TextEditingController(text: alarmController.name.value);
    return Column(
      children: [
        Text(
          'Qual será o remédio?',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: Form(
            key: formKey,
            child: CustomTextFieldWidget(
              controller: medicineNameController,
              label: 'Escreva o remédio que precisa tomar',
              placeholder: 'Ex: Paracetamol',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Escreva o nome do remédio para continuar';
                }
                return null;
              },
              onChanged: (value) {
                if (value.isNotEmpty) {
                  formKey.currentState!.validate();
                }
              },
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
              alarmController.name.value = medicineNameController.text;
              alarmController.medicinePageController.nextPage(
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
          label: 'Voltar ao início',
          onPressed: () {
            Get.back();
          },
        ),
      ],
    );
  }
}

class AlarmMedicineTypeView extends StatefulWidget {
  const AlarmMedicineTypeView({super.key});
  @override
  State<AlarmMedicineTypeView> createState() => _AlarmMedicineTypeViewState();
}
class _AlarmMedicineTypeViewState extends State<AlarmMedicineTypeView> {
  @override
  Widget build(BuildContext context) {
    final AlarmController alarmController = Get.find();
    List<DoseType> doseTypeList = DoseType.getDoseTypeList();
    return Column(
      children: [
        Text(
          'Qual é o tipo de dose?',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Toque para selecionar uma das opções',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(
                  height: 5,
                ),
                ...doseTypeList.map(
                  (DoseType doseType) => Column(
                    children: [
                      CustomSelectItemWidget(
                        label: doseType.name,
                        icon: Icon(
                          Icons.chevron_right_rounded,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 20,
                        ),
                        selected: doseType.id == alarmController.doseType.value.id,
                        onPressed: () {
                          setState(() {
                            alarmController.doseType.value = doseType;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        CustomButtonWidget(
          label: 'Próximo',
          onPressed: () {
            alarmController.medicinePageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
          },
        ),
        const SizedBox(
          height: 5,
        ),
        CustomTextButtonWidget(
          label: 'Voltar',
          onPressed: () {
            alarmController.medicinePageController.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          },
        ),
      ],
    );
  }
}

class AlarmMedicineQuantityView extends StatelessWidget {
  const AlarmMedicineQuantityView({super.key});
  @override
  Widget build(BuildContext context) {
    final AlarmController alarmController = Get.find();
    final formKey = GlobalKey<FormState>();
    TextEditingController medicineQuantityController = TextEditingController(
      text: alarmController.quantity.value == 0 ? '' : alarmController.quantity.value.toString(),
    );
    return Column(
      children: [
        Text(
          'Quantas doses precisam ser tomadas?',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: Form(
            key: formKey,
            child: CustomTextFieldWidget(
              controller: medicineQuantityController,
              label: 'Preencha a quantidade de alarmes a serem criados',
              placeholder: 'Ex: 10',
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Preencha a quantidade para continuar';
                }
                return null;
              },
              onChanged: (value) {
                if (value.isNotEmpty) {
                  formKey.currentState!.validate();
                }
              },
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
              alarmController.quantity.value = int.tryParse(medicineQuantityController.text) ?? 0;
              alarmController.medicinePageController.nextPage(
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
            alarmController.medicinePageController.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          },
        ),
      ],
    );
  }
}

class AlarmMedicineImageView extends StatefulWidget {
  const AlarmMedicineImageView({super.key});
  @override
  State<AlarmMedicineImageView> createState() => _AlarmMedicineImageViewState();
}
class _AlarmMedicineImageViewState extends State<AlarmMedicineImageView> {
  @override
  Widget build(BuildContext context) {
    final AlarmController alarmController = Get.find();
    return Column(
      children: [
        Text(
          'Deseja adicionar uma foto?',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: CustomImagePickerWidget(
                    label: 'Toque para escolher ${alarmController.image.value.isNotEmpty ? '\n' : ''}uma foto',
                    image: alarmController.image.value.isNotEmpty ? base64Decode(alarmController.image.value) : null,
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
                        alarmController.image.value = base64Encode(bytes);
                      });
                    },
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                if (alarmController.image.value.isNotEmpty) ...[
                  InkWell(
                    onTap: () {
                      setState(() {
                        alarmController.image.value = '';
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
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        CustomButtonWidget(
          label: 'Continuar para alarme',
          onPressed: () {
            Get.toNamed('/alarm/info');
          },
        ),
        const SizedBox(
          height: 5,
        ),
        CustomTextButtonWidget(
          label: 'Voltar',
          onPressed: () {
            alarmController.medicinePageController.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          },
        ),
      ],
    );
  }
}
