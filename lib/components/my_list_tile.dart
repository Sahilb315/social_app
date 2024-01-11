import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/components/comment.dart';
import 'package:social_app/components/like.dart';
import 'package:social_app/database/firestore.dart';
import 'package:social_app/helper/hashtag.dart';
import 'package:social_app/helper/timeago_messages.dart';
import 'package:social_app/models/posts_model.dart';
import 'package:social_app/pages/post_open_page.dart';
import 'package:social_app/provider/bookmark_provider.dart';
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
  bool isBookmarked = true;
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
                              " ${timeago.format(widget.postModel.timestamp!.toDate(), locale: 'en_short')}",
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
                        Consumer<BookmarkProvider>(
                          builder: (context, provider, child) => Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    widget.postModel.bookmark =
                                        !widget.postModel.bookmark;
                                  });
                                  // provider.posts[widget.index].bookmark;
                                  // log(provider.posts[widget.index].bookmark.toString());
                                  // provider.setBookmark(!provider.bookmark);
                                  firestoreDatabase.updatePostData(
                                      widget.docID, widget.postModel.bookmark);
                                },
                                icon: widget.postModel.bookmark
                                    ? const Icon(Icons.bookmark)
                                    : const Icon(Icons.bookmark_add_outlined),
                              ),
                              Comment(
                                docID: widget.docID,
                              ),
                              LikeButton(
                                postID: widget.docID,
                                likes: widget.postModel.like!.toList(),
                              ),
                            ],
                          ),
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
