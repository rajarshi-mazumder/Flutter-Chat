import 'package:flutter/material.dart';
import 'package:firebase_setup/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

User? loggedInUser;

class ChatScreen extends StatefulWidget {
  static String id = 'chat';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  String? messageText = "";
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    loggedInUser = _auth.currentUser;
    print(loggedInUser?.email);
  }

  void getMessages() async {
    final messages = await _firestore.collection('messages').get();
    for (var message in messages.docs) {
      print(message.data()['text']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                print("something");
                getMessages();
                // _auth.signOut();
                // Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(
              firestoreInstance: _firestore,
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      messageTextController.clear();
                      await _firestore.collection('messages').doc().set({
                        'text': messageText,
                        'sender': loggedInUser?.email,
                        'createdAt': DateTime.now(),
                      }).onError((error, stackTrace) => null);
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
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

class MessagesStream extends StatelessWidget {
  const MessagesStream({this.firestoreInstance});
  final firestoreInstance;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: firestoreInstance
            .collection('messages')
            .orderBy('createdAt')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final messages = snapshot.data?.docs.reversed;
            final messageBubbles = messages?.map((message) {
              return MessageBubble(
                messageSender: message['sender'],
                messageText: message['text'],
                isLoggedInUser: loggedInUser?.email.toString() ==
                    message['sender'].toString(),
              );
            }).toList();
            return Expanded(
              child: ListView(
                reverse: true,
                children: messageBubbles!,
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.messageText, this.messageSender, this.isLoggedInUser});
  final String? messageText;
  final String? messageSender;
  final bool? isLoggedInUser;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isLoggedInUser == true
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(
            messageSender!,
            style: TextStyle(color: Colors.black54, fontSize: 12),
          ),
          Material(
            borderRadius: BorderRadius.only(
              topLeft: isLoggedInUser == true
                  ? Radius.circular(30)
                  : Radius.circular(5),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
              topRight: isLoggedInUser == true
                  ? Radius.circular(5)
                  : Radius.circular(30),
            ),
            elevation: 5,
            color: isLoggedInUser == true
                ? Colors.lightBlueAccent
                : Colors.blueAccent,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                '$messageText',
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
