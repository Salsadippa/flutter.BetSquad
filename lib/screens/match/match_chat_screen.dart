import 'package:betsquad/screens/chat/chat_screen.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:betsquad/models/match.dart';

class MatchChatScreen extends StatefulWidget {

  final Match match;

  const MatchChatScreen(this.match);

  @override
  _MatchChatScreenState createState() => _MatchChatScreenState();
}

class _MatchChatScreenState extends State<MatchChatScreen> {
  final messageTextController = TextEditingController();
  String messageText;

  @override
  Widget build(BuildContext context) {
    print(widget.match.id.toString());
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        MessagesStream(
          chatId: widget.match.id.toString(),
        ),
        Container(
          decoration: kGradientBoxDecoration,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 50),
                  child: TextField(
                    style: GoogleFonts.roboto(color: Colors.white),
                    controller: messageTextController,
                    onChanged: (value) {
                      messageText = value;
                    },
                    // decoration: kMessageTextFieldDecoration,
                  ),
                ),
              ),
              FlatButton(
                  onPressed: () {
                    FirebaseDatabase.instance.reference().child('messages').child(widget.match.id.toString()).push().set({
                      'message': messageText,
                      'senderId': FirebaseAuth.instance.currentUser.uid,
                      'timestamp': DateTime.now().millisecondsSinceEpoch
                    });
                    messageTextController.clear();
                  },
                  child: Icon(
                    Icons.send,
                    color: kBetSquadOrange,
                    size: 30,
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
