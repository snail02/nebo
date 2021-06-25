import 'package:flutter/material.dart';
import 'package:nebo_app/pages/privacy_policy/privacy_policy_states.dart';
import 'package:nebo_app/pages/privacy_policy/privacy_policy_view.dart';
import 'package:nebo_app/pages/privacy_policy/privacy_policy_view_model.dart';
import 'package:nebo_app/utils/common_ui/notifications_mixin.dart';
import 'package:nebo_app/widgets/app_button.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicyPage extends StatefulWidget {
  @override
  _PrivacyPolicyPageState createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage>
    with NotificationsMixin
    implements PrivacyPolicyView {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late PrivacyPolicyViewModel _viewModel;
  bool checkValuePrivacyPolicy = false;
  bool enabledButtonContinue = false;

  @override
  void initState() {
    _viewModel = PrivacyPolicyViewModel(view: this);
    _viewModel.loadPrivacyPolicy();
    //phoneFieldFocusNode.requestFocus();
    //passwordFieldFocusNode.requestFocus();
    // _viewModel.eventsStream.listen((event) {
    //   if (event is LoginError) {
    //     print("login error");
    //     //codeFieldFocusNode.requestFocus();
    //   }
    // });
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
          "Политика конфиденциальности",
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
          child: StreamBuilder<PrivacyPolicyState>(
            initialData: Idle(errors: {}),
            stream: _viewModel.statesStream,
            builder: (context, snapshot) {
              final PrivacyPolicyState state = snapshot.data!;

              final bool loadPrivacyPolicyInProgress =
                  state is LoadPrivacyPolicyInProgress;

              final Map<Field, String> fieldErrors = {};
              if (state is Idle) {
                fieldErrors.addAll(state.errors);
              }
              // loadPrivacyPolicyInProgress
              //     ? EasyLoading.show()
              //     : EasyLoading.dismiss();
              return Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  loadPrivacyPolicyInProgress
                      ? _buildLoadingView()
                      : Expanded(
                          child: Container(
                            child: SingleChildScrollView(
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                child: Text(
                                  _viewModel.textPrivacyPolicy.toString(),
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.openSans(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                  SizedBox(height: 32),
                  Container(
                    padding: EdgeInsets.only(left: 16, right: 32),
                    child: Row(
                      children: [
                        Checkbox(
                            value: checkValuePrivacyPolicy,
                            onChanged: (value) => _onChangedPrivacyPolicy(value!)),
                        SizedBox(width: 16,),
                        Flexible(
                          child: Text(
                            "Я ознакомлен и принимаю условия политики конфиденциальности и пользовательского соглашения",
                            style: GoogleFonts.openSans(
                              color: Colors.black38,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 32),
                  Row(children: <Widget>[
                    SizedBox(width: 32),
                    Expanded(
                      child: AppButton(
                        enabled: enabledButtonContinue,
                        text: "Продолжить",
                        onPressed: () async {},
                      ),
                    ),
                    SizedBox(width: 32),
                  ]),
                  SizedBox(height: 32),
                ],
              );
            },
          ), // This trailing comma makes auto-formatting nicer for build methods.
        ),
      ),
    );
  }

  void _onChangedPrivacyPolicy(bool value) {
    setState(() {
      checkValuePrivacyPolicy = value;
      enabledButtonContinue = value;
    });
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
  void openRegistrationPage() {
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => RegistrationPage(),
    //   ),
    // );
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
