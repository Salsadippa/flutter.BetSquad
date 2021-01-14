import 'package:betsquad/api/chat_api.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:betsquad/widgets/message_bubble.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import '';

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

  @override
  void initState() {
    super.initState();
    print(widget.chatId);
    markChatAsRead();
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
        title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/app_bar_logo.png',
              fit: BoxFit.contain,
              height: 32,
            ),
          ],
        ),
      ),
      body: Column(
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
                    onPressed: () {
                      FirebaseDatabase.instance.reference().child('messages').child(widget.chatId).push().set({
                        'message': messageText,
                        'senderId': FirebaseAuth.instance.currentUser.uid,
                        'timestamp': DateTime.now().millisecondsSinceEpoch
                      });
                      messageTextController.clear();
                      ChatApi.newChatMessage(chatType: widget.chatType, chatId: widget.chatId, message: messageText);
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController = ScrollController();

      if(scrollController.hasClients){
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      } else {
        print("no clients");
      }
    });
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
        if (!snapshot.hasData){
          return Expanded(
            child: Container(
              decoration: kGradientBoxDecoration,
              child: Center(
                  child: Text('Be the first to send a chat.', style:
                  GoogleFonts.roboto(color:kBetSquadOrange, fontSize: 20),)
              ),
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
          print(message);
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

        messageBubbles.sort((a, b) => a.timestamp.compareTo(b.timestamp));

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
