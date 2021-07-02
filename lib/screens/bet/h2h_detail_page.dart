import 'package:betsquad/api/bet_api.dart';
import 'package:betsquad/api/users_api.dart';
import 'package:betsquad/models/bet.dart';
import 'package:betsquad/services/database.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:betsquad/utilities/hex_color.dart';
import 'package:betsquad/widgets/betsquad_logo_balance_appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../alert.dart';

class H2HDetailPage extends StatefulWidget {
  final Bet bet;

  const H2HDetailPage(this.bet);

  @override
  _H2HDetailPageState createState() => _H2HDetailPageState();
}

class _H2HDetailPageState extends State<H2HDetailPage> {
  String _profilePicture, _opponentProfilePicture, _selectedOpponentUsername;
  DatabaseService databaseService = DatabaseService();
  static const H2H_FEE = 0.95;
  bool _loading = false;

  void getUserDetails() async {
    User user = FirebaseAuth.instance.currentUser;
    var profilePic = await databaseService.getUserProfilePicture(user.uid);
    var opponentProfilePicture = await databaseService.getUserProfilePicture(widget.bet.vsUserID);
    var selectedOpponentUsername = await databaseService.getUserUsername(widget.bet.vsUserID);
    setState(() {
      _profilePicture = profilePic;
      _opponentProfilePicture = opponentProfilePicture;
      _selectedOpponentUsername = selectedOpponentUsername;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    var whiteTextStyle = GoogleFonts.roboto(color: Colors.white, fontSize: 15);

    return Scaffold(
      appBar: BetSquadLogoBalanceAppBar(),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        child: Column(
          children: [
            Container(
              height: 50,
              decoration: kGrassTrimBoxDecoration,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet<dynamic>(
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext bc) {
                            return Wrap(children: <Widget>[
                              Container(
                                color: Colors.black87,
                                child: ListView(
                                  shrinkWrap: true,
                                  children: [
                                    ListTile(
                                      title: Text(
                                        'Withdraw Bet',
                                        style: GoogleFonts.roboto(color: kBetSquadOrange, fontSize: 18),
                                      ),
                                      onTap: () async {
                                        setState(() {
                                          _loading = true;
                                        });
                                        var res = await BetApi().withdrawH2HBet(widget.bet);
                                        setState(() {
                                          _loading = false;
                                        });
                                        Navigator.of(context).pop();
                                        if (res['result'] == 'success') {
                                          Alert.showSuccessDialog(context, 'Bet Withdrawn', res['message']);
                                        } else {
                                          Alert.showErrorDialog(context, 'Cannot Withdraw Bet', res['message']);
                                        }
                                      },
                                    )
                                  ],
                                ),
                              )
                            ]);
                          });
                    },
                    child: Icon(
                      Icons.edit,
                      color: kBetSquadOrange,
                    ),
                  ),
                  SizedBox(width: 20)
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  decoration: kGrassTrimBoxDecoration,
                  height: MediaQuery.of(context).size.height,
                  child: FractionallySizedBox(
                    heightFactor: 0.8,
                    child: Container(
                      decoration: kGradientBoxDecoration,
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 100,
                            child: Transform.translate(
                              offset: Offset(0, -30),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: kBetSquadOrange,
                                child: CircleAvatar(
                                  backgroundImage: _profilePicture != null || _profilePicture == ''
                                      ? NetworkImage(_profilePicture)
                                      : kUserPlaceholderImage,
                                  radius: 48,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text(
                                    'You ${widget.bet.status == 'ongoing' ? 'have an ongoing' : widget.bet.status == 'withdrawn' ? 'have a withdrawn' : widget.bet.status == 'expired' ? 'have an '
                                        'expired' : widget.bet.status + ' a'}',
                                    style: whiteTextStyle),
                                Text(
                                    '£${(widget.bet.status == 'won' ? (widget.bet.amount + (widget.bet.amount * H2H_FEE)) : widget.bet.amount).toStringAsFixed(2)}',
                                    style: GoogleFonts.roboto(
                                        color: Colors.green, fontSize: 50, fontWeight: FontWeight.bold)),
                                Text(
                                  'bet that',
                                  style: whiteTextStyle,
                                ),
                                Container(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(MdiIcons.tshirtCrew, color: HexColor(widget.bet.match.homeShirtColor)),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            widget.bet.match.homeTeamName,
                                            style: whiteTextStyle,
                                          ),
                                          Text(': \t${widget.bet.match.homeGoals}\t', style: whiteTextStyle),
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
                                              child: Image.asset(
                                                widget.bet.homeBet == BetOption.Positive
                                                    ? 'images/win_green.png'
                                                    : (widget.bet.homeBet == BetOption.Negative
                                                        ? 'images/win_red.png'
                                                        : 'images/win_grey.png'),
                                              ),
                                            ),
                                            Expanded(
                                              //draw button
                                              child: Image.asset(
                                                widget.bet.drawBet == BetOption.Positive
                                                    ? 'images/draw_green.png'
                                                    : (widget.bet.drawBet == BetOption.Negative
                                                        ? 'images/draw_red.png'
                                                        : 'images/draw_grey.png'),
                                              ),
                                            ),
                                            Expanded(
                                              child: Image.asset(
                                                widget.bet.awayBet == BetOption.Positive
                                                    ? 'images/lose_green.png'
                                                    : (widget.bet.awayBet == BetOption.Negative
                                                        ? 'images/lose_red.png'
                                                        : 'images/lose_grey.png'),
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
                                          Text(': \t${widget.bet.match.awayGoals}\t', style: whiteTextStyle),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    'vs ${_selectedOpponentUsername ?? ''}',
                                    style: whiteTextStyle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (widget.bet.status == 'received')
                            Container(
                              height: 65,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: FlatButton(
                                      child: Text('Accept', style: TextStyle(color: Colors.white, fontSize: 18)),
                                      color: Colors.green,
                                      onPressed: () async {
                                        bool compliant = await UsersApi.complianceCheck();
                                        if (!compliant) {
                                          Alert.showErrorDialog(
                                              context,
                                              'Sorry',
                                              'We couldn\'t confirm your age or identity.  We will be in contact shortly to confirm what we need. If you can\'t wait send a message to The UnderFlapper');
                                        }

                                        setState(() {
                                          _loading = true;
                                        });

                                        //accept bet
                                        Map acceptedBetResponse = await BetApi().acceptH2HBet(widget.bet);
                                        print(acceptedBetResponse);
                                        setState(() {
                                          _loading = false;
                                        });
                                        if (acceptedBetResponse['result'] == 'success') {
                                          Navigator.of(context).pop();
                                          Alert.showSuccessDialog(
                                              context, 'Bet Accepted', acceptedBetResponse['message']);
                                        } else {
                                          Alert.showSuccessDialog(
                                              context, 'Accept Bet Failed', acceptedBetResponse['message']);
                                        }
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
                                      onPressed: () async {
                                        //decline bet
                                        setState(() {
                                          _loading = true;
                                        });
                                        Map acceptedBetResponse = await BetApi().declineH2HBet(widget.bet);
                                        print(acceptedBetResponse);
                                        setState(() {
                                          _loading = false;
                                        });
                                        if (acceptedBetResponse['result'] == 'success') {
                                          Navigator.of(context).pop();
                                          Alert.showSuccessDialog(
                                              context, 'Bet Declined', acceptedBetResponse['message']);
                                        } else {
                                          Alert.showErrorDialog(
                                              context, 'Decline Bet Failed', acceptedBetResponse['message']);
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          Container(
                            height: 100,
                            child: Transform.translate(
                              offset: Offset(0.0, 30.0),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: kBetSquadOrange,
                                child: CircleAvatar(
                                  backgroundImage: _opponentProfilePicture != null
                                      ? NetworkImage(_opponentProfilePicture)
                                      : kUserPlaceholderImage,
                                  radius: 48,
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
            ),
          ],
        ),
      ),
    );
  }
}
