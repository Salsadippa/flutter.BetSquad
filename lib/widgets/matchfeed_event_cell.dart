import 'package:flutter/material.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'dart:math';
import 'package:betsquad/models/event.dart';

enum EVENT_TYPE { sub, card, goal }

class MatchEventCell extends StatelessWidget {
  final event;

  const MatchEventCell(this.event);

  renderIcon() {
    switch (event.eventType) {
      case 'sub':
        return Icon(
          MdiIcons.swapHorizontal,
          color: Colors.white,
        );
      case 'card':
        return Transform.rotate(
          angle: 90 * pi / 180,
          child: Icon(
            MdiIcons.rectangle,
            color: event.cardType == "yellow" ? Colors.yellow : Colors.red,
          ),
        );
      case 'goal':
        return Icon(
          MdiIcons.soccer,
          color: Colors.white,
        );
    }
  }

  renderPlayerName() {
    switch (event.eventType) {
      case 'sub':
        return Text(
          '${event.playerIn}\n${event.playerOut}',
          style: TextStyle(color: Colors.white),
        );
      case 'card':
        return Text(
          event.player,
          style: TextStyle(color: Colors.white),
        );
      case 'goal':
        return Text(
          event.scoringPlayer,
          style: TextStyle(color: Colors.white),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    renderRow() {
      return event.side == "H"
          ? Row(
              children: <Widget>[
                SizedBox(
                  width: 20,
                ),
                Text(
                  '${event.minute}\'',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  width: 10,
                ),
                renderIcon(),
                SizedBox(
                  width: 10,
                ),
                renderPlayerName()
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                renderPlayerName(),
                SizedBox(
                  width: 10,
                ),
                renderIcon(),
                SizedBox(
                  width: 10,
                ),
                Text(
                  '${event.minute}\'',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            );
    }

    return Container(height: 50, decoration: kGradientBoxDecoration, child: renderRow());
  }
}
