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
import 'package:share/share.dart';

class BetSquadLogoProfileBalanceAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  _BetSquadLogoProfileBalanceAppBarState createState() => _BetSquadLogoProfileBalanceAppBarState();

  @override
  Size get preferredSize => new Size.fromHeight(AppBar().preferredSize.height);
}

class _BetSquadLogoProfileBalanceAppBarState extends State<BetSquadLogoProfileBalanceAppBar> {

  @override
  void initState() {
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
      child: StreamBuilder<Event>(
        stream: FirebaseDatabase.instance
            .reference()
            .child('users/' + FirebaseAuth.instance.currentUser.uid + '/balance')
            .onValue,
        builder: (context, snapshot) {
          if (snapshot.hasError || !snapshot.hasData) {
            return Text('');
          }
          return Text(
            '£${snapshot.data.snapshot.value.toStringAsFixed(2)}',
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(fontSize: 16),
          );
        },
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
              IconButton(icon: Icon(Icons.share_rounded), onPressed:(){
                Share.share('I\'m on Bet Squad and I need some friends to bet against! My username is ,username.\n\nDownload for Apple https://apps.apple.com/gb/app/betsquad/id1542057706 \n\nDownload for Android https://play.google.com/store/apps/details?id=com.betsquad.betsquad&pcampaignid=pcampaignidMKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1');
              }),
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
                child: StreamBuilder<Event>(
                  stream: FirebaseDatabase.instance.reference().child('users').child(FirebaseAuth.instance
                      .currentUser.uid).child('image').onValue,
                  builder: (context, snapshot) {
                    if (snapshot.hasError || !snapshot.hasData || snapshot.data.snapshot.value == ''){
                      return CircleAvatar(backgroundImage: kUserPlaceholderImage, radius: 50,);
                    }
                    var image = snapshot.data.snapshot.value;
                    return CircleAvatar(
                      backgroundImage: image != null ? NetworkImage(image) : kUserPlaceholderImage,
                      radius: 20,
                    );
                  }
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
