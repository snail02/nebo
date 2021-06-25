

import 'package:nebo_app/utils/view_model/view_model_state.dart';

abstract class GetCodeRecoveryState extends ViewModelState {}

class Idle extends GetCodeRecoveryState {
  final Map<Field, String> errors;

  Idle({
    required this.errors,
  });
}

enum Field {
  PHONE,
  CODE,
}


class RecoveryInProgress extends GetCodeRecoveryState {}
class SentCode extends GetCodeRecoveryState {}