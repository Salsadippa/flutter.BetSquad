import 'package:betsquad/screens/login_and_signup/login_screen.dart';
import 'package:betsquad/screens/login_and_signup/preparation_screen.dart';
import 'package:betsquad/services/firebase_services.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:betsquad/widgets/betsquad_logo_balance_appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DeleteAccountPage extends StatefulWidget {
  @override
  _DeleteAccountPageState createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  String _email, _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BetSquadLogoBalanceAppBar(),
      body: Container(
        padding: EdgeInsets.all(20),
        decoration: kGradientBoxDecoration,
        child: Column(
          children: [
            TextField(
              style: GoogleFonts.roboto(color: Colors.white),
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                labelText: 'Email',
                labelStyle: GoogleFonts.roboto(color: kBetSquadOrange),
              ),
              onChanged: (value) {
                setState(() {
                  _email = value;
                });
              },
            ),
            TextField(
              obscureText: true,
              style: GoogleFonts.roboto(color: Colors.white),
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                labelText: 'Password',
                labelStyle: GoogleFonts.roboto(color: kBetSquadOrange),
              ),
              onChanged: (value) {
                setState(() {
                  _password = value;
                });
              },
            ),
            SizedBox(height: 30),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 45,
              color: kBetSquadOrange,
              child: FlatButton(
                child: Text(
                  'Delete Account',
                  style: GoogleFonts.roboto(color: Colors.white, fontSize: 17),
                ),
                onPressed: () async {
                  bool deleted = await FirebaseServices().deleteUser(_email, _password);
                  if (deleted) {
                    Navigator.of(context, rootNavigator: true).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
