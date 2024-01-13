import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/components/comment_tile.dart';
import 'package:social_app/helper/format_date.dart';
import 'package:social_app/helper/hashtag.dart';
import 'package:social_app/models/posts_model.dart';
import 'package:social_app/provider/comments_povider.dart';
import 'package:social_app/provider/posts_provider.dart';

class PostOpenPage extends StatefulWidget {
  final String docID;
  final PostModel postModel;
  final int index;

  const PostOpenPage({
    super.key,
    required this.docID,
    required this.postModel,
    required this.index,
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
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                post.updatePostBookmark(
                                    widget.docID, widget.index);
                              },
                              icon: post.list[widget.index].bookmark
                                      .contains(user!.email)
                                  ? const Icon(CupertinoIcons.bookmark_fill)
                                  : Icon(
                                      CupertinoIcons.bookmark,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary,
                                    ),
                            ),
                            Text(
                              post.list[widget.index].bookmark.length
                                  .toString(),
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            IconButton(
                              onPressed: () {
                                comment.showDailog(
                                  context,
                                  commentController,
                                  widget.docID,
                                  post.list[widget.index].username,
                                );
                              },
                              icon: Icon(
                                CupertinoIcons.bubble_left,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                              ),
                            ),
                            Text(comment.comments.length.toString()),
                            const SizedBox(
                              width: 10,
                            ),
                            IconButton(
                              onPressed: () {
                                post.updatePostLike(
                                  widget.docID,
                                  widget.index,
                                );
                              },
                              icon: post.list[widget.index].like
                                      .contains(user!.email)
                                  // true
                                  ? const Icon(
                                      CupertinoIcons.heart_fill,
                                      color: Colors.red,
                                    )
                                  : Icon(
                                      CupertinoIcons.heart,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary,
                                    ),
                            ),
                            Text(
                              post.list[widget.index].like.length.toString(),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
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
