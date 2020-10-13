import 'package:betsquad/utilities/hex_color.dart';
import 'package:betsquad/widgets/team_shirt_name_logo.dart';
import 'package:flutter/material.dart';
import 'package:betsquad/models/match.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:intl/intl.dart';

class MatchHeader extends StatelessWidget {
  const MatchHeader({
    Key key,
    @required this.match,
  }) : super(key: key);

  final Match match;



  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat.E();
    DateTime matchDateTime = DateTime.parse(match.date);
    var date = new DateTime.fromMillisecondsSinceEpoch(
        int.parse(match.startTimestamp) * 1000);
    final matchTime = DateFormat('HH:mm').format(date);

    print(match.date);
    return Container(
      decoration: kGrassTrimBoxDecoration,
      height: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          TeamShirtNameLogo(
              teamName: match.homeTeamName,
              shirtColor: HexColor(match.homeShirtColor  ?? '#FFFFFF')),
          Container(
            width: 75,
            height: 75,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[Text('${dateFormat.format(matchDateTime)}\n$matchTime', style:
              TextStyle(color: Colors.white),
                textAlign:
              TextAlign
                  .center,)],
            ),
          ),
          TeamShirtNameLogo(
              teamName: match.awayTeamName,
              shirtColor: HexColor(match.awayShirtColor  ?? '#FFFFFF')),
        ],
      ),
    );
  }
}