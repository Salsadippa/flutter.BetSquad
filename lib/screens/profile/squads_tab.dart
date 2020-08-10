import 'package:flutter/material.dart';

class SquadsTab extends StatefulWidget {
  @override
  _SquadsTabState createState() => _SquadsTabState();
}

class _SquadsTabState extends State<SquadsTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 40),
            child: Center(
              child: CircleAvatar(
                radius: 54,
                backgroundColor: Colors.orange,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('images/user_placeholder.png'),
                ),
              ),
            ),
          ),
        ],
      ),

    );
  }
}
