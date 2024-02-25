import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/components/drawer.dart';
import 'package:social_app/pages/chat_page.dart';
import 'package:social_app/pages/non_chatted_users.dart';
import 'package:social_app/provider/latest_message_provider.dart';
import 'package:social_app/provider/user_provider.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  void initState() {
    Provider.of<UserProvider>(context, listen: false).getChattedUsers();
    Provider.of<UserProvider>(context, listen: false).getAllNonChattedUsers();
    Future.delayed(
      const Duration(seconds: 3),
      () {
        if (!mounted) return;

        final userProvider = Provider.of<UserProvider>(context, listen: false);
        final latestMessageProvider =
            Provider.of<LatestMessageProvider>(context, listen: false);
        userProvider.getLatestMessage().then((value) {
          latestMessageProvider.updateLatestMessage(value);
        });
      },
    );
    super.initState();
  }

  Future<void> _refresh() async {
    Provider.of<UserProvider>(context, listen: false).getChattedUsers();
    Future.delayed(
      const Duration(seconds: 2),
      () {
        if (!mounted) return;
        Provider.of<UserProvider>(context, listen: false)
            .getAllNonChattedUsers();

        final userProvider = Provider.of<UserProvider>(context, listen: false);
        final latestMessageProvider =
            Provider.of<LatestMessageProvider>(context, listen: false);
        userProvider.getLatestMessage().then((value) {
          latestMessageProvider.updateLatestMessage(value);
        });
      },
    );
  }
  //22 top
  //

  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const NonChattedUsersPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              var begin = const Offset(1.0, 0.0);
              var end = Offset.zero;
              var curve = Curves.ease;
              final tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        ),
        shape: const CircleBorder(),
        backgroundColor: Colors.blue,
        child: SizedBox(
          width: 30,
          height: 30,
          child: Image.asset(
            "assets/message.png",
            fit: BoxFit.cover,
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: GestureDetector(
          onTap: () => _scaffoldState.currentState!.openDrawer(),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: CircleAvatar(
              foregroundImage: NetworkImage(
                FirebaseAuth.instance.currentUser!.photoURL.toString(),
              ),
            ),
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 14.0),
            child: Icon(Icons.settings),
          ),
        ],
        title: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    right: 24.0, top: 10.0, bottom: 10.0, left: 10),
                child: Text(
                  "Seach Direct Messages",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: RefreshIndicator.adaptive(
        color: Theme.of(context).colorScheme.inversePrimary,
        onRefresh: _refresh,
        child: Column(
          children: [
            Expanded(
              child: Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  final userList = userProvider.chattedUserList;
                  return ListView.builder(
                    itemCount: userList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                        child: ListTile(
                          onTap: () => Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      ChatPage(
                                name: userList[index].name.toString(),
                                profileUrl:
                                    userList[index].profileUrl.toString(),
                                receiverEmail: userList[index].email.toString(),
                              ),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                var begin = const Offset(1.0, 0.0);
                                var end = Offset.zero;
                                var curve = Curves.easeIn;

                                var tween = Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));
                                return SlideTransition(
                                  position: animation.drive(tween),
                                  child: child,
                                );
                              },
                            ),
                          ),
                          leading: CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.background,
                            radius: 32,
                            foregroundImage: NetworkImage(
                              userList[index].profileUrl.toString(),
                            ),
                          ),
                          subtitle: Consumer<LatestMessageProvider>(
                            builder: (context, messageProvider, child) {
                              final message = messageProvider.latestMessage;
                              log(message.toString());
                              return Text(
                                message[userProvider.chattedUserList[index].email]?.isNotEmpty ?? false
                                    ? message[userProvider.chattedUserList[index].email].toString()
                                    : "",
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              );
                            },
                          ),
                          title: RichText(
                            text: TextSpan(
                              text: userList[index].name,
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                              ),
                              children: [
                                TextSpan(
                                  text: " @${userList[index].username}",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
