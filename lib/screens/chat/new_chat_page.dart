import 'package:betsquad/styles/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:betsquad/api/users_api.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class NewChatScreen extends StatefulWidget {
  final bool multipleSelection = false;

  static const String ID = 'select_opponent_screen';

  @override
  _NewChatScreenState createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {
  List<ListItem<Map<String, dynamic>>> allUsers = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      _loading = true;
    });
    Map users = await UsersApi.getAllUsers();
    var opponents = users.values.toList();
    opponents.sort((a, b) => a['username'].toString().toLowerCase().compareTo(b['username'].toString().toLowerCase()));
    setState(() {
      allUsers = List.generate(opponents.length, (index) {
        ListItem<Map<String, dynamic>> item = ListItem(opponents[index]);
        return item;
      });
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        child: Container(
          decoration: kGradientBoxDecoration,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Text(
                        'SQUADS',
                        style: GoogleFonts.roboto(color: Colors.grey, fontSize: 15,)
                      ),
                    ],
                  ),
                ),
                StreamBuilder<Event>(
                    stream: FirebaseDatabase().reference().child('users').child(FirebaseAuth.instance.currentUser.uid).child
                      ('squads').onValue,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && !snapshot.hasError) {
                        Map squadsList = snapshot.data.snapshot.value;
                        return ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            Map squad = squadsList != null ? squadsList.values.toList()[index] : {};
                            String squadId = squadsList.keys.toList()[index];
                            return ListTile(
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
                              title: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                child: Text(squad['title'], style: GoogleFonts.roboto(color: Colors.white)),
                              ),
                              onTap: () {
                                Navigator.pop(context, {
                                  'type':'squad',
                                  'squadId': squadId
                                });
                              },
                            );
                          },
                          itemCount: squadsList != null ? squadsList.values.toList().length : 0,
                        );
                      } else {
                        return Container();
                      }
                    }),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Text(
                          'FRIENDS',
                          style: GoogleFonts.roboto(color: Colors.grey, fontSize: 15,)
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: allUsers.length,
                  itemBuilder: (context, index) {
                    var user = allUsers[index].data;
                    print(user['image']);
                    return ListTile(
                      key: ObjectKey(user),
                      title: Text(
                        user['username'] ?? '',
                        style: TextStyle(color: Colors.white),
                      ),
                      leading: CircleAvatar(
                        backgroundColor: kBetSquadOrange,
                        radius: 22,
                        child: CircleAvatar(
                          backgroundImage: user['image'] != null && user['image'] != ''
                              ? NetworkImage(user['image'])
                              : kUserPlaceholderImage,
                          radius: 20,
                        ),
                      ),
                      trailing: allUsers[index].isSelected
                          ? Icon(
                              Icons.check,
                              color: kBetSquadOrange,
                            )
                          : null,
                      onTap: () {
                        Navigator.pop(context, {
                          'type':'user',
                          'user': user
                        });
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ListItem<T> {
  bool isSelected = false; //Selection property to highlight or not
  T data; //Data of the user
  ListItem(this.data); //Constructor to assign the data
}