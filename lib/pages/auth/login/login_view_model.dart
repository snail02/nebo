import 'package:nebo_app/api/exceptions/dio_exceptions.dart';
import 'package:nebo_app/pages/auth/auth_api.dart';
import 'package:nebo_app/pages/auth/auth_login_data_response.dart';
import 'package:nebo_app/pages/auth/login/login_events.dart';
import 'package:nebo_app/pages/auth/login/login_states.dart';
import 'package:nebo_app/pages/auth/login/login_view.dart';
import 'package:nebo_app/utils/common_ui/common_notification.dart';
import 'package:nebo_app/utils/repositories/user_repository.dart';
import 'package:nebo_app/utils/view_model/view_model.dart';

class LoginViewModel extends ViewModel<LoginView, LoginState, LoginEvent> {
  LoginViewModel({required LoginView view}) : super(view: view);

  final AuthApi _authApi = AuthApi();

  bool isCodeSent = false;

  final Map<Field, String> _fieldErrors = {};
  final UserRepository _userRepository = UserRepository();

  void phoneFieldChanged() {
    _fieldErrors.remove(Field.PHONE);
    _addIdleState();
  }

  void codeFieldChanged() {
    _fieldErrors.remove(Field.CODE);
    _addIdleState();
  }

  void sendLoginButtonClicked({
    required String phone,
    required String password,
  }) {
    if (!_isPhoneNotEmpty(phone: phone)) {
      showNotif(msg: "Введите номер телефона");
    }
    else {
      if (!_isPasswordNotEmpty(password: password)) {
        showNotif(msg: "Введите пароль");
      }
    else{
        _login(phone: phone, password: password);
      }
  }

    //_login(phone: phone, password: password);
    // if (_isPhoneValid(phone: phone)) {
    //   _login(phone: phone, password: password);
    // } else {
    //   _fieldErrors[Field.PHONE] = 'Некорректный номер телефона';
    //   _addIdleState();
    //   eventsStreamController.add(LoginError());
    // }
  }

  bool _isPhoneNotEmpty({
    required String phone,
  }) {
    return phone.isNotEmpty;
  }

  bool _isPasswordNotEmpty({
    required String password,
  }) {
    return password.isNotEmpty;
  }

  // void _requestConfirmationCode({
  //    String phone,
  // }) async {
  //   statesStreamController.add(RequestConfirmationCodeInProgress());
  //   await _authRepository.requestConfirmationCode(phone: phone).then((authData) {
  //     _firebaseAuthData = authData;
  //     if (_firebaseAuthData is FirebaseAuthWithoutSms) {
  //       _handleLoginWithoutSms();
  //     } else {
  //       isCodeSent = true;
  //       _addIdleState();
  //       eventsStreamController.add(CodeSent());
  //     }
  //   }).catchError((e) {
  //     view.showNotificationBanner(
  //       CommonUiNotification(
  //         type: CommonUiNotificationType.ERROR,
  //         message: 'Не удалось отправить код',
  //       ),
  //     );
  //     _addIdleState();
  //   });
  // }

  // void _handleLoginWithoutSms() {
  //   _addIdleState();
  //   _login();
  // }

  // void confirmCodeButtonClicked({
  //   String code,
  // }) {
  //   if (_isCodeValid(code: code)) {
  //     _login(code: code);
  //   } else {
  //     _fieldErrors[Field.CODE] = 'Неверный код';
  //     _addIdleState();
  //   }
  // }

  void _login({
    required String phone,
    required String password,
  }) async {
    statesStreamController.add(LoginInProgress());
    await _authApi
        .login(
      phone: phone,
      password: password,
    )
        .then((authLoginDataResponse) {
      _onSuccessLoginToApi(authLoginDataResponse);
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

  void _onSuccessLoginToApi(AuthLoginDataResponse authLoginDataResponse) async {
    _addIdleState();
    if (authLoginDataResponse.token != null) {
      await _userRepository.saveUserToken(authLoginDataResponse.token.toString());
      _addIdleState();
      view.openPrimaryPage();
    } else {
      if(authLoginDataResponse.detail!=null)
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

  bool _isCodeValid({
    required String code,
  }) {
    return code.length == 6;
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
