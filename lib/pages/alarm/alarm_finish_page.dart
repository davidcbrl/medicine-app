import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine/widgets/custom_button_widget.dart';
import 'package:medicine/widgets/custom_page_widget.dart';

class AlarmFinishPage extends StatelessWidget {
  const AlarmFinishPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPageWidget(
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/img/success.gif',
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Alarme para remédio criado com sucesso!',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          CustomButtonWidget(
            label: 'Voltar para o início',
            onPressed: () {
              Get.offAllNamed('/home');
            },
          ),
        ],
      )
    );
  }
}
