import 'package:betsquad/services/local_database.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:flutter/material.dart';
import 'package:betsquad/widgets/matchfeed_event_cell.dart';
import 'package:betsquad/models/match.dart';
import 'package:betsquad/models/event.dart';

class MatchFeedScreen extends StatefulWidget {
  static const String ID = 'match_feed_screen';

  final Match match;

  const MatchFeedScreen(this.match);

  @override
  _MatchFeedScreenState createState() => _MatchFeedScreenState();
}

class _MatchFeedScreenState extends State<MatchFeedScreen> {
  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<List<dynamic>> fetchEvents() async {
    List<Event> e = await DBProvider.db.getAllEvents(widget.match.id);
    if (e != null) {
      e.sort((a, b) => Comparable.compare(a.minute, b.minute));
      return e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchEvents(),
        builder: (context, snapshot) {
          if (snapshot.hasError || !snapshot.hasData) {
            return Container(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kBetSquadOrange),
              ),
            );
          }
          List<dynamic> events = snapshot.data;
          return Container(
            color: Colors.black54,
            child: ListView(
              children: List<Widget>.generate(events.length, (i) {
                Event event = events[i];
                return MatchEventCell(event);
              }),
            ),
          );
        });
  }
}
