import 'package:betsquad/custom_widgets/dual_coloured_text.dart';
import 'package:flutter/material.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class PreparationScreen extends StatefulWidget {
  static String id = 'preparation_screen';

  @override
  _PreparationScreenState createState() => _PreparationScreenState();
}

class _PreparationScreenState extends State<PreparationScreen> {
  @override
  Widget build(BuildContext context) {

    var betSquadLogo = Container(
        height: 110,
        child: Image(
          image: kBetSquadLogoImage,
        ));

    var spacing = SizedBox(
      height: 30,
    );

    var upToDateText = DualColouredText('v1.0.0', 'Making sure you\'re up to date');

    var gamblingCommissionLogo = Container(
        margin: EdgeInsets.only(top: 100),
        height: 110,
        child: Image(
          image: kGamblingCommissionLogoImage,
        ));

    var gamblingCommissionText = Container(
      padding: EdgeInsets.all(20),
      child: Text(
        'BetSquad is operated by iTech Gaming Limited (Company Number 10668656), a UK company licensed and regulated by the UK Gambling Commission (License number 50996)',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
    );

    return ModalProgressHUD(
      inAsyncCall: false,
      child: Scaffold(
        body: Container(
          decoration: kPitchBackgroundDecoration,
          child: SafeArea(
            child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  betSquadLogo,
                  spacing,
                  upToDateText,
                  gamblingCommissionLogo,
                  gamblingCommissionText
                ]),
          ),
        ),
      ),
    );
  }
}
