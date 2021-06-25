import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nebo_app/model/user/user.dart';
import 'package:nebo_app/pages/auth/login/login_page.dart';
import 'package:nebo_app/pages/auth/user_activation/user_activation_states.dart';
import 'package:nebo_app/pages/auth/user_activation/user_activation_view.dart';
import 'package:nebo_app/pages/auth/user_activation/user_activation_view_model.dart';
import 'package:nebo_app/pages/primary/primary_page.dart';
import 'package:nebo_app/utils/common_ui/notifications_mixin.dart';
import 'package:nebo_app/widgets/app_button.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';

class UserActivationPage extends StatefulWidget {

  final User user;

  const UserActivationPage({Key? key, required this.user})
      : super(key: key);

  @override
  _UserActivationPageState createState() => _UserActivationPageState();
}

class _UserActivationPageState extends State<UserActivationPage>
    with NotificationsMixin
    implements UserActivationView {


  final FocusNode codeFieldFocusNode = FocusNode();

  final TextEditingController codeController = TextEditingController();


  late UserActivationViewModel _viewModel;

  bool enabledSendCodeButton = false;
  int waitTimeResend = 30;
  bool codeSent = true;

  Timer? _timer;

  @override
  void initState() {
    _viewModel = UserActivationViewModel(view: this);
    _startTimer();
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
      //resizeToAvoidBottomInset: false,
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
          "Проверка кода",
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
          child: StreamBuilder<UserActivationState>(
            initialData: Idle(errors: {}),
            stream: _viewModel.statesStream,
            builder: (context, snapshot) {
              final UserActivationState state = snapshot.data!;

              final bool userActivationInProgress =
              state is UserActivationInProgress;

             // final bool sentCode = state is SentCode;

              final Map<Field, String> fieldErrors = {};
              if (state is Idle) {
                fieldErrors.addAll(state.errors);
              }
              userActivationInProgress ? EasyLoading.show() : EasyLoading.dismiss();
              return   SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 64),
                    Visibility(
                      visible: !enabledSendCodeButton,
                      maintainState :true,
                      maintainAnimation:true,
                      maintainSize:true,
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
                            _viewModel.sendCode(id: widget.user.id.toString());
                            _startTimer();
                          },
                        ),
                      ),
                      SizedBox(width: 32),
                    ]),
                    Container(
                      child: Column(children: [
                        SizedBox(height: 32),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: TextFormField(
                            focusNode: codeFieldFocusNode,
                            controller: codeController,
                            decoration:  InputDecoration(
                              labelText: 'Код',
                            ),
                          ),
                        ),
                        SizedBox(height: 32),
                        AppButton(
                          text: "ОК",
                          onPressed: () async {
                            _viewModel.checkCodeButtonClicked(code:codeController.text, id :widget.user.id.toString());
                          },
                        ),
                      ],),
                    ),
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

  @override
  void openPrimaryPage() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => PrimaryPage()),
          (Route<dynamic> route) => false,
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

  void _startTimer(){
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

}
