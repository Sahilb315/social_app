import 'package:flutter/material.dart';
import 'package:social_app/database/firestore.dart';
import 'package:social_app/helper/hashtag.dart';
import 'package:social_app/models/comments_model.dart';
import 'package:social_app/models/posts_model.dart';

class CommentTile extends StatefulWidget {
  final CommentModel commentModel;
  final PostModel postModel;

  const CommentTile({
    super.key,
    required this.commentModel,
    required this.postModel,
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
        Padding(
          padding: const EdgeInsets.symmetric(vertical:8.0),
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
                        Text(
                          widget.commentModel.commentedBy.toString(),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          "Replying to",
                        ),
                        Text(
                          " @${widget.postModel.username}",
                          style: TextStyle(
                            color: Colors.blue.shade700,
                          ),
                        )
                      ],
                    ),
                    HashtagView(
                      text: widget.commentModel.content.toString(),
                      maxLines: null,
                      textOverflow: TextOverflow.visible,
                      textSize: 14,
                    ),
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
