import 'package:betsquad/services/firebase_services.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:flutter/material.dart';

class BetSquadLogoProfileBalanceAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    var betSquadLogo = Image.asset(
      'images/app_bar_logo.png',
      fit: BoxFit.contain,
      height: 32,
    );

    var balanceButton = GestureDetector(
      child: Text('£0.00', textAlign: TextAlign.center,),
      onTap: (){

      },
    );

    return AppBar(
      elevation: 0,
      actions: <Widget>[
        Row(children: <Widget>[
          Text('£0.00', style: TextStyle(fontSize: 16),),
          SizedBox(width: 10,)
        ],)
      ],
       leading:
       Row(
         children: <Widget>[
           SizedBox(width: 10),
           GestureDetector(
             onTap: (){
               FirebaseServices fbHelper = FirebaseServices();
               fbHelper.signOut();
               Navigator.pushReplacementNamed(context, 'login_screen');
             },
             child: CircleAvatar(
                 radius: 22,
                 backgroundColor: Colors.orange,
                 child: CircleAvatar(
                   backgroundImage: kUserPlaceholderImage,
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

  @override
  Size get preferredSize => new Size.fromHeight(AppBar().preferredSize.height);
}
