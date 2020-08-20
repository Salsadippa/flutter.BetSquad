import 'package:betsquad/models/bet.dart';
import 'package:betsquad/screens/bet/ngs_invited_page.dartt.dart';
import 'package:betsquad/screens/select_opponent_screen.dart';
import 'package:betsquad/services/database.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:betsquad/utilities/utility.dart';
import 'package:betsquad/widgets/betsquad_logo_balance_appbar.dart';
import 'package:betsquad/widgets/full_width_button.dart';
import 'package:betsquad/widgets/match_header.dart';
import 'package:betsquad/widgets/text_field_with_info.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'ngs_assignments_page.dart';

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MatchHeader(match: widget.bet.match),
            Container(
              color: Colors.black87,
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      if (widget.bet.assignments != null) {
                        //show invited
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => NGSAssignmentsPage(bet: widget.bet),
                          ),
                        );
                      } else {
                        //show assignments
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => NGSInvitedPage(bet: widget.bet),
                          ),
                        );
                      }
                    },
                    child: Container(
                      decoration: kGradientBoxDecoration,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              children: [
                                Icon(
                                  MdiIcons.tshirtVOutline,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'View Players/Allocations',
                                  style: TextStyle(color: Colors.white, fontSize: 15),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: kGradientBoxDecoration,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                color: Colors.white,
                                size: 16,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'In-bet Chat',
                                style: TextStyle(color: Colors.white, fontSize: 15),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
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
                  if (widget.bet.winners != null)
                    Column(children: widget.bet.winners.values.map((e) => WinnerListItem(winner: e)).toList()),
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
            )
          ],
        ),
      ),
    );
  }
}

class WinnerListItem extends StatefulWidget {
  final winner;

  const WinnerListItem({Key key, this.winner}) : super(key: key);

  @override
  _WinnerListItemState createState() => _WinnerListItemState();
}

class _WinnerListItemState extends State<WinnerListItem> {
  String _username, _profilePicture;
  DatabaseService databaseService = DatabaseService();

  void getUserDetails(String uid) async {
    var username = await databaseService.getUserUsername(uid);
    var profilePic = await databaseService.getUserProfilePicture(uid);
    setState(() {
      _username = username;
      _profilePicture = profilePic;
    });
  }

  @override
  void initState() {
    getUserDetails(widget.winner['userID']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: kBetSquadOrange,
        child: CircleAvatar(
          radius: 20,
          backgroundImage:
              _profilePicture != null ? NetworkImage(_profilePicture) : AssetImage('images/user_placeholder.png'),
        ),
      ),
      title: Text(
        _username ?? '',
        style: GoogleFonts.roboto(color: Colors.white),
      ),
      subtitle: Text(
        '${widget.winner['scoringPlayer']} - ${widget.winner['scoringTime']}\' ',
        style: GoogleFonts.roboto(color: Colors.white),
      ),
    );
  }
}
