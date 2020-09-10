import 'package:betsquad/styles/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatTabScreen extends StatefulWidget {
  @override
  _ChatTabScreenState createState() => _ChatTabScreenState();
}

class _ChatTabScreenState extends State<ChatTabScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kGradientBoxDecoration,
      child: Center(
          child: Text(
        'Coming Soon',
        style: GoogleFonts.roboto(color: kBetSquadOrange,fontSize: 25),
      )),
    );
  }
}
