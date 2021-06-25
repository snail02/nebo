

import 'package:nebo_app/utils/view_model/view_model_state.dart';

abstract class RegistrationState extends ViewModelState {}

class Idle extends RegistrationState {
  final Map<Field, String> errors;

  Idle({
    required this.errors,
  });
}

enum Field {
  PHONE,
  CODE,
}


class RegistrationInProgress extends RegistrationState {}
class SentCode extends RegistrationState {}