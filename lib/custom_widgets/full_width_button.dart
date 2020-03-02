import 'package:flutter/material.dart';

class FullWidthButton extends StatelessWidget {

  final String title;
  final Function onPressedFunction;

  FullWidthButton(this.title, this.onPressedFunction);

  @override
  Widget build(BuildContext context) {

    var button = RaisedButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(0))
      ),
      onPressed: () {
        onPressedFunction();
      },
      child: Text(
        title,
        style: TextStyle(color: Colors.orange),
      ),
      color: Colors.black87,
    );

    return  Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      child: button
    );
  }
}
