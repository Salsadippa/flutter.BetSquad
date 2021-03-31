import 'package:betsquad/utilities/hex_color.dart';
import 'package:flutter/material.dart';

const kEmailTextFieldInputDecoration = InputDecoration(
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(Radius.circular(5)),
    ),
    filled: true,
    fillColor: Colors.white,
    prefixIcon: Icon(
      Icons.mail_outline,
      color: Colors.grey,
    ),
    hintText: 'Email address',
    hintStyle: TextStyle(color: Colors.grey));

const kUsernameTextFieldInputDecoration = InputDecoration(
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(Radius.circular(5)),
    ),
    filled: true,
    fillColor: Colors.white,
    prefixIcon: Icon(
      Icons.supervised_user_circle,
      color: Colors.grey,
    ),
    hintText: 'Username',
    hintStyle: TextStyle(color: Colors.grey));

const kPasswordTextFieldInputDecoration = InputDecoration(
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(Radius.circular(5)),
    ),
    filled: true,
    fillColor: Colors.white,
    prefixIcon: Icon(
      Icons.lock_outline,
      color: Colors.grey,
    ),
    hintText: 'Password',
    hintStyle: TextStyle(color: Colors.grey));

const kTextFieldInputDecoration = InputDecoration(
    isDense: true,
    contentPadding: EdgeInsets.all(10.0),
    //here your padding
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(Radius.circular(5)),
    ),
    filled: true,
    fillColor: Colors.grey,
    hintStyle: TextStyle(color: Colors.grey, fontSize: 13));

const kPitchBackgroundDecoration = BoxDecoration(
  image: DecorationImage(
    image: AssetImage('images/login_bg.jpg'),
    fit: BoxFit.fill,
  ),
);

const kAssignmentsHomePitchBackgroundDecoration = BoxDecoration(
  image: DecorationImage(
    image: AssetImage('images/allocationbg1.jpg'),
    fit: BoxFit.fill,
  ),
);

const kAssignmentsAwayPitchBackgroundDecoration = BoxDecoration(
  image: DecorationImage(
    image: AssetImage('images/allocationbg2.jpg'),
    fit: BoxFit.fill,
  ),
);

const kBetSquadOrange = Color.fromRGBO(236, 99, 4, 1.0);

const kVersionNumberTextStyle = TextStyle(
  color: kBetSquadOrange,
  fontSize: 16,
);

const kInstructionTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 16,
);

const kBetSquadLogoImage = AssetImage('images/betsquad_login_page_logo.png');

const kUserPlaceholderImage = AssetImage('images/user_placeholder.png');

var kGradientBoxDecoration = BoxDecoration(
  gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [HexColor('#2f2f2f'),HexColor('#191919')]),
);

const kGamblingCommissionLogoImage =
    AssetImage('images/gambling_commission_logo.png');

const kGrassTrimBoxDecoration = BoxDecoration(
  image: DecorationImage(
    image: AssetImage("images/grass_trim.jpg"),
    fit: BoxFit.fill,
  ),
);
