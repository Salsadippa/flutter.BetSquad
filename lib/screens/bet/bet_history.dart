import 'package:betsquad/models/bet.dart';
import 'package:betsquad/services/database.dart';
import 'package:betsquad/utilities/hex_color.dart';
import 'package:betsquad/widgets/betsquad_logo_profile_balance_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class BetHistoryPage extends StatefulWidget {
  @override
  _BetHistoryPageState createState() => _BetHistoryPageState();
}

class _BetHistoryPageState extends State<BetHistoryPage> {
  List<Bet> openBets = [], recentBets = [], closedBets = [];
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    this.getBets();
  }

  void getBets() async {
    setState(() {
      isLoading = true;
    });
    DatabaseService dbService = DatabaseService();
    var bets = await dbService.getUserBetHistory();
    setState(() {
      isLoading = false;
      openBets = bets[0];
      recentBets = bets[1];
      closedBets = bets[2];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: BetSquadLogoProfileBalanceAppBar(),
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: TabBar(
            tabs: [
              Tab(text: 'Open'),
              Tab(
                text: 'Recent',
              ),
              Tab(text: 'Closed'),
            ],
          ),
          body: TabBarView(
            children: [
              Scaffold(
                backgroundColor: Colors.black54,
                body: ListView.builder(
                  itemBuilder: (context, index) {
                    var bet = openBets[index];
                    return BetHistoryCell(bet: bet);
                  },
                  itemCount: openBets.length,
                ),
              ),
              Scaffold(
                backgroundColor: Colors.black54,
                body: ListView.builder(
                  itemBuilder: (context, index) {
                    var bet = recentBets[index];
                    return BetHistoryCell(bet: bet);
                  },
                  itemCount: recentBets.length,
                ),
              ),
              Scaffold(
                backgroundColor: Colors.black54,
                body: ListView.builder(
                  itemBuilder: (context, index) {
                    var bet = closedBets[index];
                    return BetHistoryCell(bet: bet);
                  },
                  itemCount: closedBets.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BetHistoryCell extends StatelessWidget {
  final Bet bet;

  const BetHistoryCell({Key key, this.bet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(bet.id);
        print(bet.match.homeShirtColor);
        print(bet.userStatus);
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black87.withOpacity(0.7),
            Colors.black.withOpacity(0.8)]),
        ),
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
                    if (bet.mode != 'custom')
                    Row(
                      children: [
                        Icon(
                          MdiIcons.tshirtCrew,
                          color: HexColor(bet.match.homeShirtColor),
                        ),
                        SizedBox(width: 5),
                        Text(
                          bet.match != null ? bet.match.homeTeamName : '',
                          maxLines: 1,
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                    bet.mode == 'custom'
                        ? Text('${bet.name.toUpperCase()}\n\nCustom Bet',style: TextStyle(color: Colors.white),
                      maxLines: 5)
                        : bet.mode == 'NGS'
                            ? Row(
                                children: [
                                  Text(
                                    'NEXT GOAL SWEEPSTAKE',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Expanded(
                                    //win button
                                    child: Image.asset(
//                                        bet.homeBet == BetOption.Positive
//                                            ? 'images/win_green.png'
//                                            : (bet.homeBet == BetOption.Negative
//                                            ? 'images/win_red.png'
//                                            :
                                        'images/win_grey.png'),
//                                      ),
                                  ),
                                  Expanded(
                                    //draw button
                                    child: Image.asset(
//                                        bet.drawBet == BetOption.Positive
//                                            ? 'images/draw_green.png'
//                                            : (bet.drawBet == BetOption.Negative
//                                            ? 'images/draw_red.png'
//                                            :
                                        'images/draw_grey.png'),
//                                      ),
                                  ),
                                  Expanded(
                                    child: Image.asset(
//                                        bet.awayBet == BetOption.Positive
//                                            ? 'images/lose_green.png'
//                                            : (bet.awayBet == BetOption.Negative
//                                            ? 'images/lose_red.png'
//                                            :
                                        'images/lose_grey.png'),
                                  ),
//                                    )
                                ],
                              ),
                    if (bet.mode != 'custom')
                      Row(
                      children: [
                        Icon(
                          MdiIcons.tshirtCrew,
                          color: HexColor(bet.match.awayShirtColor),
                        ),
                        SizedBox(width: 5),
                        Text(
                          bet.match != null ? bet.match.awayTeamName : '',
                          maxLines: 1,
                          style: TextStyle(color: Colors.white),
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
              color: Colors.white,
            ),
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.only(left: 20),
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '£${bet.amount.toStringAsFixed(2)} bet',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      'vs ${bet.accepted.length} ${bet.accepted.length > 1 ? 'users' : 'user'}',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      '${DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(bet.createdAt * 1000))}',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      '${(bet.status == 'ongoing' || bet.status == 'expired') ? bet.status : bet.userStatus}',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
