import 'package:nebo_app/pages/splash/splash_events.dart';
import 'package:nebo_app/pages/splash/splash_states.dart';
import 'package:nebo_app/pages/splash/splash_view.dart';
import 'package:nebo_app/utils/repositories/user_repository.dart';
import 'package:nebo_app/utils/view_model/view_model.dart';

class SplashViewModel extends ViewModel<SplashView, SplashState, SlashEvent> {
  SplashViewModel({required SplashView view}) : super(view: view);

  final UserRepository _userRepository = UserRepository();

  @override
  void init() {
    super.init();
    _checkSavedAccessToken();
  }

  Future<void> _checkSavedAccessToken() async {
    String? userToken = _userRepository.getUserToken();
    await Future.delayed(Duration(seconds: 1));
    if (userToken!= null) {
      if (userToken.isNotEmpty) {
        print(userToken);
        view.openPrimaryPage();
      } else
        view.openLoginPage();
    } else {
      view.openLoginPage();
    }
  }
}
