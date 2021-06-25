import 'package:nebo_app/utils/view_model/view_model_event.dart';

abstract class GetCodeRecoveryEvent extends ViewModelEvent {}

class CodeSent extends GetCodeRecoveryEvent {}