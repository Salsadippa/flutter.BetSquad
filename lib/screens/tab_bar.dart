import 'package:betsquad/models/match_data.dart';
import 'package:betsquad/models/match.dart';
import 'package:betsquad/screens/bet/bet_history_page.dart';
import 'package:betsquad/screens/bet/bet_screen_tabs.dart';
import 'package:betsquad/screens/match/match_list_screen.dart';
import 'package:betsquad/screens/profile/squads_tab.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:betsquad/widgets/betsquad_logo_profile_balance_appbar.dart';
import 'package:flutter/material.dart';
import 'package:betsquad/widgets/fab_bottom_app_bar.dart';
import 'package:betsquad/screens/chat_tab.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class TabBarController extends StatefulWidget {
  static const String ID = 'tab_bar';

  @override
  _TabBarControllerState createState() => _TabBarControllerState();
}

class _TabBarControllerState extends State<TabBarController> {
  int currentTab = 0;
  final List<Widget> screens = [
    MatchListScreen(),
    BetHistoryPage(),
    ChatTabScreen(),
    SquadsTab(),
  ];

  final PageStorageBucket bucket = PageStorageBucket();

  void _selectedTab(int index) {
    setState(() {
      currentTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MatchData>(
      create: (_) => MatchData(),
      child: Scaffold(
        appBar: BetSquadLogoProfileBalanceAppBar(),
        body: PageStorage(bucket: bucket, child: screens[currentTab]),
          bottomNavigationBar: FABBottomAppBar(
            color: Colors.grey,
            selectedColor: kBetSquadOrange,
            notchedShape: CircularNotchedRectangle(),
            onTabSelected: _selectedTab,
            items: [
              FABBottomAppBarItem(iconData: MdiIcons.soccerField, text: 'Matches'),
              FABBottomAppBarItem(iconData: MdiIcons.coins, text: 'Bets'),
              FABBottomAppBarItem(iconData: Icons.chat_bubble_outline, text: 'Chat'),
              FABBottomAppBarItem(iconData: Icons.supervised_user_circle, text: 'Squads'),
            ],
          ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: BetNowButton(),
      ),
    );
  }
}

class BetNowButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Match selectedMatch = Provider.of<MatchData>(context).selectedMatch;
    return Container(
      width: 95,
      height: 100,
      child: Visibility(
        visible: selectedMatch != null,
        child: FloatingActionButton(
          shape: CircleBorder(side: BorderSide(color: kBetSquadOrange, width: 2.0)),
          onPressed: () {
            print("bet now");
            print(selectedMatch);
            Navigator.pushNamed(context, BetScreenTabs.ID, arguments: selectedMatch);
          },
          backgroundColor: Colors.black,
          child: Text(
            'BET\nNOW',
            style: TextStyle(color: Colors.white, fontSize: 20),
            textAlign: TextAlign.center,
          ),
          elevation: 10.0,
        ),
      ),
    );
  }
}
