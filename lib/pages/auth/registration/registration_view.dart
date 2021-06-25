

import 'package:nebo_app/model/auth/user_auth_data.dart';
import 'package:nebo_app/model/user/user.dart';
import 'package:nebo_app/utils/view_model/view.dart';

abstract class RegistrationView implements View {

 // void openCreateNewPasswordPage(UserAuthData userAuthData);
  void openLoginPage();
  void openPrimaryPage();
  void openUserActivationPage({required User user});

}
