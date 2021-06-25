

import 'package:nebo_app/utils/view_model/view_model_state.dart';

abstract class NewPasswordState extends ViewModelState {}

class Idle extends NewPasswordState {
  final Map<Field, String> errors;

  Idle({
    required this.errors,
  });
}

enum Field {
  PHONE,
  CODE,
}


class SavePasswordInProgress extends NewPasswordState {}