
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/components/list_tile_bookmark.dart';
import 'package:social_app/helper/format_date.dart';
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
                    return MyBookmarkListTile(
                      title: value.bookmarks[index].username,
                      subTitle: value.bookmarks[index].postmessage,
                      leadingTime: formatDate(value.bookmarks[index].timestamp),
                      docID: value.bookmarks[index].id,
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
