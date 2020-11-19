import 'package:betsquad/api/users_api.dart';
import 'package:betsquad/screens/login_and_signup/login_screen.dart';
import 'package:betsquad/services/firebase_services.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:betsquad/widgets/betsquad_logo_balance_appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../alert.dart';

class SelfExclusionPage extends StatefulWidget {
  @override
  _SelfExclusionPageState createState() => _SelfExclusionPageState();
}

class _SelfExclusionPageState extends State<SelfExclusionPage> {
  bool oneDay = false, oneWeek = false, oneMonth = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BetSquadLogoBalanceAppBar(),
      body: Container(
        padding: EdgeInsets.all(20),
        decoration: kGradientBoxDecoration,
        child: Column(
          children: [
            ListTile(
              onTap: () {
                setState(() {
                  oneDay = true;
                  oneWeek = false;
                  oneMonth = false;
                });
              },
              title: Text(
                '24 hours',
                style: GoogleFonts.roboto(color: Colors.white),
              ),
              trailing: oneDay
                  ? Icon(
                      Icons.check_box,
                      color: kBetSquadOrange,
                    )
                  : Icon(
                      Icons.check_box_outline_blank,
                      color: Colors.grey,
                    ),
            ),
            ListTile(
              onTap: () {
                setState(() {
                  oneDay = false;
                  oneWeek = true;
                  oneMonth = false;
                });
              },
              title: Text(
                '1 week',
                style: GoogleFonts.roboto(color: Colors.white),
              ),
              trailing: oneWeek
                  ? Icon(
                      Icons.check_box,
                      color: kBetSquadOrange,
                    )
                  : Icon(
                      Icons.check_box_outline_blank,
                      color: Colors.grey,
                    ),
            ),
            ListTile(
              onTap: () {
                setState(() {
                  oneDay = false;
                  oneWeek = false;
                  oneMonth = true;
                });
              },
              title: Text(
                '1 month',
                style: GoogleFonts.roboto(color: Colors.white),
              ),
              trailing: oneMonth
                  ? Icon(
                      Icons.check_box,
                      color: kBetSquadOrange,
                    )
                  : Icon(
                      Icons.check_box_outline_blank,
                      color: Colors.grey,
                    ),
            ),
            SizedBox(height: 30),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 45,
              color: kBetSquadOrange,
              child: FlatButton(
                child: Text(
                  'Self Exclude',
                  style: GoogleFonts.roboto(color: Colors.white, fontSize: 17),
                ),
                onPressed: () async {
                  int exclusionPeriod;
                  if (oneDay) {
                    exclusionPeriod = 86400000;
                  } else if (oneWeek) {
                    exclusionPeriod = 604800000;
                  } else if (oneMonth) {
                    exclusionPeriod = 2592000000;
                  } else {
                    return;
                  }
                  var res = await UsersApi.selfExclusion(exclusionPeriod: exclusionPeriod);
                  print(res.runtimeType);
                  if (res['result'] == 'success') {
                    await FirebaseServices().signOut();
                    Navigator.of(context, rootNavigator: true).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  } else {
                    Alert.showErrorDialog(context, 'Self Exclusion Failed', res['message']);
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
