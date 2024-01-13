// ignore_for_file: file_names
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/components/drawer.dart';
import 'package:social_app/components/my_list_tile.dart';
import 'package:social_app/models/posts_model.dart';
import 'package:social_app/provider/posts_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController postController = TextEditingController();
  List<PostModel> postList = [];

  @override
  void initState() {
    Provider.of<PostsProvider>(context, listen: false).fetchPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        toolbarHeight: MediaQuery.sizeOf(context).height * 0.08,
        title: const Text("P O S T S"),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      drawer: const MyDrawer(),
      // floatingActionButton:
      body: Stack(
        children: [
          Consumer<PostsProvider>(
            builder: (context, value, child) {
              log("In Home Consumer");
              final postList = value.list;
              return Center(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: postList.length,
                        itemBuilder: (context, index) {
                          return MyListTile(
                            docID: postList[index].id,
                            index: index,
                            postModel: postList[index],
                            date: postList[index].timestamp.toString(),
                          );
                        },
                      ),
                    ),
                  ],
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
              onPressed: () => context
                  .read<PostsProvider>()
                  .showDailog(context, postController),
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
