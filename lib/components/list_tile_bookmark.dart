import 'package:flutter/material.dart';

class MyBookmarkListTile extends StatefulWidget {
  final String title;
  final String subTitle;
  final String leadingTime;
  final String docID;
  // final VoidCallback onPressed;
  // final bool bookmarkValue;

  const MyBookmarkListTile({
    super.key,
    required this.title,
    required this.subTitle,
    required this.leadingTime,
    required this.docID,
    // required this.onPressed,
    // required this.bookmarkValue,
  });

  @override
  State<MyBookmarkListTile> createState() => _MyBookmarkListTileState();
}

class _MyBookmarkListTileState extends State<MyBookmarkListTile> {
  bool bookmarkOrNot = true;

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
          // trailing: IconButton(
          //   onPressed: widget.onPressed,
          //   icon: widget.bookmarkValue
          //       ? const Icon(CupertinoIcons.bookmark_fill)
          //       : const Icon(CupertinoIcons.bookmark),
          // ),
        ),
      ),
    );
  }
}
