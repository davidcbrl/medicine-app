
import 'package:shared_preferences/shared_preferences.dart';

class StorageProvider {
  static Future<bool> writeJson(String key, String json) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.setString(key, json);
  }

  static Future<String> readJson(String key) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(key) ?? '{}';
  }
}
