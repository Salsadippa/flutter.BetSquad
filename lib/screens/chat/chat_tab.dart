import 'package:betsquad/api/chat_api.dart';
import 'package:betsquad/screens/bet/select_opponent_screen.dart';
import 'package:betsquad/screens/chat/chat_screen.dart';
import 'package:betsquad/screens/chat/new_chat_page.dart';
import 'package:betsquad/string_utils.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatTabScreen extends StatefulWidget {
  @override
  _ChatTabScreenState createState() => _ChatTabScreenState();
}

class _ChatTabScreenState extends State<ChatTabScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            var result = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NewChatScreen(),
              ),
            );
            if (result['type'] == 'user') {
              Map response = await ChatApi.openChat(talkingTo: result['user']['uid']);
              if (response['result'] == 'success') {
                var chatId = response['chatId'];
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      chatId: chatId,
                    ),
                  ),
                );
              }
            } else if (result['type'] == 'squad') {
              print(result['squadId']);
              Map response = await ChatApi.openSquadChat(squadId: result['squadId']);
              if (response['result'] == 'success') {
                var chatId = response['chatId'];
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      chatId: chatId,
                    ),
                  ),
                );
              }
            }
          },
          child: Container(
            decoration: kGradientBoxDecoration,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    color: kBetSquadOrange,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'New Chat',
                    style: GoogleFonts.roboto(color: kBetSquadOrange, fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: kGradientBoxDecoration,
            child: StreamBuilder<Event>(
              stream: FirebaseDatabase.instance
                  .reference()
                  .child('users')
                  .child(FirebaseAuth.instance.currentUser.uid)
                  .child('chats')
                  .orderByChild('deleted')
                  .equalTo(false)
                  .onValue,
              builder: (context, snapshot) {
                if (snapshot.hasError || !snapshot.hasData) {
                  return Container();
                }
                Map chatsSnapshot = snapshot.data.snapshot.value;
                List chats = [];

                if (chatsSnapshot == null || chatsSnapshot.isEmpty) {
                  return Center(
                    child: Text(
                      'No chats',
                      style: GoogleFonts.roboto(fontSize: 22, color: kBetSquadOrange),
                    ),
                  );
                }

                chatsSnapshot.forEach((key, value) {
                  value['id'] = key;
                  chats.add(value);
                });

                print(chats);

                return ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    var chat = chats[index];
                    print(chat);
                    bool unread = chat['unread'] == true;
                    print(unread);
                    return Container(
                      decoration: kGradientBoxDecoration,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  chatId: chat['id'],
                                ),
                              ),
                            );
                          },
                          leading: CircleAvatar(
                            backgroundColor: kBetSquadOrange,
                            radius: 24,
                            child: chat['type'] == 'bet'
                                ? CircleAvatar(
                                    radius: 22,
                                    backgroundImage: AssetImage('images/user_placeholder.png'),
                                  )
                                : FutureBuilder<DataSnapshot>(
                                    future: chat['type'] == 'personal'
                                        ? FirebaseDatabase.instance
                                            .reference()
                                            .child('users')
                                            .child(chat['talkingToId'])
                                            .child('image')
                                            .once()
                                        : FirebaseDatabase.instance
                                            .reference()
                                            .child('squads')
                                            .child(chat['squadId'])
                                            .child('image')
                                            .once(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) print(snapshot.error);
                                      if (snapshot.hasData) print(snapshot.data.value);
                                      return CircleAvatar(
                                        radius: 22,
                                        backgroundImage: !snapshot.hasData ||
                                                snapshot.hasError ||
                                                StringUtils.isNullOrEmpty(snapshot.data.value)
                                            ? AssetImage('images/user_placeholder'
                                                '.png')
                                            : NetworkImage(snapshot.data.value),
                                      );
                                    }),
                          ),
                          trailing: GestureDetector(
                            onTap: () async {
                              print("delete chat");
                              await ChatApi.deleteChat(chatId: chat['id'], chatType: chat['type']);
                              print("delete chat done");
                            },
                            child: Icon(
                              Icons.cancel_outlined,
                              color: Colors.red,
                              size: 17,
                            ),
                          ),
                          title: FutureBuilder<DataSnapshot>(
                              future: chat['type'] == 'personal'
                                  ? FirebaseDatabase.instance
                                      .reference()
                                      .child('users')
                                      .child(chat['talkingToId'])
                                      .child('username')
                                      .once()
                                  : chat['type'] == 'squad'
                                      ? FirebaseDatabase.instance
                                          .reference()
                                          .child('squads')
                                          .child(chat['squadId'])
                                          .child('name')
                                          .once()
                                      : FirebaseDatabase.instance
                                          .reference()
                                          .child('chats')
                                          .child(chat['id'])
                                          .child('title')
                                          .once(),
                              builder: (context, snapshot) {
                                print(snapshot.error);
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    if (unread)
                                      Container(
                                        margin: EdgeInsets.only(right: 10),
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(4),
                                          color: kBetSquadOrange,
                                        ),
                                      ),
                                    Flexible(
                                      child: Text(
                                        !snapshot.hasData ||
                                                snapshot.hasError ||
                                                StringUtils.isNullOrEmpty(snapshot.data.value)
                                            ? ''
                                            : chat['type'] == 'bet'
                                                ? 'NGS Bet: ${snapshot.data.value}'
                                                : snapshot.data.value,
                                        style: GoogleFonts.roboto(color: Colors.white, fontSize: 16),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
