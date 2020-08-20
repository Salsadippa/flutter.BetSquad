import 'package:betsquad/services/database.dart';
import 'package:betsquad/styles/constants.dart';
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
  String _userProfilePicture, _userUsername;
  DatabaseService databaseService = DatabaseService();

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  void getUserInfo() async {
    var picture = await databaseService.getUserProfilePicture(widget.userId);
    var username = await databaseService.getUserUsername(widget.userId);
    setState(() {
      _userProfilePicture = picture;
      _userUsername = username;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            child: CircleAvatar(
              radius: 30,
              backgroundColor: kBetSquadOrange,
              child: CircleAvatar(
                radius: 28,
                backgroundImage: _userProfilePicture != null
                    ? NetworkImage(_userProfilePicture)
                    : AssetImage('images/user_placeholder'
                        '.png'),
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
                Text(
                  _userUsername ?? '',
                  maxLines: 1,
                  style: GoogleFonts.roboto(color: Colors.white, fontSize: 11),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
