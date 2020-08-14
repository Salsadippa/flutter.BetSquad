import 'package:betsquad/models/bet.dart';
import 'package:betsquad/screens/select_opponent_screen.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:betsquad/utilities/utility.dart';
import 'package:betsquad/widgets/betsquad_logo_balance_appbar.dart';
import 'package:betsquad/widgets/full_width_button.dart';
import 'package:betsquad/widgets/match_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class NGSBetScreen extends StatefulWidget {
  static const String ID = 'ngs_bet_screen';

  final Bet bet;

  const NGSBetScreen(this.bet);

  @override
  _NGSBetScreenState createState() => _NGSBetScreenState();
}

class _NGSBetScreenState extends State<NGSBetScreen> {
  var invitedUsers = [];

  TextEditingController textEditingController = TextEditingController();
  TextEditingController textEditingController2 = TextEditingController();
  TextEditingController textEditingController3 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    textEditingController.text = '£${widget.bet.amount.toStringAsFixed(2)}';
    textEditingController2.text = widget.bet.rollovers;
    textEditingController3.text = '£${(widget.bet.amount * int.parse(widget.bet.rollovers)).toStringAsFixed(2)}';

    return Scaffold(
      appBar: BetSquadLogoBalanceAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          MatchHeader(match: widget.bet.match),
          Expanded(
            child: Container(
              color: Colors.black87,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  TextFieldWithTitleInfo(
                    title: 'Bet amount per goal:',
                    isEnabled: false,
                    controller: textEditingController,
                    onInfoButtonPressed: () {
                      Utility.getInstance().showErrorAlertDialog(context, "Bet per goal",
                          "Just before the game kicks off, all users will receive their random allocation of players.  If your player scores you will win the pot.  You will then receive a new allocation of players for the next bet.  There are 21 players available, which is the 10 outfield players from each team and 1 Goalkeepers/ own goals/ no goal.  If either goalkeeper scores or there is an own goal or the game ends, you will win the pot.");
                    },
                    onChanged: (value) {},
                  ),
                  TextFieldWithTitleInfo(
                    title: 'Max bets per match:',
                    isEnabled: false,
                    onInfoButtonPressed: () {
                      Utility.getInstance().showErrorAlertDialog(
                          context,
                          "Bets per match",
                          "This is the maximum number of times you "
                              "will be automatically added to a new bet once a goal has been scored.  We will take funds from your account to cover all rollovers.  If there are not enough goals in the game, you will be refunded any remaining funds.");
                    },
                    controller: textEditingController2,
                    onChanged: (value) {},
                  ),
                  TextFieldWithTitleInfo(
                    title: 'Total stake:',
                    isEnabled: false,
                    onInfoButtonPressed: () {
                      Utility.getInstance().showErrorAlertDialog(context, "Total stake",
                          "The total amount you will be charged. Bets Per Goal x Bets Per Match. Any excess funds will be refunded at the end of the match.");
                    },
                    onChanged: (value) {},
                    controller: textEditingController3,
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    decoration: kGradientBoxDecoration,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('${widget.bet.invited != null ? widget.bet.invited.length : 0} players invited',
                            style: TextStyle(color: Colors.white), textAlign: TextAlign.center)
                      ],
                    ),
                  ),
                  if (widget.bet.userStatus == 'sent')
                    FullWidthButton('Invite Players +', () async {
                      var selectOpponents =
                          await Navigator.pushNamed(context, SelectOpponentScreen.ID, arguments: true);
                      setState(() {
                        invitedUsers = selectOpponents;
                      });
                    }),
                  SizedBox(
                    height: 50,
                  ),
                  if (widget.bet.status == 'open' && widget.bet.userStatus == 'received')
                    Container(
                      height: 65,
                      child: Row(
                        children: [
                          Expanded(
                            child: FlatButton(
                              child: Text('Accept', style: TextStyle(color: Colors.white, fontSize: 18)),
                              color: Colors.green,
                              onPressed: () {
                                //accept bet
                              },
                            ),
                          ),
                          SizedBox(
                            width: 50,
                          ),
                          Expanded(
                            child: FlatButton(
                              child: Text(
                                'Decline',
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),
                              color: Colors.red,
                              onPressed: () {
                                //decline bet
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                ],
              ),
            ),
          )
        ],
      ),
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
