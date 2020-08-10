import 'package:betsquad/screens/bet/bet_screen_tabs.dart';
import 'package:betsquad/screens/bet/h2h_bet_screen.dart';
import 'package:betsquad/screens/match/match_detail_tabs.dart';
import 'package:betsquad/screens/match/match_list_screen.dart';
import 'package:betsquad/screens/login_and_signup/preparation_screen.dart';
import 'package:betsquad/screens/login_and_signup/signup_address_screen.dart';
import 'package:betsquad/screens/login_and_signup/signup_userinfo_screen.dart';
import 'package:betsquad/screens/login_and_signup/signup_username_screen.dart';
import 'package:betsquad/screens/select_opponent_screen.dart';
import 'package:betsquad/screens/tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:betsquad/screens/login_and_signup/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'BetSquad',
      debugShowCheckedModeBanner: false,
      theme: Theme.of(context).copyWith(
          accentIconTheme:
              Theme.of(context).accentIconTheme.copyWith(color: Colors.white),
          accentColor: Colors.orange,
          primaryColor: Colors.white,
          primaryIconTheme:
              Theme.of(context).primaryIconTheme.copyWith(color: Colors.black),
          primaryTextTheme: Theme.of(context)
              .primaryTextTheme
              .apply(bodyColor: Colors.black)),
      initialRoute: PreparationScreen.ID,
      routes: {
        PreparationScreen.ID: (context) => PreparationScreen(),
        LoginScreen.ID: (context) => LoginScreen(),
        SignUpUsernameScreen.ID: (context) => SignUpUsernameScreen(),
        SignupUserInfoScreen.ID: (context) => SignupUserInfoScreen(),
        SignupAddressScreen.ID: (context) => SignupAddressScreen(),
        TabBarController.ID: (context) => TabBarController(),
        MatchListScreen.ID: (context) => MatchListScreen(),
        MatchDetailTabs.ID: (context) => MatchDetailTabs(),
        BetScreenTabs.ID: (context) => BetScreenTabs(),
        SelectOpponentScreen.ID: (context) => SelectOpponentScreen(),
      },
    );
  }
}
