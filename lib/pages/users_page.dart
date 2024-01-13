import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_app/components/list_tile_user.dart';
import 'package:social_app/helper/helper_function.dart';
import 'package:social_app/models/user_model.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
  List<UserModel> usersList = [];
    return Scaffold(
      appBar: AppBar(
        title: const Text("U S E R S"),
        centerTitle: true,
      ),
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
          usersList = users.map((doc) => UserModel.fromFirestore(doc)).toList();
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: usersList.length,
                  padding: const EdgeInsets.only(top: 15, right: 10),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: MyUserListTile(
                        title: usersList[index].username,
                        subTitle: usersList[index].email,
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
