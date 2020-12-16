import 'dart:convert';
import 'package:betsquad/styles/constants.dart';
import 'package:flutter/material.dart';
import 'package:betsquad/widgets/match_lineup_cell.dart';
import 'package:betsquad/models/match.dart';

class MatchLineupScreen extends StatelessWidget {
  static const String ID = 'match_lineups_screen';

  final Match match;

  const MatchLineupScreen(this.match);

  List sortPlayers(players) {
    List goalkeepers = (players).where((player) => player["position"] == 'G').toList();
    List defenders = (players).where((player) => player["position"] == 'D').toList();
    List midfielders = (players).where((player) => player["position"] == 'M').toList();
    List forwards = (players).where((player) => player["position"] == 'A').toList();
    var playersSorted = [...goalkeepers, ...defenders, ...midfielders, ...forwards];
    return playersSorted;
  }

  @override
  Widget build(BuildContext context) {
    var homePlayersSorted = [];
    var awayPlayersSorted = [];

    if (match.homeLineup != null && match.awayLineup != null) {
      homePlayersSorted = sortPlayers(json.decode(match.homeLineup));
      awayPlayersSorted = sortPlayers(json.decode(match.awayLineup));
    }

    return Container(
      decoration: kGradientBoxDecoration,
      child: ListView(
        children: List<Widget>.generate(homePlayersSorted.length, (i) {
          var homePlayer = homePlayersSorted[i];
          var awayPlayer = awayPlayersSorted[i];
          return LineupCell(
              homePlayerName: homePlayer['name'],
              homePlayerNumber: homePlayer['number'].toString(),
              awayPlayerName: awayPlayer['name'],
              awayPlayerNumber: awayPlayer['number'].toString());
        }),
      ),
    );
  }
}
