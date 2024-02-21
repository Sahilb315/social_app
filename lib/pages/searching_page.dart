import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/pages/posts_user_profile.dart';
import 'package:social_app/provider/search_provider.dart';

class SearchingPage extends StatefulWidget {
  const SearchingPage({super.key});

  @override
  State<SearchingPage> createState() => _SearchingPageState();
}

class _SearchingPageState extends State<SearchingPage> {
  final searchController = TextEditingController();
  @override
  void initState() {
    Provider.of<SearchProvider>(context, listen: false).getAllUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: TextFormField(
              autofocus: true,
              controller: searchController,
              decoration: const InputDecoration(
                hintText: "Search X",
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
              ),
              onChanged: (value) {
                for (var i = 0; i < provider.users.length; i++) {
                  /// Clear the list when the textfield is empty
                  if (value.isEmpty) {
                    provider.clearList();

                    /// Getting all the users full name & username and matching it with the text entered
                    /// and adding the users in an separate list
                  } else if (provider.users[i].name
                          .toLowerCase()
                          .contains(value.toLowerCase()) ||
                      provider.users[i].username
                          .toLowerCase()
                          .contains(value.toString())) {
                    /// If the user is already in the list then return so there are no duplicates
                    if (provider.searchedUsers.contains(provider.users[i])) {
                      return;
                    }
                    provider.addUser(provider.users[i]);
                  }
                }
              },
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: provider.searchedUsers.length,
                  itemBuilder: (context, index) {
                    final singleUser = provider.searchedUsers[index];
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  PostUserProfile(
                            userModel: singleUser,
                            // postModel: postModel,
                          ),
                          transitionDuration: const Duration(milliseconds: 300),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
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
                      child: ListTile(
                        leading: CircleAvatar(
                          foregroundImage: NetworkImage(singleUser.profileUrl),
                        ),
                        title: Text(singleUser.name),
                        subtitle: Text(singleUser.username),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
