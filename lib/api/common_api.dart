

import 'package:dio/dio.dart';
import 'package:nebo_app/api/api.dart';
import 'package:nebo_app/api/exceptions/dio_exceptions.dart';
import 'package:nebo_app/pages/privacy_policy/privacy_policy_data_response.dart';

class CommonApi extends Api {

  Future<PrivacyPolicyDataResponse> getPrivacyPolicy() async {
    Response response = await super.authRequest(
      functionName: 'get-privacy-policy/',
      method: 'GET',
    );
    final Map<dynamic, dynamic> responseMap = response.data;

    if (responseMap['detail'] != null)
      throw DioExceptions.setMessage(
          responseMap['detail'].toString());
    return PrivacyPolicyDataResponse.fromJson(responseMap);

  }
}
