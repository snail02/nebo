import 'package:nebo_app/api/exceptions/dio_exceptions.dart';
import 'package:nebo_app/model/user/user.dart';
import 'package:nebo_app/pages/auth/auth_api.dart';
import 'package:nebo_app/pages/auth/registration/registration_events.dart';
import 'package:nebo_app/pages/auth/registration/registration_states.dart';
import 'package:nebo_app/pages/auth/registration/registration_view.dart';
import 'package:nebo_app/pages/auth/result_response.dart';

import 'package:nebo_app/utils/common_ui/common_notification.dart';
import 'package:nebo_app/utils/view_model/view_model.dart';

class RegistrationViewModel
    extends ViewModel<RegistrationView, RegistrationState, RegistrationEvent> {
  RegistrationViewModel({required RegistrationView view}) : super(view: view);

  final AuthApi _authApi = AuthApi();
  bool isCodeSent = false;

  final Map<Field, String> _fieldErrors = {};

  User? user;

  String _isFiledNotEmpty({
    required String phone,
    required String password,
    required String confirmPassword,
  }) {
    if (phone.isEmpty) return "Введите номер телефона";
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

  void sendRegistrationButtonClicked({
    required String phone,
    String? refererCode,
    required String password,
    required String confirmPassword,
  }) {
    var result = _isFiledNotEmpty(
        phone: phone, password: password, confirmPassword: confirmPassword);
    if (result != 'ok') {
      showNotif(msg: result);
    } else {
      if (_isValidPassword(
          password: password, confirmPassword: confirmPassword))
        _registration(
            phone: phone,
            refererCode: refererCode,
            password: password,
            confirmPassword: confirmPassword);
      else
        showNotif(msg: "Пароли должны совпадать");
    }
  }

  Future<void> _registration(
      {required String phone,
      String? refererCode,
      required String password,
      required String confirmPassword}) async {
    statesStreamController.add(RegistrationInProgress());
    await _authApi
        .registration(
            phone: phone,
            refererCode: refererCode,
            password: password,
            confirmPassword: confirmPassword)
        .then((resultResponse) {
      return _onSuccessSendCodeToApi(resultResponse);
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

  void _onSuccessSendCodeToApi(ResultResponse resultResponse) async {
    _addIdleState();
    if (resultResponse.user != null && resultResponse.user!.id != null) {
      user = resultResponse.user;
      view.openUserActivationPage(user: user!);
    } else {
      if (resultResponse.detail != null) {
        String withoutEquals = resultResponse.detail!;
        withoutEquals = withoutEquals.replaceAll("],", "\n");
        withoutEquals = withoutEquals.replaceAll("]", "");
        withoutEquals = withoutEquals.replaceAll('[', '');
        print(withoutEquals);
        view.showNotificationBanner(
          CommonUiNotification(
            type: CommonUiNotificationType.ERROR,
            message: withoutEquals,
          ),
        );
      } else
        view.showNotificationBanner(
          CommonUiNotification(
            type: CommonUiNotificationType.ERROR,
            message: "Не удалось получить данные",
          ),
        );
    }
  }

  void _addIdleState() {
    statesStreamController.add(
      Idle(
        errors: _fieldErrors,
      ),
    );
  }

  void showNotif({required String msg}) {
    view.showNotificationBanner(
      CommonUiNotification(
        type: CommonUiNotificationType.ALERT,
        message: msg,
      ),
    );
  }
}
