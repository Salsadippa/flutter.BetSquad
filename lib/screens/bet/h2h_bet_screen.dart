import 'package:betsquad/models/bet.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:betsquad/utilities/hex_color.dart';
import 'package:betsquad/widgets/betsquad_logo_balance_appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:currency_textfield/currency_textfield.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:betsquad/screens/select_opponent_screen.dart';

class Head2HeadBetScreen extends StatefulWidget {
  static const String ID = 'head2head_bet_screen';
  final Bet bet;
  const Head2HeadBetScreen(this.bet);

  @override
  _Head2HeadBetScreenState createState() => _Head2HeadBetScreenState();
}

class _Head2HeadBetScreenState extends State<Head2HeadBetScreen> {
  var whiteTextStyle = TextStyle(color: Colors.white);
  CurrencyTextFieldController currencyTextFieldController =
      CurrencyTextFieldController(rightSymbol: "£", decimalSymbol: ".", thousandSymbol: ",");

  Bet bet = Bet();
  var userProfilePic;
  var selectedOpponent;

  getCurrentUserImageUrl() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    print(user.uid);
    final dbRef = await FirebaseDatabase.instance.reference().child("users/${user.uid}").once();
    setState(() {
      userProfilePic = dbRef.value['image'];
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentUserImageUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BetSquadLogoBalanceAppBar(),
      body: Center(
        child: Container(
          decoration: kGrassTrimBoxDecoration,
          child: FractionallySizedBox(
            heightFactor: 0.70,
            child: Container(
              color: Colors.black,
              child: Column(
                children: <Widget>[
                  Container(
                    height: 100,
                    child: Transform.translate(
                      offset: Offset(0, -30),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.orange,
                        child: CircleAvatar(
                          backgroundImage: userProfilePic != null ? NetworkImage(userProfilePic) : kUserPlaceholderImage,
                          radius: 48,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.black,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'You are betting',
                                  style: whiteTextStyle,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  height: 35,
                                  width: 100,
                                  child: TextField(
                                    decoration: kTextFieldInputDecoration,
                                    controller: currencyTextFieldController,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text('that', style: whiteTextStyle)
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(MdiIcons.tshirtCrew, color: HexColor(widget.bet.match.homeShirtColor)),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      widget.bet.match.homeTeamName + ' will',
                                      style: whiteTextStyle,
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width - 50,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        //win button
                                        child: GestureDetector(
                                          onTap: () {
                                            if (bet.homeBet == BetOption.Positive) {
                                              setState(() {
                                                bet.homeBet = BetOption.Negative;
                                                bet.awayBet = BetOption.Positive;
                                              });
                                            } else if (bet.homeBet == BetOption.Negative) {
                                              setState(() {
                                                bet.homeBet = BetOption.Positive;
                                                bet.awayBet = BetOption.Negative;
                                              });
                                            } else {
                                              setState(() {
                                                bet.drawBet = BetOption.Negative;
                                                bet.homeBet = BetOption.Positive;
                                                bet.awayBet = BetOption.Negative;
                                              });
                                            }
                                          },
                                          child: Image.asset(
                                            bet.homeBet == BetOption.Positive
                                                ? 'images/win_green.png'
                                                : (bet.homeBet == BetOption.Negative
                                                    ? 'images/win_red.png'
                                                    : 'images/win_grey.png'),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        //draw button
                                        child: GestureDetector(
                                          onTap: () {
                                            if (bet.drawBet == BetOption.Neutral) {
                                              setState(() {
                                                bet.drawBet = BetOption.Positive;
                                              });
                                            } else if (bet.drawBet == BetOption.Positive) {
                                              if (bet.homeBet == BetOption.Positive ||
                                                  bet.awayBet == BetOption.Positive) {
                                                setState(() {
                                                  bet.drawBet = BetOption.Negative;
                                                });
                                              }
                                            } else if (bet.drawBet == BetOption.Negative) {
                                              setState(() {
                                                bet.drawBet = BetOption.Neutral;
                                              });
                                            }
                                          },
                                          child: Image.asset(
                                            bet.drawBet == BetOption.Positive
                                                ? 'images/draw_green.png'
                                                : (bet.drawBet == BetOption.Negative
                                                    ? 'images/draw_red.png'
                                                    : 'images/draw_grey.png'),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            if (bet.awayBet == BetOption.Positive) {
                                              setState(() {
                                                bet.awayBet = BetOption.Negative;
                                                bet.homeBet = BetOption.Positive;
                                              });
                                            } else if (bet.awayBet == BetOption.Negative ||
                                                bet.awayBet == BetOption.Neutral) {
                                              setState(() {
                                                bet.awayBet = BetOption.Positive;
                                                bet.homeBet = BetOption.Negative;
                                              });
                                            }
                                          },
                                          child: Image.asset(
                                            bet.awayBet == BetOption.Positive
                                                ? 'images/lose_green.png'
                                                : (bet.awayBet == BetOption.Negative
                                                    ? 'images/lose_red.png'
                                                    : 'images/lose_grey.png'),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'against',
                                      style: whiteTextStyle,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(MdiIcons.tshirtCrew, color: HexColor(widget.bet.match.awayShirtColor)),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      widget.bet.match.awayTeamName,
                                      style: whiteTextStyle,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Text(
                              'with ${selectedOpponent != null ? selectedOpponent['username'] : ''}',
                              style: whiteTextStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 100,
                    child: Transform.translate(
                      offset: Offset(0.0, 30.0),
                      child: GestureDetector(
                        onTap: () async {
                          var result = await Navigator.pushNamed(context, SelectOpponentScreen.ID, arguments: false);
                          setState(() {
                            selectedOpponent = result;
                          });
                        },
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.orange,
                          child: CircleAvatar(
                            backgroundImage: selectedOpponent != null &&
                                    selectedOpponent['image'] != null &&
                                    selectedOpponent['image'] != ''
                                ? NetworkImage(selectedOpponent['image'])
                                : kUserPlaceholderImage,
                            radius: 48,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
