import 'package:betsquad/screens/preparation_screen.dart';
import 'package:betsquad/screens/signup_address_screen.dart';
import 'package:betsquad/screens/signup_userinfo_screen.dart';
import 'package:betsquad/screens/signup_username_screen.dart';
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
      initialRoute: LoginScreen.id,
      routes: {
        PreparationScreen.id: (context) => PreparationScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        SignUpUsernameScreen.id: (context) => SignUpUsernameScreen(),
        SignupUserInfoScreen.id: (context) => SignupUserInfoScreen(),
        SignupAddressScreen.id: (context) => SignupAddressScreen(),
      },
    );
  }
}
