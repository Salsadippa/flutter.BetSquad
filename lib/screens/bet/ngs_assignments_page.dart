import 'package:betsquad/models/bet.dart';
import 'package:betsquad/services/database.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:betsquad/widgets/betsquad_logo_balance_appbar.dart';
import 'package:betsquad/widgets/match_header.dart';
import 'package:betsquad/widgets/swipeable_tabs.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'allocation_view.dart';

class NGSAssignmentsPage extends StatefulWidget {
  static const ID = 'ngs_assignments_page';
  final Bet bet;

  const NGSAssignmentsPage({this.bet});

  @override
  _NGSAssignmentsPageState createState() => _NGSAssignmentsPageState();
}

class _NGSAssignmentsPageState extends State<NGSAssignmentsPage> {
  int initPosition = 0;

  @override
  Widget build(BuildContext context) {
    List<String> tabs = [widget.bet.match.homeTeamName, widget.bet.match.awayTeamName];

    var goalkeepersH = widget.bet.assignments.values
        .toList()
        .where((element) => element['position'] == 'G' || element['position'] == null)
        .toList();
    var defendersH = widget.bet.assignments.values.toList().where((element) => element['position'] == 'D' &&
        element['side'] == 'home');
    var midfieldersH = widget.bet.assignments.values.toList().where((element) => element['position'] == 'M' &&
        element['side'] == 'home');
    var attackersH = widget.bet.assignments.values.toList().where((element) => element['position'] == 'A' &&
        element['side'] == 'home');

    var homeTeamPlayers = [...goalkeepersH, ...defendersH, ...midfieldersH, ...attackersH];


    var goalkeepersA = widget.bet.assignments.values
        .toList()
        .where((element) => element['position'] == 'G' || element['position'] == null)
        .toList();
    var defendersA = widget.bet.assignments.values.toList().where((element) => element['position'] == 'D' &&
        element['side'] == 'away');
    var midfieldersA = widget.bet.assignments.values.toList().where((element) => element['position'] == 'M' &&
        element['side'] == 'away');
    var attackersA = widget.bet.assignments.values.toList().where((element) => element['position'] == 'A' &&
        element['side'] == 'away');

    var awayTeamPlayers = [...goalkeepersA, ...defendersA, ...midfieldersA, ...attackersA];

    return Scaffold(
      appBar: BetSquadLogoBalanceAppBar(),
      body: Container(
        color: Colors.black87,
        child: Column(
          children: [
            MatchHeader(match: widget.bet.match),
            Expanded(
              child: CustomTabView(
                initPosition: initPosition,
                itemCount: tabs.length,
                labelSpacing: 50,
                tabBuilder: (context, index) => Tab(text: tabs[index]),
                pageBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return Scaffold(
                        body: Container(
                          decoration: kAssignmentsHomePitchBackgroundDecoration,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  AllocationView(
                                      userId: homeTeamPlayers[0]['userID'],
                                      playerNumber: homeTeamPlayers[0]['number'],
                                      playerName: homeTeamPlayers[0]['name']),
                                ],
                              ),
                              Row(
                                children: [
                                  AllocationView(
                                      userId: homeTeamPlayers[1]['userID'],
                                      playerNumber: homeTeamPlayers[1]['number'],
                                      playerName: homeTeamPlayers[1]['name']),
                                  AllocationView(
                                      userId: homeTeamPlayers[2]['userID'],
                                      playerNumber: homeTeamPlayers[2]['number'],
                                      playerName: homeTeamPlayers[2]['name']),
                                  AllocationView(
                                      userId: homeTeamPlayers[3]['userID'],
                                      playerNumber: homeTeamPlayers[3]['number'],
                                      playerName: homeTeamPlayers[3]['name']),
                                  AllocationView(
                                      userId: homeTeamPlayers[4]['userID'],
                                      playerNumber: homeTeamPlayers[4]['number'],
                                      playerName: homeTeamPlayers[4]['name']),
                                ],
                              ),
                              Row(
                                children: [
                                  AllocationView(
                                      userId: homeTeamPlayers[5]['userID'],
                                      playerNumber: homeTeamPlayers[5]['number'],
                                      playerName: homeTeamPlayers[5]['name']),
                                  AllocationView(
                                      userId: homeTeamPlayers[6]['userID'],
                                      playerNumber: homeTeamPlayers[6]['number'],
                                      playerName: homeTeamPlayers[6]['name']),
                                  AllocationView(
                                      userId: homeTeamPlayers[7]['userID'],
                                      playerNumber: homeTeamPlayers[7]['number'],
                                      playerName: homeTeamPlayers[7]['name']),
                                  AllocationView(
                                      userId: homeTeamPlayers[8]['userID'],
                                      playerNumber: homeTeamPlayers[8]['number'],
                                      playerName: homeTeamPlayers[8]['name']),
                                ],
                              ),
                              Row(
                                children: [
                                  AllocationView(
                                      userId: homeTeamPlayers[9]['userID'],
                                      playerNumber: homeTeamPlayers[9]['number'],
                                      playerName: homeTeamPlayers[9]['name']),
                                  AllocationView(
                                      userId: homeTeamPlayers[10]['userID'],
                                      playerNumber: homeTeamPlayers[10]['number'],
                                      playerName: homeTeamPlayers[10]['name']),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    default:
                      return Scaffold(
                        body: Container(
                          decoration: kAssignmentsAwayPitchBackgroundDecoration,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  AllocationView(
                                      userId: awayTeamPlayers[0]['userID'],
                                      playerNumber: awayTeamPlayers[0]['number'],
                                      playerName: awayTeamPlayers[0]['name']),
                                ],
                              ),
                              Row(
                                children: [
                                  AllocationView(
                                      userId: awayTeamPlayers[1]['userID'],
                                      playerNumber: awayTeamPlayers[1]['number'],
                                      playerName: awayTeamPlayers[1]['name']),
                                  AllocationView(
                                      userId: awayTeamPlayers[2]['userID'],
                                      playerNumber: awayTeamPlayers[2]['number'],
                                      playerName: awayTeamPlayers[2]['name']),
                                  AllocationView(
                                      userId: awayTeamPlayers[3]['userID'],
                                      playerNumber: awayTeamPlayers[3]['number'],
                                      playerName: awayTeamPlayers[3]['name']),
                                  AllocationView(
                                      userId: awayTeamPlayers[4]['userID'],
                                      playerNumber: awayTeamPlayers[4]['number'],
                                      playerName: awayTeamPlayers[4]['name']),
                                ],
                              ),
                              Row(
                                children: [
                                  AllocationView(
                                      userId: awayTeamPlayers[5]['userID'],
                                      playerNumber: awayTeamPlayers[5]['number'],
                                      playerName: awayTeamPlayers[5]['name']),
                                  AllocationView(
                                      userId: awayTeamPlayers[6]['userID'],
                                      playerNumber: awayTeamPlayers[6]['number'],
                                      playerName: awayTeamPlayers[6]['name']),
                                  AllocationView(
                                      userId: awayTeamPlayers[7]['userID'],
                                      playerNumber: awayTeamPlayers[7]['number'],
                                      playerName: awayTeamPlayers[7]['name']),
                                  AllocationView(
                                      userId: awayTeamPlayers[8]['userID'],
                                      playerNumber: awayTeamPlayers[8]['number'],
                                      playerName: awayTeamPlayers[8]['name']),
                                ],
                              ),
                              Row(
                                children: [
                                  AllocationView(
                                      userId: awayTeamPlayers[9]['userID'],
                                      playerNumber: awayTeamPlayers[9]['number'],
                                      playerName: awayTeamPlayers[9]['name']),
                                  AllocationView(
                                      userId: awayTeamPlayers[10]['userID'],
                                      playerNumber: awayTeamPlayers[10]['number'],
                                      playerName: awayTeamPlayers[10]['name']),
                                ],
                              )
                            ].reversed.toList(),
                          ),
                        ),
                      );
                  }
                },
                onPositionChange: (index) {
                  initPosition = index;
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

