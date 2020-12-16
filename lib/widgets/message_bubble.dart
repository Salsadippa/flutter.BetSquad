import 'package:betsquad/styles/constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text, this.isMe, this.timestamp});

  final String sender;
  final String text;
  final bool isMe;
  final int timestamp;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          isMe
              ? Text(
            'Me',
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.white,
            ),
          )
              : FutureBuilder<DataSnapshot>(
              future: FirebaseDatabase.instance.reference().child('users').child(sender).child('username').once(),
              builder: (context, snapshot) {
                print(sender);
                if (!snapshot.hasData || snapshot.hasError) {
                  return Text('');
                }
                return Text(
                  snapshot.data.value,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.white,
                  ),
                );
              }),
          SizedBox(height: 5),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                topLeft: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0))
                : BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            elevation: 5.0,
            color: isMe ? Colors.lightBlueAccent : kBetSquadOrange,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.black : Colors.white,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
