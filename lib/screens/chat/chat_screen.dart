import 'package:betsquad/api/chat_api.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:betsquad/widgets/message_bubble.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '';
import '../../string_utils.dart';

User loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  final String chatId, chatType;

  const ChatScreen({Key key, this.chatId, this.chatType}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  String messageText;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    print("CHAT ID: " + widget.chatId);
    markChatAsRead();
  }

  void showChat() {
    ChatApi.showChat(chatId: widget.chatId, chatType: widget.chatType);
  }

  void markChatAsRead() {
    ChatApi.markChatAsRead(chatId: widget.chatId, chatType: widget.chatType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.maps_ugc_outlined),
              onPressed: () {
                showChat();
              })
        ],
        title: FutureBuilder<DataSnapshot>(
            future: FirebaseDatabase.instance
                .reference()
                .child('users')
                .child(FirebaseAuth.instance.currentUser.uid)
                .child('chats')
                .child(widget.chatId)
                .once(),
            builder: (context, snapshot) {
              if (snapshot.hasError || !snapshot.hasData || snapshot.data.value == null) {
                return Container();
              }
              var chat = snapshot.data.value;
              print(chat);
              return FutureBuilder<DataSnapshot>(
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
                              .child(widget.chatId)
                              .child('title')
                              .once(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError || !snapshot.hasData) return Text('');
                    print("title:" + snapshot.data.value);
                    return Text(
                      snapshot.data.value,
                      style: GoogleFonts.roboto(fontSize: 15),
                    );
                  });
            }),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(
              chatId: widget.chatId,
              // scrollController: scrollController,
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
                    onPressed: () async {
                      if (!StringUtils.isNullOrEmpty(messageText)) {
                        setState(() {
                          _loading = true;
                        });
                        await FirebaseDatabase.instance.reference().child('messages').child(widget.chatId).push().set({
                          'message': messageText,
                          'senderId': FirebaseAuth.instance.currentUser.uid,
                          'timestamp': DateTime.now().millisecondsSinceEpoch
                        });
                        await ChatApi.newChatMessage(
                            chatType: widget.chatType, chatId: widget.chatId, message: messageText);
                        messageTextController.clear();
                        setState(() {
                          messageText = null;
                          _loading = false;
                        });
                      }
                    },
                    child: Icon(
                      Icons.send,
                      color: kBetSquadOrange,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatefulWidget {
  final String chatId;

  MessagesStream({Key key, this.chatId}) : super(key: key);

  @override
  _MessagesStreamState createState() => _MessagesStreamState();
}

class _MessagesStreamState extends State<MessagesStream> {
  ScrollController scrollController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Event>(
      stream: FirebaseDatabase.instance.reference().child('messages').child(widget.chatId).onValue,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return Expanded(
            child: Container(
              decoration: kGradientBoxDecoration,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(kBetSquadOrange),
                ),
              ),
            ),
          );
        }
        if (!snapshot.hasData) {
          return Expanded(
            child: Container(
              decoration: kGradientBoxDecoration,
              child: Center(
                  child: Text(
                'Be the first to send a chat.',
                style: GoogleFonts.roboto(color: kBetSquadOrange, fontSize: 20),
              )),
            ),
          );
        }

        Map messages = snapshot.data.snapshot.value;
        if (messages == null || messages.isEmpty) {
          return Expanded(
            child: Container(
                decoration: kGradientBoxDecoration,
                child: Center(
                    child: Text(
                  'Send a message',
                  style: GoogleFonts.roboto(color: kBetSquadOrange, fontSize: 20),
                ))),
          );
        }
        List<MessageBubble> messageBubbles = [];
        for (var message in messages.values) {
          final messageText = message['message'];
          final senderId = message['senderId'];
          final timestamp = message['timestamp'];
          final currentUser = FirebaseAuth.instance.currentUser.uid;

          final messageBubble = MessageBubble(
            text: messageText ?? '',
            isMe: currentUser == senderId,
            sender: senderId,
            timestamp: timestamp,
          );

          messageBubbles.add(messageBubble);
        }

        messageBubbles.sort((a, b) => b.timestamp.compareTo(a.timestamp));

        return Expanded(
          child: Container(
            decoration: kGradientBoxDecoration,
            child: ListView(
              reverse: true,
              controller: scrollController,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              children: messageBubbles,
            ),
          ),
        );
      },
    );
  }
}
