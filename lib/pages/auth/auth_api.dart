import 'package:dio/dio.dart';
import 'package:nebo_app/api/api.dart';
import 'package:nebo_app/api/exceptions/dio_exceptions.dart';
import 'package:nebo_app/model/user/user.dart';
import 'package:nebo_app/pages/auth/auth_login_data_response.dart';
import 'package:nebo_app/pages/auth/result_response.dart';

class AuthApi extends Api {
  Future<AuthLoginDataResponse> login({
    required String phone,
    required String password,
  }) async {
    Response response = await super.authRequest(
      functionName: 'signin/',
      method: 'POST',
      body: {
        'phone': phone,
        'password': password,
      },
    );
    final Map<dynamic, dynamic> responseMap = response.data;

    // if (responseMap['detail'] != null)
    //   throw DioExceptions.setMessage(responseMap['detail'].toString());
    return AuthLoginDataResponse.fromJson(responseMap);
  }

  Future<ResultResponse> restoreSendCode({
    required String phone,
  }) async {
    Response response = await super.authRequest(
      functionName: 'restore/send-code/',
      method: 'POST',
      body: {
        'phone': phone,
      },
    );

    if (response.data != null && response.data != '') {
      final Map<dynamic, dynamic> responseMap = response.data;
      if (responseMap['detail'] != null)
        return ResultResponse(detail: responseMap['detail'].toString());

    } else {
      if (response.statusCode == 200) return ResultResponse(result: "ok");
    }
    return ResultResponse(result: "bad");
  }

  Future<ResultResponse> registration({
    required String phone,
    String? refererCode,
    required String password,
    required String confirmPassword,
  }) async {
    Response response;
    if (refererCode != null && refererCode != '')
      response = await super.authRequest(
        functionName: 'signup/',
        method: 'POST',
        body: {
          'phone': phone,
          'referer': refererCode,
          'password1': password,
          'password2': confirmPassword,
        },
      );
    else
      response = await super.authRequest(
        functionName: 'signup/',
        method: 'POST',
        body: {
          'phone': phone,
          'password1': password,
          'password2': confirmPassword,
        },
      );
    final Map<dynamic, dynamic> responseMap = response.data;

    if (responseMap['detail'] != null)
      return ResultResponse(detail: responseMap['detail'].toString());
    if (responseMap['id'] != null) {
      int? intId;
      try {
        intId = int.tryParse(responseMap['id'].toString());
      } catch (e) {
        intId = null;
      }
      return ResultResponse(user: User(id: intId));
    }

    return ResultResponse(result: "bad");
  }

  Future<AuthLoginDataResponse> checkCode({
    required String code,
    required String id,
  }) async {
    Response response = await super.authRequest(
      functionName: 'check-code/',
      method: 'GET',
      queryParameters: {
        'code': code,
        'id': id,
      },
    );
    final Map<dynamic, dynamic> responseMap = response.data;

    // if (responseMap['detail'] != null)
    //   throw DioExceptions.setMessage(responseMap['detail'].toString());
    return AuthLoginDataResponse.fromJson(responseMap);
  }

  Future<ResultResponse> sendCode({
    required String id,
  }) async {
    Response response = await super.authRequest(
      functionName: 'send-code/',
      method: 'GET',
      queryParameters: {
        'id': id,
      },
    );

    if (response.data != null && response.data != '') {
      final Map<dynamic, dynamic> responseMap = response.data;
      if (responseMap['detail'] != null)
        return ResultResponse(detail: responseMap['detail'].toString());

    } else {
      if (response.statusCode == 200) return ResultResponse(result: "ok");
    }
    return ResultResponse(result: "bad");

  }

  Future<AuthLoginDataResponse> changePassword({
    required String code,
    required String phone,
    required String newPassword1,
    required String newPassword2,
  }) async {
    Response response = await super.authRequest(
      functionName: 'restore/change-password/',
      method: 'POST',
      body: {
        'code': code,
        'phone': phone,
        'new_password1': newPassword1,
        'new_password2': newPassword2,
      },
    );
    final Map<dynamic, dynamic> responseMap = response.data;

    // if (responseMap['detail'] != null)
    //   return AuthLoginDataResponse(detail: responseMap['detail'].toString());
    // if (responseMap['token'] != null)
    //   return ResultResponse(detail: responseMap['token'].toString());
    return AuthLoginDataResponse.fromJson(responseMap);
  }
}
