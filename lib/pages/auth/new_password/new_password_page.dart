import 'package:flutter/material.dart';
import 'package:nebo_app/model/auth/user_auth_data.dart';
import 'package:nebo_app/model/auth/user_data_recovery.dart';
import 'package:nebo_app/pages/auth/login/login_page.dart';
import 'package:nebo_app/pages/auth/new_password/new_password_states.dart';
import 'package:nebo_app/pages/auth/new_password/new_password_view.dart';
import 'package:nebo_app/pages/auth/new_password/new_password_view_model.dart';
import 'package:nebo_app/pages/primary/primary_page.dart';
import 'package:nebo_app/utils/common_ui/notifications_mixin.dart';
import 'package:nebo_app/widgets/app_button.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';

class NewPasswordPage extends StatefulWidget {
  final UserDataRecovery userDataRecovery;

  const NewPasswordPage({Key? key, required this.userDataRecovery})
      : super(key: key);

  @override
  _NewPasswordPageState createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage>
    with NotificationsMixin
    implements NewPasswordView {
  final FocusNode passwordFieldFocusNode = FocusNode();
  final FocusNode confirmPasswordFieldFocusNode = FocusNode();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  late NewPasswordViewModel _viewModel;

  String labelTextPasswordField = "Пароль";
  String textAppBar = "";

  @override
  void initState() {
    _viewModel = NewPasswordViewModel(view: this);
    labelTextPasswordField = 'Новый пароль';
    textAppBar = "Восстановление пароля";
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
          textAppBar,
          style: GoogleFonts.openSans(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white30,
      ),
      body: GestureDetector(
        child: SafeArea(
          child: StreamBuilder<NewPasswordState>(
            initialData: Idle(errors: {}),
            stream: _viewModel.statesStream,
            builder: (context, snapshot) {
              final NewPasswordState state = snapshot.data!;

              final bool savePasswordInProgress =
                  state is SavePasswordInProgress;

              final Map<Field, String> fieldErrors = {};
              if (state is Idle) {
                fieldErrors.addAll(state.errors);
              }
              savePasswordInProgress
                  ? EasyLoading.show()
                  : EasyLoading.dismiss();
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 64),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormField(
                        focusNode: passwordFieldFocusNode,
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: labelTextPasswordField,
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
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
                    SizedBox(height: 64),
                    Row(children: <Widget>[
                      SizedBox(width: 32),
                      Expanded(
                        child: AppButton(
                          text: "Сохранить",
                          onPressed: () async {
                            _viewModel.sendSaveButtonClicked(phone: widget.userDataRecovery.phone, code: widget.userDataRecovery.code, password: passwordController.text, confirmPassword: confirmPasswordController.text);
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

  @override
  void openLoginPage() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false,
    );
  }

  @override
  void openPrimaryPage() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => PrimaryPage()),
          (Route<dynamic> route) => false,
    );
  }
}
