import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/helper/hashtag.dart';
import 'package:social_app/provider/comments_povider.dart';
import 'package:social_app/provider/posts_provider.dart';
import 'package:social_app/provider/profile_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    context.read<ProfileProvider>().fetchDetailsOfUser();
    context.read<ProfileProvider>().fetchPostsByUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("P R O F I L E"),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Theme.of(context).colorScheme.primary),
            padding: const EdgeInsets.all(25),
            child: const Icon(
              Icons.person_outline_rounded,
              size: 50,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            context.watch<ProfileProvider>().userModel.username,
            style: const TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            context.watch<ProfileProvider>().userModel.useremail,
            style: const TextStyle(
              fontSize: 25,
            ),
          ),
          Consumer<ProfileProvider>(
            builder: (context, value, child) {
              return Expanded(
                child: ListView.builder(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(value
                                              .usersPostList[index].username
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
                                        text: value
                                            .usersPostList[index].postmessage
                                            .toString(),
                                        maxLines: 6,
                                        textOverflow: TextOverflow.ellipsis,
                                        textSize: 16,
                                      ),
                                      Consumer2<PostsProvider,
                                          CommentsProvider>(
                                        builder: (context, postProvider,
                                            commentProvider, child) {
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 3.0),
                                                  child: Icon(
                                                    CupertinoIcons.bookmark,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .inversePrimary,
                                                  ),
                                                ),
                                                Text(
                                                  postProvider.list[index]
                                                      .bookmark.length
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 16),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 3.0),
                                                  child: Icon(
                                                    CupertinoIcons.bubble_left,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .inversePrimary,
                                                  ),
                                                ),
                                                Text(commentProvider
                                                    .comments.length
                                                    .toString()),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 3.0),
                                                  child: Icon(
                                                    CupertinoIcons.heart,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .inversePrimary,
                                                  ),
                                                ),
                                                Text(
                                                  postProvider
                                                      .list[index].like.length
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
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}




// docID: value.usersPostList[index].id,
//                       index: index,
//                       postModel: value.usersPostList[index],
//                       date: value.usersPostList[index].timestamp.toString(),