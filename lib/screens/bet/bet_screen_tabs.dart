import 'package:betsquad/api/bet_api.dart';
import 'package:betsquad/models/bet.dart';
import 'package:betsquad/screens/bet/bet_history.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:betsquad/screens/bet/ngs_bet_screen.dart';
import 'package:betsquad/utilities/hex_color.dart';
import 'package:betsquad/widgets/betsquad_logo_balance_appbar.dart';
import 'package:betsquad/widgets/fab_bottom_app_bar.dart';
import 'package:currency_textfield/currency_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:betsquad/models/match.dart';
import 'package:betsquad/widgets/swipeable_tabs.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../chat_tab.dart';
import '../select_opponent_screen.dart';
import '../squads_tab.dart';
import '../alert.dart';

class BetScreenTabs extends StatefulWidget {
  static const String ID = 'bet_screen_tabs';

  @override
  _BetScreenTabsState createState() => _BetScreenTabsState();
}

class _BetScreenTabsState extends State<BetScreenTabs> {
  List<String> tabs = ['HEAD 2 HEAD', 'NEXT GOAL SWEEPSTAKE'];
  int initPosition = 0;
  int currentIndex = 0;

  var h2hBet = Bet(mode: 'head2head');
  var userProfilePic;
  var selectedOpponent;
  var whiteTextStyle = TextStyle(color: Colors.white);
  CurrencyTextFieldController currencyTextFieldController =
      CurrencyTextFieldController(rightSymbol: "£", decimalSymbol: ".", thousandSymbol: ",");

