import 'package:betsquad/screens/match_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:betsquad/widgets/fab_bottom_app_bar.dart';
import 'package:betsquad/screens/bets_tab.dart';
import 'package:betsquad/screens/chat_tab.dart';
import 'package:betsquad/screens/squads_tab.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TabBarController extends StatefulWidget {
  static const String ID = 'tab_bar';

  @override
  _TabBarControllerState createState() => _TabBarControllerState();
}

class _TabBarControllerState extends State<TabBarController> {
  int currentTab = 0;
  final List<Widget> screens = [
    MatchListScreen(),
    BetsTabScreen(),
    ChatTabScreen(),
    SquadsTabScreen(),
  ];

  final PageStorageBucket bucket = PageStorageBucket();

  void _selectedTab(int index) {
    setState(() {
      currentTab = index;
    });
  }

  void _selectedFab() {
    setState(() {
      print("bet now");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        child: screens[currentTab],
        bucket: bucket,
      ),
      bottomNavigationBar: FABBottomAppBar(
        color: Colors.grey,
        selectedColor: Colors.blueAccent,
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
      floatingActionButton: Container(
        width: 95,
        height: 100,
        child: Visibility(
          visible: true,
          child: FloatingActionButton(
            shape: CircleBorder(side: BorderSide(color: Colors.orange, width: 2.0)),
            onPressed: () {
              _selectedFab();
            },
            backgroundColor: Colors.black,
            child: Text(
              'BET\nNOW', style: TextStyle(color: Colors.white, fontSize: 20), textAlign: TextAlign.center,
            ),
            elevation: 10.0,
          ),
        ),
      ),
    );
  }
}
