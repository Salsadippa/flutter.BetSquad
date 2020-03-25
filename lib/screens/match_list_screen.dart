import 'package:betsquad/widgets/betsquad_logo_profile_balance_appbar.dart';
import 'package:betsquad/screens/match_details_screen.dart';
import 'package:betsquad/services/local_database.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:flutter/material.dart';
import 'package:calendar_strip/calendar_strip.dart';
import 'package:betsquad/widgets/custom_expansion_tile.dart' as custom;
import 'package:betsquad/models/match.dart';
import 'package:betsquad/widgets/match_cell.dart';

class MatchListScreen extends StatefulWidget {
  static const String ID = 'match_list_screen';

  @override
  _MatchListScreenState createState() => _MatchListScreenState();
}

class _MatchListScreenState extends State<MatchListScreen> {
  Map<String, List<Match>> matches;
  DateTime selectedDay = DateTime.now();
  Match selectedMatch;

  @override
  void initState() {
    super.initState();
    getMatches();
  }

  getMatches() async {
    var fetchMatchesResult = await DBProvider.db.getMatchesOnDate(selectedDay);
    setState(() {
      matches = fetchMatchesResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BetSquadLogoProfileBalanceAppBar(),
      body: Container(
        decoration: kGrassTrimBoxDecoration,
        child: Column(
          children: <Widget>[
            CalendarStrip(
              onDateSelected: (DateTime date) {
                setState(() {
                  selectedDay = date;
                });
                getMatches();
              },
              containerDecoration: BoxDecoration(color: Colors.white),
              monthNameWidget: (monthLabel) => Container(
                  child: Text(monthLabel),
                  padding: EdgeInsets.only(top: 7, bottom: 3)),
            ),
            Expanded(
              child: new ListView.builder(
                itemCount: matches != null ? matches.length : 0,
                itemBuilder: (context, i) {
                  return custom.ExpansionTile(
                    initiallyExpanded: true,
                    headerBackgroundColor: Colors.orange,
                    title: Container(
                      padding: EdgeInsets.only(left: 35),
                      child: Text(
                        matches.keys.toList()[i],
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    children: _buildExpandableContent(
                        matches[matches.keys.toList()[i]], (match) {
                      setState(() {
                        Navigator.pushNamed(context, MatchDetailsScreen.ID, arguments: match);
                        print(match);
                        selectedMatch = match;
                      });
                    }),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

_buildExpandableContent(List<Match> matches, Function onPressed) {
  List<Widget> expandableContent = [];
  for (Match match in matches) {
    expandableContent.add(MatchCell(match, false, () {
      onPressed(match);
    }));
  }
  return expandableContent;
}


