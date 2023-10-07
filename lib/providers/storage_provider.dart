
import 'package:shared_preferences/shared_preferences.dart';

class StorageProvider {
  static Future<bool> writeJson({required String key, required String json}) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.setString(key, json);
  }

  static Future<String> readJson({required String key}) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(key) ?? '{}';
  }

  static Future<bool> removeJson({required String key}) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.remove(key);
  }
}
