
import 'package:nebo_app/model/auth/user_auth_data.dart';

class UserDataRecovery extends UserAuthData{

  final String phone;
  final String code;

  UserDataRecovery({
    required this.phone,
    required this.code
  });


}