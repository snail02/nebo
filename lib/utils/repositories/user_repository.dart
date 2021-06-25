

import 'package:nebo_app/utils/common_modules.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  static const String _KEY_USER_TOKEN = "userToken";

  final SharedPreferences sharedPreferences = CommonModules.sharedPreferences;

  String? getUserToken() {
    return sharedPreferences.getString(_KEY_USER_TOKEN);
  }

  Future<void> saveUserToken(String token) async {
    await sharedPreferences.setString(_KEY_USER_TOKEN, token);
  }

  Future<void> clearUserToken() async {
    await sharedPreferences.setString(_KEY_USER_TOKEN, '');
  }

  Future<void> clear() async {
    await sharedPreferences.clear();
  }
}
