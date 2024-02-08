import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/components/comment_tile.dart';
import 'package:social_app/components/post_tile_icons.dart';
import 'package:social_app/helper/format_date.dart';
import 'package:social_app/helper/hashtag.dart';
import 'package:social_app/models/posts_model.dart';
import 'package:social_app/provider/comments_povider.dart';
import 'package:social_app/provider/posts_provider.dart';

class PostOpenPage extends StatefulWidget {
  final String docID;
  final PostModel postModel;
  final int index;
  final String profileUrl;

  const PostOpenPage({
    super.key,
    required this.docID,
    required this.postModel,
    required this.index,
    required this.profileUrl,
  });

  @override
  State<PostOpenPage> createState() => PostOpenPageState();
}

class PostOpenPageState extends State<PostOpenPage> {
  User? user = FirebaseAuth.instance.currentUser;
  final commentController = TextEditingController();

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
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: CircleAvatar(
                            foregroundImage: NetworkImage(widget.profileUrl),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  post.post.username,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              post.post.useremail,
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
                          text: post.post.postmessage,
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
                              formatDate(post.post.timestamp),
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
                              //? Issue with using the model from the home screen is that it will not update the bookmarks
                              IconsContainer(
                                value: post.list[widget.index].bookmark
                                    .contains(user!.email),
                                text: post.list[widget.index].bookmark.length
                                    .toString(),
                                iconFalse: CupertinoIcons.bookmark,
                                iconTrue: CupertinoIcons.bookmark_fill,
                                colorTrue: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                onPressed: () {
                                  post.updatePostBookmark(
                                    widget.postModel.id,
                                    widget.index,
                                  );
                                },
                              ),
                              const SizedBox(
                                width: 15,
                              ),
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
                                    post.list[widget.index].username,
                                  );
                                },
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              IconsContainer(
                                value: post.list[widget.index].like
                                    .contains(user!.email),
                                text: post.list[widget.index].like.length
                                    .toString(),
                                iconFalse: CupertinoIcons.heart,
                                iconTrue: CupertinoIcons.heart_fill,
                                colorTrue: Colors.red,
                                onPressed: () {
                                  post.updatePostLike(
                                    widget.docID,
                                    widget.index,
                                  );
                                },
                              ),
                              // IconButton(
                              //   onPressed: () {
                              //     post.updatePostLike(
                              //       widget.docID,
                              //       widget.index,
                              //     );
                              //   },
                              //   icon: post.list[widget.index].like
                              //           .contains(user!.email)
                              //       // true
                              //       ? const Icon(
                              //           CupertinoIcons.heart_fill,
                              //           color: Colors.red,
                              //         )
                              //       : Icon(
                              //           CupertinoIcons.heart,
                              //           color: Theme.of(context)
                              //               .colorScheme
                              //               .inversePrimary,
                              //         ),
                              // ),
                              // Text(
                              //   post.list[widget.index].like.length.toString(),
                              //   style: const TextStyle(fontSize: 16),
                              // ),
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
