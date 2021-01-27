import 'package:betsquad/screens/payments/deposit_page.dart';
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
            actions: [

            ],
          );
        });
  }

  static showDepositError(BuildContext context, String title, String subtitle) {
    // set up the button
    Widget okButton = FlatButton(
      color: Colors.red,
      child: Text("OK", style: TextStyle(color: Colors.white, fontSize: 15)),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the button
    Widget deposit = FlatButton(
      color: Colors.green,
      child: Text("Deposit", style: TextStyle(color: Colors.white, fontSize: 15)),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return DepositPage();
            },
          ),
        );
      },
    );

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
            actions: [
              okButton,
              Container(width: 10,),
              deposit
            ],
          );
        });
  }
}
