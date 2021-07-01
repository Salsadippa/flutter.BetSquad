import 'dart:convert';

import 'package:betsquad/api/users_api.dart';
import 'package:betsquad/models/goal.dart';
import 'package:betsquad/models/match_data.dart';
import 'package:betsquad/models/substitution.dart';
import 'package:betsquad/screens/match/match_detail_tabs.dart';
import 'package:betsquad/services/local_database.dart';
import 'package:betsquad/services/push_notifications.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:betsquad/utilities/utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:calendar_strip/calendar_strip.dart';
import 'package:betsquad/widgets/custom_expansion_tile.dart' as custom;
import 'package:betsquad/models/match.dart';
import 'package:betsquad/widgets/match_cell.dart';
import 'package:provider/provider.dart';
import 'package:betsquad/models/card.dart' as BSCard;
import 'package:sortedmap/sortedmap.dart';

class MatchListScreen extends StatefulWidget {
  static const String ID = 'match_list_screen';

  @override
  _MatchListScreenState createState() => _MatchListScreenState();
}

class _MatchListScreenState extends State<MatchListScreen> {
  Map<String, List<Match>> matches;
  DateTime selectedDay;
  bool noMatches = false;
  @override
  void initState() {
    super.initState();
    selectedDay = DateTime.now();
    PushNotificationsManager().init();
    getMatches();
    print("Current userId:" + FirebaseAuth.instance.currentUser.uid);
  }

