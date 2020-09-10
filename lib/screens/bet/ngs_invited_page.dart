import 'package:betsquad/models/bet.dart';
import 'package:betsquad/services/database.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:betsquad/widgets/betsquad_logo_balance_appbar.dart';
import 'package:betsquad/widgets/match_header.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NGSInvitedPage extends StatefulWidget {
  static const ID = 'ngs_invited_page';
  final Bet bet;

  const NGSInvitedPage({this.bet});

  @override
  _NGSInvitedPageState createState() => _NGSInvitedPageState();
}

class _NGSInvitedPageState extends State<NGSInvitedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BetSquadLogoBalanceAppBar(),
      body: Container(
        color: Colors.black87,
        child: Column(
          children: [
            MatchHeader(match: widget.bet.match),
              Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var user = widget.bet.invited.values.toList()[index];
                    print(user);
                    return UserListItem(user: user, uid: widget.bet.invited.keys.toList()[index]);
                  },
                  itemCount: widget.bet.invited.values.toList().length,
                ),
              )
          ],
        ),
      ),
    );
  }
}

class UserListItem extends StatefulWidget {
  final user, uid;

  const UserListItem({Key key, this.user, this.uid}) : super(key: key);

  @override
  _UserListItemState createState() => _UserListItemState();
}

class _UserListItemState extends State<UserListItem> {
  String userProfilePicture;
  DatabaseService databaseService = DatabaseService();

  @override
  void initState() {
    fetchProfilePicture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: kBetSquadOrange,
        child: CircleAvatar(
          radius: 20,
          backgroundImage:
              userProfilePicture != null ? NetworkImage(userProfilePicture) : AssetImage('images/user_placeholder.png'),
        ),
      ),
      title: Text(
        widget.user['name'] ?? '',
        style: GoogleFonts.roboto(color: Colors.white),
      ),
      subtitle: widget.user['accepted'] == true ? Text('Accepted', style: GoogleFonts.roboto(color: Colors.white),) :
      Text('Pending', style: GoogleFonts.roboto(color: Colors.white)),
    );
  }

  void fetchProfilePicture() async {
    String img = await databaseService.getUserProfilePicture(widget.uid);
    setState(() {
      print(img);
      userProfilePicture = img;
    });
  }
}