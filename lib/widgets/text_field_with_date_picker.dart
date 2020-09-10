import 'package:flutter/material.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class TextFieldWithDatePicker extends StatelessWidget {
  final String title, detail, value;
  final Function onDateChanged;
  final bool shouldObscureText;

  TextFieldWithDatePicker(
      {Key key,
      @required this.title,
      @required this.value,
      this.detail,
      @required this.onDateChanged,
      this.shouldObscureText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var titleText = Text(
      title,
      textAlign: TextAlign.start,
      style: TextStyle(
        color: kBetSquadOrange,
      ),
    );

    var spacing = SizedBox(
      height: 5,
    );

    return Container(
      decoration: kGradientBoxDecoration,
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          titleText,
          if (detail != null) ...[
            spacing,
            Text(
              detail,
              style: TextStyle(color: kBetSquadOrange, fontSize: 12),
            ),
          ],
          spacing,
          FlatButton(
              color: Colors.grey,
              onPressed: () {
                DatePicker.showDatePicker(context, showTitleActions: true,
                    onChanged: (date) {
                  print('change $date');
                }, onConfirm: (date) {
                  onDateChanged(date);
                });
              },
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  style: TextStyle(color: Colors.white),
                ),
              ))
        ],
      ),
    );
  }
}
