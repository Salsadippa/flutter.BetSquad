import 'package:flutter/material.dart';
import 'package:betsquad/widgets/title_value_label.dart';

class MatchInfoScreen extends StatefulWidget {
  static const String ID = 'match_info_screen';

  @override
  _MatchInfoScreenState createState() => _MatchInfoScreenState();
}

class _MatchInfoScreenState extends State<MatchInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: ListView(
        children: <Widget>[
          SizedBox(height: 30,),
          TitleValueLabel('Competition', '-'),
          TitleValueLabel('Competition', '-'),
          TitleValueLabel('Competition', '-'),
          SizedBox(height: 30,),
          TitleValueLabel('Competition', '-'),
          TitleValueLabel('Competition', '-'),
        ],
      ),
    );
  }
}


