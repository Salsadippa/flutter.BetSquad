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
import '../../string_utils.dart';
import '../chat/chat_tab.dart';
import 'select_opponent_screen.dart';
import '../alert.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

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
  bool inputtingBetAmount = false;

  var h2hBet = Bet(mode: 'head2head', amount: 0);
  var ngsBet = Bet(mode: 'NGS', amount: 0);

//  double ngsTotalStake = 0;
  var userProfilePic;
  var selectedOpponent;
  var whiteTextStyle = TextStyle(color: Colors.white);
  CurrencyTextFieldController currencyTextFieldController =
      CurrencyTextFieldController(rightSymbol: "£", decimalSymbol: ".", thousandSymbol: ",");
  var invitedUsers = [];
  var invitedSquads = [];

  CurrencyTextFieldController currencyTextFieldController2 =
      CurrencyTextFieldController(rightSymbol: "£", decimalSymbol: ".", thousandSymbol: ",");

//  TextEditingController textEditingController = TextEditingController();
//  TextEditingController textEditingController2 = TextEditingController();

  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  final FocusNode _nodeText3 = FocusNode();

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: false,
      actions: [
        KeyboardActionsItem(
          focusNode: _nodeText1,
        ),
        KeyboardActionsItem(
          focusNode: _nodeText2,
        ),
        KeyboardActionsItem(
          focusNode: _nodeText3,
        ),
      ],
    );
  }

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
        heightFactor: _nodeText1.hasFocus ? 0.95 : 0.8,
        child: Container(
          decoration: kGradientBoxDecoration,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: _nodeText1.hasFocus ? 20 : 0,
              ),
              Container(
                height: _nodeText1.hasFocus ? 0 : 80,
                child: Transform.translate(
                  offset: Offset(0.0, -30.0),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: kBetSquadOrange,
                    child: FutureBuilder<DataSnapshot>(
                        future: FirebaseDatabase.instance
                            .reference()
                            .child('users')
                            .child(FirebaseAuth.instance.currentUser.uid)
                            .child('image')
                            .once(),
                        builder: (context, snapshot) {
                          return CircleAvatar(
                            backgroundImage: snapshot.hasData && !StringUtils.isNullOrEmpty(snapshot.data.value)
                                ? NetworkImage(snapshot.data.value)
                                : kUserPlaceholderImage,
                            radius: 48,
                          );
                        }),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 150,
                  child: KeyboardActions(
                    config: _buildConfig(context),
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
                                  focusNode: _nodeText1,
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
              ),
              Container(
                height: _nodeText1.hasFocus ? 0 : 80,
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
                        backgroundImage:
                            selectedOpponent != null && !StringUtils.isNullOrEmpty(selectedOpponent['image'])
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

    var ngsScreen = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        MatchHeader(match: match),
        Expanded(
          child: Container(
            decoration: kGradientBoxDecoration,
            child: KeyboardActions(
              config: _buildConfig(context),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  TextFieldWithTitleInfo(
                    title: 'Total Bet:',
                    focusNode: _nodeText2,
                    keyboardType: TextInputType.number,
                    controller: currencyTextFieldController2,
                    onInfoButtonPressed: () {
                      Utility.getInstance().showErrorAlertDialog(context, "Total Bet",
                          "As the game kicks off, everyone who has accepted the bet will receive an equal split of random players.  If your player scores, you will win a share of the pot (calculated at the end of the game).  There are 21 player tickets available which is for the 10 outfield players from each team and one ticket for both goalkeepers, own goals and no goal scorer.  If there is an own goal, either goalkeeper scores, or the game ends while you hold this ticket, you will win a share of the pot.");
                    },
                    onChanged: (value) {
                      setState(() {
                        ngsBet.amount = currencyTextFieldController2.doubleValue;
                      });
//                      if (currencyTextFieldController2.text.isNotEmpty &&
//                          textEditingController2.text.isNotEmpty) {
//                        double totalStake =
//                            currencyTextFieldController2.doubleValue *
//                                double.parse(textEditingController2.text);
//                        textEditingController.text =
//                            "£${totalStake.toStringAsFixed(2)}";
//                        setState(() {
//                          print("setting amount");
//                          ngsTotalStake = totalStake;
//                        });
//                      }
                    },
                  ),
//                  TextFieldWithTitleInfo(
//                    title: 'Max bets per match:',
//                    focusNode: _nodeText3,
//                    keyboardType: TextInputType.number,
//                    onInfoButtonPressed: () {
//                      Utility.getInstance().showErrorAlertDialog(
//                          context,
//                          "Bets per match",
//                          "This is the maximum number of times you "
//                              "will be automatically added to a new bet once a goal has been scored.  We will take funds from your account to cover all rollovers.  If there are not enough goals in the game, you will be refunded any remaining funds.");
//                    },
//                    controller: textEditingController2,
//                    onChanged: (value) {
//                      if (currencyTextFieldController2.text.isNotEmpty &&
//                          textEditingController2.text.isNotEmpty) {
//                        var totalStake =
//                            currencyTextFieldController2.doubleValue *
//                                double.parse(textEditingController2.text);
//                        textEditingController.text =
//                            "£${(totalStake).toStringAsFixed(2)}";
//                        setState(() {
//                          ngsTotalStake = totalStake;
//                          ngsBet.rollovers =
//                              textEditingController2.text.toString();
//                        });
//                      }
//                    },
//                  ),
//                  TextFieldWithTitleInfo(
//                    title: 'Total stake:',
//                    isEnabled: false,
//                    onInfoButtonPressed: () {
//                      Utility.getInstance().showErrorAlertDialog(
//                          context,
//                          "Total stake",
//                          "The total amount you will be charged. Bets Per Goal x Bets Per Match. Any excess funds will be refunded at the end of the match.");
//                    },
//                    onChanged: (value) {},
//                    controller: textEditingController,
//                  ),
                  SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    decoration: kGradientBoxDecoration,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                            '${invitedUsers != null ? invitedUsers.length : 0} players invited, ${invitedSquads != null ? invitedSquads.length : 0} squads invited',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center)
                      ],
                    ),
                  ),
                  FullWidthButton('Invite Players +', () async {
                    var result = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SelectOpponentScreen(
                          multipleSelection: true,
                          alreadySelectedUsers: invitedUsers != null ? invitedUsers.map((e) => e['uid']).toList() : [],
                          alreadySelectedSquads: invitedSquads,
                        ),
                      ),
                    );
                    print(result['selectedSquads']);
                    setState(() {
                      invitedUsers = result['selectedUsers'];
                      invitedSquads = result['selectedSquads'];
                    });
                  })
                ],
              ),
            ),
          ),
        )
      ],
    );

    var betScreens = Scaffold(
        body: ModalProgressHUD(
      progressIndicator: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(kBetSquadOrange),
      ),
      inAsyncCall: _ngsLoading || _h2hLoading,
      child: Column(
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
    ));

    final List<Widget> screens = [
      betScreens,
      BetHistoryPage(),
      ChatTabScreen(),
      SquadsTab(),
    ];

    return Scaffold(
      appBar: BetSquadLogoBalanceAppBar(),
      body: screens[currentIndex],
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
          FABBottomAppBarItem(iconData: MdiIcons.soccerField, text: 'Matches', showBadge: false),
          FABBottomAppBarItem(iconData: MdiIcons.coins, text: 'Bets', showBadge: true),
          FABBottomAppBarItem(iconData: Icons.chat_bubble_outline, text: 'Chat', showBadge: true),
          FABBottomAppBarItem(iconData: Icons.supervised_user_circle, text: 'Squads', showBadge: true),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: 95,
        height: 100,
        child: FloatingActionButton(
          shape: CircleBorder(side: BorderSide(color: kBetSquadOrange, width: 2.0)),
          onPressed: () async {
            if (_h2hLoading) return;
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
                    context,
                    'Sorry',
                    'We couldn\'t confirm your age or identity.  We will be in contact shortly to confirm what we need.  If you '
                        'can\'t wait send a message to The UnderFlapper');
              }

              Map createBetResponse = await BetApi().sendH2HBet(h2hBet);
              print(createBetResponse);
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

                if (errorMsg == "You do not have enough funds to place this bet") {
                  Alert.showDepositError(context, 'Insufficient funds', errorMsg);
                } else {
                  Alert.showErrorDialog(context, 'Sorry', errorMsg);
                }
              }
            } else {
              if (_ngsLoading) return;

              print("send NGS bet");
              print(ngsBet.amount);
//              print(ngsTotalStake);

//              if (ngsBet.rollovers == null) {
//                print("rollovers null");
//                Utility.getInstance().showErrorAlertDialog(
//                    context,
//                    'Enter max bets',
//                    'Please enter a max bets per match value');
//                return;
//              }
//
              if (ngsBet.amount < 2) {
                Utility.getInstance().showErrorAlertDialog(
                    context,
                    'Minimum £2 bet',
                    'The minimum total bet amount'
                        ' is £2.00');
                return;
              }

              if (invitedUsers.length < 1 && invitedSquads.length < 1) {
                Utility.getInstance().showErrorAlertDialog(
                    context,
                    'Invite users',
                    'You must invite at least 1 user or squad'
                        'to this bet');
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
                    context,
                    'Sorry',
                    'We couldn\'t confirm your age or identity.  We will be in contact shortly to confirm what we need. If you '
                        'can\'t wait send a message to The UnderFlapper');
              }

              Map createBetResponse = await BetApi().sendNGSBet(ngsBet, invitedUsers, invitedSquads);
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
                Alert.showErrorDialog(context, 'Sorry', errorMsg);
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
    );
  }
}
