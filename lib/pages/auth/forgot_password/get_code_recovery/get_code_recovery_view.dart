

import 'package:nebo_app/model/auth/user_auth_data.dart';
import 'package:nebo_app/model/auth/user_data_recovery.dart';
import 'package:nebo_app/utils/view_model/view.dart';

abstract class GetCodeRecoveryView implements View {

  void openCreateNewPasswordPage({required UserDataRecovery userDataRecovery});
  void  startTimer();
}
