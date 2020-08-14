import 'package:betsquad/services/firebase_services.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class BetSquadLogoProfileBalanceAppBar extends StatefulWidget implements PreferredSizeWidget {

  @override
  _BetSquadLogoProfileBalanceAppBarState createState() => _BetSquadLogoProfileBalanceAppBarState();

  @override
  Size get preferredSize => new Size.fromHeight(AppBar().preferredSize.height);
}

class _BetSquadLogoProfileBalanceAppBarState extends State<BetSquadLogoProfileBalanceAppBar> {
  double userBalance;
  String userProfilePic;

  getUserInfo() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    print(user.uid);
    final dbRef = await FirebaseDatabase.instance.reference().child("users/${user.uid}").once();
    setState(() {
      userBalance = dbRef.value['balance'];
      userProfilePic = dbRef.value['image'];
    });
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var betSquadLogo = Image.asset(
      'images/app_bar_logo.png',
      fit: BoxFit.contain,
      height: 32,
    );

    var balanceButton = GestureDetector(
      child: Text(
        '£${userBalance != null ? userBalance.toStringAsFixed(2) : 0.toStringAsFixed(2)}',
        textAlign: TextAlign.center,
      ),
      onTap: () {},
    );

    return AppBar(
        elevation: 0,
        actions: <Widget>[
          Row(
            children: <Widget>[
              balanceButton,
              SizedBox(
                width: 10,
              )
            ],
          )
        ],
        leading: Row(
          children: <Widget>[
            SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                FirebaseServices fbHelper = FirebaseServices();
                fbHelper.signOut();
                Navigator.pushReplacementNamed(context, 'login_screen');
              },
              child: CircleAvatar(
                radius: 22,
                backgroundColor: Colors.orange,
                child: CircleAvatar(
                  backgroundImage: userProfilePic != null ? NetworkImage(userProfilePic): kUserPlaceholderImage,
                  radius: 20,
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [betSquadLogo],
        ));
  }
}
