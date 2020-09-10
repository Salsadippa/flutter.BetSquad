import 'package:betsquad/api/users_api.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:betsquad/widgets/betsquad_logo_balance_appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../alert.dart';

class FriendRequestsPage extends StatefulWidget {
  @override
  _FriendRequestsPageState createState() => _FriendRequestsPageState();
}

class _FriendRequestsPageState extends State<FriendRequestsPage> {
  var requests = [];

  fetchRequests() async {
    var result = await UsersApi.getFriendRequests();
    setState(() {
      requests = result;
    });
  }

  @override
  void initState() {
    fetchRequests();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        var result = await UsersApi.acceptFriendRequest(req['uid']);
                        print(result);
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
                      onTap: () {
                        //decline request
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
    );
  }
}
