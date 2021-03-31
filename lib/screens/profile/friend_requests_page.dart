import 'package:betsquad/api/users_api.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:betsquad/widgets/betsquad_logo_balance_appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../alert.dart';

class FriendRequestsPage extends StatefulWidget {
  @override
  _FriendRequestsPageState createState() => _FriendRequestsPageState();
}

class _FriendRequestsPageState extends State<FriendRequestsPage> {
  var requests = [];
  bool _loading = false;

  fetchRequests() async {
    setState(() {
      _loading = true;
    });
    var result = await UsersApi.getFriendRequests();
    print(result);
    setState(() {
      requests = result;
      _loading = false;
    });
  }

  @override
  void initState() {
    print("hello");
    fetchRequests();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _loading,
      child: Scaffold(
        appBar: BetSquadLogoBalanceAppBar(),
        body: Container(
          decoration: kGradientBoxDecoration,
          child: ListView.builder(
            itemBuilder: (context, index) {
              var req = requests[index];
              print(req);
              return Container(
                decoration: kGradientBoxDecoration,
                child: ListTile(
                  title: Text(
                    req['username'],
                    style: GoogleFonts.roboto(color: Colors.white),
                  ),
                  subtitle: Text(
                    req['firstName'] + ' ' + req['lastName'],
                    style: GoogleFonts.roboto(color: Colors.white),
                  ),
                  leading: CircleAvatar(
                    radius: 22,
                    backgroundColor: kBetSquadOrange,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage:
                          req['image'] != null ? NetworkImage(req['image']) : AssetImage('images/user_placeholder.pngg'),
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        child: Icon(Icons.check, size: 30, color: Colors.green),
                        onTap: () async {
                          //accept request
                          print(req['uid']);
                          setState(() {
                            _loading = true;
                          });
                          var result = await UsersApi.acceptFriendRequest(req['uid']);
                          print(result);
                          setState(() {
                            _loading = false;
                          });
                          if (result['result'] == 'success') {
                            Alert.showSuccessDialog(context, 'Accepted', result['message']);
                          } else {
                            Alert.showErrorDialog(context, 'Couldn\'t Accecpt', result['message']);
                          }
                        },
                      ),
                      SizedBox(width: 30),
                      GestureDetector(
                        child: Icon(Icons.clear, size: 30, color: Colors.red),
                        onTap: () async {
                          //decline request
                          setState(() {
                            _loading = true;
                          });
                          var result = await UsersApi.declineFriendRequest(req['uid']);
                          print(result);
                          setState(() {
                            _loading = false;
                          });
                          if (result['result'] == 'success') {
                            Alert.showSuccessDialog(context, 'Declined', result['message']);
                          } else {
                            Alert.showErrorDialog(context, 'Couldn\'t Decline', result['message']);
                          }
                        },
                      )
                    ],
                  ),
                ),
              );
            },
            itemCount: requests.length,
          ),
        ),
      ),
    );
  }
}
