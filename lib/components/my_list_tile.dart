
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/database/firestore.dart';
import 'package:social_app/helper/hashtag.dart';
import 'package:social_app/helper/timeago_messages.dart';
import 'package:social_app/models/posts_model.dart';
import 'package:social_app/pages/post_open_page.dart';
import 'package:social_app/provider/comments_povider.dart';
import 'package:social_app/provider/posts_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class MyListTile extends StatefulWidget {
  final String docID;
  final int index;
  final PostModel postModel;
  final String date;

  const MyListTile({
    super.key,
    required this.docID,
    required this.index,
    required this.postModel,
    required this.date,
  });

  @override
  State<MyListTile> createState() => _MyListTileState();
}

class _MyListTileState extends State<MyListTile> {
  FirestoreDatabase firestoreDatabase = FirestoreDatabase();
  final user = FirebaseAuth.instance.currentUser;
  final commentController = TextEditingController();
  @override
  void initState() {
    timeago.setLocaleMessages('my_en', MyCustomMessages());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostOpenPage(
              postModel: widget.postModel,
              docID: widget.docID,
              index: widget.index,
            ),
          ),
        );
      },
      child: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.index == 0
                ? const Divider(
                    thickness: 0.4,
                  )
                : const SizedBox.shrink(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    foregroundImage: NetworkImage(
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTvi7HpQ-_PMSMOFrj1hwjp6LDcI-jm3Ro0Xw&usqp=CAU"),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(widget.postModel.username.toString()),
                            //* If want to display the users email ↓
                            // Text(
                            //   "  ${widget.postModel.useremail.toString()}",
                            //   style: TextStyle(
                            //     color: Theme.of(context)
                            //         .colorScheme
                            //         .inversePrimary,
                            //   ),
                            // ),
                            Text(
                              " ${timeago.format(widget.postModel.timestamp.toDate(), locale: 'en_short')}",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                              ),
                            ),
                          ],
                        ),
                        HashtagView(
                          text: widget.postModel.postmessage.toString(),
                          maxLines: 6,
                          textOverflow: TextOverflow.ellipsis,
                          textSize: 16,
                        ),
                        Consumer2<PostsProvider, CommentsProvider>(
                          builder:
                              (context, postProvider, commentProvider, child) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    postProvider.updatePostBookmark(
                                      widget.docID,
                                      widget.index,
                                    );
                                  },
                                  icon: postProvider.list[widget.index].bookmark
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
                              postProvider.list[widget.index].bookmark.length
                                  .toString(),
                              style: const TextStyle(fontSize: 16),
                            ),
                                const SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                  onPressed: () {
                                    commentProvider.showDailog(
                                      context,
                                      commentController,
                                      widget.docID,
                                      postProvider.list[widget.index].username,
                                    );
                                  },
                                  icon: Icon(
                                    CupertinoIcons.bubble_left,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                  ),
                                ),
                                // Text(commentProvider.comments.length.toString()),
                                const SizedBox(
                                  width: 0,
                                ),
                                IconButton(
                                  onPressed: () {
                                    postProvider.updatePostLike(
                                      widget.docID,
                                      widget.index,
                                    );
                                  },
                                  icon: postProvider.list[widget.index].like
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
                                  postProvider.list[widget.index].like.length
                                      .toString(),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 0.4,
            )
          ],
        ),
      ),
    );
  }
}
