import 'package:betsquad/api/chat_api.dart';
import 'package:betsquad/screens/bet/select_opponent_screen.dart';
import 'package:betsquad/screens/chat/chat_screen.dart';
import 'package:betsquad/screens/chat/new_chat_page.dart';
import 'package:betsquad/string_utils.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:betsquad/utilities/utility.dart';
import 'package:betsquad/widgets/swipeable_tabs.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatTabScreen extends StatefulWidget {
  @override
  _ChatTabScreenState createState() => _ChatTabScreenState();
}

class _ChatTabScreenState extends State<ChatTabScreen> {
  List<String> tabs = ['Private', 'Group'];
  int initPosition = 0;
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    buildChatList({bool showOnlyPersonalChats}) => Container(
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
                style: GoogleFonts.roboto(
                    fontSize: 22, color: kBetSquadOrange),
              ),
            );
          }

          chatsSnapshot.forEach((key, value) {
            value['id'] = key;
            if (showOnlyPersonalChats) {
              if (value['type'] == 'personal') {
                chats.add(value);
              }
            } else {
              if (value['type'] != 'personal') {
                chats.add(value);
              }
            }
          });

          return ListView.builder(
            itemCount: chats.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return GestureDetector(
                  onTap: () async {
                    var result = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => NewChatScreen(),
                      ),
                    );
                    if (result['type'] == 'user') {
                      Map response = await ChatApi.openChat(
                          talkingTo: result['user']['uid']);
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
                      Map response = await ChatApi.openSquadChat(
                          squadId: result['squadId']);
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
                      padding: const EdgeInsets.symmetric(vertical: 20),
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
                            style: GoogleFonts.roboto(
                                color: kBetSquadOrange, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              var chat = chats[index - 1];
              bool unread = chat['unread'] == true;

              return SwipeActionCell(
                backgroundColor: Colors.white,
                key: ObjectKey(chat),
                performsFirstActionWithFullSwipe: true,
                trailingActions: <SwipeAction>[
                  SwipeAction(
                      icon: Icon(
                        Icons.delete_outlined,
                        color: Colors.white,
                      ),
                      onTap: (CompletionHandler handler) async {
                        await handler(true);
                        await ChatApi.deleteChat(
                            chatId: chat['id'], chatType: chat['type']);
                        setState(() {});
                      },
                      color: Colors.red),
                ],
                child: Container(
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
                      trailing: Icon(
                        Icons.navigate_next_rounded,
                        color: Colors.grey,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: kBetSquadOrange,
                        radius: 28,
                        child: chat['type'] == 'bet'
                            ? FutureBuilder<DataSnapshot>(
                            future: FirebaseDatabase.instance
                                .reference()
                                .child('bets')
                                .child(chat['id'])
                                .child('from')
                                .once(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return CircleAvatar(
                                  radius: 25,
                                  backgroundImage:
                                  AssetImage('images/ball.png'),
                                );
                              }
                              print("bet id: " + chat['id']);
                              if (snapshot.data.value == null) {
                                print(chat['id'] + 'no value');
                              }
                              print("user ID: " + snapshot.data.value);

                              if (snapshot.hasError)
                                print(snapshot.error);
                              return FutureBuilder<DataSnapshot>(
                                  future: FirebaseDatabase.instance
                                      .reference()
                                      .child('users')
                                      .child(snapshot.data.value)
                                      .child('image')
                                      .once(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError)
                                      print(snapshot.error);
                                    return CircleAvatar(
                                      radius: 25,
                                      backgroundImage: !snapshot
                                          .hasData ||
                                          snapshot.hasError ||
                                          StringUtils.isNullOrEmpty(
                                              snapshot.data.value)
                                          ? AssetImage(
                                          'images/user_placeholder'
                                              '.png')
                                          : CachedNetworkImageProvider(snapshot.data.value),
//                                          NetworkImage(snapshot
//                                              .data.value),
                                    );
                                  });
                            })
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
                              if (snapshot.hasError)
                                print(snapshot.error);
                              return CircleAvatar(
                                radius: 25,
                                backgroundImage: !snapshot.hasData ||
                                    snapshot.hasError ||
                                    StringUtils.isNullOrEmpty(
                                        snapshot.data.value)
                                    ? AssetImage(
                                    'images/user_placeholder'
                                        '.png')
                                    : CachedNetworkImageProvider(snapshot.data.value),
                              );
                            }),
                      ),
                      subtitle: StreamBuilder<Event>(
                          stream: FirebaseDatabase.instance
                              .reference()
                              .child('messages')
                              .child(chat['id'] as String)
                              .limitToLast(1)
                              .onValue,
                          builder: (context, snapshot) {
                            String lastMessage;
                            int lastMessageTimestamp;
                            if (snapshot.hasData) {
                              Map messagesDict =
                              (snapshot.data.snapshot.value);
                              //considering there could be no messages in the chat
                              if (messagesDict != null) {
                                Map lastMessageDict =
                                messagesDict.values.toList()[0];
                                lastMessage =
                                    (lastMessageDict['message']).toString();
                                lastMessageTimestamp =
                                    (lastMessageDict['timestamp'] as num)
                                        .toInt();
                              }
                            }
                            return Padding(
                              padding:
                              const EdgeInsets.symmetric(vertical: 8.0),
                              child: lastMessage == null
                                  ? Container()
                                  : Column(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    lastMessage ?? '',
                                    style: GoogleFonts.roboto(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    lastMessageTimestamp != null
                                        ? Utility.timeAgoSinceDate(DateTime
                                        .fromMillisecondsSinceEpoch(
                                        lastMessageTimestamp))
                                        : '',
                                    style: GoogleFonts.roboto(
                                        color: Colors.grey),
                                  )
                                ],
                              ),
                            );
                          }),
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
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                if (unread)
                                  Container(
                                    margin: EdgeInsets.only(right: 10),
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(4),
                                      color: kBetSquadOrange,
                                    ),
                                  ),
                                Flexible(
                                  child: Text(
                                    !snapshot.hasData ||
                                        snapshot.hasError ||
                                        StringUtils.isNullOrEmpty(
                                            snapshot.data.value)
                                        ? ''
                                        : chat['type'] == 'bet'
                                        ? 'NGS Bet: ${snapshot.data.value}'
                                        : snapshot.data.value,
                                    style: GoogleFonts.roboto(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            );
                          }),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );

    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: TabBar(
            indicatorColor: kBetSquadOrange,
            tabs: [
              Tab(text: 'Private'),
              Tab(text: 'Group'),
            ],
          ),
          body: TabBarView(
            children: [
              buildChatList(showOnlyPersonalChats: true),
              buildChatList(showOnlyPersonalChats: false),
            ],
          ),
        ),
      ),
    );
  }
}
