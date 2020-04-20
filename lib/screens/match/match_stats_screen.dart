import 'package:betsquad/widgets/match_stat_cell.dart';
import 'package:flutter/material.dart';
import 'package:betsquad/models/match.dart';
import 'dart:convert';

class MatchStatsScreen extends StatelessWidget {
  static const String ID = 'match_stats_screen';

  final Match match;

  const MatchStatsScreen(this.match);

  @override
  Widget build(BuildContext context) {
    var homeStats = {};
    var awayStats = {};

    if (match.stats != null) {
      var stats = json.decode(match.stats);
      homeStats = (stats).where((dict) => dict["team_id"] == match.homeTeamId).toList()[0];
      awayStats = (stats).where((dict) => dict["team_id"] == match.awayTeamId).toList()[0];
    }

    return Container(
      color: Colors.black54,
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          MatchStatCell('Posession', '${homeStats['possessiontime'] ?? 0}%', '${awayStats['possessiontime'] ?? 0}%'),
          MatchStatCell('Shots on target', homeStats['shots'] != null ? homeStats['shots']['ongoal'] : "-",
              awayStats['shots'] != null ? awayStats['shots']['ongoal'] : "-"),
          MatchStatCell('Shots off target', homeStats['shots'] != null ? homeStats['shots']['offgoal'] : "-",
              awayStats['shots'] != null ? awayStats['shots']['offgoal'] : "-"),
          SizedBox(
            height: 30,
          ),
          MatchStatCell('Free kicks', homeStats['free_kick'] ?? "-",
              awayStats['free_kick'] ?? "-"),
          MatchStatCell('Corners', homeStats['corners'] ?? "-",
              awayStats['corners'] ?? "-"),
          MatchStatCell('Fouls', homeStats['fouls'] ?? "-",  awayStats['fouls'] ?? "-"),
          MatchStatCell('Injuries', homeStats['injuries'] ?? "-", awayStats['injuries'] ?? "-"),
        ],
      ),
    );
  }
}