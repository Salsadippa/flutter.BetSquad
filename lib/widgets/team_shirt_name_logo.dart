import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TeamShirtNameLogo extends StatelessWidget {
  final String teamName;
  final Color shirtColor;

  const TeamShirtNameLogo({
    this.teamName,
    this.shirtColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
//                  color: Colors.purple,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            MdiIcons.tshirtCrew,
            color: shirtColor,
            size: 60,
          ),
          Text(
            teamName,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 14, color: Colors.white),
          )
        ],
      ),
    );
  }
}