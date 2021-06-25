import 'package:flutter/material.dart';
import 'package:nebo_app/pages/auth/login/login_page.dart';
import 'package:nebo_app/pages/splash/splash_page.dart';
import 'package:nebo_app/utils/common_modules.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CommonModules.init();
  runApp(MyApp());
  configLoading();
}



void configLoading() {
  EasyLoading.instance
  // ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..loadingStyle = EasyLoadingStyle.custom
  // ..indicatorSize = 45.0
    ..radius = 18.0
    ..progressColor = Colors.black
    ..backgroundColor = Colors.transparent
    ..indicatorColor = Colors.black
    ..textColor = Colors.black
    ..maskType = EasyLoadingMaskType.custom
    ..maskColor = Colors.white.withOpacity(0.5)
    ..userInteractions = false;
  // ..dismissOnTap = false;
  //..customAnimation = CustomAnimation();
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nebo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: SplashPage(),
      builder: EasyLoading.init(),
    );
  }
}



