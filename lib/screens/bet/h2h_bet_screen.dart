import 'package:betsquad/styles/constants.dart';
import 'package:flutter/material.dart';
import 'package:betsquad/models/match.dart';

class Head2HeadBetScreen extends StatefulWidget {
  static const String ID = 'head2head_bet_screen';

  final Match match;

  const Head2HeadBetScreen(this.match);

  @override
  _Head2HeadBetScreenState createState() => _Head2HeadBetScreenState();
}

class _Head2HeadBetScreenState extends State<Head2HeadBetScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: kGrassTrimBoxDecoration,
        child: FractionallySizedBox(
          heightFactor: 0.90,
          child: Container(
            color: Colors.black,
            child: Column(
              children: <Widget>[
                Container(
                  height: 100,
                  child: Transform.translate(
                    offset: Offset(0.0, -30.0),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.orange,
                      child: CircleAvatar(
                        backgroundImage: kUserPlaceholderImage,
                        radius: 48,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.black,
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'You are betting',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                height: 35,
                                width: 100,
                                child: TextField(
                                  decoration: kTextFieldInputDecoration,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text('that', style: TextStyle(color: Colors.white))
                            ],
                          ),
                        ),
                        Container(),
                        Container()
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 100,
                  color: Colors.orange,
                ),
              ],
            ),
          ),
        ));
  }
}
