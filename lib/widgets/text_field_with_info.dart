import 'package:betsquad/styles/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TextFieldWithTitleInfo extends StatelessWidget {
  @required
  final String title;
  final TextEditingController controller;
  @required
  final Function onInfoButtonPressed;
  final bool isEnabled;
  final Function onChanged;

  const TextFieldWithTitleInfo({this.controller, this.onInfoButtonPressed, this.isEnabled, this.title, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kGradientBoxDecoration,
      height: 50,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            flex: 2,
            child: TextField(
              decoration: kTextFieldInputDecoration,
              style: TextStyle(color: Colors.white),
              onChanged: onChanged,
              controller: controller,
              textAlign: TextAlign.center,
              enabled: isEnabled ?? true,
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                onInfoButtonPressed();
              },
              child: Icon(
                MdiIcons.informationOutline,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
