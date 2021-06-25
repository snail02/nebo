import 'package:flutter/material.dart';
import 'package:nebo_app/pages/auth/login/login_page.dart';
import 'package:nebo_app/utils/common_ui/notifications_mixin.dart';
import 'package:nebo_app/utils/repositories/user_repository.dart';
import 'package:nebo_app/widgets/app_button.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';

class PrimaryPage extends StatefulWidget {
  @override
  _PrimaryPageState createState() => _PrimaryPageState();
}



class _PrimaryPageState extends State<StatefulWidget> with NotificationsMixin {

  final UserRepository _userRepository = UserRepository();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Color.fromRGBO(0, 0, 0, 0.3),
        title: Text(
          "Стартовое окно",
          style: GoogleFonts.openSans(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white30,
        actions: <Widget>[
          TextButton(
              onPressed: () async{
                await _userRepository.clearUserToken();
                openLoginPage();
              },
              child: Text(
                "Выход",
                style: GoogleFonts.openSans(
                  color: Theme.of(context).toggleableActiveColor,
                  //color: Color.fromRGBO(r, g, b, opacity)
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
              )),
          SizedBox(
            width: 16,
          )
        ],
      ),
      body: GestureDetector(
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            ],
          ),
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

  void openLoginPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }


}
