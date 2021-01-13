import 'package:betsquad/styles/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/foundation.dart' show TargetPlatform;
import 'package:url_launcher/url_launcher.dart';

class Alerts {


  static showErrorAlert({BuildContext context, String title, String message }){
    Alert(
      context: context,
      type: AlertType.error,
      title: title,
      desc: message,
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
          color: kBetSquadOrange,
        )
      ],
    ).show();
  }

  static updateApp({BuildContext context}){

    var platform = Theme.of(context).platform;

    Alert(
      context: context,
      type: AlertType.error,
      title: "Version outdated",
      desc: "You're not on the latest version of the app",
      buttons: [
        DialogButton(
          child: Text(
            "Update",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => {
            if(platform == TargetPlatform.iOS){
              launch('https://apps.apple.com/gb/app/betsquad/id1542057706')
            }else{
              launch('https://play.google.com/store/apps/details?id=com.betsquad.betsquad')
            }
          },
          width: 120,
          color: kBetSquadOrange,
        )
      ],
    ).show();
  }

  static showSuccessAlert({BuildContext context, String title, String message}){
    Alert(
      context: context,
      type: AlertType.success,
      title: title,
      desc: message,
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
          color: kBetSquadOrange,
        )
      ],
    ).show();
  }

}