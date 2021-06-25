

import 'package:shared_preferences/shared_preferences.dart';

class CommonModules {
  static late SharedPreferences sharedPreferences;

  static Future<void> init() async {
    print("2222");
    sharedPreferences = await SharedPreferences.getInstance();
    print("1111");
    //sharedPreferences.clear();
  }

  static Future<void> setStringByKey(String key, String str) async {
    await sharedPreferences.setString(key, str);
  }

  static String? getStringByKey(String key) {
    return sharedPreferences.containsKey(key)
        ? sharedPreferences.getString(key)
        : null;
  }
}
