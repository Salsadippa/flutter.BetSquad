import 'package:flutter/material.dart';
import 'package:betsquad/styles/constants.dart';

class TitleValueLabel extends StatelessWidget {
  final String title, value;

  const TitleValueLabel(
      this.title,
      this.value,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kGradientBoxDecoration,
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
          Text(
            value,
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}