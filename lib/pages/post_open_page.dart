// ignore_for_file: sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/components/bookmark.dart';
import 'package:social_app/components/comment_tile.dart';
import 'package:social_app/components/like.dart';
import 'package:social_app/database/firestore.dart';
import 'package:social_app/components/comment.dart';

class PostOpenPage extends StatefulWidget {
  final String docID;
  final List<dynamic> likes;
  final String username;
  final String useremail;
  final String dateTime;

  const PostOpenPage({
    super.key,
    required this.docID,
    required this.likes,
    required this.username,
    required this.useremail,
    required this.dateTime,
  });

  @override
  State<PostOpenPage> createState() => PostOpenPageState();
}

class PostOpenPageState extends State<PostOpenPage> {
  User? user = FirebaseAuth.instance.currentUser;

  FirestoreDatabase firestoreDatabase = FirestoreDatabase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Post'),
      ),
      body: FutureBuilder(
        future: firestoreDatabase.getPostDocumentById(widget.docID),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!.data() as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.all(14.0),
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.red,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    widget.username,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                data.isNotEmpty
                                    ? data['useremail']
                                    : 'No Message',
                              ), // Use data with a check for non-empty map
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.isNotEmpty
                                ? data['postmessage']
                                : 'No Message',
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.dateTime,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const Divider(
                            height: 0,
                          ),
                          Row(
                            children: [
                              Bookmark(
                                docID: widget.docID,
                              ),
                              // Comment
                              Comment(
                                docID: widget.docID,
                              ),
                              // Like
                              LikeButton(
                                postID: widget.docID,
                                likes: widget.likes,
                              ),
                              // Text(data['like']),
                            ],
                          ),
                          const Divider(
                            height: 0,
                          ),
                          StreamBuilder(
                            stream: firestoreDatabase.getComments(widget.docID),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: Center(
                                    child: Text(
                                      ".",
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary,
                                      ),
                                    ),
                                  ),
                                );
                              } else if (snapshot.hasData) {
                                final commentsDoc = snapshot.data!.docs;
                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: commentsDoc.length,
                                  itemBuilder: (context, index) {
                                    final comments = commentsDoc[index];
                                    return CommentTile(
                                      tweetedUsername: widget.username,
                                      content: comments['content'],
                                      useremail: comments['commentedEmail'],
                                      leadingTime: comments['timestamp'],
                                      username: comments['commentedBy'],
                                      docID: comments.id,
                                    );
                                  },
                                );
                                //*            Another way to get Data
                                // return ListView(
                                //   shrinkWrap: true,
                                //   physics: const NeverScrollableScrollPhysics(),
                                //   children: snapshot.data!.docs.map((doc) {
                                //     final commentData =
                                //         doc.data() as Map<String, dynamic>;

                                //     return ListTile(
                                //       title: Text(commentData['content'].toString()),
                                //     );
                                //   }).toList(),
                                // );
                              } else if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                return Center(
                                  child: Text(snapshot.error.toString()),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      // const SizedBox(
                      //   height: 40,
                      // ),

                      // const Divider(
                      //   color: Colors.black,
                      // )
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          }
        },
      ),
    );
  }
}
