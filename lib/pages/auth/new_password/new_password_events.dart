import 'package:nebo_app/utils/view_model/view_model_event.dart';

abstract class NewPasswordEvent extends ViewModelEvent {}

class CodeSent extends NewPasswordEvent {}

class RequestConfirmationCodeError extends NewPasswordEvent {}

class LoginError extends NewPasswordEvent {}