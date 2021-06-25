

import 'package:flutter/material.dart';
import 'package:nebo_app/pages/auth/login/login_page.dart';
import 'package:nebo_app/pages/primary/primary_page.dart';
import 'package:nebo_app/pages/splash/splash_view.dart';
import 'package:nebo_app/pages/splash/splash_view_model.dart';
import 'package:nebo_app/utils/common_ui/notifications_mixin.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with NotificationsMixin implements SplashView {

  late SplashViewModel _viewModel;

  @override
  void initState() {
    _viewModel = SplashViewModel(view: this);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          "Nebo",
          style: GoogleFonts.openSans(
          color: Colors.blueAccent,
          fontSize: 32,
          fontWeight: FontWeight.w600,
        )
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

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



}
