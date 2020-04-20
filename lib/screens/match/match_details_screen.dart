import 'package:flutter/material.dart';
import 'package:betsquad/widgets/title_value_label.dart';
import 'package:betsquad/models/match.dart';

class MatchDetailsScreen extends StatefulWidget {
  static const String ID = 'match_info_screen';

  final Match match;
  const MatchDetailsScreen(this.match);

  @override
  _MatchInfoScreenState createState() => _MatchInfoScreenState();
}

class _MatchInfoScreenState extends State<MatchDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: ListView(
        children: <Widget>[
          SizedBox(height: 30,),
          TitleValueLabel('Competition', widget.match.competitionName),
          TitleValueLabel('Stage', widget.match.stage),
          TitleValueLabel('Venue', widget.match.venue),
          SizedBox(height: 30,),
          TitleValueLabel('Competition', '-'),
          TitleValueLabel('Competition', '-'),
        ],
      ),
    );
  }
}


