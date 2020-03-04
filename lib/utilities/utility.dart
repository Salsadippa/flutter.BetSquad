import 'package:flutter/material.dart';

class Utility {

  static Utility utility;

  static Utility getInstance(){
    if(utility == null){
      utility = Utility();
    }
    return utility;
  }

  showErrorAlertDialog(BuildContext context, String alertTitle, String alertMessage){
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("OK"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(alertTitle),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(alertMessage)
          ],
        ),
      ),
      actions: [
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  bool isNumeric(String s) {
    if(s == null) {
      return false;
    }
    return double.parse(s) != null;
  }

}