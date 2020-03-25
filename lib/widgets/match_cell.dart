import 'package:flutter/material.dart';
import 'package:betsquad/models/match.dart';
import 'package:intl/intl.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:betsquad/utilities/hex_color.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MatchCell extends StatelessWidget {
  const MatchCell(this.match, this.selected, this.onMatchPressed, this.onMatchLongPressed);

  final Match match;
  final Function onMatchPressed, onMatchLongPressed;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    String matchTimeText;

    if (match.currentState == 0) {
      var date = new DateTime.fromMillisecondsSinceEpoch(
          int.parse(match.startTimestamp) * 1000);
      final formattedDate = DateFormat('HH:mm').format(date);
      matchTimeText = formattedDate;
    } else if (match.currentState == 2) {
      matchTimeText = 'P - P';
    } else {
      matchTimeText = '${match.homeGoals} - ${match.awayGoals}';
    }

    return GestureDetector(
      onTap: () {
        onMatchPressed();
      },
      onLongPress: (){
        onMatchLongPressed();
      },
      child: Container(
        height: 50,
        decoration: selected ? BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black87, Colors.black]),
          border: Border.all(color: Colors.orange, width: 1.5),
        ) :
        kGradientBoxDecoration,
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
                    color: HexColor(match.homeShirtColor),
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
                            style: TextStyle(fontSize: 13, color: Colors.white),
                          ))),
                ],
              ),
            ),
            Expanded(
              child: Text(
                matchTimeText,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.orange, fontSize: 13),
              ),
              flex: 1,
            ),
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    MdiIcons.tshirtCrew,
                    color: HexColor(match.awayShirtColor),
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
                            style: TextStyle(fontSize: 13, color: Colors.white),
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