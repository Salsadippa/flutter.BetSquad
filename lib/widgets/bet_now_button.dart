import 'package:betsquad/models/match_data.dart';
import 'package:betsquad/screens/bet/bet_screen_tabs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:betsquad/models/match.dart';

class BetNowButton extends StatelessWidget {
  final Function onPressed;
  final String title;

  const BetNowButton({Key key, this.onPressed, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Match selectedMatch = Provider.of<MatchData>(context).selectedMatch;
    return Container(
      width: 95,
      height: 100,
      child: Visibility(
        visible: selectedMatch != null,
        child: FloatingActionButton(
          shape: CircleBorder(side: BorderSide(color: Colors.orange, width: 2.0)),
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