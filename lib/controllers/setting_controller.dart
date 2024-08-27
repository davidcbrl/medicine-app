import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine/providers/storage_provider.dart';

class SettingController extends GetxController {
  var theme = ''.obs;

  @override
  onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      theme.value = get(name: 'theme');
      switch (theme.value) {
        case 'ThemeMode.light':
          Get.changeThemeMode(ThemeMode.light);
          break;
        case 'ThemeMode.dark':
          Get.changeThemeMode(ThemeMode.dark);
          break;
        default:
          Get.changeThemeMode(ThemeMode.system);
      }
    });
  }

  String get({required String name}) {
    String value = StorageProvider.readJson(key: 'setting.$name');
    if (value == '{}') {
      return '';
    }
    return value;
  }

  void set({required String name, required String value}) {
    StorageProvider.writeJson(key: 'setting.$name', json: value);
  }
}
