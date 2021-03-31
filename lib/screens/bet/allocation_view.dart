import 'package:betsquad/services/database.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AllocationView extends StatefulWidget {
  final String userId, playerName;
  final int playerNumber;

  const AllocationView({this.userId, this.playerNumber, this.playerName});

  @override
  _AllocationViewState createState() => _AllocationViewState();
}

class _AllocationViewState extends State<AllocationView> {

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            child: CircleAvatar(
              radius: 30,
              backgroundColor: kBetSquadOrange,
              child: FutureBuilder<DataSnapshot>(
                  future: FirebaseDatabase.instance.reference().child('users').child(widget.userId).child('image')
                      .once(),
                  builder: (context, snapshot) {
                  return CircleAvatar(
                    radius: 28,
                    backgroundImage: snapshot.hasData
                        ? NetworkImage(snapshot.data.value)
                        : AssetImage('images/user_placeholder'
                            '.png'),
                  );
                }
              ),
            ),
          ),
          Container(
            width: 100,
            color: Colors.black,
            child: Column(
              children: [
                Text(
                  widget.playerName ?? '',
                  maxLines: 1,
                  style: GoogleFonts.roboto(color: Colors.white, fontSize: 11),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
                FutureBuilder<DataSnapshot>(
                  future: FirebaseDatabase.instance.reference().child('users').child(widget.userId).child('username')
                      .once(),
                  builder: (context, snapshot) {
                    return Text(
                      snapshot.hasData ? snapshot.data.value : '',
                      maxLines: 1,
                      style: GoogleFonts.roboto(color: Colors.white, fontSize: 11),
                      textAlign: TextAlign.center,
                    );
                  }
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
