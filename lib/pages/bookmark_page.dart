import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/components/bookmark_tile.dart';
import 'package:social_app/pages/post_open_page.dart';
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
    Provider.of<BookmarkProvider>(context, listen: false).user =
        FirebaseAuth.instance.currentUser!;
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
            builder: (context, bookmarkProvider, post, child) {
              return Expanded(
                child: ListView.builder(
                  itemCount: bookmarkProvider.bookmarks.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  PostOpenPage(
                            username: bookmarkProvider.bookmarks[index].username,
                            docID: bookmarkProvider.bookmarks[index].id,
                            postModel: bookmarkProvider.bookmarks[index],
                            // profileUrl: profileUrl,
                          ),
                        ),
                      ),
                      child: MyBookmarkListTile(
                        postModel: bookmarkProvider.bookmarks[index],
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
