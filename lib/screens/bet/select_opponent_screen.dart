import 'package:betsquad/styles/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:betsquad/api/users_api.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:convert';

import '../../string_utils.dart';

class SelectOpponentScreen extends StatefulWidget {
  final Map alreadyInvitedUsers;
  final List alreadySelectedUsers, alreadySelectedSquads;
  final bool multipleSelection;

  static const String ID = 'select_opponent_screen';

  SelectOpponentScreen(
      {this.alreadyInvitedUsers = const {}, this.multipleSelection = false, this.alreadySelectedUsers = const [
      ], this.alreadySelectedSquads = const []});

  @override
  _SelectOpponentScreenState createState() => _SelectOpponentScreenState();
}

class _SelectOpponentScreenState extends State<SelectOpponentScreen> {
  List<ListItem<Map<String, dynamic>>> allUsers = [];
  var selectedUsers = [];
  var selectedSquads = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      _loading = true;
      selectedSquads = widget.alreadySelectedSquads;
    });
    Map users = await UsersApi.getOpponents();
    var opponents = users.values.toList();
    opponents.sort((a, b) => a['username'].toString().toLowerCase().compareTo(b['username'].toString().toLowerCase()));
    opponents.removeWhere((element) => widget.alreadyInvitedUsers.keys.contains(element['uid']));
    setState(() {
      allUsers = List.generate(opponents.length, (index) {
        ListItem<Map<String, dynamic>> item = ListItem(opponents[index]);
        bool selected = (widget.alreadySelectedUsers.contains(opponents[index]['uid']));
        if (selected) {
          selectedUsers.add(opponents[index]);
        }
        item.isSelected = selected;
        return item;
      });
      allUsers.removeWhere((element) => !element.data.containsKey('username'));
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          widget.multipleSelection != null && widget.multipleSelection
              ? Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context, {'selectedUsers': selectedUsers, 'selectedSquads': selectedSquads});
              },
              child: Center(
                  child: Text(
                    'Done',
                    style: TextStyle(fontSize: 15),
                  )),
            ),
          )
              : Text('')
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        child: Container(
          color: Colors.black87,
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (widget.multipleSelection)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Text(
                          'SQUADS',
                          style: GoogleFonts.roboto(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (widget.multipleSelection)
                  StreamBuilder<Event>(
                      stream: FirebaseDatabase()
                          .reference()
                          .child('users')
                          .child(FirebaseAuth.instance.currentUser.uid)
                          .child('squads')
                          .onValue,
                      builder: (context, snapshot) {
                        if (snapshot.hasData && !snapshot.hasError && snapshot.data.snapshot.value != null) {
                          Map squadsList = snapshot.data.snapshot.value;

                          List squads = squadsList.values.toList();
                          List squadKeys = squadsList.keys.toList();

                          return ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            itemBuilder: (context, index) {
                              Map squad = squads[index];
                              String squadId = squadKeys[index];
                              // Map squad = squadsList != null ? squadsList.values.toList()[index] : {};
                              // String squadId = squadsList.keys.toList()[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  radius: 22,
                                  backgroundColor: kBetSquadOrange,
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundImage: squad['image'] != null && squad['image']
                                        .toString()
                                        .isNotEmpty
                                        ? NetworkImage(squad['image'])
                                        : AssetImage('images/ball.png'),
                                  ),
                                ),
                                title: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                  child: Text(squad['title'], style: GoogleFonts.roboto(color: Colors.white)),
                                ),
                                trailing: selectedSquads.contains(squadId)
                                    ? Icon(
                                  Icons.check,
                                  color: kBetSquadOrange,
                                )
                                    : null,
                                onTap: () {
                                  print(squadId);
                                  if (widget.multipleSelection) {
                                    setState(() {
                                      if (selectedSquads.contains(squadId)) {
                                        selectedSquads.remove(squadId);
                                      } else {
                                        selectedSquads.add(squadId);
                                      }
                                    });
                                  }
                                },
                              );
                            },
                            itemCount: squadsList != null ? squadsList.values
                                .toList()
                                .length : 0,
                          );
                        } else {
                          return Container();
                        }
                      }),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Text('FRIENDS',
                          style: GoogleFonts.roboto(
                            color: Colors.grey,
                            fontSize: 15,
                          )),
                    ],
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: allUsers.length,
                  itemBuilder: (context, index) {
                    var user = allUsers[index].data;
                    return ListTile(
                      key: ObjectKey(user),
                      title: Text(
                        user['username'] ?? '',
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: allUsers[index].isSelected
                          ? Icon(
                        Icons.check,
                        color: kBetSquadOrange,
                      )
                          : null,
                      onTap: () {
                        if (widget.multipleSelection) {
                          setState(() {
                            if (allUsers[index].isSelected) {
                              selectedUsers.remove(user);
                            } else {
                              selectedUsers.add(user);
                            }
                            allUsers[index].isSelected = !allUsers[index].isSelected;
                          });
                        } else {
                          Navigator.pop(context, user);
                        }
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