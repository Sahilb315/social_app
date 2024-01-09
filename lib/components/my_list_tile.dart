import 'package:flutter/material.dart';
import 'package:social_app/components/bookmark.dart';
import 'package:social_app/components/comment.dart';
import 'package:social_app/components/like.dart';
import 'package:social_app/database/firestore.dart';
import 'package:social_app/pages/post_open_page.dart';

class MyListTile extends StatefulWidget {
  final String title;
  final String useremail;
  final String leadingTime;
  final String docID;
  final List<dynamic> likes;
  // final String docID;
  final String username;
  final int index;
  // final String useremail;

  const MyListTile({
    super.key,
    required this.title,
    required this.useremail,
    required this.leadingTime,
    required this.docID,
    required this.likes,
    required this.username,
    required this.index,
    // required this.useremail,
    // required this.docID,
  });

  @override
  State<MyListTile> createState() => _MyListTileState();
}

class _MyListTileState extends State<MyListTile> {
  FirestoreDatabase firestoreDatabase = FirestoreDatabase();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, '/postPage',arguments: widget.docID);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostOpenPage(
              docID: widget.docID,
              likes: widget.likes,
              username: widget.username,
              dateTime: widget.leadingTime,
              useremail: widget.useremail,
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
                  const CircleAvatar(),
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
                            Text(widget.username),
                            Text(
                              "  ${widget.useremail}",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary),
                            ),
                          ],
                        ),
                        Text(
                          widget.title,
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
                              likes: widget.likes,
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

/**Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Divider(
          thickness: 0.5,
        ),
        ListTile(
          leading: CircleAvatar(),
          onTap: () {
            // Navigator.pushNamed(context, '/postPage',arguments: widget.docID);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostOpenPage(
                  docID: widget.docID,
                  likes: widget.likes,
                  username: widget.username,
                  dateTime: widget.leadingTime,
                  useremail: widget.useremail,
                ),
              ),
            );
          },
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          title: Text(
            widget.title,
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            "${widget.useremail} . ${widget.leadingTime}",
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Bookmark
              Bookmark(docID: widget.docID),
              // Comment
              const Comment(),
              // Like
              LikeButton(
                postID: widget.docID,
                likes: widget.likes,
              ),
            ],
          ),
        ),
      ],
    ); */
