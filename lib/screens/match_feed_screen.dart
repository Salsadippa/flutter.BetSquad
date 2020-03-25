import 'package:flutter/material.dart';
import 'package:betsquad/widgets/matchfeed_event_cells.dart';

class MatchFeedScreen extends StatefulWidget {
  static const String ID = 'match_feed_screen';

  @override
  _MatchFeedScreenState createState() => _MatchFeedScreenState();
}

class _MatchFeedScreenState extends State<MatchFeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: ListView(
        children: <Widget>[
          HomeMatchEvent(type: EVENT_TYPE.goal, player: "Player", time: "12",),
          HomeMatchEvent(type: EVENT_TYPE.card, player: "Player", time: "15", cardType: "yellow"),
          AwayMatchEvent(type: EVENT_TYPE.sub, player: "Player 1\nPlayer 2", time: "75"),
          AwayMatchEvent(type: EVENT_TYPE.card, player: "Player", time: "15", cardType: "yellow"),
        ],
      ),
    );
  }
}


