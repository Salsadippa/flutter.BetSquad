import 'package:flutter/material.dart';
import 'package:betsquad/styles/constants.dart';

class DualColouredText extends StatelessWidget {
  final String firstString, secondString;

  DualColouredText(this.firstString, this.secondString);

  @override
  Widget build(BuildContext context) {
    var firstPart = Text(
      firstString,
      textAlign: TextAlign.center,
      style: kVersionNumberTextStyle,
    );

    var spacing = SizedBox(
      width: 8,
    );

    var secondPart = Text(secondString,
        textAlign: TextAlign.center, style: kInstructionTextStyle);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[firstPart, spacing, secondPart],
    );
  }
}
