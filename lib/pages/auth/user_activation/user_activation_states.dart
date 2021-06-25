

import 'package:nebo_app/utils/view_model/view_model_state.dart';

abstract class UserActivationState extends ViewModelState {}

class Idle extends UserActivationState {
  final Map<Field, String> errors;

  Idle({
    required this.errors,
  });
}

enum Field {
  PHONE,
  CODE,
}


class UserActivationInProgress extends UserActivationState {}