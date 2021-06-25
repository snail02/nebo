import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import 'common_notification.dart';

mixin NotificationsMixin<T extends StatefulWidget> on State<T> {
  void showNotificationBanner(CommonUiNotification notification) {
    Flushbar(
      margin: EdgeInsets.all(12),
      borderRadius: BorderRadius.all(Radius.circular(8)),
      title: notification.type == CommonUiNotificationType.ERROR ? 'Ошибка' : 'Внимание',
      message: notification.message,
      backgroundColor: Colors.black87,
      flushbarPosition: FlushbarPosition.TOP,
      icon: Icon(
        Icons.error_outline,
        color: Colors.white,
        size: 30,
      ),
      duration: Duration(seconds: 3),
    ).show(context);
  }
}