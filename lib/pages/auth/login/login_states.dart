

import 'package:nebo_app/utils/view_model/view_model_state.dart';

abstract class LoginState extends ViewModelState {}

class Idle extends LoginState {
  final Map<Field, String> errors;

  Idle({
    required this.errors,
  });
}

enum Field {
  PHONE,
  CODE,
}

class RequestConfirmationCodeInProgress extends LoginState {}

class LoginInProgress extends LoginState {}