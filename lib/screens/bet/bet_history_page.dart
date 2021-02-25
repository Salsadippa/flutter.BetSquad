import 'package:betsquad/models/bet.dart';
import 'package:betsquad/screens/bet/h2h_bet_screen.dart';
import 'package:betsquad/screens/bet/h2h_detail_page.dart';
import 'package:betsquad/screens/bet/ngs_bet_screen.dart';
import 'package:betsquad/services/database.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:betsquad/utilities/hex_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class BetHistoryPage extends StatefulWidget {
  static const ID = 'bet_history_page';

  @override
  _BetHistoryPageState createState() => _BetHistoryPageState();
}

class _BetHistoryPageState extends State<BetHistoryPage> {
  var isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<Map> getBet(String betId, String value) async {
    var b = await FirebaseDatabase.instance.reference().child('bets').child(betId).once();
    var bet = b.value;

    if (bet == null) {
      return null;
    }

    if (bet != null && bet['mode'] != 'custom' && bet['matchID'] != null) {
      var match = await DatabaseService().getMatch(bet['matchID']);
      bet['match'] = match;
    }

    bet['id'] = betId;

    if (bet['mode'] == "head2head") {
      bet['opponentId'] = value;
    } else {
      bet['userStatus'] = value;
    }

    return bet;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: BetSquadLogoProfileBalanceAppBar(),
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: TabBar(
            indicatorColor: kBetSquadOrange,
            tabs: [
              Tab(text: 'Open'),
              Tab(text: 'Recent'),
              Tab(text: 'Closed'),
            ],
          ),
          body: StreamBuilder<Event>(
              stream: FirebaseDatabase.instance
                  .reference()
                  .child('users')
                  .child(FirebaseAuth.instance.currentUser.uid)
                  .child('bets')
                  .onValue,
              builder: (context, snapshot) {
                if (snapshot.hasError || !snapshot.hasData || snapshot.data.snapshot.value == null) {
                  return Container(
                    decoration: kGradientBoxDecoration,
                  );
                }
                Map usersBetsMap = snapshot.data.snapshot.value;
                // print(usersBetsMap);

                var futures = <Future>[];
                usersBetsMap.forEach((key, value) async {
                  futures.add(getBet(key, value));
                });

                var betFutures = Future.wait(futures);

                return FutureBuilder(
                  future: betFutures,
                  builder: (context, snapshot) {
                    if (snapshot.hasError || !snapshot.hasData) {
                      return Container(
                        decoration: kGradientBoxDecoration,
                      );
                    }
                    var bets = snapshot.data;

                    bets.sort((a, b) => a['created'] > b['created']
                        ? -1
                        : a['created'] == b['created']
                            ? 0
                            : 1);
                    List<Bet> open = [], recent = [], closed = [];
                    var threeDaysAgo = DateTime.now().subtract(Duration(days: 3)).millisecondsSinceEpoch;
                    for (var i = 0; i < bets.length; i++) {
                      var bet = bets[i];
                      if (['ongoing', 'sent', 'received', 'reversal', 'requested', 'open'].contains(bet['status']) &&
                          bet['userStatus'] != 'declined') {
                        open.add(Bet.fromMap(bet));
                      } else if (['won', 'lost', 'requested reversal', 'reversed'].contains(bet['status']) ||
                          (bet['status'] == 'closed' && (bet['userStatus'] == 'won' || bet['userStatus'] == 'lost'))) {
                        var created = bet['created'];
                        if (created > sevenDaysAgo) {
                          recent.add(Bet.fromMap(bet));
                        } else {
                          print("status: " + bet["status"]);
                          print("status: " + bet["status"]);

                        }
                      } else {
                        if (bet['status'] != 'withdrawn' && bet['status'] != 'declined' && bet['status'] != 'expired'){
                          closed.add(Bet.fromMap(bet));
                        }
                      }
                    }

                    return TabBarView(
                      children: [
                        Scaffold(
                          body: Container(
                            decoration: kGradientBoxDecoration,
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                var bet = open[index];
                                return BetHistoryCell(bet: bet);
                              },
                              itemCount: open.length,
                            ),
                          ),
                        ),
                        Scaffold(
                          body: Container(
                            decoration: kGradientBoxDecoration,
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                var bet = recent[index];
                                return BetHistoryCell(bet: bet);
                              },
                              itemCount: recent.length,
                            ),
                          ),
                        ),
                        Scaffold(
                          body: Container(
                            decoration: kGradientBoxDecoration,
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                var bet = closed[index];
                                return BetHistoryCell(bet: bet);
                              },
                              itemCount: closed.length,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }),
        ),
      ),
    );
  }
}

