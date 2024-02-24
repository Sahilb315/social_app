import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/pages/chat_page.dart';
import 'package:social_app/provider/user_provider.dart';

class NonChattedUsersPage extends StatefulWidget {
  const NonChattedUsersPage({super.key});

  @override
  State<NonChattedUsersPage> createState() => _NonChattedUsersPageState();
}

class _NonChattedUsersPageState extends State<NonChattedUsersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Direct Message'),
      ),
      body: Consumer<UserProvider>(
        builder: (context, value, child) {
          final nonChattedUsers = value.usersList;
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: nonChattedUsers.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        foregroundImage:
                            NetworkImage(nonChattedUsers[index].profileUrl),
                      ),
                      title: Text(
                        nonChattedUsers[index].name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "@${nonChattedUsers[index].username}",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      onTap: () => Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  ChatPage(
                            name: nonChattedUsers[index].name,
                            profileUrl: nonChattedUsers[index].profileUrl,
                            receiverEmail: nonChattedUsers[index].email,
                          ),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            var begin = const Offset(1.0, 0.0);
                            var end = Offset.zero;
                            var curve = Curves.ease;
                            final tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
