import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/database/firestore.dart';
import 'package:social_app/routes/myroutes.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final User? user = FirebaseAuth.instance.currentUser;

  FirestoreDatabase firestoreDatabase = FirestoreDatabase();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // drawer header
          FutureBuilder(
            future: firestoreDatabase.getUserName(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data!.data() as Map<String, dynamic>;
                final username = data["username"];
                return Column(
                  children: [
                    UserAccountsDrawerHeader(
                      currentAccountPicture: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                          child: Image.network(
                              "https://img.freepik.com/free-vector/illustration-businessman_53876-5856.jpg?size=626&ext=jpg&ga=GA1.2.1573903318.1701284006&semt=ais")),
                      accountName: Text(
                        username,
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
                    // home
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: ListTile(
                        leading: const Icon(
                          Icons.home,
                          size: 30,
                        ),
                        title: const Text(
                          "H O M E",
                          style: TextStyle(fontSize: 18),
                        ),
                        onTap: () => Navigator.pop(context),
                      ),
                    ),

                    // profile
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: ListTile(
                        leading: const Icon(
                          Icons.person,
                          size: 30,
                        ),
                        title: const Text(
                          "P R O F I L E",
                          style: TextStyle(fontSize: 18),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, MyRoutes.profilePage);
                        },
                      ),
                    ),
                    // Bookmarks
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: ListTile(
                        leading: const Icon(
                          Icons.bookmark,
                          size: 30,
                        ),
                        title: const Text(
                          "B O O K M A R K S",
                          style: TextStyle(fontSize: 18),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, MyRoutes.bookmarkPage);
                        },
                      ),
                    ),
                    // user
                    Padding(
                      padding: const EdgeInsets.only(left: 13.0),
                      child: ListTile(
                        leading: const Icon(
                          Icons.group,
                          size: 30,
                        ),
                        title: const Text(
                          "U S E R S",
                          style: TextStyle(fontSize: 18),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, MyRoutes.usersPage);
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
                          Navigator.pushNamed(context, MyRoutes.settingsPage);
                        },
                      ),
                    ),
                  ],
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return const Center(
                  child: Text(""),
                );
              }
            },
          ),

          // logout
          Padding(
            padding: const EdgeInsets.only(left: 10.0, bottom: 25, right: 20),
            child: ListTile(
              shape: StadiumBorder(
                side: BorderSide(
                  width: 2,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              leading: const Icon(
                Icons.logout_rounded,
                size: 30,
              ),
              title: const Text(
                "L O G O U T",
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.pop(context);
                FirebaseAuth.instance.signOut();
              },
            ),
          ),
        ],
      ),
    );
  }
}
