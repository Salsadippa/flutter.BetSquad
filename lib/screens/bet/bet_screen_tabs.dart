import 'dart:convert';

import 'package:betsquad/api/bet_api.dart';
import 'package:betsquad/api/users_api.dart';
import 'package:betsquad/models/bet.dart';
import 'package:betsquad/screens/bet/bet_history_page.dart';
import 'package:betsquad/screens/profile/squads_tab.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:betsquad/utilities/hex_color.dart';
import 'package:betsquad/utilities/utility.dart';
import 'package:betsquad/widgets/betsquad_logo_balance_appbar.dart';
import 'package:betsquad/widgets/fab_bottom_app_bar.dart';
import 'package:betsquad/widgets/full_width_button.dart';
import 'package:betsquad/widgets/match_header.dart';
import 'package:betsquad/widgets/text_field_with_info.dart';
import 'package:currency_textfield/currency_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:betsquad/models/match.dart';
import 'package:betsquad/widgets/swipeable_tabs.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../chat_tab.dart';
import 'select_opponent_screen.dart';
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
  bool _ngsLoading = false, _h2hLoading = false;

  var h2hBet = Bet(mode: 'head2head', amount: 0);
  var ngsBet = Bet(mode: 'NGS', amount: 0);
  double ngsTotalStake = 0;
  var userProfilePic;
  var selectedOpponent;
  var whiteTextStyle = TextStyle(color: Colors.white);
  CurrencyTextFieldController currencyTextFieldController =
      CurrencyTextFieldController(rightSymbol: "£", decimalSymbol: ".", thousandSymbol: ",");
  var invitedUsers = [];

  CurrencyTextFieldController currencyTextFieldController2 =
      CurrencyTextFieldController(rightSymbol: "£", decimalSymbol: ".", thousandSymbol: ",");

  TextEditingController textEditingController = TextEditingController();
  TextEditingController textEditingController2 = TextEditingController();

  getCurrentUserImageUrl() async {
    User user = FirebaseAuth.instance.currentUser;
    print(user.uid);
    setState(() {
      h2hBet.from = user.uid;
      ngsBet.from = user.uid;
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
      ngsBet.match = match;
    });

    var h2hScreen = Container(
      decoration: kGrassTrimBoxDecoration,
      child: FractionallySizedBox(
        heightFactor: 0.75,
        child: ModalProgressHUD(
          inAsyncCall: _h2hLoading,
          child: Container(
            decoration: kGradientBoxDecoration,
            child: Column(
              children: <Widget>[
                Container(
                  height: 100,
                  child: Transform.translate(
                    offset: Offset(0.0, -30.0),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: kBetSquadOrange,
                      child: CircleAvatar(
                        backgroundImage: userProfilePic != null || userProfilePic == ''
                            ? NetworkImage(userProfilePic)
                            : kUserPlaceholderImage,
                        radius: 48,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
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
                                  keyboardType: TextInputType.number,
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
//                      Padding(
//                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 50),
//                        child: Container(
//                          child: Column(
//                            crossAxisAlignment: CrossAxisAlignment.stretch,
//                            children: [
//                              Container(
//                                child: FlatButton(
//                                  shape: RoundedRectangleBorder(
//                                      borderRadius: BorderRadius.circular(8),
//                                  ),
//                                  child: Text('ARSENAL WIN', style: GoogleFonts.russoOne(fontSize: 17, color: Colors.white)),
//                                  onPressed: () {
//                                    if (h2hBet.homeBet == BetOption.Positive) {
//                                      setState(() {
//                                        h2hBet.homeBet = BetOption.Negative;
//                                        h2hBet.awayBet = BetOption.Positive;
//                                      });
//                                    } else if (h2hBet.homeBet == BetOption.Negative) {
//                                      setState(() {
//                                        h2hBet.homeBet = BetOption.Positive;
//                                        h2hBet.awayBet = BetOption.Negative;
//                                      });
//                                    } else {
//                                      print('else');
//                                      setState(() {
//                                        h2hBet.drawBet = BetOption.Negative;
//                                        h2hBet.homeBet = BetOption.Positive;
//                                        h2hBet.awayBet = BetOption.Negative;
//                                      });
//                                    }
//                                  },
//                                  color: h2hBet.homeBet == BetOption.Positive
//                                      ? Colors.green
//                                      : h2hBet.homeBet == BetOption.Negative ? Colors.red : Colors.grey,
//                                ),
//                              ),
//                              Container(
//                                child: FlatButton(
//                                  shape: RoundedRectangleBorder(
//                                      borderRadius: BorderRadius.circular(8),
//                                  ),
//                                  child: Text('DRAW', style: GoogleFonts.russoOne(fontSize: 17, color: Colors.white)),
//                                  onPressed: () {
//                                    if (h2hBet.drawBet == BetOption.Positive) {
//                                      if (h2hBet.homeBet == BetOption.Positive ||
//                                          h2hBet.awayBet == BetOption.Positive) {
//                                        setState(() {
//                                          h2hBet.drawBet = BetOption.Negative;
//                                        });
//                                      }
//                                    } else if (h2hBet.drawBet == BetOption.Negative) {
//                                      setState(() {
//                                        h2hBet.drawBet = BetOption.Neutral;
//                                      });
//                                    } else {
//                                      setState(() {
//                                        h2hBet.drawBet = BetOption.Positive;
//                                        h2hBet.homeBet = BetOption.Negative;
//                                        h2hBet.awayBet = BetOption.Negative;
//                                      });
//                                    }
//                                  },
//                                  color: h2hBet.drawBet == BetOption.Positive
//                                      ? Colors.green
//                                      : h2hBet.drawBet == BetOption.Negative ? Colors.red : Colors.grey,
//                                ),
//                              ),
//                              Container(
//                                child: FlatButton(
//                                  shape: RoundedRectangleBorder(
//                                      borderRadius: BorderRadius.circular(8),
//                                  ),
//                                  child: Text(
//                                    'MANCHESTER UNITED WIN',
//                                    style: GoogleFonts.russoOne(fontSize: 17, color: Colors.white),
//                                  ),
//                                  onPressed: () {
//                                    if (h2hBet.awayBet == BetOption.Positive) {
//                                      setState(() {
//                                        h2hBet.awayBet = BetOption.Negative;
//                                        h2hBet.homeBet = BetOption.Positive;
//                                      });
//                                    } else if (h2hBet.awayBet == BetOption.Negative) {
//                                      setState(() {
//                                        h2hBet.awayBet = BetOption.Positive;
//                                        h2hBet.homeBet = BetOption.Negative;
//                                      });
//                                    } else {
//                                      setState(() {
//                                        h2hBet.drawBet = BetOption.Negative;
//                                        h2hBet.homeBet = BetOption.Negative;
//                                        h2hBet.awayBet = BetOption.Positive;
//                                      });
//                                    }
//                                  },
//                                  color: h2hBet.awayBet == BetOption.Positive
//                                      ? Colors.green
//                                      : h2hBet.awayBet == BetOption.Negative ? Colors.red : Colors.grey,
//                                ),
//                              )
//                            ],
//                          ),
//                        ),
//                      ),
                        Container(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(MdiIcons.tshirtCrew, color: HexColor(match.homeShirtColor ?? '#FFFFFF')),
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
                                            print('else');
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
                                          if (h2hBet.drawBet == BetOption.Positive) {
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
                                          } else {
                                            setState(() {
                                              h2hBet.drawBet = BetOption.Positive;
                                              h2hBet.homeBet = BetOption.Negative;
                                              h2hBet.awayBet = BetOption.Negative;
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
                                      //lose button
                                      child: GestureDetector(
                                        onTap: () {
                                          if (h2hBet.awayBet == BetOption.Positive) {
                                            setState(() {
                                              h2hBet.awayBet = BetOption.Negative;
                                              h2hBet.homeBet = BetOption.Positive;
                                            });
                                          } else if (h2hBet.awayBet == BetOption.Negative) {
                                            setState(() {
                                              h2hBet.awayBet = BetOption.Positive;
                                              h2hBet.homeBet = BetOption.Negative;
                                            });
                                          } else {
                                            setState(() {
                                              h2hBet.drawBet = BetOption.Negative;
                                              h2hBet.homeBet = BetOption.Negative;
                                              h2hBet.awayBet = BetOption.Positive;
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
                                  Icon(MdiIcons.tshirtCrew, color: HexColor(match.awayShirtColor ?? '#FFFFFF')),
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
                            'vs ${selectedOpponent != null ? selectedOpponent['username'] : ''}',
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
                    offset: Offset(0.0, 10.0),
                    child: GestureDetector(
                      onTap: () async {
                        var result = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SelectOpponentScreen(),
                          ),
                        );
                        setState(() {
                          selectedOpponent = result;
                          h2hBet.vsUserID = selectedOpponent['uid'];
                        });
                      },
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: kBetSquadOrange,
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
    );

    var ngsScreen = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        MatchHeader(match: match),
        Expanded(
          child: Container(
            decoration: kGradientBoxDecoration,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                TextFieldWithTitleInfo(
                  title: 'Bet amount per goal:',
                  keyboardType: TextInputType.number,
                  controller: currencyTextFieldController2,
                  onInfoButtonPressed: () {
                    Utility.getInstance().showErrorAlertDialog(context, "Bet per goal",
                        "Just before the game kicks off, all users will receive their random allocation of players.  If your player scores you will win the pot.  You will then receive a new allocation of players for the next bet.  There are 21 players available, which is the 10 outfield players from each team and 1 Goalkeepers/ own goals/ no goal.  If either goalkeeper scores or there is an own goal or the game ends, you will win the pot.");
                  },
                  onChanged: (value) {
                    setState(() {
                      ngsBet.amount = currencyTextFieldController2.doubleValue;
                    });
                    if (currencyTextFieldController2.text.isNotEmpty && textEditingController2.text.isNotEmpty) {
                      double totalStake =
                          currencyTextFieldController2.doubleValue * double.parse(textEditingController2.text);
                      textEditingController.text = "£${totalStake.toStringAsFixed(2)}";
                      setState(() {
                        print("setting amount");
                        ngsTotalStake = totalStake;
                      });
                    }
                  },
                ),
                TextFieldWithTitleInfo(
                  title: 'Max bets per match:',
                  keyboardType: TextInputType.number,
                  onInfoButtonPressed: () {
                    Utility.getInstance().showErrorAlertDialog(
                        context,
                        "Bets per match",
                        "This is the maximum number of times you "
                            "will be automatically added to a new bet once a goal has been scored.  We will take funds from your account to cover all rollovers.  If there are not enough goals in the game, you will be refunded any remaining funds.");
                  },
                  controller: textEditingController2,
                  onChanged: (value) {
                    if (currencyTextFieldController2.text.isNotEmpty && textEditingController2.text.isNotEmpty) {
                      var totalStake =
                          currencyTextFieldController2.doubleValue * double.parse(textEditingController2.text);
                      textEditingController.text = "£${(totalStake).toStringAsFixed(2)}";
                      setState(() {
                        ngsTotalStake = totalStake;
                        ngsBet.rollovers = textEditingController2.text.toString();
                      });
                    }
                  },
                ),
                TextFieldWithTitleInfo(
                  title: 'Total stake:',
                  isEnabled: false,
                  onInfoButtonPressed: () {
                    Utility.getInstance().showErrorAlertDialog(context, "Total stake",
                        "The total amount you will be charged. Bets Per Goal x Bets Per Match. Any excess funds will be refunded at the end of the match.");
                  },
                  onChanged: (value) {},
                  controller: textEditingController,
                ),
                SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: kGradientBoxDecoration,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('${invitedUsers != null ? invitedUsers.length : 0} players invited',
                          style: TextStyle(color: Colors.white), textAlign: TextAlign.center)
                    ],
                  ),
                ),
                FullWidthButton('Invite Players +', () async {
                  var result = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SelectOpponentScreen(
                        multipleSelection: true,
                        alreadySelected: invitedUsers != null ? invitedUsers.map((e) => e['uid']).toList() : []
                      ),
                    ),
                  );
                  setState(() {
                    invitedUsers = result;
                  });
                })
              ],
            ),
          ),
        )
      ],
    );

    var betScreens = Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: CustomTabView(
              initPosition: initPosition,
              itemCount: tabs.length,
              labelSpacing: 20,
              tabBuilder: (context, index) => Tab(text: tabs[index]),
              pageBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return h2hScreen;
                  default:
                    return ngsScreen;
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
      SquadsTab(),
    ];

    return Scaffold(
      appBar: BetSquadLogoBalanceAppBar(),
      body: ModalProgressHUD(inAsyncCall: _ngsLoading, child: screens[currentIndex]),
      bottomNavigationBar: FABBottomAppBar(
        color: Colors.grey,
        selectedColor: kBetSquadOrange,
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
            shape: CircleBorder(side: BorderSide(color: kBetSquadOrange, width: 2.0)),
            onPressed: () async {
              if (initPosition == 0) {
                print("send H2H bet");

                if (h2hBet.amount < 2) {
                  Utility.getInstance().showErrorAlertDialog(
                      context,
                      'Minimum £2 bet',
                      'The minimum total bet amount'
                          ' is £2.00');
                  return;
                }

                if (h2hBet.homeBet == null || h2hBet.awayBet == null || h2hBet.drawBet == null) {
                  print("null");
                  Utility.getInstance().showErrorAlertDialog(context, 'Select Bet Criteria',
                      'Please select your bet criteria by clicking on the home team, draw or away team buttons');
                  return;
                }

                if (h2hBet.vsUserID == null) {
                  print("no opponent");
                  Utility.getInstance().showErrorAlertDialog(context, 'Select Opponent',
                      'Please select who your bet opponent by clicking the user profille image.');
                  return;
                }

                setState(() {
                  _h2hLoading = true;
                });

                bool compliant = await UsersApi.complianceCheck();
                if (!compliant) {
                  setState(() {
                    _h2hLoading = false;
                  });
                  Alert.showErrorDialog(
                      context, 'Cannot bet', 'You have failed our compliance check. Please contact info@bet-squad.com');
                }

                Map createBetResponse = await BetApi().sendH2HBet(h2hBet);
                setState(() {
                  _h2hLoading = false;
                });
                if (createBetResponse['result'] == 'success') {
                  Navigator.pop(context);
                  Alert.showSuccessDialog(
                      context, 'Bet Sent', 'Your bet on ${match.homeTeamName} vs ${match.awayTeamName} has been sent');
                } else {
                  var errorMsg = createBetResponse['message'];
                  print(errorMsg);
                  Alert.showErrorDialog(context, 'Failed to Send', errorMsg);
                }
              } else {
                print("send NGS bet");
                print(ngsBet.amount);

                print(ngsTotalStake);

                if (ngsBet.rollovers == null) {
                  print("rollovers null");
                  Utility.getInstance()
                      .showErrorAlertDialog(context, 'Enter max bets', 'Please enter a max bets per match value');
                  return;
                }

                if (ngsTotalStake < 2) {
                  Utility.getInstance().showErrorAlertDialog(
                      context,
                      'Minimum £2 bet',
                      'The minimum total bet amount'
                          ' is £2.00');
                  return;
                }

                if (invitedUsers.length < 1) {
                  Utility.getInstance().showErrorAlertDialog(
                      context,
                      'Invite users',
                      'You must invite at least 1 '
                          'user to this bet');
                  return;
                }

                setState(() {
                  _ngsLoading = true;
                });

                bool compliant = await UsersApi.complianceCheck();
                if (!compliant) {
                  setState(() {
                    _ngsLoading = false;
                  });
                  Alert.showErrorDialog(
                      context, 'Cannot bet', 'You have failed our compliance check. Please contact info@bet-squad.com');
                }

                Map createBetResponse = await BetApi().sendNGSBet(ngsBet, invitedUsers);
                setState(() {
                  _ngsLoading = false;
                });
                if (createBetResponse['result'] == 'success') {
                  print('bet sent');
                  Navigator.pop(context);
                  Alert.showSuccessDialog(
                      context, 'Bet Sent', 'Your bet on ${match.homeTeamName} vs ${match.awayTeamName} has been sent');
                } else {
                  var errorMsg = createBetResponse['message'];
                  print(errorMsg);
                  Navigator.pop(context);
                  Alert.showErrorDialog(context, 'Failed to Send', errorMsg);
                }
              }
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
