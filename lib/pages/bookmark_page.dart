import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/components/post_tile.dart';
import 'package:social_app/provider/bookmarks_provider.dart';
import 'package:social_app/provider/posts_provider.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    Provider.of<BookmarkProvider>(context, listen: false).fetchUsersBookmarks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("B O O K M A R K S"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Consumer2<BookmarkProvider, PostsProvider>(
            builder: (context, value, post, child) {
              return Expanded(
                child: ListView.builder(
                  itemCount: value.bookmarks.length,
                  itemBuilder: (context, index) {
                    return PostTile(
                      docID:  value.bookmarks[index].id,
                      index: index,
                      postModel: post.list[index],
                      date: post.list[index].timestamp.toString(),
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
