import 'package:betsquad/screens/bet/bet_screen_tabs.dart';
import 'package:betsquad/screens/bet/h2h_bet_screen.dart';
import 'package:betsquad/screens/bet/ngs_assignments_page.dart';
import 'package:betsquad/screens/bet/ngs_invited_page.dart';
import 'package:betsquad/screens/bet/ngs_winner_page.dart';
import 'package:betsquad/screens/match/match_detail_tabs.dart';
import 'package:betsquad/screens/match/match_list_screen.dart';
import 'package:betsquad/screens/login_and_signup/preparation_screen.dart';
import 'package:betsquad/screens/login_and_signup/signup_address_screen.dart';
import 'package:betsquad/screens/login_and_signup/signup_userinfo_screen.dart';
import 'package:betsquad/screens/login_and_signup/signup_username_screen.dart';
import 'package:betsquad/screens/bet/select_opponent_screen.dart';
import 'package:betsquad/screens/profile/search_friends.dart';
import 'package:betsquad/screens/tab_bar.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:betsquad/screens/login_and_signup/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'BetSquad',
      debugShowCheckedModeBanner: false,
      theme: Theme.of(context).copyWith(
          accentIconTheme:
              Theme.of(context).accentIconTheme.copyWith(color: Colors.white),
          accentColor: kBetSquadOrange,
          primaryColor: Colors.white,
          primaryIconTheme:
              Theme.of(context).primaryIconTheme.copyWith(color: Colors.black),
          primaryTextTheme: Theme.of(context)
              .primaryTextTheme
              .apply(bodyColor: Colors.black, fontFamily: GoogleFonts.roboto().toString())),

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
        NGSInvitedPage.ID: (context) => NGSInvitedPage(),
        NGSAssignmentsPage.ID: (context) => NGSAssignmentsPage(),
        NGSWinnerPage.ID: (context) => NGSWinnerPage(),
        FindFriendsPage.ID: (context) => FindFriendsPage()
      },
    );
  }
}
