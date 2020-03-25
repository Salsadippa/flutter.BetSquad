import 'package:betsquad/widgets/dual_coloured_text.dart';
import 'package:betsquad/screens/login_screen.dart';
import 'package:betsquad/screens/tab_bar.dart';
import 'package:betsquad/services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:betsquad/api/match_api.dart';
import 'package:betsquad/services/local_database.dart';
import 'package:betsquad/models/match.dart';

class PreparationScreen extends StatefulWidget {
  static const String ID = 'preparation_screen';

  @override
  _PreparationScreenState createState() => _PreparationScreenState();
}

class _PreparationScreenState extends State<PreparationScreen> {
  FirebaseServices firebaseHelper = FirebaseServices();

  @override
  void initState() {
    super.initState();
    saveMatches();
  }

  saveMatches() async {
    List matches = await MatchApi().getMatches();

    for (final match in matches) {
      Match m = Match(
          id: match["id"],
          awayShirtColor: match["awayTeam"]["shirtUrl"],
          homeShirtColor: match["homeTeam"]["shirtUrl"],
          awayGoals: match["awayGoals"] ?? 0,
          homeGoals: match["homeGoals"] ?? 0,
          awayPenalties: match["awayPenalties"] ?? -1,
          homePenalties: match["homePenalties"] ?? -1,
          awayTeamName: match["awayTeam"]["name"],
          competitionId: match["competition"]["dbid"],
          competitionName: match["competition"]["name"],
          currentState: match["currentState"],
          date: match["date"],
          homeTeamName: match["homeTeam"]["name"],
          lastPolled: match["lastPolled"],
          minute: match["minute"],
          nextState: match["nextState"],
          round: match["round"],
          startTimestamp: match["start"],
          venue: match["venue"]);
      await DBProvider.db.insertMatch(m);
    }
    print("saved matches");
    if (await firebaseHelper.loggedInUser())
      Navigator.pushReplacementNamed(context, TabBarController.ID);
    else
      Navigator.pushReplacementNamed(context, LoginScreen.ID);
  }

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

    var upToDateText =
        DualColouredText('v1.0.0', 'Making sure you\'re up to date');

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
      inAsyncCall: true,
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
