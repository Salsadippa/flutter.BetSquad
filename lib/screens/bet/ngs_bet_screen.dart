import 'package:betsquad/styles/constants.dart';
import 'package:betsquad/widgets/full_width_button.dart';
import 'package:betsquad/widgets/match_header.dart';
import 'package:flutter/material.dart';
import 'package:betsquad/models/match.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:currency_textfield/currency_textfield.dart';

class NGSBetScreen extends StatefulWidget {
  static const String ID = 'head2head_bet_screen';

  final Match match;

  const NGSBetScreen(this.match);

  @override
  _NGSBetScreenState createState() => _NGSBetScreenState();
}

class _NGSBetScreenState extends State<NGSBetScreen> {
  @override
  Widget build(BuildContext context) {
    CurrencyTextFieldController currencyTextFieldController =
        CurrencyTextFieldController(rightSymbol: "£", decimalSymbol: ".", thousandSymbol: ",");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        MatchHeader(match: widget.match),
        Expanded(
          child: Container(
            color: Colors.grey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                TextFieldWithTitleInfo(
                  title: 'Bet amount per goal:',
                  controller: currencyTextFieldController,
                  onInfoButtonPressed: () {
                    print("amount per goal alert");
                  },
                ),
                TextFieldWithTitleInfo(
                    title: 'Max bets per match:',
                    onInfoButtonPressed: () {
                      print("alertt");
                    }),
                TextFieldWithTitleInfo(
                  title: 'Total stake:',
                  isEnabled: false,
                  onInfoButtonPressed: () {
                    print("total alert");
                  },
                ),
                SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: kGradientBoxDecoration,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('0 players invited', style: TextStyle(color: Colors.white), textAlign: TextAlign.center)
                    ],
                  ),
                ),
                FullWidthButton('Invite Players +', () {
                  print("invite players");
                })
              ],
            ),
          ),
        )
      ],
    );
  }
}

class TextFieldWithTitleInfo extends StatelessWidget {
  @required
  final String title;
  final TextEditingController controller;
  @required
  final Function onInfoButtonPressed;
  final bool isEnabled;

  const TextFieldWithTitleInfo({this.controller, this.onInfoButtonPressed, this.isEnabled, this.title});

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
              onChanged: (value) {},
              controller: controller,
              textAlign: TextAlign.center,
              enabled: isEnabled ?? true,
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
