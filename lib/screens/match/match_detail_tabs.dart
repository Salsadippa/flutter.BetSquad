import 'package:betsquad/screens/match/match_chat_screen.dart';
import 'package:betsquad/screens/match/match_stats_screen.dart';
import 'package:betsquad/widgets/betsquad_logo_balance_appbar.dart';
import 'package:betsquad/screens/match/match_feed_screen.dart';
import 'package:betsquad/screens/match/match_details_screen.dart';
import 'package:betsquad/screens/match/match_lineups_screen.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:betsquad/utilities/hex_color.dart';
import 'package:betsquad/widgets/match_header.dart';
import 'package:flutter/material.dart';
import 'package:betsquad/widgets/team_shirt_name_logo.dart';
import 'package:betsquad/models/match.dart';
import 'package:betsquad/widgets/swipeable_tabs.dart';

class MatchDetailTabs extends StatefulWidget {
  static const String ID = 'match_details_screen';

  @override
  _MatchDetailTabsState createState() => _MatchDetailTabsState();
}

class _MatchDetailTabsState extends State<MatchDetailTabs> {
  List<String> tabs = ['Feed', 'Details', 'Stats', 'Lineups', 'Chat'];
  int initPosition = 1;

  @override
  Widget build(BuildContext context) {
    final Match match = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: BetSquadLogoBalanceAppBar(),
      body: Column(
        children: <Widget>[
          MatchHeader(match: match),
          Expanded(
            child: CustomTabView(
              initPosition: initPosition,
              itemCount: tabs.length,
              tabBuilder: (context, index) => Tab(text: tabs[index]),
              pageBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return MatchFeedScreen(match);
                  case 1:
                    return MatchDetailsScreen(match);
                  case 2:
                    return MatchStatsScreen(match);
                  case 3:
                    return MatchLineupScreen(match);
                  default:
                    return MatchChatScreen();
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


