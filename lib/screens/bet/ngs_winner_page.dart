import 'package:betsquad/models/bet.dart';
import 'package:betsquad/screens/bet/ngs_assignments_page.dart';
import 'package:betsquad/services/database.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:betsquad/utilities/hex_color.dart';
import 'package:betsquad/widgets/betsquad_logo_balance_appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'select_opponent_screen.dart';

class NGSWinnerPage extends StatefulWidget {
  static const ID = 'ngs_winner_page';
  final String uid, scoringPlayer, scoringTime;
  final double amount;
  final Bet bet;
  final winnerEntryId;

  const NGSWinnerPage({this.uid, this.amount, this.scoringPlayer, this.scoringTime, this.bet, this.winnerEntryId});

  @override
  _NGSWinnerPageState createState() => _NGSWinnerPageState();
}

class _NGSWinnerPageState extends State<NGSWinnerPage> {
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

  String returnWholeNumberIfMoneyIsWhole(double earning){
    //Whole meaning it ends with .00
    var reversedEarning =  earning.toStringAsFixed(2).split('').reversed.join();

    if(reversedEarning[0] == "0" && reversedEarning[1] == "0"){
      return earning.toStringAsFixed(2); //Converts to a 2dp string
    }else{
      return earning.toStringAsFixed(0); //Convert to a whole number 
    }

  }

  @override
  void initState() {
    super.initState();
    getUserDetails(widget.uid);
  }

  var whiteTextStyle = TextStyle(color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BetSquadLogoBalanceAppBar(),
      body: Center(
        child: Container(
          decoration: kGrassTrimBoxDecoration,
          height: MediaQuery.of(context).size.height,
          child: FractionallySizedBox(
            heightFactor: 0.70,
            child: Container(
              decoration: kGradientBoxDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    height: 100,
                    child: Transform.translate(
                      offset: Offset(0, -30),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: kBetSquadOrange,
                        child: CircleAvatar(
                          backgroundImage:
                              _profilePicture != null || _profilePicture == '' ? NetworkImage(_profilePicture) : kUserPlaceholderImage,
                          radius: 48,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            '$_username won',
                            style: GoogleFonts.roboto(color: Colors.white, fontSize: 25),
                          ),
                          Text(
                            '£${widget.amount != null ? returnWholeNumberIfMoneyIsWhole(widget.amount) : '??.??'}',
                            style: GoogleFonts.roboto(color: Colors.green, fontSize: 50, fontWeight: FontWeight.bold),
                          ),
                          Column(
                            children: [
                              Text('NGS Game', style: GoogleFonts.roboto(color: Colors.white, fontSize: 16)),
                              SizedBox(height: 5),
                              Text('${widget.scoringPlayer} ${widget.scoringTime}\'',
                                  style: GoogleFonts.roboto(color: Colors.white, fontSize: 20)),
                            ],
                          ),
                          FlatButton(
                            onPressed: () {
                              print("pressed");
                              print(widget.bet.winners);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => NGSAssignmentsPage(bet: widget.bet, winnerEntryId: widget.winnerEntryId,),
                                ),
                              );
                            },
                            child: Text('View Round Assignments',
                                style: GoogleFonts.roboto(color: Colors.white, fontSize: 16)),
                          ),
                          Text('New players have been assigned', style: GoogleFonts.roboto(color: Colors.white,
                              fontSize: 16)),

                        ],
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
