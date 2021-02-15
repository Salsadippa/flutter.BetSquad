import 'package:betsquad/api/bet_api.dart';
import 'package:betsquad/api/users_api.dart';
import 'package:betsquad/models/bet.dart';
import 'package:betsquad/screens/bet/ngs_invited_page.dart';
import 'package:betsquad/screens/bet/ngs_winner_page.dart';
import 'package:betsquad/screens/bet/select_opponent_screen.dart';
import 'package:betsquad/screens/chat/chat_screen.dart';
import 'package:betsquad/services/database.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:betsquad/utilities/utility.dart';
import 'package:betsquad/widgets/betsquad_logo_balance_appbar.dart';
import 'package:betsquad/widgets/full_width_button.dart';
import 'package:betsquad/widgets/match_header.dart';
import 'package:betsquad/widgets/text_field_with_info.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../alert.dart';
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
  var invitedSquads = [];
  bool _loading = false;

  TextEditingController textEditingController = TextEditingController();
//  TextEditingController textEditingController2 = TextEditingController();
//  TextEditingController textEditingController3 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    textEditingController.text = '£${widget.bet.amount.toStringAsFixed(2)}';
//    textEditingController2.text = widget.bet.rollovers;
//    textEditingController3.text = '£${(widget.bet.amount * int.parse(widget.bet.rollovers)).toStringAsFixed(2)}';

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: BetSquadLogoBalanceAppBar(),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
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
                                          if (widget.bet.userStatus == 'sent') {
                                            setState(() {
                                              _loading = true;
                                            });
                                            var res = await BetApi().withdrawNGSBet(widget.bet);
                                            setState(() {
                                              _loading = false;
                                            });
                                            Navigator.of(context).pop();
                                            Alert.showSuccessDialog(context, 'Bet Withdrawn', res['message']);
                                          } else {
                                            Navigator.of(context).pop();
                                            Alert.showErrorDialog(
                                                context,
                                                'Cannot Withdraw Bet',
                                                'You cannot withdraw '
                                                    'this bet at this time.');
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
              MatchHeader(match: widget.bet.match),
              Container(
                decoration: kGradientBoxDecoration,
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        if (widget.bet.assignments.isNotEmpty) {
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
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              chatId: widget.bet.id,
                            ),
                          ),
                        );
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
//                    TextFieldWithTitleInfo(
//                      title: 'Max bets per match:',
//                      isEnabled: false,
//                      onInfoButtonPressed: () {
//                        Utility.getInstance().showErrorAlertDialog(
//                            context,
//                            "Bets per match",
//                            "This is the maximum number of times you "
//                                "will be automatically added to a new bet once a goal has been scored.  We will take funds from your account to cover all rollovers.  If there are not enough goals in the game, you will be refunded any remaining funds.");
//                      },
//                      controller: textEditingController2,
//                      onChanged: (value) {},
//                    ),
//                    TextFieldWithTitleInfo(
//                      title: 'Total stake:',
//                      isEnabled: false,
//                      onInfoButtonPressed: () {
//                        Utility.getInstance().showErrorAlertDialog(context, "Total stake",
//                            "The total amount you will be charged. Bets Per Goal x Bets Per Match. Any excess funds will be refunded at the end of the match.");
//                      },
//                      onChanged: (value) {},
//                      controller: textEditingController3,
//                    ),
                    SizedBox(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: kGradientBoxDecoration,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('${widget.bet.invited != null ? widget.bet.invited.length : 0} players invited, '
                              '${widget.bet.invitedSquads != null ? widget.bet.invitedSquads.length : 0} squads '
                              'invited',
                              style: TextStyle(color: Colors.white), textAlign: TextAlign.center)
                        ],
                      ),
                    ),

                    StreamBuilder<Event>(
                      stream: FirebaseDatabase.instance.reference().child("bets").child(widget.bet.id).child("winners").onValue,
                      builder: (context,  snapshot) {
                        if (snapshot.hasData) {

                          Map<dynamic, dynamic> winners = snapshot.data.snapshot.value;

                          if (winners == null || winners.length == 0)
                            return Container();

                            return Column(
                                children:winners.entries
                                    .map(
                                      (e) => WinnerListItem(winner: e.value, winnerEntryId: e.key, bet: widget.bet),
                                ).toList());
                        }
                        return Container();
                      },
                    ),

                    if (widget.bet.userStatus == 'sent')
                      FullWidthButton('Invite Players +', () async {
                        var result = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SelectOpponentScreen(
                              multipleSelection: true,
                              alreadyInvitedUsers: widget.bet.invited,
                              alreadySelectedUsers:
                                  invitedUsers != null ? invitedUsers.map((e) => e['uid']).toList() : [],
                              alreadySelectedSquads: invitedSquads,
                            ),
                          ),
                        );
                        List users = result['selectedUsers'];
                        List squads = result['selectedSquads'];
                        setState(() {
                          invitedUsers = users
                              .map((e) => {
                                    'username': e['username'],
                                    'uid': e['uid'],
                                    'messagingToke'
                                        'n': e['messagingToken']
                                  })
                              .toList();
                          invitedSquads = squads;
                        });
                        // set up the buttons
                        Widget sendButton = FlatButton(
                          child: Text("Send Invites"),
                          onPressed: () async {
                            Navigator.pop(context);
                            // setState(() {
                            //   _loading = true;
                            // });
                            print(users);
                            print(squads);

                            var res = await BetApi().additionalNGSInvites(widget.bet, invitedUsers, invitedSquads);
                            print(res);

                            setState(() {
                              invitedUsers = [];
                              invitedSquads = [];
                            });

                            Alert.showSuccessDialog(context, 'Invites sent', res['message']);
                          },
                        );

                        Widget cancelButton = FlatButton(
                          child: Text("Cancel"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        );
                        // set up the AlertDialog
                        AlertDialog alert = AlertDialog(
                          title: Text('Send Invites?'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text('Are you sure you want to send ${users.length + squads.length} additional '
                                    'invites')
                              ],
                            ),
                          ),
                          actions: [
                            cancelButton,
                            sendButton,
                          ],
                        );

                        // show the dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return alert;
                          },
                        );
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
                                onPressed: () async {
                                  bool compliant = await UsersApi.complianceCheck();
                                  if (!compliant) {
                                    Alert.showErrorDialog(context, 'Cannot bet',
                                        'You have failed our compliance check. Please contact info@bet-squad.com');
                                  }
                                  setState(() {
                                    _loading = true;
                                  });

                                  //accept bet
                                  Map acceptedBetResponse = await BetApi().acceptNGSBet(widget.bet);
                                  print(acceptedBetResponse);
                                  setState(() {
                                    _loading = false;
                                  });
                                  if (acceptedBetResponse['result'] == 'success') {
                                    Navigator.of(context).pop();
                                    Alert.showSuccessDialog(context, 'Bet Accepted', acceptedBetResponse['message']);
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
                                  Map acceptedBetResponse = await BetApi().declineNGSBet(widget.bet);
                                  print(acceptedBetResponse);
                                  setState(() {
                                    _loading = false;
                                  });
                                  if (acceptedBetResponse['result'] == 'success') {
                                    Navigator.of(context).pop();
                                    Alert.showSuccessDialog(context, 'Bet Declined', acceptedBetResponse['message']);
                                  } else {
                                    Alert.showSuccessDialog(
                                        context, 'Decline Bet Failed', acceptedBetResponse['message']);
                                  }
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
      ),
    );
  }
}

class WinnerListItem extends StatefulWidget {
  final winner;
  final Bet bet;
  final winnerEntryId;

  const WinnerListItem({Key key, this.winner, this.bet, this.winnerEntryId}) : super(key: key);

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
      onTap: () {
        print('betID -> ' + widget.bet.id);
        print('amount -> ' + widget.winnerEntryId);

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return NGSWinnerPage(
                winnerEntryId: widget.winnerEntryId,
                amount: widget.winner['amount'],
                uid: widget.winner['userID'],
                scoringPlayer: widget.winner['scoringPlayer'],
                scoringTime: widget.winner['scoringTime'],
                bet: widget.bet,
              );
            },
          ),
        );
      },
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
