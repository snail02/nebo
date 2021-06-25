import 'package:flutter/material.dart';
import 'package:nebo_app/pages/auth/forgot_password/get_code_recovery/get_code_recovery_page.dart';
import 'package:nebo_app/pages/auth/login/login_events.dart';
import 'package:nebo_app/pages/auth/login/login_states.dart';
import 'package:nebo_app/pages/auth/login/login_view.dart';
import 'package:nebo_app/pages/auth/login/login_view_model.dart';
import 'package:nebo_app/pages/auth/new_password/new_password_page.dart';
import 'package:nebo_app/pages/auth/registration/registration_page.dart';
import 'package:nebo_app/pages/primary/primary_page.dart';
import 'package:nebo_app/pages/privacy_policy/privacy_policy_page.dart';
import 'package:nebo_app/utils/common_ui/notifications_mixin.dart';
import 'package:nebo_app/widgets/app_button.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with NotificationsMixin
    implements LoginView {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final FocusNode phoneFieldFocusNode = FocusNode();
  final FocusNode passwordFieldFocusNode = FocusNode();

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  late LoginViewModel _viewModel;

  @override
  void initState() {
    _viewModel = LoginViewModel(view: this);

    //phoneFieldFocusNode.requestFocus();
    //passwordFieldFocusNode.requestFocus();
    _viewModel.eventsStream.listen((event) {
      if (event is LoginError) {
        print("login error");
        //codeFieldFocusNode.requestFocus();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        child: SafeArea(
          child: StreamBuilder<LoginState>(
            initialData: Idle(errors: {}),
            stream: _viewModel.statesStream,
            builder: (context, snapshot) {
              final LoginState state = snapshot.data!;

              final bool loginInProgress = state is LoginInProgress;

              final Map<Field, String> fieldErrors = {};
              if (state is Idle) {
                fieldErrors.addAll(state.errors);
              }
              loginInProgress ? EasyLoading.show() : EasyLoading.dismiss();
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 75),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Вход",
                        style: GoogleFonts.openSans(
                          color: Colors.black,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(height: 75),
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
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormField(
                        focusNode: passwordFieldFocusNode,
                        controller: passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Пароль',
                        ),
                      ),
                    ),
                    SizedBox(height: 31),
                    Row(children: <Widget>[
                      SizedBox(width: 32),
                      Expanded(
                        child: AppButton(
                          enabled: true,
                          text: "Войти",
                          onPressed: () async {
                            _viewModel.sendLoginButtonClicked(
                                phone: phoneController.text,
                                password: passwordController.text);
                          },
                        ),
                      ),
                      SizedBox(width: 32),
                    ]),
                    SizedBox(height: 64),
                    TextButton(
                        onPressed: openPrivacyPolicyPage,
                        child: Text("Регистрация",
                            style: GoogleFonts.openSans(
                              color: Colors.blueAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ))),
                    SizedBox(height: 24),
                    TextButton(
                        onPressed: openGetCodeRecoveryPage,
                        child: Text("Забыли пароль?",
                            style: GoogleFonts.openSans(
                              color: Colors.blueAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ))),
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

  Widget _buildPhoneNumberPart({
    required String errorText,
    required bool isActive,
  }) {
    return _buildPhoneNumberContent(
      errorText: errorText,
      isActive: isActive,
    );
  }

  Widget _buildPhoneNumberContent({
    required String errorText,
    required bool isActive,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        TextFormField(),
        SizedBox(
          height: 8,
        ),
        AppButton(
          enabled: isActive,
          text: 'Выслать код',
          onPressed: () async {
            // _viewModel.sendCodeButtonClicked(phone: phoneController.text);
          },
        ),
      ],
    );
  }

  Widget _buildCodePart({
    required String errorText,
    required bool isActive,
  }) {
    return _buildCodeContent(
      errorText: errorText,
      isActive: isActive,
    );
  }

  Widget _buildCodeContent({
    required String errorText,
    required bool isActive,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        TextFormField(),
        SizedBox(
          height: 8,
        ),
        AppButton(
          enabled: isActive,
          text: 'Отправить',
          onPressed: () async {
            //_viewModel.confirmCodeButtonClicked(code: codeController.text);
          },
        ),
      ],
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

  @override
  void openPrivacyPolicyPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RegistrationPage(),
      ),
    );
  }

  @override
  void openGetCodeRecoveryPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GetCodeRecoveryPage(),
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



  Future<void> showToast(String msg) async {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black26,
        textColor: Colors.white,
        fontSize: 16.0);
  }


}
