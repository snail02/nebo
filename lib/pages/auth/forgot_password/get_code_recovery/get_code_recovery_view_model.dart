


import 'package:nebo_app/api/exceptions/dio_exceptions.dart';
import 'package:nebo_app/pages/auth/auth_api.dart';
import 'package:nebo_app/pages/auth/forgot_password/get_code_recovery/get_code_recovery_events.dart';
import 'package:nebo_app/pages/auth/forgot_password/get_code_recovery/get_code_recovery_states.dart';
import 'package:nebo_app/pages/auth/forgot_password/get_code_recovery/get_code_recovery_view.dart';
import 'package:nebo_app/pages/auth/result_response.dart';
import 'package:nebo_app/utils/common_ui/common_notification.dart';
import 'package:nebo_app/utils/view_model/view_model.dart';

class GetCodeRecoveryViewModel extends ViewModel<GetCodeRecoveryView,
    GetCodeRecoveryState, GetCodeRecoveryEvent> {
  GetCodeRecoveryViewModel({required GetCodeRecoveryView view}) : super(view: view);

  final AuthApi _authApi = AuthApi();
  bool isCodeSent = false;

  final Map<Field, String> _fieldErrors = {};


  bool _isPhoneNotEmpty({
    required String phone,
  }) {
    return phone.isNotEmpty;
  }


  void sendLoginButtonClicked({
    required String phone,
  }) {
    if (!_isPhoneNotEmpty(phone: phone)) {
      showNotif(msg: "Введите номер телефона");
    }
    else{
      restoreSendCode(phone: phone);
    }
  }


  Future<void> restoreSendCode({required String phone}) async {
    statesStreamController.add(RecoveryInProgress());
    await _authApi.restoreSendCode(phone: phone).then((restoreSendCodeDataResponse) {
      return _onSuccessSendCodeToApi(restoreSendCodeDataResponse);
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

  void _onSuccessSendCodeToApi(
      ResultResponse restoreSendCodeDataResponse) async {
    _addIdleState();
    if (restoreSendCodeDataResponse.result != null) {
      if(restoreSendCodeDataResponse.result == 'ok'){
        isCodeSent = true;
        view.startTimer();
        view.showNotificationBanner(
          CommonUiNotification(
            type: CommonUiNotificationType.ALERT,
            message: 'CODE: 1111',
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
      if(restoreSendCodeDataResponse.detail!=null)
      view.showNotificationBanner(
        CommonUiNotification(
          type: CommonUiNotificationType.ERROR,
          message: restoreSendCodeDataResponse.detail.toString(),
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
