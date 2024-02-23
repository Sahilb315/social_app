import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/components/comment_tile.dart';
import 'package:social_app/components/post_tile_icons.dart';
import 'package:social_app/helper/format_date.dart';
import 'package:social_app/helper/hashtag.dart';
import 'package:social_app/models/posts_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/pages/posts_user_profile.dart';
import 'package:social_app/pages/profile_page.dart';
import 'package:social_app/provider/comments_povider.dart';
import 'package:social_app/provider/posts_provider.dart';

class PostOpenPage extends StatefulWidget {
  final String docID;
  final PostModel postModel;
  // final String profileUrl;
  final String username;

  const PostOpenPage({
    super.key,
    required this.username,
    required this.docID,
    required this.postModel,
    // required this.profileUrl,
  });

  @override
  State<PostOpenPage> createState() => PostOpenPageState();
}

class PostOpenPageState extends State<PostOpenPage> {
  User? user = FirebaseAuth.instance.currentUser;
  final commentController = TextEditingController();

  Future<DocumentSnapshot> getProfile() async {
    final userCollection = FirebaseFirestore.instance.collection("user");
    final doc = await userCollection.doc(widget.postModel.useremail).get();
    return doc;
  }

  String? profileUrl;
  String? username;
  @override
  void initState() {
    Provider.of<PostsProvider>(context, listen: false)
        .fetchPostDocumentById(widget.docID);
    Provider.of<CommentsProvider>(context, listen: false)
        .fetchComments(widget.docID);
    Provider.of<CommentsProvider>(context, listen: false).user =
        FirebaseAuth.instance.currentUser!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text('Post'),
      ),
      body: Consumer2<PostsProvider, CommentsProvider>(
        builder: (context, post, comment, child) {
          final singlePostModel =
              post.list.where((element) => element.id == widget.docID).first;
          log("In Open Page consumer");
          return Padding(
            padding: const EdgeInsets.all(14.0),
            child: SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        FutureBuilder(
                          future: getProfile(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              UserModel userModel =
                                  UserModel.fromFirestore(snapshot.data!);

                              final doc =
                                  snapshot.data!.data() as Map<String, dynamic>;
                              String data = doc["profileUrl"];
                              username = doc['username'];
                              profileUrl = data;
                              return GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                        secondaryAnimation) {
                                      if (FirebaseAuth
                                              .instance.currentUser!.email ==
                                          widget.postModel.useremail) {
                                        return const ProfilePage();
                                      }
                                      return PostUserProfile(
                                        userModel: userModel,
                                        // postModel: widget.postModel,
                                      );
                                    },
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
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
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: CircleAvatar(
                                    foregroundImage: NetworkImage(data),
                                  ),
                                ),
                              );
                            } else {
                              return const CircleAvatar(
                                foregroundImage: NetworkImage(
                                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTV5lof4YCEqxL3U1KVac7UgbdG6SG8bfs0hWoVkqJ2w4GIeujd_ps78_loMw&s",
                                ),
                              );
                            }
                          },
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  widget.postModel.username,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                            Text("@${widget.username}"),
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
                          text: widget.postModel.postmessage,
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
                              formatDate(widget.postModel.timestamp),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Divider(height: 0),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              //* Issue with using the model from the home screen is that it will not update the bookmarks
                              //? Bookmark
                              IconsContainer(
                                value: singlePostModel.bookmark
                                    .contains(user!.email),
                                text:
                                    singlePostModel.bookmark.length.toString(),
                                iconFalse: CupertinoIcons.bookmark,
                                iconTrue: CupertinoIcons.bookmark_fill,
                                colorTrue: Colors.blue,
                                onPressed: () {
                                  post.updateSinglePostBookmark(widget.docID);
                                },
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              //? Repost
                              IconsContainer(
                                value: false,
                                iconFalse: CupertinoIcons.repeat,
                                iconTrue: CupertinoIcons.repeat,
                                onPressed: () {},
                                colorTrue: Colors.green,
                                text: "0",
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              //? Comment
                              IconsContainer(
                                value: true,
                                text: comment.comments.length.toString(),
                                iconFalse: CupertinoIcons.bubble_left,
                                iconTrue: CupertinoIcons.bubble_left,
                                colorTrue: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                onPressed: () {
                                  comment.addCommentSheet(
                                    context,
                                    commentController,
                                    widget.docID,
                                    widget.postModel.username,
                                  );
                                },
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              //? Like
                              IconsContainer(
                                value:
                                    singlePostModel.like.contains(user!.email),
                                text: singlePostModel.like.length.toString(),
                                iconFalse: CupertinoIcons.heart,
                                iconTrue: CupertinoIcons.heart_fill,
                                colorTrue: Colors.red,
                                onPressed: () {
                                  post.updateSinglePostLike(widget.docID);
                                },
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 0),
                        Consumer<CommentsProvider>(
                          builder: (context, comment, child) {
                            if (comment.comments.isEmpty) {
                              return const Center(
                                child: Column(
                                  children: [
                                    SizedBox(height: 20),
                                    Text(
                                      "No Comments ...",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: comment.comments.length,
                              itemBuilder: (context, index) {
                                return CommentTile(
                                  commentModel: comment.comments[index],
                                  postModel: post.list[index],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
