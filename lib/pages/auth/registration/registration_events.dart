import 'package:nebo_app/utils/view_model/view_model_event.dart';

abstract class RegistrationEvent extends ViewModelEvent {}

class CodeSent extends RegistrationEvent {}