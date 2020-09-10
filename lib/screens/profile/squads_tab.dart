import 'package:betsquad/screens/profile/friend_requests_page.dart';
import 'package:betsquad/screens/profile/search_friends.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SquadsTab extends StatefulWidget {
  @override
  _SquadsTabState createState() => _SquadsTabState();
}

class _SquadsTabState extends State<SquadsTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 100),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 40),
              child: Center(
                child: CircleAvatar(
                  radius: 54,
                  backgroundColor: kBetSquadOrange,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('images/user_placeholder.png'),
                  ),
                ),
              ),
            ),
            ListView(
              primary: false,
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'SQUADS',
                    style: GoogleFonts.roboto(color: Colors.grey, fontSize: 15),
                  ),
                ),
                Container(
                  decoration: kGradientBoxDecoration,
                  child: ListTile(
                    leading: Icon(Icons.add, color: Colors.white, size: 35),
                    title: Text('Create a new squad', style: GoogleFonts.roboto(color: Colors.white)),
                    subtitle:
                        Text('Squads allow you to send group bets', style: GoogleFonts.roboto(color: Colors.white)),
                  ),
                ),
                Container(
                  decoration: kGradientBoxDecoration,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 22,
                      backgroundColor: kBetSquadOrange,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage('images/user_placeholder.png'),
                      ),
                    ),
                    trailing: Icon(Icons.edit, color: kBetSquadOrange),
                    title: Text('My Squad 1', style: GoogleFonts.roboto(color: Colors.white)),
                    subtitle: Text('adedayo12, The UnderFlapper...', style: GoogleFonts.roboto(color: Colors.white)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'FRIENDS',
                    style: GoogleFonts.roboto(color: Colors.grey, fontSize: 15),
                  ),
                ),
                Container(
                  decoration: kGradientBoxDecoration,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 22,
                      backgroundColor: kBetSquadOrange,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage('images/user_placeholder.png'),
                      ),
                    ),
                    title: Text('My Squad 1', style: GoogleFonts.roboto(color: Colors.white)),
                    subtitle: Text('adedayo12, The UnderFlapper...', style: GoogleFonts.roboto(color: Colors.white)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'ADD FRIENDS',
                    style: GoogleFonts.roboto(color: Colors.grey, fontSize: 15),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FindFriendsPage(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: kGradientBoxDecoration,
                    child: ListTile(
                      leading: Icon(Icons.search, color: kBetSquadOrange, size: 30),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 20,
                      ),
                      title: Text('Find Friends', style: GoogleFonts.roboto(color: Colors.white)),
                      subtitle: Text('Search for and add other users ', style: GoogleFonts.roboto(color: Colors.white)),
                    ),
                  ),
                ),
                Container(
                  decoration: kGradientBoxDecoration,
                  child: ListTile(
                    leading: Icon(Icons.add, color: kBetSquadOrange, size: 34),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 20,
                    ),
                    title: Text('Invite Friends', style: GoogleFonts.roboto(color: Colors.white)),
                    subtitle: Text('Search for and add other users ', style: GoogleFonts.roboto(color: Colors.white)),
                  ),
                ),
                Container(
                  decoration: kGradientBoxDecoration,
                  child: ListTile(
                    leading: Icon(Icons.search, color: kBetSquadOrange, size: 30),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 20,
                    ),
                    title: Text('Connect Facebook Account', style: GoogleFonts.roboto(color: Colors.white)),
                    subtitle: Text('Search for and add other users ', style: GoogleFonts.roboto(color: Colors.white)),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FriendRequestsPage(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: kGradientBoxDecoration,
                    child: ListTile(
                      leading: Icon(Icons.people, color: kBetSquadOrange, size: 30),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 20,
                      ),
                      title: Text('Friend Requests', style: GoogleFonts.roboto(color: Colors.white)),
                      subtitle: Text('Search for and add other users ', style: GoogleFonts.roboto(color: Colors.white)),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
