// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/components/drawer.dart';
import 'package:social_app/components/post_tile.dart';
import 'package:social_app/models/posts_model.dart';
import 'package:social_app/provider/comments_povider.dart';
import 'package:social_app/provider/posts_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController postController = TextEditingController();
  List<PostModel> postList = [];
  late User? user;

  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    if (Provider.of<PostsProvider>(context, listen: false).dataIsFetched ==
        false) {
      Provider.of<PostsProvider>(context, listen: false).fetchPosts();
      Provider.of<PostsProvider>(context, listen: false).setDataFetch(true);
    } else {}
    Provider.of<PostsProvider>(context, listen: false).user =
        FirebaseAuth.instance.currentUser;
    user = FirebaseAuth.instance.currentUser!;
    Provider.of<CommentsProvider>(context, listen: false).user =
        FirebaseAuth.instance.currentUser!;
    log(FirebaseAuth.instance.currentUser!.photoURL.toString());
    super.initState();
  }

  Future<void> refresh() async {
    user = FirebaseAuth.instance.currentUser!;
    Provider.of<PostsProvider>(context, listen: false).fetchPosts();
  }

  final commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      key: _scaffoldState,
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        leading: Builder(
          builder: (context) => GestureDetector(
            onTap: () => _scaffoldState.currentState!.openDrawer(),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: CircleAvatar(
                foregroundImage: NetworkImage(user!.photoURL.toString()),
              ),
            ),
          ),
        ),
        title: const Text("P O S T S"),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      drawer: const MyDrawer(),
      body: context.watch<PostsProvider>().currentStatus == DataStatus.fetching
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            )
          : RefreshIndicator.adaptive(
              color: Theme.of(context).colorScheme.inversePrimary,
              onRefresh: refresh,
              child: Stack(
                children: [
                  Consumer2<PostsProvider, CommentsProvider>(
                    builder: (context, postProvider, commentProvider, child) {
                      log("Home Page Consumer");
                      final postList = postProvider.list;
                      return Center(
                        child: ListView.builder(
                          itemCount: postList.length,
                          itemBuilder: (context, index) {
                            final postModel = postList[index];
                            return PostTile(
                              docID: postModel.id,
                              index: index,
                              postModel: postModel,
                              date: postModel.timestamp.toString(),
                              onBookmarkPressed: () {
                                postProvider.updatePostBookmark(
                                  postModel.id,
                                  index,
                                );
                              },
                              onCommentPressed: () {
                                commentProvider.addCommentSheet(
                                  context,
                                  commentController,
                                  postModel.id,
                                  postModel.username,
                                );
                              },
                              onLikePressed: () {
                                postProvider.updatePostLike(
                                  postModel.id,
                                  index,
                                );
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 20,
                    right: 15,
                    child: FloatingActionButton(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      shape: const StadiumBorder(),
                      onPressed: () => Provider.of<PostsProvider>(
                        context,
                        listen: false,
                      ).addPostsSheet(
                        context,
                        postController,
                      ),
                      child: const Icon(Icons.add),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
