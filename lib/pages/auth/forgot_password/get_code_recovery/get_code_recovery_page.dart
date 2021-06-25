import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nebo_app/model/auth/user_auth_data.dart';
import 'package:nebo_app/model/auth/user_data_recovery.dart';
import 'package:nebo_app/pages/auth/forgot_password/get_code_recovery/get_code_recovery_events.dart';
import 'package:nebo_app/pages/auth/forgot_password/get_code_recovery/get_code_recovery_states.dart';
import 'package:nebo_app/pages/auth/forgot_password/get_code_recovery/get_code_recovery_view.dart';
import 'package:nebo_app/pages/auth/forgot_password/get_code_recovery/get_code_recovery_view_model.dart';
import 'package:nebo_app/pages/auth/new_password/new_password_page.dart';
import 'package:nebo_app/utils/common_ui/notifications_mixin.dart';
import 'package:nebo_app/widgets/app_button.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';

class GetCodeRecoveryPage extends StatefulWidget {
  @override
  _GetCodeRecoveryPageState createState() => _GetCodeRecoveryPageState();
}

class _GetCodeRecoveryPageState extends State<GetCodeRecoveryPage>
    with NotificationsMixin
    implements GetCodeRecoveryView {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final FocusNode phoneFieldFocusNode = FocusNode();
  final FocusNode codeFieldFocusNode = FocusNode();

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController codeController = TextEditingController();

  late GetCodeRecoveryViewModel _viewModel;

  bool visibleFieldCode = false;
  bool enabledSendCodeButton = true;
  int waitTimeResend = 30;
  bool codeSent = false;

  Timer? _timer;

  @override
  void initState() {
    _viewModel = GetCodeRecoveryViewModel(view: this);
    //phoneFieldFocusNode.requestFocus();
    //passwordFieldFocusNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if(_timer!=null)
    _timer!.cancel();
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
          "Восстановление пароля",
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
          child: StreamBuilder<GetCodeRecoveryState>(
            initialData: Idle(errors: {}),
            stream: _viewModel.statesStream,
            builder: (context, snapshot) {
              final GetCodeRecoveryState state = snapshot.data!;

              final bool recoveryInProgress = state is RecoveryInProgress;
              final bool sentCode = state is SentCode;

              final Map<Field, String> fieldErrors = {};
              if (state is Idle) {
                fieldErrors.addAll(state.errors);
              }
              if (sentCode) {codeSent = true; visibleFieldCode = true; }
              recoveryInProgress ? EasyLoading.show() : EasyLoading.dismiss();
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 64),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormField(
                        focusNode: phoneFieldFocusNode,
                        controller: phoneController,
                        decoration: InputDecoration(
                          labelText: 'Номер телефона',
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Visibility(
                      visible: !enabledSendCodeButton,
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                            "Повторная отправка кода будет доступна через: " +
                                waitTimeResend.toString() + " сек",
                            style: GoogleFonts.openSans(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            )),
                      ),
                    ),
                    SizedBox(height: 24),
                    Row(children: <Widget>[
                      SizedBox(width: 32),
                      Expanded(
                        child: AppButton(
                          text: "Получить код",
                          enabled: enabledSendCodeButton,
                          onPressed: () async {
                            _viewModel.sendLoginButtonClicked(
                                phone: phoneController.text);
                          },
                        ),
                      ),
                      SizedBox(width: 32),
                    ]),
                    Visibility(
                      visible: _viewModel.isCodeSent,
                      maintainState :true,
                      maintainAnimation:true,
                      maintainSize:true,
                      child: Container(
                        child: Column(children: [
                          SizedBox(height: 32),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: TextFormField(
                              focusNode: codeFieldFocusNode,
                              controller: codeController,
                              decoration: const InputDecoration(
                                labelText: 'Код',
                              ),
                            ),
                          ),
                          SizedBox(height: 32),
                          AppButton(
                            text: "ОК",
                            onPressed: () async {
                              openCreateNewPasswordPage(userDataRecovery: UserDataRecovery(phone: phoneController.text, code: codeController.text));
                            },
                          ),
                        ],),
                      ),
                    ),
                    SizedBox(height: 32),
                    Center(
                      child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
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

  @override
  void openCreateNewPasswordPage({required UserDataRecovery userDataRecovery}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NewPasswordPage( userDataRecovery: userDataRecovery),
      ),
    );
  }

  void startTimer(){
    waitTimeResend = 30;
    enabledSendCodeButton = false;
    if(_timer!=null)
      _timer!.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if(waitTimeResend>0){
          waitTimeResend--;
        }
        else {
          _timer!.cancel();
          enabledSendCodeButton = true;
        }
      });
    });
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
