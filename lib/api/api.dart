import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nebo_app/api/exceptions/dio_exceptions.dart';


abstract class Api {
  static final options = BaseOptions(
    baseUrl: 'https://nebo.ws/api/',
    connectTimeout: 10000,
    receiveTimeout: 5000,
  );

  static final authOptions = BaseOptions(
    baseUrl: 'https://auth.nebo.ws/api/',
    connectTimeout: 10000,
    receiveTimeout: 5000,
  );

  // Dio dio = Dio(options)..interceptors.add(ErrorInterceptor());
  Dio dio = Dio(options);
  Dio authDio = Dio(authOptions);

  @protected
  Future<Response<dynamic>> authRequest({
    required String functionName,
    required String method,
    String? token,
    Map<String, dynamic>? body = const {},
    Map<String, dynamic>? queryParameters = const {},
  }) async {
    try {
      final response = await authDio.request(
        functionName,
        data: body,
        queryParameters: queryParameters,
         options: Options(
             method: method),
      );

      //final Map<dynamic, dynamic> data = response.data;
      return response;
    } catch (e) {
      if (e is DioError)
        throw DioExceptions.fromDioError(e);
      else
        throw e;
    }
  }


}
