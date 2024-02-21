import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_app/components/post_tile_icons.dart';
import 'package:social_app/helper/hashtag.dart';
import 'package:social_app/models/posts_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/pages/posts_user_profile.dart';
import 'package:social_app/pages/profile_page.dart';
import 'package:timeago/timeago.dart' as timeago;

class MyBookmarkListTile extends StatefulWidget {
  final PostModel postModel;
  const MyBookmarkListTile({
    super.key,
    required this.postModel,
  });

  @override
  State<MyBookmarkListTile> createState() => _MyBookmarkListTileState();
}

class _MyBookmarkListTileState extends State<MyBookmarkListTile> {
  Future<DocumentSnapshot> getProfile() async {
    final userCollection = FirebaseFirestore.instance.collection("user");
    final doc = await userCollection.doc(widget.postModel.useremail).get();
    return doc;
  }

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser!;
    super.initState();
  }

  User? user;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.02,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder(
                  future: getProfile(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      UserModel userModel =
                          UserModel.fromFirestore(snapshot.data!);

                      final doc = snapshot.data!.data() as Map<String, dynamic>;
                      String data = doc["profileUrl"];
                      // profileUrl = data;
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              if (FirebaseAuth.instance.currentUser!.email ==
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
                        child: CircleAvatar(
                          foregroundImage: NetworkImage(data),
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
                            widget.postModel.username.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          FutureBuilder(
                            future: getProfile(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final doc = snapshot.data!.data()
                                    as Map<String, dynamic>;
                                String data = doc["username"];
                                return Text(
                                  " @$data",
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                );
                              }
                              return const Text("");
                            },
                          ),
                          Text(
                            " ${timeago.format(widget.postModel.timestamp.toDate(), locale: 'en_short')}",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
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
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconsContainer(
                            value: true,
                            iconFalse: CupertinoIcons.bookmark,
                            iconTrue: CupertinoIcons.bookmark_fill,
                            onPressed: () {},
                            colorTrue: Colors.blue,
                            text: widget.postModel.bookmark.length.toString(),
                          ),
                          IconsContainer(
                            value: true,
                            iconFalse: CupertinoIcons.repeat,
                            iconTrue: CupertinoIcons.repeat,
                            onPressed: () {},
                          ),
                          IconsContainer(
                            value: true,
                            iconFalse: CupertinoIcons.bubble_left,
                            iconTrue: CupertinoIcons.bubble_left,
                            onPressed: () {},
                          ),
                          IconsContainer(
                            value: widget.postModel.like.contains(user!.email),
                            iconFalse: CupertinoIcons.heart,
                            iconTrue: CupertinoIcons.heart_fill,
                            onPressed: () {},
                            colorTrue: Colors.red,
                            text: widget.postModel.like.length.toString(),
                          ), // Icon(CupertinoIcons.bookmark),
                          const SizedBox(),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.grey,
            thickness: 0.3,
          )
        ],
      ),
    );
  }
}
