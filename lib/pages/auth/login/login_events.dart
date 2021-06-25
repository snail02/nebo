import 'package:nebo_app/utils/view_model/view_model_event.dart';

abstract class LoginEvent extends ViewModelEvent {}

class CodeSent extends LoginEvent {}

class RequestConfirmationCodeError extends LoginEvent {}

class LoginError extends LoginEvent {}