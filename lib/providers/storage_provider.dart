
import 'package:get_storage/get_storage.dart';

class StorageProvider {
  static void writeJson({required String key, required String json}) {
    GetStorage storage = GetStorage();
    storage.write(key, json);
  }

  static String readJson({required String key}) {
    GetStorage storage = GetStorage();
    return storage.read(key) ?? '{}';
  }

  static void removeJson({required String key}) {
    GetStorage storage = GetStorage();
    storage.remove(key);
  }
}
