import 'package:flutter/material.dart';
import 'package:betsquad/styles/constants.dart';

class TextFieldWithTitleDesc extends StatelessWidget {
  final String title, detail;
  final Function onChangeTextField;

  TextFieldWithTitleDesc(
      {Key key,
        @required this.title,
        this.detail,
        @required this.onChangeTextField})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kGradientBoxDecoration,
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.orange,
            ),
          ),
          if (detail != null) ...[
            SizedBox(
              height: 5,
            ),
            Text(
              detail,
              style: TextStyle(color: Colors.orange, fontSize: 12),
            ),
          ],
          SizedBox(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.only(bottom: 10),
            child: TextField(
              decoration: kDOBTextFieldInputDecoration,
              style: TextStyle(color: Colors.white),
              onChanged: (value) {
                onChangeTextField();
              },
            ),
          )
        ],
      ),
    );
  }
}
