import 'package:betsquad/screens/payments/deposit_page.dart';
import 'package:betsquad/screens/payments/transactions_page.dart';
import 'package:betsquad/screens/payments/withdrawal_page.dart';
import 'package:betsquad/screens/profile/account_info_page.dart';
import 'package:betsquad/services/firebase_services.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      userBalance = double.parse(dbRef.value['balance'].toString());
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
        style: GoogleFonts.roboto(fontSize: 16),
      ),
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                title: Text(
                  'Transactions',
                  textAlign: TextAlign.center,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => TransactionsPage(),
                  ));
                },
              ),
              ListTile(
                title: Text('Deposit Funds', textAlign: TextAlign.center),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DepositPage(),
                  ));
                },
              ),
              ListTile(
                title: Text('Withdraw Funds', textAlign: TextAlign.center),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => WithdrawalPage(),
                  ));
                },
              ),
            ],
          ),
        );
      },
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
                // FirebaseServices fbHelper = FirebaseServices();
                // fbHelper.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccountInfoPage(),
                  ),
                );
              },
              child: CircleAvatar(
                radius: 22,
                backgroundColor: kBetSquadOrange,
                child: CircleAvatar(
                  backgroundImage: userProfilePic != null ? NetworkImage(userProfilePic) : kUserPlaceholderImage,
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
