import 'package:flutter/material.dart';
import 'package:social_app/database/firestore.dart';

class Bookmark extends StatefulWidget {
  final String docID;
  const Bookmark({Key? key, required this.docID}) : super(key: key);

  @override
  State<Bookmark> createState() => _BookmarkState();
}

class _BookmarkState extends State<Bookmark> {
  FirestoreDatabase firestoreDatabase = FirestoreDatabase();
  bool bookmarkedOrNot = false;

  void onPressedBookmark() {
    setState(() {
      bookmarkedOrNot = !bookmarkedOrNot;
    });

    if (bookmarkedOrNot) {
      firestoreDatabase.updatePostData(widget.docID, true);
    } else {
      firestoreDatabase.updatePostData(widget.docID, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        bookmarkedOrNot
            ? IconButton(
                onPressed: onPressedBookmark,
                icon: const Icon(Icons.bookmark),
              )
            : IconButton(
                onPressed: onPressedBookmark,
                icon: const Icon(Icons.bookmark_add_outlined),
              ),
      ],
    );
  }
}
