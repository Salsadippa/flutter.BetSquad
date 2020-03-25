import 'package:betsquad/screens/match_details_screen.dart';
import 'package:betsquad/screens/match_feed_screen.dart';
import 'package:betsquad/screens/match_info_screen.dart';
import 'package:betsquad/screens/match_lineups_screen.dart';
import 'package:betsquad/screens/match_list_screen.dart';
import 'package:betsquad/screens/preparation_screen.dart';
import 'package:betsquad/screens/signup_address_screen.dart';
import 'package:betsquad/screens/signup_userinfo_screen.dart';
import 'package:betsquad/screens/signup_username_screen.dart';
import 'package:betsquad/screens/tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:betsquad/screens/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'BetSquad',
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
        MatchDetailsScreen.ID: (context) => MatchDetailsScreen(),
        MatchInfoScreen.ID: (context) => MatchInfoScreen(),
        MatchFeedScreen.ID: (context) => MatchFeedScreen(),
        MatchLineupsScreen.ID: (context) => MatchLineupsScreen(),
      },
    );
  }
}
