import 'package:get/get.dart';
import 'package:medicine/providers/storage_provider.dart';

class SettingController extends GetxController {
  var loading = false.obs;

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
