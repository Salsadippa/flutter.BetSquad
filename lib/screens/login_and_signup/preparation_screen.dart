import 'dart:convert';

import 'package:betsquad/models/goal.dart';
import 'package:betsquad/models/match.dart';
import 'package:betsquad/models/card.dart' as BSCard;
import 'package:betsquad/models/substitution.dart';
import 'package:betsquad/services/push_notifications.dart';
import 'package:betsquad/utilities/utility.dart';
import 'package:betsquad/widgets/dual_coloured_text.dart';
import 'package:betsquad/screens/login_and_signup/login_screen.dart';
import 'package:betsquad/screens/tab_bar.dart';
import 'package:betsquad/services/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:betsquad/api/match_api.dart';
import 'package:betsquad/services/local_database.dart';

import '../alert.dart';

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
    await DBProvider.db.deleteAllMatchesAndData();

    List matches = await MatchApi().getMatches();
    List<Future<dynamic>> futures = [];
    if (matches != null) {
      for (final match in matches) {
        Match m = Match(
          id: match["id"],
          awayShirtColor: match["awayTeam"]["shirtUrl"],
          homeShirtColor: match["homeTeam"]["shirtUrl"],
          awayTeamId: match["awayTeam"]["dbid"],
          homeTeamId: match["homeTeam"]["dbid"],
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
          round: match["round"] != null ? match["round"]["name"].toString() : "-",
          startTimestamp: match["start"],
          venue: match["venue"] != null ? match["venue"]["name"] : "-",
          stage: match["stage"] != null ? match["stage"]["name"] + " " + match["stage"]["type"] : "-",
          stats: match["stats"] != null ? json.encode(match["stats"]) : null,
          homeLineup: match["homePlayers"] != null ? json.encode(match["homePlayers"]) : null,
          awayLineup: match["awayPlayers"] != null ? json.encode(match["awayPlayers"]) : null,
        );

        futures.add(DBProvider.db.insertMatch(m));

        if (match["goals"] != null) {
          for (final goal in match["goals"]) {
            Goal g = Goal(
                id: goal['id'],
                type: goal["goalType"],
                side: goal["side"],
                scoringPlayer: goal["scoringPlayer"],
                matchId: m.id,
                playerId: goal["playerId"],
                minute: goal["minute"]);
            futures.add(DBProvider.db.insertGoal(g));
          }
        }

        if (match["cards"] != null) {
          for (final card in match["cards"]) {
            BSCard.Card c = BSCard.Card(
                id: card['id'],
                cardType: card["cardType"],
                minute: card["minute"],
                player: card["player"],
                playerId: card["playerId"],
                side: card["side"],
                matchId: m.id);
            futures.add(DBProvider.db.insertCard(c));
          }
        }

        if (match["substitutions"] != null) {
          for (final sub in match["substitutions"]) {
            Substitution s = Substitution(
                id: sub['id'],
                matchId: m.id,
                side: sub["side"],
                minute: sub["minute"],
                playerIn: sub["playerIn"],
                playerInId: sub["playerInId"],
                playerOut: sub["playerOut"],
                playerOutId: sub["playerOutId"]);
            futures.add(DBProvider.db.insertSub(s));
          }
        }
      }
    }

    Future.wait(futures).then((values) async {
     // if (!(await Utility().isInTheUk())) {
     //   Alert.showErrorDialog(
     //       context,
     //       'UK Access Only',
     //       'You are not in the UK or we could not verify your location so we can\'t let you in. '
     //           'Make sure location access is enabled and relaunch the app.');
     //   return;
     // }

      print("saved match data");

      if (await firebaseHelper.loggedInUser()){
        await PushNotificationsManager().init();
        Navigator.pushReplacementNamed(context, TabBarController.ID);
      }
      else
        Navigator.pushReplacementNamed(context, LoginScreen.ID);

    });
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

    var upToDateText = DualColouredText('', 'Making sure you\'re up to date');

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
