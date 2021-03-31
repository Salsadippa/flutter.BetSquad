import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:betsquad/models/match.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:betsquad/utilities/hex_color.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MatchCell extends StatelessWidget {
  const MatchCell(this.match, this.selected, this.onMatchPressed, this.onMatchLongPressed);

  final Match match;
  final Function onMatchPressed, onMatchLongPressed;
  final bool selected;

  Widget _getMatchTimeWidget() {
    String matchTimeText;

    if (match.currentState == 0) {
      var date = new DateTime.fromMillisecondsSinceEpoch(int.parse(match.startTimestamp) * 1000);
      final formattedDate = DateFormat('HH:mm').format(date);
      matchTimeText = formattedDate;
    } else if (match.currentState == 2) {
      matchTimeText = 'P - P';
    } else {
      return StreamBuilder<Event>(
          stream: FirebaseDatabase.instance
              .reference()
              .child('sm_matches/' + match.date + '/' + match.homeTeamName + '/homeGoals')
              .onValue,
          builder: (context, homeGoalsSnapshot) {
            if (homeGoalsSnapshot.hasError || !homeGoalsSnapshot.hasData) {
              return Container();
            }
            return StreamBuilder<Event>(
                stream: FirebaseDatabase.instance
                    .reference()
                    .child('sm_matches/' + match.date + '/' + match.homeTeamName + '/awayGoals')
                    .onValue,
                builder: (context, awayGoalsSnapshot) {
                  if (awayGoalsSnapshot.hasError || !awayGoalsSnapshot.hasData) {
                    return Container();
                  }
                  return Expanded(
                    child: Text(
                      '${homeGoalsSnapshot.data.snapshot.value} - ${awayGoalsSnapshot.data.snapshot.value}',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: kBetSquadOrange, fontSize: 14),
                    ),
                    flex: 1,
                  );
                });
          });
    }

    return Expanded(
      child: Text(
        matchTimeText,
        textAlign: TextAlign.center,
        style: TextStyle(color: kBetSquadOrange, fontSize: 14),
      ),
      flex: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onMatchPressed();
      },
      onLongPress: () {
        onMatchLongPressed();
      },
      child: Container(
        height: 50,
        decoration: selected
            ? BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black87, Colors.black]),
                border: Border.all(color: kBetSquadOrange, width: 1.5),
              )
            : kGradientBoxDecoration,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    MdiIcons.tshirtCrew,
                    color: HexColor(match.homeShirtColor ?? '#FFFFFF'),
                    size: 20,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Flexible(
                      child: Container(
                          child: Text(
                    match.homeTeamName,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(fontSize: 14, color: Colors.white),
                  ))),
                ],
              ),
            ),
            _getMatchTimeWidget(),
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    MdiIcons.tshirtCrew,
                    color: HexColor(match.awayShirtColor ?? '#FFFFFF'),
                    size: 20,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Flexible(
                      child: Container(
                          child: Text(
                    match.awayTeamName,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(fontSize: 14, color: Colors.white),
                  ))),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
