

import 'package:nebo_app/model/user/user.dart';

class ResultResponse{
  final String? result;
  final User? user;
  final String? detail;

  ResultResponse(
      {
        this.result,
        this.user,
        this.detail,
      });

}