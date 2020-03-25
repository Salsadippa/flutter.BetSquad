import 'package:betsquad/widgets/betsquad_logo_balance_appbar.dart';
import 'package:betsquad/screens/match_feed_screen.dart';
import 'package:betsquad/screens/match_info_screen.dart';
import 'package:betsquad/screens/match_lineups_screen.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:betsquad/utilities/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:betsquad/widgets/team_shirt_name_logo.dart';
import 'package:betsquad/models/match.dart';
import 'package:betsquad/widgets/swipeable_tabs.dart';

class MatchDetailsScreen extends StatefulWidget {
  static const String ID = 'match_details_screen';

  @override
  _MatchDetailsScreenState createState() => _MatchDetailsScreenState();
}

class _MatchDetailsScreenState extends State<MatchDetailsScreen> {
  List<String> tabs = ['Feed', 'Details', 'Lineups', 'Chat'];
  int initPosition = 1;

  @override
  Widget build(BuildContext context) {
    final Match match = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: BetSquadLogoBalanceAppBar(),
      body: Column(
        children: <Widget>[
          Container(
            decoration: kGrassTrimBoxDecoration,
            height: 125,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TeamShirtNameLogo(
                    teamName: match.homeTeamName,
                    shirtColor: HexColor(match.homeShirtColor)),
                Container(
                  width: 75,
                  height: 75,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[Text('Fri\n20:45', style: TextStyle(color: Colors.white),textAlign: TextAlign.center,)],
                  ),
                ),
                TeamShirtNameLogo(
                    teamName: match.awayTeamName,
                    shirtColor: HexColor(match.awayShirtColor)),
              ],
            ),
          ),
          Expanded(
            child: CustomTabView(
              initPosition: initPosition,
              itemCount: tabs.length,
              tabBuilder: (context, index) => Tab(text: tabs[index]),
              pageBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return MatchFeedScreen();
                  case 1:
                    return MatchInfoScreen();
                  case 2:
                    return MatchLineupsScreen();
                  default:
                    return MatchFeedScreen();
                }
              },
              onPositionChange: (index) {
                initPosition = index;
              },
            ),
          )
        ],
      ),
    );
  }
}
