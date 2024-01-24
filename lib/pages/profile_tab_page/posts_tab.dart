import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/helper/hashtag.dart';
import 'package:social_app/provider/comments_povider.dart';
import 'package:social_app/provider/posts_provider.dart';
import 'package:social_app/provider/profile_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class ProfilePostsTabPage extends StatelessWidget {
  const ProfilePostsTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ProfileProvider>(
        builder: (context, value, child) {
          return ListView.builder(
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
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          //* Bookmark
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              right: 3.0,
                                            ),
                                            child: Icon(
                                              CupertinoIcons.bookmark,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .inversePrimary,
                                            ),
                                          ),
                                          Text(
                                            postProvider
                                                .list[index].bookmark.length
                                                .toString(),
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),

                                          //* Comment
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              right: 3.0,
                                            ),
                                            child: Icon(
                                              CupertinoIcons.bubble_left,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .inversePrimary,
                                            ),
                                          ),
                                          Text(commentProvider.comments.length
                                              .toString()),
                                          const SizedBox(
                                            width: 15,
                                          ),

                                          //* Like
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              right: 3.0,
                                            ),
                                            child: Icon(
                                              CupertinoIcons.heart,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .inversePrimary,
                                            ),
                                          ),
                                          Text(
                                            postProvider.list[index].like.length
                                                .toString(),
                                          ),
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
      ),
    );
  }
}
