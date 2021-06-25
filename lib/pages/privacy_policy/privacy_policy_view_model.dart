import 'package:nebo_app/api/common_api.dart';
import 'package:nebo_app/api/exceptions/dio_exceptions.dart';
import 'package:nebo_app/pages/privacy_policy/privacy_policy_data_response.dart';
import 'package:nebo_app/pages/privacy_policy/privacy_policy_events.dart';
import 'package:nebo_app/pages/privacy_policy/privacy_policy_states.dart';
import 'package:nebo_app/pages/privacy_policy/privacy_policy_view.dart';
import 'package:nebo_app/utils/common_ui/common_notification.dart';
import 'package:nebo_app/utils/view_model/view_model.dart';

class PrivacyPolicyViewModel extends ViewModel<PrivacyPolicyView,
    PrivacyPolicyState, PrivacyPolicyEvent> {
  PrivacyPolicyViewModel({required PrivacyPolicyView view}) : super(view: view);

  final CommonApi _commonApi = CommonApi();

  String? textPrivacyPolicy;

  bool isCodeSent = false;

  final Map<Field, String> _fieldErrors = {};

  Future<void> loadPrivacyPolicy() async {
    statesStreamController.add(LoadPrivacyPolicyInProgress());
    await _commonApi.getPrivacyPolicy().then((privacyPolicyDataResponse) {
      return _onSuccessLoadPrivacyPolicyToApi(privacyPolicyDataResponse);
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

  void _onSuccessLoadPrivacyPolicyToApi(
      PrivacyPolicyDataResponse privacyPolicyDataResponse) async {
    _addIdleState();
    if (privacyPolicyDataResponse.text != null) {
      textPrivacyPolicy = privacyPolicyDataResponse.text.toString();
    } else {
      view.showNotificationBanner(
        CommonUiNotification(
          type: CommonUiNotificationType.ERROR,
          message: 'Не удалось получить данные',
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
}
