import 'package:chat_app/global/services/auth/auth_service.dart';
import 'package:chat_app/global/services/chat/chat_service.dart';
import 'package:chat_app/global/components/my_drawer.dart';
import 'package:chat_app/global/components/user_tile.dart';
import 'package:chat_app/modules/chat/chat_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  // extract name from the email
  String extractNameFromEmail(String email) {
    int atIndex = email.indexOf('@');
    String name = email.substring(0, atIndex);
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
        centerTitle: true,
        title: const Text("Home"),
      ),
      body: _buildUserList(),
      drawer: const MyDrawer(),
    );
  }

  // build a list of users except for the current logged in user
  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        // error
        if (snapshot.hasError) {
          return const Text("Error");
        }
        // loading...
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // return a list of users
        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  // build individual list tile for user
  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    if (userData["email"] != _authService.getCurrentUser()!.email) {
      return UserTile(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return ChatPage(
                receiverEmail: userData["email"],
                receiverID: userData["uid"],
              );
            },
          ));
        },
        text: extractNameFromEmail(userData["email"]),
      );
    } else {
      return Container();
    }
  }
}
