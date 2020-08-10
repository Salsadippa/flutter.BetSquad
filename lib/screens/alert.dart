import 'package:flutter/material.dart';
import 'package:rich_alert/rich_alert.dart';

class Alert {
  static showSuccessDialog(BuildContext context, String title, String subtitle) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return RichAlertDialog(
            alertTitle: richTitle(title),
            alertSubtitle: Text(
              subtitle,
              style: TextStyle(color: Colors.black, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            alertType: RichAlertType.SUCCESS,
          );
        });
  }

  static showErrorDialog(BuildContext context, String title, String subtitle) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return RichAlertDialog(
            alertTitle: richTitle(title),
            alertSubtitle: Text(
              subtitle,
              style: TextStyle(color: Colors.black, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            alertType: RichAlertType.ERROR,
          );
        });
  }
}
