import 'package:betsquad/api/users_api.dart';
import 'package:betsquad/screens/profile/create_squad_page.dart';
import 'package:betsquad/screens/profile/edit_squad_page.dart';
import 'package:betsquad/screens/profile/friend_requests_page.dart';
import 'package:betsquad/screens/profile/search_friends.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class SquadsTab extends StatefulWidget {
  @override
  _SquadsTabState createState() => _SquadsTabState();
}

class _SquadsTabState extends State<SquadsTab> {
  Query squads;
  Query friends;

  void createStreams() async {
    var currentUser = await FirebaseAuth.instance.currentUser();
    setState(() {
      squads = FirebaseDatabase().reference().child('users').child(currentUser.uid).child('squads');
      friends = FirebaseDatabase().reference().child('users').child(currentUser.uid).child('friends');
    });
  }

  @override
  void initState() {
    createStreams();
    super.initState();
  }

  fetchFriends(List friendIds) async {
    return await UsersApi.getFriends(friendIds);
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

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
                child: GestureDetector(
                  onTap: getImage,
                  child: CircleAvatar(
                    radius: 53,
                    backgroundColor: kBetSquadOrange,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('images/user_placeholder.png'),
                    ),
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
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateSquadPage()));
                  },
                  child: Container(
                    decoration: kGradientBoxDecoration,
                    child: ListTile(
                      leading: Icon(Icons.add, color: Colors.white, size: 35),
                      title: Text('Create a new squad', style: GoogleFonts.roboto(color: Colors.white)),
                      subtitle:
                          Text('Squads allow you to send group bets', style: GoogleFonts.roboto(color: Colors.white)),
                    ),
                  ),
                ),
                squads != null
                    ? StreamBuilder<Event>(
                        stream: squads.onValue,
                        builder: (context, snapshot) {
                          if (snapshot.hasData && !snapshot.hasError) {
                            Map squadsList = snapshot.data.snapshot.value;
                            return ListView.builder(
                              primary: false,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                Map squad = squadsList != null ? squadsList.values.toList()[index] : {};
                                String squadId = squadsList.keys.toList()[index];
                                return SquadListTile(squad: squad, id: squadId);
                              },
                              itemCount: squadsList != null ? squadsList.values.toList().length : 0,
                            );
                          } else {
                            return Container();
                          }
                        })
                    : Container(),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'FRIENDS',
                    style: GoogleFonts.roboto(color: Colors.grey, fontSize: 15),
                  ),
                ),
                friends != null
                    ? StreamBuilder<Event>(
                        stream: friends.onValue,
                        builder: (context, snapshot) {
                          if (snapshot.hasData && !snapshot.hasError) {
                            Map friendsList = snapshot.data.snapshot.value;
                            List friendIds = friendsList.keys.toList();
                            return FutureBuilder(
                              future: fetchFriends(friendIds),
                              builder: (context, friendsSnapshot) {
                                if (!friendsSnapshot.hasData) {
                                  print("no data");
                                  return Container();
                                }
                                return ListView.builder(
                                  shrinkWrap: true,
                                  primary: false,
                                  itemCount: friendsSnapshot.data.length,
                                  itemBuilder: (context, index) {
                                    var friend = friendsSnapshot.data[index];
                                    if (friend == null) {return Container();}
                                    return Container(
                                      decoration: kGradientBoxDecoration,
                                      child: ListTile(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                                        leading: CircleAvatar(
                                          radius: 22,
                                          backgroundColor: kBetSquadOrange,
                                          child: CircleAvatar(
                                              radius: 20,
                                              backgroundImage: friend['image'] == null || friend['image'].toString().trim()
                                                  .isEmpty
                                                  ? AssetImage('images/user_placeholder'
                                                  '.png')
                                                  : NetworkImage(friend['image'])),
                                        ),
                                        title: Text(
                                          friend['username'],
                                          style: GoogleFonts.roboto(color: Colors.white),
                                        ),
                                        subtitle: Text((friend['firstName'] ?? '') + ' ' + (friend['lastName'] ?? ''),
                                            style: GoogleFonts.roboto(color: Colors.white)),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          } else {
                            return Container();
                          }
                        })
                    : Container(),
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

class SquadListTile extends StatelessWidget {
  final Map squad;
  final String id;

  const SquadListTile({
    Key key,
    this.squad,
    this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kGradientBoxDecoration,
      child: ListTile(
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: kBetSquadOrange,
          child: CircleAvatar(
            radius: 20,
            backgroundImage: squad['image'] != null && squad['image'].toString().isNotEmpty
                ? NetworkImage(squad['image'])
                : AssetImage('images/ball.png'),
          ),
        ),
        trailing: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditSquadPage(squadId: id),
                ),
              );
            },
            child: Icon(Icons.edit, color: kBetSquadOrange)),
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(squad['title'], style: GoogleFonts.roboto(color: Colors.white)),
        ),
      ),
    );
  }
}
