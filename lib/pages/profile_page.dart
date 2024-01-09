import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:social_app/components/back_button.dart';
import 'package:social_app/components/list_tile_profile.dart';
import 'package:social_app/database/firestore.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);
  final FirestoreDatabase firestoreDatabase = FirestoreDatabase();
  final User? currentUser = FirebaseAuth.instance.currentUser;

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    return await FirebaseFirestore.instance
        .collection('user')
        .doc(currentUser!.email)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: getUserDetails(),
        builder: (context, snapshot) {
          // loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          // any error

          else if (snapshot.hasError) {
            return Text("Error ${snapshot.error}");
          }
          // get data

          else if (snapshot.hasData) {
            if (snapshot.data!.data() == null) {
              return const Center(child: Text("No Data"));
            }
            Map<String, dynamic> user =
                snapshot.data!.data() as Map<String, dynamic>;

            return Center(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 60.0, left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        MyBackButton(),
                        SizedBox(width: 65),
                        Text(
                          "P R O F I L E",
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: Theme.of(context).colorScheme.primary),
                    padding: const EdgeInsets.all(25),
                    child: const Icon(
                      Icons.person_outline_rounded,
                      size: 60,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    user['username'],
                    style: const TextStyle(
                        fontSize: 27, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user['email'],
                    style: const TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  StreamBuilder(
                    stream: firestoreDatabase.showPosts(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final posts = snapshot.data!.docs;
                      if (snapshot.data == null || posts.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(30),
                            child: Text(
                              "No Posts..",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }
                      return Expanded(
                        child: ListView.builder(
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            final post = posts[index];
                            final docID = post.id;

                            String message = post['postmessage'];
                            String userEmail = post['useremail'];
                            Timestamp timestamp = post['timestamp'];

                            DateTime date = timestamp.toDate();
                            final formatDate =
                                DateFormat("yyyy-MM-dd").format(date);
                            if (currentUser!.email == userEmail) {
                              return UserListTile(
                                title: message,
                                subTitle: userEmail,
                                leadingTime: formatDate.toString(),
                                docID: docID,
                              );
                            } else {
                              // _count++;
                              // if(_count > 2){
                              // return const Text("You have not posted yet.");
                              // }
                              return null;
                            }
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          } else {
            return const Text('No Data');
          }
        },
      ),
    );
  }
}
