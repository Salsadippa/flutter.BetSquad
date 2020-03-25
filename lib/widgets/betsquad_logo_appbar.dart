import 'package:flutter/material.dart';

class BetSquadLogoAppBar extends StatelessWidget implements PreferredSizeWidget {

  @override
  Widget build(BuildContext context) {

    var betSquadLogo =  Image.asset(
      'images/app_bar_logo.png',
      fit: BoxFit.contain,
      height: 32,
    );

    return AppBar(
        centerTitle: true, // this is all you need
        title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           betSquadLogo
          ],
        ));
  }

  @override
  Size get preferredSize => new Size.fromHeight(AppBar().preferredSize.height);
}

