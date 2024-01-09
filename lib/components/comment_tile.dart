import 'package:flutter/material.dart';
import 'package:social_app/database/firestore.dart';

class CommentTile extends StatefulWidget {
  final String content;
  final String useremail;
  final String leadingTime;
  final String docID;
  // final String docID;
  final String username;
  final String tweetedUsername;
// final String useremail;

  const CommentTile({
    super.key,
    required this.content,
    required this.useremail,
    required this.leadingTime,
    required this.docID,
    required this.username,
    
    required this.tweetedUsername,
    // required this.useremail,
    // required this.docID,
  });

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  FirestoreDatabase firestoreDatabase = FirestoreDatabase();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // widget.index == 0
        //     ? const Divider(
        //         thickness: 0.4,
        //       )
        //     : const SizedBox.shrink(),
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
                        Text("  ${widget.useremail}")
                      ],
                    ),
                    Row(
                      children: [
                        const Text("Replying to"),
                        Text(
                          " @${widget.tweetedUsername}",
                          style: TextStyle(
                            color: Colors.blue.shade700,
                          ),
                        )
                      ],
                    ),
                    // Text("Replying to @${widget.tweetedUsername}"),
                    Text(
                      widget.content,
                      maxLines: 6,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     Bookmark(docID: widget.docID),
                    //     Comment(
                    //       docID: widget.docID,
                    //     ),
                    //     LikeButton(
                    //       postID: widget.docID,
                    //       likes: widget.likes,
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(
          thickness: 0.4,
        ),
      ],
    );
  }
}
