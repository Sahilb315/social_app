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

  @override
  void initState() {
    Provider.of<PostsProvider>(context, listen: false).fetchPosts();
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

  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                // foregroundImage: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTV5lof4YCEqxL3U1KVac7UgbdG6SG8bfs0hWoVkqJ2w4GIeujd_ps78_loMw&s"),
              ),
            ),
          ),
        ),
        // toolbarHeight: MediaQuery.sizeOf(context).height * 0.06,
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
                  Consumer<PostsProvider>(
                    builder: (context, value, child) {
                      final postList = value.list;
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
                            );
                          },
                        ),
                      );
                    },
                  ),
                  // Consumer<PostsProvider>(
                  //   builder: (context, value, child) {
                  //     final postList = value.list;
                  //     return Center(
                  //       child: ListView(
                  //         children: List.generate(
                  //           value.list.length,
                  //           (index) {
                  //             return PostTile(
                  //               docID: postList[index].id,
                  //               index: index,
                  //               postModel: postList[index],
                  //               date: postList[index].timestamp.toString(),
                  //             );
                  //           },
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // ),
                  Positioned(
                    bottom: 20,
                    right: 15,
                    child: FloatingActionButton(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      shape: const StadiumBorder(),
                      onPressed: () =>
                          Provider.of<PostsProvider>(context, listen: false)
                              .addPostsSheet(context, postController),
                      child: const Icon(Icons.add),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
