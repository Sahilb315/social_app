import 'package:flutter/material.dart';
import 'package:social_app/database/firestore.dart';

class MyBookmarkListTile extends StatefulWidget {
  final String title;
  final String subTitle;
  final String leadingTime;
  final String docID;

  const MyBookmarkListTile({
    super.key,
    required this.title,
    required this.subTitle,
    required this.leadingTime, required this.docID,
  });

  @override
  State<MyBookmarkListTile> createState() => _MyBookmarkListTileState();
}

class _MyBookmarkListTileState extends State<MyBookmarkListTile> {
  bool bookmarkOrNot = true;
  FirestoreDatabase firestoreDatabase = FirestoreDatabase();

  void Function()? onPressed() {
    setState(() {
      bookmarkOrNot = !bookmarkOrNot;
    });
    if(bookmarkOrNot == false){
      firestoreDatabase.updatePostData(widget.docID, false);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          title: Text(widget.title),
          subtitle: Text(
            "${widget.subTitle} . ${widget.leadingTime}",
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
          trailing: bookmarkOrNot
              ? IconButton(
                  onPressed: onPressed, icon: const Icon(Icons.bookmark))
              : IconButton(
                  onPressed: onPressed,
                  icon: const Icon(Icons.bookmark_add_outlined),
                ),
        ),
      ),
    );
  }
}