class BetHistoryCell extends StatelessWidget {
  final Bet bet;

  const BetHistoryCell({Key key, this.bet}) : super(key: key);

  Future<String> getUsername(String userId) async {
    final dbRef = await FirebaseDatabase.instance.reference().child("users").child(userId).child('username').once();
    return dbRef.value;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(bet.id);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return bet.mode == "NGS" ? NGSBetScreen(bet) : H2HDetailPage(bet);
            },
          ),
        );
      },
      child: StreamBuilder<Event>(
          stream: FirebaseDatabase.instance.reference().child('bets').child(bet.id).onValue,
          builder: (context, snapshot) {
            if (snapshot.hasError || !snapshot.hasData) {
              return Container();
            }

            var liveBet = bet;
            // Bet.fromMap(snapshot.data.snapshot.value);
            // liveBet.match = bet.match;

            return Container(
              decoration: kGradientBoxDecoration,
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      padding: EdgeInsets.only(left: 20, right: 10),
                      height: 120,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          if (liveBet.mode != 'custom')
                            Row(
                              children: [
                                Icon(
                                  MdiIcons.tshirtCrew,
                                  color: HexColor(bet.match.homeShirtColor ?? '#FFFFFF'),
                                ),
                                SizedBox(width: 5),
                                Flexible(
                                  child: Text(
                                    liveBet.match != null ? liveBet.match.homeTeamName : '',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          liveBet.mode == 'custom'
                              ? Text('${liveBet.name.toUpperCase()}\n\nCustom Bet',
                                  style: TextStyle(color: Colors.white), maxLines: 5)
                              : liveBet.mode == 'NGS'
                                  ? Row(
                                      children: [
                                        Text(
                                          'NEXT GOAL SWEEPSTAKE',
                                          style: TextStyle(color: kBetSquadOrange, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        Expanded(
                                          //win button
                                          child: Image.asset(
                                            liveBet.homeBet == BetOption.Positive
                                                ? 'images/win_green.png'
                                                : (liveBet.homeBet == BetOption.Negative
                                                    ? 'images/win_red.png'
                                                    : 'images/win_grey.png'),
                                          ),
                                        ),
                                        Expanded(
                                          //draw button
                                          child: Image.asset(
                                            liveBet.drawBet == BetOption.Positive
                                                ? 'images/draw_green.png'
                                                : (liveBet.drawBet == BetOption.Negative
                                                    ? 'images/draw_red.png'
                                                    : 'images/draw_grey.png'),
                                          ),
                                        ),
                                        Expanded(
                                          child: Image.asset(
                                            liveBet.awayBet == BetOption.Positive
                                                ? 'images/lose_green.png'
                                                : (liveBet.awayBet == BetOption.Negative
                                                    ? 'images/lose_red.png'
                                                    : 'images/lose_grey.png'),
                                          ),
                                        )
                                      ],
                                    ),
                          if (liveBet.mode != 'custom')
                            Row(
                              children: [
                                Icon(
                                  MdiIcons.tshirtCrew,
                                  color: HexColor(liveBet.match.awayShirtColor ?? '#FFFFFF'),
                                ),
                                SizedBox(width: 5),
                                Flexible(
                                  child: Text(
                                    liveBet.match != null ? liveBet.match.awayTeamName : '',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 0.5,
                    height: 100,
                    color: kBetSquadOrange,
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.only(left: 20),
                      height: 110,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            liveBet.mode == "NGS"
                                ? '£${liveBet.amount.toStringAsFixed(2)} bet x ${liveBet.rollovers} rollovers'
                                : '£${liveBet.amount.toStringAsFixed(2)} bet',
                            style: TextStyle(color: Colors.white),
                          ),
                          liveBet.mode == "NGS"
                              ? Text(
                                  'vs ${liveBet.accepted.length} ${liveBet.accepted.length > 1 ? 'users' : 'user'}',
                                  style: TextStyle(color: Colors.white),
                                )
                              : FutureBuilder<String>(
                                  future: getUsername(liveBet.vsUserID),
                                  builder: (context, snapshot) {
                                    return Text(
                                      'vs ${snapshot.hasError || !snapshot.hasData ? '' : snapshot.data}',
                                      style: TextStyle(color: Colors.white),
                                    );
                                  }),
                          Text(
                            '${DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(int.parse(liveBet.match.startTimestamp) * 1000))}',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            '${(liveBet.status == 'ongoing' || liveBet.status == 'withdrawn' || liveBet.status == 'expired' || liveBet.status == 'rec'
                                'eived' || liveBet.status == 'sent' || liveBet.status == 'won' || liveBet.status == 'lost') || liveBet.status == 'declined' ? liveBet.status : liveBet.userStatus}',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}
