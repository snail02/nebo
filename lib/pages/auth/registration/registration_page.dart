import 'package:flutter/material.dart';
import 'package:nebo_app/model/auth/user_auth_data.dart';
import 'package:nebo_app/model/auth/user_data_registration.dart';
import 'package:nebo_app/model/user/user.dart';
import 'package:nebo_app/pages/auth/login/login_page.dart';
import 'package:nebo_app/pages/auth/new_password/new_password_page.dart';
import 'package:nebo_app/pages/auth/registration/registration_states.dart';
import 'package:nebo_app/pages/auth/registration/registration_view.dart';
import 'package:nebo_app/pages/auth/registration/registration_view_model.dart';
import 'package:nebo_app/pages/auth/user_activation/user_activation_page.dart';
import 'package:nebo_app/pages/primary/primary_page.dart';
import 'package:nebo_app/utils/common_ui/notifications_mixin.dart';
import 'package:nebo_app/widgets/app_button.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage>
    with NotificationsMixin
    implements RegistrationView {

  final FocusNode phoneFieldFocusNode = FocusNode();
  final FocusNode codeFieldFocusNode = FocusNode();
  final FocusNode refererCodeFieldFocusNode = FocusNode();
  final FocusNode passwordFieldFocusNode = FocusNode();
  final FocusNode confirmPasswordFieldFocusNode = FocusNode();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController refererCodeController = TextEditingController();

  late RegistrationViewModel _viewModel;

  bool visibleFieldCode = false;
  bool enabledSendCodeButton = true;
  int waitTimeResend = 30;
  bool codeSent = false;

  @override
  void initState() {
    _viewModel = RegistrationViewModel(view: this);
    //phoneFieldFocusNode.requestFocus();
    //passwordFieldFocusNode.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.blue,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        shadowColor: Color.fromRGBO(0, 0, 0, 0.3),
        title: Text(
          "Регистрация",
          style: GoogleFonts.openSans(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white30,
      ),
      body: GestureDetector(
        child: SafeArea(
          child: StreamBuilder<RegistrationState>(
            initialData: Idle(errors: {}),
            stream: _viewModel.statesStream,
            builder: (context, snapshot) {
              final RegistrationState state = snapshot.data!;

              final bool registrationInProgress =
              state is RegistrationInProgress;

              final bool sentCode = state is SentCode;

              final Map<Field, String> fieldErrors = {};
              if (state is Idle) {
                fieldErrors.addAll(state.errors);
              }
              if(sentCode) {codeSent=true; visibleFieldCode = true;}
              registrationInProgress ? EasyLoading.show() : EasyLoading.dismiss();
              return   SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormField(
                        focusNode: phoneFieldFocusNode,
                        controller: phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Номер телефона',
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormField(
                        focusNode: refererCodeFieldFocusNode,
                        controller: refererCodeController,
                        decoration: const InputDecoration(
                          labelText: 'Реферальный код',
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormField(
                        focusNode: passwordFieldFocusNode,
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: "Введите пароль",
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormField(
                        focusNode: confirmPasswordFieldFocusNode,
                        controller: confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Повторите пароль',
                        ),
                      ),
                    ),

                    SizedBox(height: 24),
                    Row(children: <Widget>[
                      SizedBox(width: 32),
                      Expanded(
                        child: AppButton(
                          text: "Регистрация",
                          enabled: enabledSendCodeButton,
                          onPressed: () async {
                              _viewModel.sendRegistrationButtonClicked(phone: phoneController.text, password: passwordController.text, confirmPassword: confirmPasswordController.text, refererCode: refererCodeController.text );
                          },
                        ),
                      ),
                      SizedBox(width: 32),
                    ]),
                    SizedBox(height: 32),
                    Center(
                      child: TextButton(
                          onPressed: openLoginPage,
                          child: Text("Отмена",
                              style: GoogleFonts.openSans(
                                color: Colors.blueAccent,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ))),
                    ),
                    SizedBox(height: 32),
                  ],
                ),
              );
            },
          ), // This trailing comma makes auto-formatting nicer for build methods.
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Container(
      height: 36,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  // @override
  // void openCreateNewPasswordPage(UserAuthData userAuthData) {
  //   Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (context) => NewPasswordPage( userAuthData: userAuthData),
  //     ),
  //   );
  // }

  @override
  void openLoginPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  @override
  void openPrimaryPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => PrimaryPage(),
      ),
    );
  }

  @override
  void openUserActivationPage({required User user}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UserActivationPage(user: user,),
      ),
    );
  }

// Future<void> showToast(String msg) async {
//   Fluttertoast.showToast(
//       msg: msg,
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.CENTER,
//       timeInSecForIosWeb: 1,
//       backgroundColor: Colors.black26,
//       textColor: Colors.white,
//       fontSize: 16.0);
// }
}
