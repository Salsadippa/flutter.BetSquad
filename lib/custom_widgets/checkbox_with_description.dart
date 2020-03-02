import 'package:flutter/material.dart';
import 'package:betsquad/styles/constants.dart';

class CheckboxWithDescription extends StatelessWidget {
  final String description;
  final bool value;
  final Function onChangedFunction;

  CheckboxWithDescription(this.description, this.value, this.onChangedFunction);

  @override
  Widget build(BuildContext context) {
    var checkbox = CheckboxListTile(
        dense: true,
        activeColor: Colors.orange,
        title: Text(
          description,
          style: TextStyle(color: Colors.white70),
        ),
        value: value == true,
        onChanged: (value) {
          onChangedFunction(value);
        });

    return Container(
        height: 60, decoration: kGradientBoxDecoration, child: checkbox);
  }
}
