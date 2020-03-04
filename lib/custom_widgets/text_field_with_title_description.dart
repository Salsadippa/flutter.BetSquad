import 'package:flutter/material.dart';
import 'package:betsquad/styles/constants.dart';

class TextFieldWithTitleDesc extends StatelessWidget {
  final String title, detail;
  final Function onChangeTextField;
  final bool shouldObscureText;
  final TextEditingController controller;

  TextFieldWithTitleDesc(
      {Key key,
      @required this.title,
      this.detail,
      this.controller,
      @required this.onChangeTextField,
      this.shouldObscureText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var titleText = Text(
      title,
      textAlign: TextAlign.start,
      style: TextStyle(
        color: Colors.orange,
      ),
    );

    var spacing = SizedBox(
      height: 5,
    );

    var textField = Container(
      padding: EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        obscureText: shouldObscureText != null ? shouldObscureText : false,
        decoration: kTextFieldInputDecoration,
        style: TextStyle(color: Colors.white),
        onChanged: (value) {
          onChangeTextField(value);
        },
      ),
    );

    return Container(
      decoration: kGradientBoxDecoration,
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          titleText,
          if (detail != null) ...[
            spacing,
            Text(
              detail,
              style: TextStyle(color: Colors.orange, fontSize: 12),
            ),
          ],
          spacing,
          textField
        ],
      ),
    );
  }
}
