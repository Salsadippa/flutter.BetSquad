import 'package:betsquad/api/users_api.dart';
import 'package:betsquad/screens/profile/create_squad_page.dart';
import 'package:betsquad/screens/profile/edit_squad_page.dart';
import 'package:betsquad/screens/profile/friend_requests_page.dart';
import 'package:betsquad/screens/profile/search_friends.dart';
import 'package:betsquad/services/firebase_services.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:betsquad/widgets/squads_list_tile.dart';
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
    var currentUser = FirebaseAuth.instance.currentUser;
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
    FirebaseServices().uploadProfilePhotoForExistingUser(image);
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
                  child: StreamBuilder<Event>(
                      stream: FirebaseDatabase.instance
                          .reference()
                          .child('users')
                          .child(FirebaseAuth.instance.currentUser.uid)
                          .child('image')
                          .onValue,
                      builder: (context, snapshot) {
                        if (snapshot.hasError || !snapshot.hasData || snapshot.data.snapshot.value == '') {
                          return CircleAvatar(
                            backgroundImage: kUserPlaceholderImage,
                            radius: 50,
                          );
                        }
                        var image = snapshot.data.snapshot.value;
                        return CircleAvatar(
                          radius: 53,
                          backgroundColor: kBetSquadOrange,
                          child: CircleAvatar(
                            backgroundImage: image != null ? NetworkImage(image) : kUserPlaceholderImage,
                            radius: 50,
                          ),
                        );
                      }),
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
                          if (!snapshot.hasData || snapshot.hasError || snapshot.data.snapshot.value == null) {
                            return Container(
                              height: 20,
                            );
                          }
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
                                  if (friend == null) {
                                    return Container();
                                  }
                                  return Container(
                                    decoration: kGradientBoxDecoration,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                                      leading: CircleAvatar(
                                        radius: 22,
                                        backgroundColor: kBetSquadOrange,
                                        child: CircleAvatar(
                                            radius: 20,
                                            backgroundImage:
                                                friend['image'] == null || friend['image'].toString().trim().isEmpty
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
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          StreamBuilder<Event>(
                              stream: FirebaseDatabase.instance
                                  .reference()
                                  .child('friendRequests')
                                  .child(FirebaseAuth.instance.currentUser.uid)
                                  .onValue,
                              builder: (context, snapshot) {
                                if (snapshot.hasError || !snapshot.hasData || snapshot.data.snapshot.value == null)
                                  return Container(width: 0, height: 0);
                                Map res = snapshot.data.snapshot.value;
                                return Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      res.length.toString(),
                                      style: GoogleFonts.roboto(color: Colors.white),
                                    ),
                                  ),
                                );
                              }),
                          SizedBox(width: 20),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                            size: 20,
                          ),
                        ],
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
