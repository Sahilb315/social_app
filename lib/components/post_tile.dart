import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/components/post_tile_icons.dart';
import 'package:social_app/helper/hashtag.dart';
import 'package:social_app/helper/timeago_messages.dart';
import 'package:social_app/models/posts_model.dart';
import 'package:social_app/pages/post_open_page.dart';
import 'package:social_app/provider/comments_povider.dart';
import 'package:social_app/provider/posts_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostTile extends StatefulWidget {
  final String docID;
  final int index;
  final PostModel postModel;
  final String date;

  const PostTile({
    super.key,
    required this.docID,
    required this.index,
    required this.postModel,
    required this.date,
  });

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  late final user;
  final commentController = TextEditingController();
  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    timeago.setLocaleMessages('my_en', MyCustomMessages());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                PostOpenPage(
              docID: widget.docID,
              postModel: widget.postModel,
              index: widget.index,
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              var begin = const Offset(1.0, 0.0);
              var end = Offset.zero;
              var curve = Curves.ease;
              final tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
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
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    foregroundImage: NetworkImage(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTvi7HpQ-_PMSMOFrj1hwjp6LDcI-jm3Ro0Xw&usqp=CAU",
                    ),
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
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //?   BOOKMARK
                                  IconsContainer(
                                    value: postProvider
                                        .list[widget.index].bookmark
                                        .contains(user!.email),
                                    text: postProvider
                                        .list[widget.index].bookmark.length
                                        .toString(),
                                    iconFalse: CupertinoIcons.bookmark,
                                    iconTrue: CupertinoIcons.bookmark_fill,
                                    colorTrue:
                                        Theme.of(context).colorScheme.secondary,
                                    onPressed: () {
                                      postProvider.updatePostBookmark(
                                        widget.docID,
                                        widget.index,
                                      );
                                    },
                                  ),
                                  //?   RETWEET
                                  IconsContainer(
                                    value: false,
                                    iconFalse: CupertinoIcons.repeat,
                                    iconTrue: CupertinoIcons.repeat,
                                    onPressed: () {},
                                    colorTrue: Colors.green,
                                  ),
                                  //?   COMMENT
                                  IconsContainer(
                                    value: true,
                                    iconFalse: CupertinoIcons.bubble_left,
                                    iconTrue: CupertinoIcons.bubble_left,
                                    colorTrue: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                    onPressed: () {
                                      commentProvider.addCommentSheet(
                                        context,
                                        commentController,
                                        widget.docID,
                                        postProvider
                                            .list[widget.index].username,
                                      );
                                    },
                                  ),
                                  //?   LIKE
                                  IconsContainer(
                                    value: postProvider.list[widget.index].like
                                        .contains(user!.email),
                                    text: postProvider
                                        .list[widget.index].like.length
                                        .toString(),
                                    iconFalse: CupertinoIcons.heart,
                                    iconTrue: CupertinoIcons.heart_fill,
                                    colorTrue: Colors.red,
                                    onPressed: () {
                                      postProvider.updatePostLike(
                                        widget.docID,
                                        widget.index,
                                      );
                                    },
                                  ),
                                  // To arrange the icons
                                  const SizedBox()
                                ],
                              ),
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
