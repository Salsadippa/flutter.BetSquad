import 'package:flutter/material.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'dart:math';

enum EVENT_TYPE { sub, card, goal }

class HomeMatchEvent extends StatelessWidget {
  final EVENT_TYPE type;
  final String player, time, cardType;

  const HomeMatchEvent({
    this.type,
    this.player,
    this.time, this.cardType,
  });

  renderIcon() {
    switch (type) {
      case EVENT_TYPE.sub:
        return Icon(
          MdiIcons.swapHorizontal,
          color: Colors.white,
        );
      case EVENT_TYPE.card:
        return Transform.rotate(
          angle: 90 * pi / 180,
          child: Icon(
            MdiIcons.rectangle,
            color: cardType == "yellow" ? Colors.yellow : Colors.red,
          ),
        );
      case EVENT_TYPE.goal:
        return Icon(
          MdiIcons.soccer,
          color: Colors.white,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: kGradientBoxDecoration,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Text(
            '$time\'',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            width: 10,
          ),
          renderIcon(),
          SizedBox(
            width: 10,
          ),
          Text(
            player,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}


class AwayMatchEvent extends StatelessWidget {
  final EVENT_TYPE type;
  final String player, time, cardType;

  const AwayMatchEvent({
    this.type,
    this.player,
    this.time, this.cardType,
  });

  renderIcon() {
    switch (type) {
      case EVENT_TYPE.sub:
        return Icon(
          MdiIcons.swapHorizontal,
          color: Colors.white,
        );
      case EVENT_TYPE.card:
        return Transform.rotate(
          angle: 90 * pi / 180,
          child: Icon(
            MdiIcons.rectangle,
            color: cardType == "yellow" ? Colors.yellow : Colors.red,
          ),
        );
      case EVENT_TYPE.goal:
        return Icon(
          MdiIcons.soccer,
          color: Colors.white,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: kGradientBoxDecoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            player,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            width: 10,
          ),
          renderIcon(),
          SizedBox(
            width: 10,
          ),
          Text(
            '$time\'',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }
}