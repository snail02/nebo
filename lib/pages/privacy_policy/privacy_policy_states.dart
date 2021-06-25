

import 'package:nebo_app/utils/view_model/view_model_state.dart';

abstract class PrivacyPolicyState extends ViewModelState {}

class Idle extends PrivacyPolicyState {
  final Map<Field, String> errors;

  Idle({
    required this.errors,
  });
}

enum Field {
  PHONE,
  CODE,
}


class LoadPrivacyPolicyInProgress extends PrivacyPolicyState {}