import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_app/components/back_button.dart';
import 'package:social_app/components/list_tile_user.dart';
import 'package:social_app/helper/helper_function.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('user').snapshots(),
        builder: ((context, snapshot) {
          // any error
          if (snapshot.hasError) {
            diplayMessageToUser("Some Error occured", context);
          }
          // loading
          else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data == null) {
            diplayMessageToUser("No Data..", context);
          }
          // get all users
          final users = snapshot.data!.docs;

          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 60.0, left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    MyBackButton(),
                    SizedBox(
                      width: 90,
                    ),
                    Text(
                      "U S E R S",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  padding: const EdgeInsets.only(top: 15),
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final username = user['username'];
                    final email = user['email'];
                    return Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: MyUserListTile(
                        title: username,
                        subTitle: email,
                        leadingTime: "",
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