  getCurrentUserImageUrl() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    print(user.uid);
    setState(() {
      h2hBet.from = user.uid;
    });
    final dbRef = await FirebaseDatabase.instance.reference().child("users/${user.uid}").once();
    setState(() {
      userProfilePic = dbRef.value['image'];
    });
  }

  @override
  void initState() {
    getCurrentUserImageUrl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Match match = ModalRoute.of(context).settings.arguments;
    setState(() {
      h2hBet.match = match;
    });

    var h2hScreen = Container(
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
                  offset: Offset(0.0, -30.0),
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
                                onChanged: (String value) {
                                  double val = currencyTextFieldController.doubleValue;
                                  print(val);
                                  setState(() {
                                    h2hBet.amount = val;
                                  });
                                },
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
                                Icon(MdiIcons.tshirtCrew, color: HexColor(match.homeShirtColor)),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  match.homeTeamName + ' will',
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
                                        if (h2hBet.homeBet == BetOption.Positive) {
                                          setState(() {
                                            h2hBet.homeBet = BetOption.Negative;
                                            h2hBet.awayBet = BetOption.Positive;
                                          });
                                        } else if (h2hBet.homeBet == BetOption.Negative) {
                                          setState(() {
                                            h2hBet.homeBet = BetOption.Positive;
                                            h2hBet.awayBet = BetOption.Negative;
                                          });
                                        } else {
                                          setState(() {
                                            h2hBet.drawBet = BetOption.Negative;
                                            h2hBet.homeBet = BetOption.Positive;
                                            h2hBet.awayBet = BetOption.Negative;
                                          });
                                        }
                                      },
                                      child: Image.asset(
                                        h2hBet.homeBet == BetOption.Positive
                                            ? 'images/win_green.png'
                                            : (h2hBet.homeBet == BetOption.Negative
                                                ? 'images/win_red.png'
                                                : 'images/win_grey.png'),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    //draw button
                                    child: GestureDetector(
                                      onTap: () {
                                        if (h2hBet.drawBet == BetOption.Neutral) {
                                          setState(() {
                                            h2hBet.drawBet = BetOption.Positive;
                                            h2hBet.homeBet = BetOption.Negative;
                                            h2hBet.awayBet = BetOption.Negative;
                                          });
                                        } else if (h2hBet.drawBet == BetOption.Positive) {
                                          if (h2hBet.homeBet == BetOption.Positive ||
                                              h2hBet.awayBet == BetOption.Positive) {
                                            setState(() {
                                              h2hBet.drawBet = BetOption.Negative;
                                            });
                                          }
                                        } else if (h2hBet.drawBet == BetOption.Negative) {
                                          setState(() {
                                            h2hBet.drawBet = BetOption.Neutral;
                                          });
                                        }
                                      },
                                      child: Image.asset(
                                        h2hBet.drawBet == BetOption.Positive
                                            ? 'images/draw_green.png'
                                            : (h2hBet.drawBet == BetOption.Negative
                                                ? 'images/draw_red.png'
                                                : 'images/draw_grey.png'),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        if (h2hBet.awayBet == BetOption.Positive) {
                                          setState(() {
                                            h2hBet.awayBet = BetOption.Negative;
                                            h2hBet.homeBet = BetOption.Positive;
                                          });
                                        } else if (h2hBet.awayBet == BetOption.Negative ||
                                            h2hBet.awayBet == BetOption.Neutral) {
                                          setState(() {
                                            h2hBet.awayBet = BetOption.Positive;
                                            h2hBet.homeBet = BetOption.Negative;
                                          });
                                        }
                                      },
                                      child: Image.asset(
                                        h2hBet.awayBet == BetOption.Positive
                                            ? 'images/lose_green.png'
                                            : (h2hBet.awayBet == BetOption.Negative
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
                                Icon(MdiIcons.tshirtCrew, color: HexColor(match.awayShirtColor)),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  match.awayTeamName,
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
                        h2hBet.vsUserID = selectedOpponent['uid'];
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
    );

    var betScreens = Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: CustomTabView(
              initPosition: initPosition,
              itemCount: tabs.length,
              tabBuilder: (context, index) => Tab(text: tabs[index]),
              pageBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return h2hScreen;
                  default:
                    return NGSBetScreen(match);
                }
              },
              onPositionChange: (index) {
                initPosition = index;
              },
            ),
          )
        ],
      ),
    );

    final List<Widget> screens = [
      betScreens,
      BetHistoryPage(),
      ChatTabScreen(),
      SquadsTabScreen(),
    ];

    return Scaffold(
      appBar: BetSquadLogoBalanceAppBar(),
      body: screens[currentIndex],
      bottomNavigationBar: FABBottomAppBar(
        color: Colors.grey,
        selectedColor: Colors.blueAccent,
        notchedShape: CircularNotchedRectangle(),
        onTabSelected: (int selected) {
          setState(() {
            currentIndex = selected;
          });
        },
        items: [
          FABBottomAppBarItem(iconData: MdiIcons.soccerField, text: 'Matches'),
          FABBottomAppBarItem(iconData: MdiIcons.coins, text: 'Bets'),
          FABBottomAppBarItem(iconData: Icons.chat_bubble_outline, text: 'Chat'),
          FABBottomAppBarItem(iconData: Icons.supervised_user_circle, text: 'Squads'),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: 95,
        height: 100,
        child: Visibility(
          child: FloatingActionButton(
            shape: CircleBorder(side: BorderSide(color: Colors.orange, width: 2.0)),
            onPressed: () async {
              if (initPosition == 0) {
                print("send H2H bet");
                print(h2hBet);
                Map createBetResponse = await BetApi().sendH2HBet(h2hBet);
                if (createBetResponse['result'] == 'success') {
                  print('bet sent');
                  Alert.showSuccessDialog(context, 'Bet Sent', 'Your bet on ${match.homeTeamName} vs ${match
                      .awayTeamName} has been sent');
                } else {
                  var errorMsg = createBetResponse['message'];
                  print(errorMsg);
                  Alert.showErrorDialog(context, 'Failed to Send', errorMsg);
                }
              } else {
                print("send NGS bet");
              }
//            Navigator.pushNamed(context, BetScreenTabs.ID, arguments: selectedMatch);
            },
            backgroundColor: Colors.black,
            child: Text(
              'SEND\nBET',
              style: TextStyle(color: Colors.white, fontSize: 20),
              textAlign: TextAlign.center,
            ),
            elevation: 10.0,
          ),
        ),
      ),
    );
  }
}
