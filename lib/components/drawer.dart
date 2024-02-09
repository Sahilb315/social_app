import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_app/pages/bookmark_page.dart';
import 'package:social_app/pages/profile_page.dart';
import 'package:social_app/pages/settings_page.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // drawer header
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const ProfilePage(),
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
                  );
                },
                child: UserAccountsDrawerHeader(
                  currentAccountPicture: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: 
                    Image.network(
                      FirebaseAuth.instance.currentUser!.photoURL.toString(),
                    ),
                    // Image.network(
                    //  ("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTV5lof4YCEqxL3U1KVac7UgbdG6SG8bfs0hWoVkqJ2w4GIeujd_ps78_loMw&s"),
                    // ),
                  ),
                  accountName: Text(
                    FirebaseAuth.instance.currentUser!.displayName.toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  accountEmail: Text(
                    FirebaseAuth.instance.currentUser!.email.toString(),
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                  ),
                ),
              ),
              // profile
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: ListTile(
                  leading: const Icon(
                    CupertinoIcons.person,
                    size: 30,
                  ),
                  title: const Text(
                    "P R O F I L E",
                    style: TextStyle(fontSize: 18),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const ProfilePage(),
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
                    );
                  },
                ),
              ),
              // Bookmarks
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: ListTile(
                  leading: const Icon(
                    CupertinoIcons.bookmark,
                    size: 30,
                  ),
                  title: const Text(
                    "B O O K M A R K S",
                    style: TextStyle(fontSize: 18),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const BookmarkPage(),
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
                    );
                  },
                ),
              ),
              // Settings
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: ListTile(
                  leading: const Icon(
                    Icons.settings,
                    size: 30,
                  ),
                  title: const Text(
                    "S E T T I N G S",
                    style: TextStyle(fontSize: 18),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const SettingsPage(),
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
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
