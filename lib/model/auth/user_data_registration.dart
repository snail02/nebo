

import 'package:nebo_app/model/auth/user_auth_data.dart';

class UserDataRegistration extends UserAuthData{

  final String phone;
  final String? refererCode;
  final String code;

  UserDataRegistration({
    required this.phone,
    this.refererCode,
    required this.code
});

}