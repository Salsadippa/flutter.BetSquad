import 'package:betsquad/screens/payments/deposit_page.dart';
import 'package:betsquad/screens/payments/transactions_page.dart';
import 'package:betsquad/screens/payments/withdrawal_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BetSquadLogoBalanceAppBar extends StatefulWidget implements PreferredSizeWidget {
  final IconButton leading;

  const BetSquadLogoBalanceAppBar({Key key, this.leading}) : super(key: key);

  @override
  _BetSquadLogoBalanceAppBarState createState() => _BetSquadLogoBalanceAppBarState();

  @override
  Size get preferredSize => new Size.fromHeight(AppBar().preferredSize.height);
}

class _BetSquadLogoBalanceAppBarState extends State<BetSquadLogoBalanceAppBar> {
  String userProfilePic;

  getUserInfo() async {
    User user = FirebaseAuth.instance.currentUser;
    print(user.uid);
    final dbRef = await FirebaseDatabase.instance.reference().child("users/${user.uid}").once();
    setState(() {
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
            children: [
              ListTile(
                title: Text('Transactions', textAlign: TextAlign.center),
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
      leading: widget.leading,
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
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [betSquadLogo],
      ),
    );
  }
}
