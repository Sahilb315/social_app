import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/helper/hashtag.dart';
import 'package:social_app/models/comments_model.dart';
import 'package:social_app/models/posts_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/pages/posts_user_profile.dart';
import 'package:social_app/pages/profile_page.dart';

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
  Future<DocumentSnapshot> getProfileUrl() async {
    final userCollection = FirebaseFirestore.instance.collection("user");
    final doc =
        await userCollection.doc(widget.commentModel.commentedEmail).get();
    return doc;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                future: getProfileUrl(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircleAvatar(
                      foregroundImage: NetworkImage(
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTV5lof4YCEqxL3U1KVac7UgbdG6SG8bfs0hWoVkqJ2w4GIeujd_ps78_loMw&s",
                      ),
                    );
                  }
                  final doc = snapshot.data!.data() as Map;
                  final data = doc['profileUrl'];
                  UserModel userModel = UserModel.fromFirestore(snapshot.data!);
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          if (FirebaseAuth.instance.currentUser!.email ==
                              widget.postModel.useremail) {
                            return const ProfilePage();
                          }
                          return PostUserProfile(
                            userModel: userModel,
                            // postModel: widget.postModel,
                          );
                        },
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
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
                    child: CircleAvatar(
                      foregroundImage: NetworkImage(data),
                    ),
                  );
                },
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
