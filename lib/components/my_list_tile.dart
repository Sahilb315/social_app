import 'package:flutter/material.dart';
import 'package:social_app/components/bookmark.dart';
import 'package:social_app/components/comment.dart';
import 'package:social_app/components/like.dart';
import 'package:social_app/database/firestore.dart';
import 'package:social_app/helper/timeago_messages.dart';
import 'package:social_app/models/posts_model.dart';
import 'package:social_app/pages/post_open_page.dart';
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
              likes: widget.postModel.like!.toList(),
              username: widget.postModel.username.toString(),
              dateTime: widget.date,
              useremail: widget.postModel.useremail.toString(),
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
                    foregroundImage: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTvi7HpQ-_PMSMOFrj1hwjp6LDcI-jm3Ro0Xw&usqp=CAU"),
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
                            Text(
                              "  ${widget.postModel.useremail.toString()}",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                              ),
                            ),
                            Text(
                              " @${timeago.format(widget.postModel.timestamp!.toDate(), locale: 'en_short')}",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          widget.postModel.postmessage.toString(),
                          maxLines: 6,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Bookmark(
                              docID: widget.docID,
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
