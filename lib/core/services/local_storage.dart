import 'package:shared_preferences/shared_preferences.dart';

class AppLocal {
  static String role = 'role';

  static Future<void> cacheData(String key, value) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString(key, value);
  }

  static Future<String> getData(String key) async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(key) ?? '0';
  }
}
