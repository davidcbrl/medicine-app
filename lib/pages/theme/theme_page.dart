import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine/controllers/setting_controller.dart';
import 'package:medicine/models/calendar_style.dart';
import 'package:medicine/providers/firebase_provider.dart';
import 'package:medicine/widgets/custom_header_widget.dart';
import 'package:medicine/widgets/custom_page_widget.dart';
import 'package:medicine/widgets/custom_select_item_widget.dart';
import 'package:medicine/widgets/custom_text_button_widget.dart';

class ThemePage extends StatefulWidget {
  const ThemePage({super.key});

  @override
  State<ThemePage> createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  SettingController settingController = Get.find();

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
          Expanded(
            child: Column(
              children: [
                Text(
                  'Customizar app',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Tema',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(
                  height: 5,
                ),
                CustomSelectItemWidget(
                  label: 'Claro',
                  selected: settingController.get(name: 'theme').isNotEmpty && settingController.get(name: 'theme') == 'ThemeMode.light',
                  onPressed: () {
                    FirebaseProvider.instance.log(name: 'theme_color_light');
                    Get.changeThemeMode(ThemeMode.light);
                    settingController.set(name: 'theme', value: ThemeMode.light.toString());
                    setState(() {
                      settingController.theme.value = ThemeMode.light.toString();
                    });
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                CustomSelectItemWidget(
                  label: 'Escuro',
                  selected: settingController.get(name: 'theme').isNotEmpty && settingController.get(name: 'theme') == 'ThemeMode.dark',
                  onPressed: () {
                    FirebaseProvider.instance.log(name: 'theme_color_dark');
                    Get.changeThemeMode(ThemeMode.dark);
                    settingController.set(name: 'theme', value: ThemeMode.dark.toString());
                    setState(() {
                      settingController.theme.value = ThemeMode.dark.toString();
                    });
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                CustomSelectItemWidget(
                  label: 'Automático (dispositivo)',
                  selected: settingController.get(name: 'theme').isEmpty || settingController.get(name: 'theme') == 'ThemeMode.system',
                  onPressed: () {
                    FirebaseProvider.instance.log(name: 'theme_color_system');
                    Get.changeThemeMode(ThemeMode.system);
                    settingController.set(name: 'theme', value: ThemeMode.system.toString());
                    setState(() {
                      settingController.theme.value = ThemeMode.system.toString();
                    });
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Estilo do calendário',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(
                  height: 5,
                ),
                ...CalendarStyle.getCalendarStyleList().map(
                  (CalendarStyle calendarStyle) => Column(
                    children: [
                      CustomSelectItemWidget(
                        label: calendarStyle.name,
                        selected: settingController.get(name: 'calendar').isNotEmpty
                          ? calendarStyle.id.toString() == settingController.get(name: 'calendar')
                          : calendarStyle.id.toString() == '1',
                        onPressed: () {
                          FirebaseProvider.instance.log(name: 'theme_calendar_${calendarStyle.name.toLowerCase()}');
                          settingController.set(name: 'calendar', value: calendarStyle.id.toString());
                          setState(() {
                            settingController.calendar.value = calendarStyle.id.toString();
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
          const SizedBox(
            height: 20,
          ),
          CustomTextButtonWidget(
            label: 'Voltar',
            onPressed: () {
              FirebaseProvider.instance.log(name: 'theme_back');
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}
