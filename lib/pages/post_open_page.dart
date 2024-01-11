import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/components/comment_tile.dart';
import 'package:social_app/components/like.dart';
import 'package:social_app/database/firestore.dart';
import 'package:social_app/components/comment.dart';
import 'package:social_app/helper/hashtag.dart';
import 'package:social_app/models/comments_model.dart';
import 'package:social_app/models/posts_model.dart';

class PostOpenPage extends StatefulWidget {
  final String docID;
  final PostModel postModel;

  const PostOpenPage({
    super.key,
    required this.docID,
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
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text('Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: SingleChildScrollView(
          child: SizedBox(
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
                          widget.postModel.timestamp.toString(),
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
                        FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection("post")
                              .doc(widget.docID)
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final data =
                                  snapshot.data!.data() as Map<String, dynamic>;
                              final bookmark = data['bookmark'];
                              return IconButton(
                                onPressed: () {
                                  setState(() {
                                    widget.postModel.bookmark =
                                        !widget.postModel.bookmark;
                                  });
                                  firestoreDatabase.updatePostData(
                                      widget.docID, widget.postModel.bookmark);
                                },
                                icon:bookmark
                                    ? const Icon(Icons.bookmark)
                                    : const Icon(Icons.bookmark_add_outlined),
                              );
                            } else {
                              return const CircularProgressIndicator();
                            }
                          },
                        ),
                        // Bookmark(
                        //   docID: widget.docID,
                        // ),
                        // Comment
                        // FutureBuilder(
                        //   future: firestoreDatabase.up,
                        //   builder: builder,
                        // ),
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
                              return CommentTile(
                                postModel: widget.postModel,
                                commentModel: newComments,
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
      ),
    );
  }
}
