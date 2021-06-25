import 'package:nebo_app/api/exceptions/dio_exceptions.dart';
import 'package:nebo_app/pages/auth/auth_api.dart';
import 'package:nebo_app/pages/auth/auth_login_data_response.dart';
import 'package:nebo_app/pages/auth/new_password/new_password_events.dart';
import 'package:nebo_app/pages/auth/new_password/new_password_states.dart';
import 'package:nebo_app/pages/auth/new_password/new_password_view.dart';
import 'package:nebo_app/pages/auth/result_response.dart';
import 'package:nebo_app/utils/common_ui/common_notification.dart';
import 'package:nebo_app/utils/repositories/user_repository.dart';
import 'package:nebo_app/utils/view_model/view_model.dart';

class NewPasswordViewModel
    extends ViewModel<NewPasswordView, NewPasswordState, NewPasswordEvent> {
  NewPasswordViewModel({required NewPasswordView view}) : super(view: view);

  final AuthApi _authApi = AuthApi();

  bool isCodeSent = false;

  final Map<Field, String> _fieldErrors = {};

  final UserRepository _userRepository = UserRepository();

  String _isFiledNotEmpty({
    required String password,
    required String confirmPassword,
  }) {
    if (password.isEmpty) return "Введите пароль";
    if (confirmPassword.isEmpty) return "Повторите пароль";
    return "ok";
  }

  bool _isValidPassword(
      {required String password, required String confirmPassword}) {
    if (password == confirmPassword)
      return true;
    else
      return false;
  }

  void sendSaveButtonClicked({
    required String phone,
    required String code,
    required String password,
    required String confirmPassword,
  }) {
    var result = _isFiledNotEmpty(password: password, confirmPassword: confirmPassword);
    if (result != 'ok') {
      showNotif(msg: result);
    } else {
      if(_isValidPassword(password: password, confirmPassword: confirmPassword))
      _changePassword(phone: phone, code: code, password: password, confirmPassword: confirmPassword);
      else
        showNotif(msg: "Пароли должны совпадать");
    }
  }

  Future<void> _changePassword(
      {required String phone,
      required String code,
      required String password,
      required String confirmPassword}) async {
    statesStreamController.add(SavePasswordInProgress());
    await _authApi.changePassword(code: code, phone: phone, newPassword1: password, newPassword2: confirmPassword)
        .then((authLoginDataResponse) {
      return _onSuccessChangePasswordToApi(authLoginDataResponse);
    }).catchError((e) async {
      if (e is DioExceptions) {
        _addIdleState();
        view.showNotificationBanner(
          CommonUiNotification(
            type: CommonUiNotificationType.ERROR,
            message: e.message,
          ),
        );
      }
    });
  }

  void _onSuccessChangePasswordToApi(AuthLoginDataResponse authLoginDataResponse) async {

    if (authLoginDataResponse.token != null) {
      await _userRepository.saveUserToken(authLoginDataResponse.token.toString());
      _addIdleState();
       view.openPrimaryPage();

    } else {
      _addIdleState();
      if (authLoginDataResponse.detail != null)
        view.showNotificationBanner(
          CommonUiNotification(
            type: CommonUiNotificationType.ERROR,
            message: authLoginDataResponse.detail.toString(),
          ),
        );
      else
        view.showNotificationBanner(
          CommonUiNotification(
            type: CommonUiNotificationType.ERROR,
            message: "Не удалось получить данные",
          ),
        );
    }
  }

  void showNotif({required String msg}) {
    view.showNotificationBanner(
      CommonUiNotification(
        type: CommonUiNotificationType.ALERT,
        message: msg,
      ),
    );
  }

  void _addIdleState() {
    statesStreamController.add(
      Idle(
        errors: _fieldErrors,
      ),
    );
  }
}
