import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:social_app/components/back_button.dart';
import 'package:social_app/components/list_tile_bookmark.dart';
import 'package:social_app/database/firestore.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  FirestoreDatabase firestoreDatabase = FirestoreDatabase();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // SizedBox(height: 50,),
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 50),
                child: MyBackButton(),
              ),
              SizedBox(
                width: 50,
              ),
              Text(
                "B O O K M A R K S",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          StreamBuilder(
            stream: firestoreDatabase.showBookmarkPosts(),
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
                    padding: EdgeInsets.all(25),
                    child: Text(
                      "No Bookmarks..",
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
                  padding: const EdgeInsets.all(0),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    String docID = post.id;
                    String message = post['postmessage'];
                    String userEmail = post['useremail'];
                    Timestamp timestamp = post['timestamp'];

                    DateTime date = timestamp.toDate();
                    final formatDate = DateFormat("yyyy-MM-dd").format(date);

                    return MyBookmarkListTile(
                      title: message,
                      subTitle: userEmail,
                      leadingTime: formatDate.toString(),
                      docID: docID,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
