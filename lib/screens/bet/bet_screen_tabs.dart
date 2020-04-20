import 'package:betsquad/screens/bet/h2h_bet_screen.dart';
import 'package:betsquad/screens/bet/ngs_bet_screen.dart';
import 'package:betsquad/screens/match/match_stats_screen.dart';
import 'package:betsquad/widgets/betsquad_logo_balance_appbar.dart';
import 'package:betsquad/screens/match/match_feed_screen.dart';
import 'package:betsquad/screens/match/match_details_screen.dart';
import 'package:betsquad/screens/match/match_lineups_screen.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:betsquad/utilities/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:betsquad/widgets/team_shirt_name_logo.dart';
import 'package:betsquad/models/match.dart';
import 'package:betsquad/widgets/swipeable_tabs.dart';

class BetScreenTabs extends StatefulWidget {
  static const String ID = 'bet_screen_tabs';

  @override
  _BetScreenTabsState createState() => _BetScreenTabsState();
}

class _BetScreenTabsState extends State<BetScreenTabs> {
  List<String> tabs = ['HEAD 2 HEAD', 'NEXT GOAL SWEEPSTAKE'];
  int initPosition = 0;

  @override
  Widget build(BuildContext context) {
    final Match match = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: BetSquadLogoBalanceAppBar(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: CustomTabView(
              initPosition: initPosition,
              itemCount: tabs.length,
              tabBuilder: (context, index) => Tab(text: tabs[index]),
              pageBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return Head2HeadBetScreen(match);
                  default:
                    return NGSBetScreen(match);
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
