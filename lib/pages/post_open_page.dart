// ignore_for_file: sized_box_for_whitespace

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/components/bookmark.dart';
import 'package:social_app/components/comment_tile.dart';
import 'package:social_app/components/like.dart';
import 'package:social_app/database/firestore.dart';
import 'package:social_app/components/comment.dart';
import 'package:social_app/helper/hashtag.dart';
import 'package:social_app/models/comments_model.dart';
import 'package:social_app/models/posts_model.dart';

class PostOpenPage extends StatefulWidget {
  final String docID;
  final List<dynamic> likes;
  final String username;
  final String useremail;
  final String dateTime;
  final PostModel postModel;

  const PostOpenPage({
    super.key,
    required this.docID,
    required this.likes,
    required this.username,
    required this.useremail,
    required this.dateTime,
    required this.postModel,
  });

  @override
  State<PostOpenPage> createState() => PostOpenPageState();
}

class PostOpenPageState extends State<PostOpenPage> {
  User? user = FirebaseAuth.instance.currentUser;

  FirestoreDatabase firestoreDatabase = FirestoreDatabase();
  List<CommentModel> commentsList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Post'),
      ),
      body: Padding(
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
                              widget.postModel.username.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          widget.postModel.useremail.toString(),
                        ),
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
                    HashtagView(
                      text: widget.postModel.postmessage.toString(),
                      maxLines: null,
                      textOverflow: TextOverflow.visible,
                      textSize: 20,
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
                          likes: widget.postModel.like!.toList(),
                        ),
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
                          commentsList = commentsDoc
                              .map(
                                (doc) => CommentModel.fromJson(
                                    doc.data() as Map<String, dynamic>),
                              )
                              .toList();
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: commentsDoc.length,
                            itemBuilder: (context, index) {
                              final newComments = commentsList[index];
                              final comments = commentsDoc[index];
                              return CommentTile(
                                tweetedUsername:
                                    widget.postModel.username.toString(),
                                content: newComments.content.toString(),
                                useremail:
                                    newComments.commentedEmail.toString(),
                                leadingTime: newComments.timestamp.toString(),
                                username: newComments.commentedBy.toString(),
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
              ],
            ),
          ),
        ),

        //  else {
        //   return const Center(
        //     child: CircularProgressIndicator(
        //       color: Colors.black,
        //     ),
        //   );
        // }
      ),
    );
  }
}
