import 'package:betsquad/models/bet.dart';
import 'package:betsquad/services/database.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:betsquad/widgets/betsquad_logo_balance_appbar.dart';
import 'package:betsquad/widgets/match_header.dart';
import 'package:betsquad/widgets/swipeable_tabs.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'allocation_view.dart';

class NGSAssignmentsPage extends StatefulWidget {
  static const ID = 'ngs_assignments_page';
  final Bet bet;
  final String winnerEntryId;

  const NGSAssignmentsPage({this.bet, this.winnerEntryId});

  @override
  _NGSAssignmentsPageState createState() => _NGSAssignmentsPageState();
}

class _NGSAssignmentsPageState extends State<NGSAssignmentsPage> {
  int initPosition = 0;
  var goalkeepersH, defendersH, midfieldersH, attackersH, homeTeamPlayers;
  var goalkeepersA, defendersA, midfieldersA, attackersA, awayTeamPlayers;


  void setPlayerVariables(Bet bet){
    var data =
    widget.winnerEntryId == null ? bet.assignments : bet.winners[widget.winnerEntryId]['assignments'];

    goalkeepersH =
        data.values.toList().where((element) => element['position'] == 'G' || element['position'] == null).toList();
    defendersH = data.values.toList().where((element) => element['position'] == 'D' && element['side'] == 'home');
    midfieldersH = data.values.toList().where((element) => element['position'] == 'M' && element['side'] == 'home');
    attackersH = data.values.toList().where((element) => element['position'] == 'A' && element['side'] == 'home');

    homeTeamPlayers = [...goalkeepersH, ...defendersH, ...midfieldersH, ...attackersH];

    goalkeepersA =
        data.values.toList().where((element) => element['position'] == 'G' || element['position'] == null).toList();
    defendersA = data.values.toList().where((element) => element['position'] == 'D' && element['side'] == 'away');
    midfieldersA = data.values.toList().where((element) => element['position'] == 'M' && element['side'] == 'away');
    attackersA = data.values.toList().where((element) => element['position'] == 'A' && element['side'] == 'away');

    awayTeamPlayers = [...goalkeepersA, ...defendersA, ...midfieldersA, ...attackersA];

    print(homeTeamPlayers);
    print(awayTeamPlayers);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> tabs = [widget.bet.match.homeTeamName, widget.bet.match.awayTeamName];

    return StreamBuilder<Event>(
        stream: FirebaseDatabase.instance.reference().child('bets').child(widget.bet.id).onValue,
        builder: (context, snapshot) {

          if(snapshot.hasError || !snapshot.hasData){
            return Container();
          }

          Bet bet = Bet.fromMap(snapshot.data.snapshot.value);

          //Use bets object to set the players variables
          setPlayerVariables(bet);

          return Scaffold(
            appBar: BetSquadLogoBalanceAppBar(),
            body: Container(
              color: Colors.black87,
              child: Column(
                children: [
                  MatchHeader(match: widget.bet.match),
                  if (homeTeamPlayers != null && awayTeamPlayers != null)
                    Expanded(
                      child: CustomTabView(
                        initPosition: initPosition,
                        itemCount: tabs.length,
                        labelSpacing: 50,
                        tabBuilder: (context, index) =>
                            Container(width: MediaQuery.of(context).size.width / 2, child: Tab(text: tabs[index])),
                        pageBuilder: (context, index) {
                          switch (index) {
                            case 0:
                              return Scaffold(
                                body: Container(
                                  height: MediaQuery.of(context).size.height,
                                  decoration: kAssignmentsHomePitchBackgroundDecoration,
                                  child: Center(
                                    child: SingleChildScrollView(
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
                                          SizedBox(height: 20),
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
                                          SizedBox(height: 20),
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
                                          SizedBox(height: 20),
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
                                  ),
                                ),
                              );
                            default:
                              return Scaffold(
                                body: Container(
                                  height: MediaQuery.of(context).size.height,
                                  decoration: kAssignmentsAwayPitchBackgroundDecoration,
                                  child: Center(
                                    child: SingleChildScrollView(
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
                                          SizedBox(height: 20),
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
                                          SizedBox(height: 20),
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
                                          SizedBox(height: 20),
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
    );
  }
}