import 'package:flutter/material.dart';
import 'package:betsquad/widgets/match_lineup_cell.dart';

class MatchLineupsScreen extends StatefulWidget {
  static const String ID = 'match_lineups_screen';

  @override
  _MatchLineupsScreenState createState() => _MatchLineupsScreenState();
}

class _MatchLineupsScreenState extends State<MatchLineupsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: ListView(
        children: <Widget>[
          LineupCell(
              homePlayerName: 'Player A.',
              homePlayerNumber: '1',
              awayPlayerName: 'Player B.',
              awayPlayerNumber: '2'),
          LineupCell(
              homePlayerName: 'Player A.',
              homePlayerNumber: '1',
              awayPlayerName: 'Player B.',
              awayPlayerNumber: '2'),
          LineupCell(
              homePlayerName: 'Player A.',
              homePlayerNumber: '1',
              awayPlayerName: 'Player B.',
              awayPlayerNumber: '2'),
          LineupCell(
              homePlayerName: 'Player A.',
              homePlayerNumber: '1',
              awayPlayerName: 'Player B.',
              awayPlayerNumber: '2'),
        ],
      ),
    );
  }
}


