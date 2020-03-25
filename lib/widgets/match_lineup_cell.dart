import 'package:flutter/material.dart';
import 'package:betsquad/styles/constants.dart';

class LineupCell extends StatelessWidget {
  final String homePlayerNumber,
      homePlayerName,
      awayPlayerNumber,
      awayPlayerName;

  const LineupCell({
    this.homePlayerNumber,
    this.homePlayerName,
    this.awayPlayerNumber,
    this.awayPlayerName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kGradientBoxDecoration,
      height: 50,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 20,
                ),
                Text(
                  homePlayerNumber,
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  homePlayerName,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  awayPlayerName,
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  awayPlayerNumber,
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}