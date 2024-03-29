import 'package:chat_app/auth/services/auth_service.dart';
import 'package:chat_app/chat/chat_service.dart';
import 'package:chat_app/components/chat_bubble.dart';
import 'package:chat_app/components/custom_text_field.dart';
import 'package:chat_app/pages/call_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;
  const ChatPage(
      {super.key, required this.receiverEmail, required this.receiverID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  
  // text controller
  final TextEditingController _messageController = TextEditingController();

  // chat & auth services intances
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  // extract name from the email
  String extractNameFromEmail(String email) {
    int atIndex = email.indexOf('@');
    String name = email.substring(0, atIndex);
    return name;
  }

  // send message
  Future<void> sendMessage() async {
    // if there is somthing inside the textfield
    if (_messageController.text.isNotEmpty) {
      // send message
      await _chatService.sendMessage(
          widget.receiverID, _messageController.text);
      // clear textfield
      scrollDown();
      _messageController.clear();
    }
  }

  // for textfield focus
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
    });
    // wait a bit for listbiew to be built, then scroll to the bottom
    Future.delayed(
      const Duration(milliseconds: 500),
      () => scrollDown(),
    );
  }

  @override
  void dispose() {
    focusNode.dispose();
    _messageController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  // scroll controller
  final ScrollController _scrollController = ScrollController();
  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 40,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: AppBar(
        title: Text(extractNameFromEmail(widget.receiverEmail)),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AgoraVideoChatWidget(
                            channelName:
                                _chatService.getChannelId(widget.receiverID),
                            userName: widget.receiverEmail),
                      ));
                },
                icon: Icon(Icons.video_call)),
          )
        ],
      ),
      body: Column(
        children: [
          // display all messages
          Expanded(
            child: _buildMessageList(),
          ),
          // user input
          _buildUserInput()
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessage(widget.receiverID, senderID),
      builder: (context, snapshot) {
        // error
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }
        // loading...
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Text("Loading ..."),
          );
        }
        // return list view
        return ListView(
          controller: _scrollController,
          children: snapshot.data!.docs.map((doc) {
            Future.delayed(
              const Duration(milliseconds: 500),
              () => scrollDown(),
            );
            return _buildMessageItem(doc);
          }).toList(),
        );
      },
    );
  }

  // build message item
  Widget _buildMessageItem(QueryDocumentSnapshot<Object?> doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    // is currrent user
    bool isCurrentUser = data["senderID"] == _authService.getCurrentUser()!.uid;

    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    // Convert the timestamp to DateTime
    DateTime timestamp = DateTime.fromMillisecondsSinceEpoch(
      data["timestamp"].seconds * 1000,
    );
// Convert the timestamp to DateTime
    timestamp = DateTime.fromMillisecondsSinceEpoch(
      data["timestamp"].seconds * 1000,
    );

    // Format the DateTime to desired format (YYYY/MM/DD HH:MM)
    String formattedTimestamp =
        DateFormat('yyyy/MM/dd HH:mm').format(timestamp);

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 15),
            child: Text(
              formattedTimestamp,
              style: TextStyle(
                fontSize: 12, // Adjust the font size as needed
                color: Colors.grey, // Adjust the color as needed
              ),
            ),
          ),
          ChatBubble(
            message: data["message"],
            isCurrentUser: isCurrentUser,
          ),
        ],
      ),
    );
  }

  // build message input
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Row(
        children: [
          // texfield should take up  most of the space
          Expanded(
            child: CustomTextFiled(
              hintText: 'Type a message',
              obsucureText: false,
              controller: _messageController,
              focusNode: focusNode,
            ),
          ),
          // send button
          Container(
            decoration: const BoxDecoration(
                color: Colors.green, shape: BoxShape.circle),
            margin: const EdgeInsets.only(right: 25),
            child: IconButton(
              icon: const Icon(Icons.send),
              onPressed: sendMessage,
            ),
          ),
          Container(
            decoration: const BoxDecoration(
                color: Colors.green, shape: BoxShape.circle),
            margin: const EdgeInsets.only(right: 25),
            child: IconButton(
              icon: const Icon(Icons.mic),
              onPressed: sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}
