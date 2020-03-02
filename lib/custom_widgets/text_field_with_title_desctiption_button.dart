import 'package:flutter/material.dart';
import 'package:betsquad/styles/constants.dart';

class TextFieldWithTitleDescButton extends StatelessWidget {
  final String title, detail, buttonTitle;
  final Function onChangeTextField, onPressedButton;

  TextFieldWithTitleDescButton(
      {Key key,
      @required this.title,
      this.detail,
      @required this.buttonTitle,
      @required this.onPressedButton,
      @required this.onChangeTextField})
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
        decoration: kTextFieldInputDecoration,
        style: TextStyle(color: Colors.white),
        onChanged: (value){
          this.onChangeTextField(value);
        },
      ),
    );

    var searchButton = Container(
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(5.0)),
        color: Colors.orange,
        onPressed: (){
          this.onPressedButton();
        },
        child: Text(buttonTitle,
            style: TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );

    return Container(
      decoration: kGradientBoxDecoration,
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          titleText,
          spacing,
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: textField,
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(flex: 1, child: searchButton)
            ],
          )
        ],
      ),
    );
  }
}