  getMatches() async {
    var fetchMatchesResult = await DBProvider.db.getMatchesOnDate(selectedDay);
    setState(() {
      matches = fetchMatchesResult;
    });

    if(matches.length == 0){
      print("there are no matches");
      setState(() {
        noMatches = true;
      });
    }else{
      print("showing matches => $fetchMatchesResult");
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget emptyListTextWidget = Center(
      child: Text(
        noMatches ? "No matches yet" : " ",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
    );

    Match selectedMatch = Provider.of<MatchData>(context).selectedMatch;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Container(
              decoration: kGrassTrimBoxDecoration,
              child: Column(
                children: <Widget>[
                  CalendarStrip(
                    startDate: DateTime.now().subtract(Duration(days: 7)),
                    endDate: DateTime.now().add(Duration(days: 30)),
                    selectedDate: selectedDay,
                    onDateSelected: (DateTime date) {
                      setState(() {
                        selectedDay = date;
                        print(date);
                      });
                      getMatches();
                    },
                    containerDecoration: BoxDecoration(color: Colors.white),
                    monthNameWidget: (monthLabel) =>
                        Container(child: Text(monthLabel), padding: EdgeInsets.only(top: 7, bottom: 3)),
                  ),
                  Expanded(
                    child: new ListView.builder(
                      itemCount: matches != null ? matches.length : 0,
                      itemBuilder: (context, i) {
                        return custom.ExpansionTile(
                          initiallyExpanded: true,
                          headerBackgroundColor: kBetSquadOrange,
                          title: Container(
                            padding: EdgeInsets.only(left: 35),
                            child: Text(
                              matches.keys.toList()[i],
                              style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          children: _buildExpandableContent(matches[matches.keys.toList()[i]], (Match match) {
                            if (match.currentState == 0) {
                              Provider.of<MatchData>(context, listen: false).updateSelectedMatch(match);
                            } else {
                              Navigator.pushNamed(context, MatchDetailTabs.ID, arguments: match);
                            }
                          }, (Match match) {
                            Navigator.pushNamed(context, MatchDetailTabs.ID, arguments: match);
                          }, selectedMatch),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          emptyListTextWidget,
        ],
      ),
    );
  }

  _buildExpandableContent(List<Match> matches, Function onPressed, Function onLongPressed, Match selectedMatch) {
    List<Widget> expandableContent = [];

    matches.sort((a, b) {
      if (a.startTimestamp.compareTo(b.startTimestamp) == 0) {
        return a.homeTeamName.compareTo(b.homeTeamName);
      } else {
        return a.startTimestamp.compareTo(b.startTimestamp);
      }
    });

    for (Match match in matches) {
      expandableContent.add(
        StreamBuilder<Event>(
            stream: FirebaseDatabase.instance
                .reference()
                .child('sm_matches')
                .child(match.date + '/' + match.homeTeamName)
                .onValue,
            builder: (context, snapshot) {
              if (snapshot.hasError || !snapshot.hasData || snapshot.data.snapshot.value == null) {
                return MatchCell(match, match == selectedMatch, () {
                  onPressed(match);
                }, () {
                  onLongPressed(match);
                });
              }
              List<Future<dynamic>> futures = [];

              var matchSnapshot = snapshot.data.snapshot.value;

              Match m = Match(
                id: matchSnapshot["id"],
                awayShirtColor: match.awayShirtColor,
                homeShirtColor: match.homeShirtColor,
                awayTeamId: matchSnapshot["awayTeam"]["dbid"],
                homeTeamId: matchSnapshot["homeTeam"]["dbid"],
                awayGoals: matchSnapshot["awayGoals"] ?? 0,
                homeGoals: matchSnapshot["homeGoals"] ?? 0,
                awayPenalties: matchSnapshot["awayPenalties"] ?? -1,
                homePenalties: matchSnapshot["homePenalties"] ?? -1,
                awayTeamName: matchSnapshot["awayTeam"]["name"],
                competitionId: matchSnapshot["competition"]["dbid"],
                competitionName: matchSnapshot["competition"]["name"],
                currentState: matchSnapshot["currentState"],
                date: matchSnapshot["date"],
                homeTeamName: matchSnapshot["homeTeam"]["name"],
                lastPolled: matchSnapshot["lastPolled"],
                minute: matchSnapshot["minute"],
                nextState: matchSnapshot["nextState"],
                round: matchSnapshot["round"] != null ? matchSnapshot["round"]["name"].toString() : "-",
                startTimestamp: matchSnapshot["start"],
                venue: matchSnapshot["venue"] != null ? matchSnapshot["venue"]["name"] : "-",
                stage: matchSnapshot["stage"] != null
                    ? matchSnapshot["stage"]["name"] + " " + matchSnapshot["stage"]["type"]
                    : "-",
                stats: matchSnapshot["stats"] != null ? json.encode(matchSnapshot["stats"]) : null,
                homeLineup: matchSnapshot["homePlayers"] != null ? json.encode(matchSnapshot["homePlayers"]) : null,
                awayLineup: matchSnapshot["awayPlayers"] != null ? json.encode(matchSnapshot["awayPlayers"]) : null,
              );

              futures.add(DBProvider.db.insertMatch(m));

              if (matchSnapshot["goals"] != null) {
                for (final goal in matchSnapshot["goals"]) {
                  Goal g = Goal(
                      id: goal['id'],
                      type: goal["goalType"],
                      side: goal["side"],
                      scoringPlayer: goal["scoringPlayer"],
                      matchId: m.id,
                      playerId: goal["playerId"],
                      minute: goal["minute"]);
                  futures.add(DBProvider.db.insertGoal(g));
                }
              }

              if (matchSnapshot["cards"] != null) {
                for (final card in matchSnapshot["cards"]) {
                  BSCard.Card c = BSCard.Card(
                      id: card['id'],
                      cardType: card["cardType"],
                      minute: card["minute"],
                      player: card["player"],
                      playerId: card["playerId"],
                      side: card["side"],
                      matchId: m.id);
                  futures.add(DBProvider.db.insertCard(c));
                }
              }

              if (matchSnapshot["substitutions"] != null) {
                for (final sub in matchSnapshot["substitutions"]) {
                  Substitution s = Substitution(
                      id: sub['id'],
                      matchId: m.id,
                      side: sub["side"],
                      minute: sub["minute"],
                      playerIn: sub["playerIn"],
                      playerInId: sub["playerInId"],
                      playerOut: sub["playerOut"],
                      playerOutId: sub["playerOutId"]);
                  futures.add(DBProvider.db.insertSub(s));
                }
              }

              //update local db
              Future.wait(futures);

              return MatchCell(match, match == selectedMatch, () {
                onPressed(match);
              }, () {
                onLongPressed(match);
              });
            }),
      );
    }
    return expandableContent;
  }
}
