


import 'package:nebo_app/api/exceptions/dio_exceptions.dart';
import 'package:nebo_app/pages/auth/auth_api.dart';
import 'package:nebo_app/pages/auth/auth_login_data_response.dart';
import 'package:nebo_app/pages/auth/result_response.dart';
import 'package:nebo_app/pages/auth/user_activation/user_activation_events.dart';
import 'package:nebo_app/pages/auth/user_activation/user_activation_states.dart';
import 'package:nebo_app/pages/auth/user_activation/user_activation_view.dart';

import 'package:nebo_app/utils/common_ui/common_notification.dart';
import 'package:nebo_app/utils/repositories/user_repository.dart';
import 'package:nebo_app/utils/view_model/view_model.dart';

class UserActivationViewModel extends ViewModel<UserActivationView,
    UserActivationState, UserActivationEvent> {
  UserActivationViewModel({required UserActivationView view}) : super(view: view);

  final AuthApi _authApi = AuthApi();
  bool isCodeSent = false;

  final Map<Field, String> _fieldErrors = {};

  final UserRepository _userRepository = UserRepository();

  bool _isCodeNotEmpty({
    required String code,
  }) {
    return code.isNotEmpty;
  }

  void checkCodeButtonClicked({
    required String code,
    required String id,
  }) {
    if (!_isCodeNotEmpty(code: code)) {
      showNotif(msg: "Введите код");
    }
    else{
      _checkCode(code: code, id: id);
    }
  }

  Future<void> _checkCode({required String code, required String id}) async {
    statesStreamController.add(UserActivationInProgress());
    await _authApi.checkCode(code: code, id: id).then((authLoginDataResponse) {
      return _onSuccessCheckCodeToApi(authLoginDataResponse);
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

  void _onSuccessCheckCodeToApi( AuthLoginDataResponse authLoginDataResponse) async {

    if (authLoginDataResponse.token != null) {
      await _userRepository.saveUserToken(authLoginDataResponse.token.toString());
      _addIdleState();
      view.openPrimaryPage();
    } else {
      _addIdleState();
      if(authLoginDataResponse.detail!=null) {
        String withoutEquals = authLoginDataResponse.detail!;
        withoutEquals = withoutEquals.replaceAll("],", "\n");
        withoutEquals = withoutEquals.replaceAll("]", "");
        withoutEquals = withoutEquals.replaceAll('[', '');
        view.showNotificationBanner(
          CommonUiNotification(
            type: CommonUiNotificationType.ERROR,
            message: withoutEquals,
          ),
        );
      }
      else
        view.showNotificationBanner(
          CommonUiNotification(
            type: CommonUiNotificationType.ERROR,
            message: "Не удалось получить данные",
          ),
        );
    }
  }


  Future<void> sendCode({required String id}) async {
    statesStreamController.add(UserActivationInProgress());
    await _authApi.sendCode(id: id).then((resultResponse) {
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

  void _onSuccessSendCodeToApi( ResultResponse resultResponse) async {
    _addIdleState();
    if (resultResponse.result != null) {
      if(resultResponse.result == 'ok'){
        //statesStreamController.add(SentCode());
        view.showNotificationBanner(
          CommonUiNotification(
            type: CommonUiNotificationType.ALERT,
            message: 'Code sent',
          ),
        );
      }
      else{
        view.showNotificationBanner(
          CommonUiNotification(
            type: CommonUiNotificationType.ERROR,
            message: 'bad',
          ),
        );
      }
    } else {
      if(resultResponse.detail!=null)
        view.showNotificationBanner(
          CommonUiNotification(
            type: CommonUiNotificationType.ERROR,
            message: resultResponse.detail.toString(),
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
