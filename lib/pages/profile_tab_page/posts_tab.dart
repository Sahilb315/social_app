import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/components/post_tile_icons.dart';
import 'package:social_app/helper/hashtag.dart';
import 'package:social_app/models/posts_model.dart';
import 'package:social_app/provider/comments_povider.dart';
import 'package:social_app/provider/posts_provider.dart';
import 'package:social_app/provider/profile_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class ProfilePostsTabPage extends StatelessWidget {
  final List<PostModel> userPostList;
  const ProfilePostsTabPage({super.key, required this.userPostList});

  @override
  Widget build(BuildContext context) {
    return
        // Scaffold(
        //   body:
        Consumer<ProfileProvider>(
      builder: (context, value, child) {
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: value.usersPostList.length,
          itemBuilder: (context, index) {
            return SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  index == 0
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(value.usersPostList[index].username
                                          .toString()),
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
                                        " ${timeago.format(value.usersPostList[index].timestamp.toDate(), locale: 'en_short')}",
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .inversePrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  PopupMenuButton(
                                    itemBuilder: (context) {
                                      return [
                                        PopupMenuItem(
                                          onTap: () {
                                            value.deletePost(
                                              value.usersPostList[index].id,
                                              value.usersPostList[index]
                                                  .useremail,
                                            );
                                          },
                                          value: "Delete",
                                          child: Text(
                                            "Delete",
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .inversePrimary,
                                            ),
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: "Edit",
                                          child: Text(
                                            "Edit",
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .inversePrimary,
                                            ),
                                          ),
                                        ),
                                      ];
                                    },
                                  )
                                ],
                              ),
                              HashtagView(
                                text: value.usersPostList[index].postmessage
                                    .toString(),
                                maxLines: 6,
                                textOverflow: TextOverflow.ellipsis,
                                textSize: 16,
                              ),
                              Consumer2<PostsProvider, CommentsProvider>(
                                builder: (context, postProvider,
                                    commentProvider, child) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 6,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        //?   BOOKMARK
                                        IconsContainer(
                                          value: false,
                                          iconFalse: CupertinoIcons.bookmark,
                                          iconTrue:
                                              CupertinoIcons.bookmark_fill,
                                          colorTrue: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          onPressed: () {},
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
                                          value: false,
                                          iconFalse: CupertinoIcons.bubble_left,
                                          iconTrue: CupertinoIcons.bubble_left,
                                          colorTrue: Theme.of(context)
                                              .colorScheme
                                              .inversePrimary,
                                          onPressed: () {},
                                        ),
                                        //?   LIKE
                                        IconsContainer(
                                          value: false,
                                          iconFalse: CupertinoIcons.heart,
                                          iconTrue: CupertinoIcons.heart_fill,
                                          colorTrue: Colors.red,
                                          onPressed: () {},
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
            );
          },
        );
      },
    );
    // );
  }
}
