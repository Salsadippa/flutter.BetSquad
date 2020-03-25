import 'package:flutter/material.dart';

class BetSquadLogoBalanceAppBar extends StatelessWidget
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
        actions: <Widget>[
          Row(children: <Widget>[
            Text('£0.00', style: TextStyle(fontSize: 16),),
            SizedBox(width: 10,)
          ],)
        ],
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
