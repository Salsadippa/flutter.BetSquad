import 'package:betsquad/api/users_api.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:betsquad/utilities/utility.dart';
import 'package:betsquad/widgets/betsquad_logo_balance_appbar.dart';
import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../alert.dart';

class FindFriendsPage extends StatefulWidget {
  static const ID = 'find_friends_page';

  @override
  _FindFriendsPageState createState() => _FindFriendsPageState();
}

class _FindFriendsPageState extends State<FindFriendsPage> {
  List users = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    print("hi");
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _loading,
      child: Scaffold(
        backgroundColor: Colors.black87,
        appBar: BetSquadLogoBalanceAppBar(),
        body: Container(
          color: Colors.black87,
          child: FloatingSearchBar.builder(
            itemCount: users.length,
            itemBuilder: (BuildContext context, int index) {
              var user = users[index];
              return Container(
                decoration: kGradientBoxDecoration,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 22,
                    backgroundColor: kBetSquadOrange,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: user['image'] != null
                          ? NetworkImage(user['image'])
                          : AssetImage('images/user_placeholder'
                              '.png'),
                    ),
                  ),
                  trailing: GestureDetector(
                    child: Icon(
                      Icons.add,
                      color: kBetSquadOrange,
                    ),
                    onTap: () async {
                      // add friend
                      setState(() {
                        _loading = true;
                      });
                      var result = await UsersApi.sendFriendRequest(user['uid']);
                      setState(() {
                        _loading = false;
                      });
                      if (result['result'] == 'success') {
                        Alert.showSuccessDialog(context, 'Friend Request Sent', result['message']);
                      } else {
                        Alert.showErrorDialog(context, 'Can\'t Send Request', result['message']);
                      }
                      print(result);
                    },
                  ),
                  title: Text(
                    (user['firstName'] ?? '') + ' ' + (user['lastName'] ?? ''),
                    style: GoogleFonts.roboto(color: Colors.white),
                  ),
                  subtitle: Text(
                    user['username'],
                    style: GoogleFonts.roboto(color: Colors.white),
                  ),
                ),
              );
            },
            onChanged: (String value) async {
              List res = await UsersApi.searchUsers(value);
              setState(() {
                users = res;
              });
            },
            decoration: InputDecoration.collapsed(
              hintText: "Search...",
              hintStyle: GoogleFonts.roboto(color: Colors.black
              )
            ),
          ),
        ),
      ),
    );
  }
}
