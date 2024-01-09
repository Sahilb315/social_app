import 'package:flutter/material.dart';
import 'package:social_app/database/firestore.dart';

class UserListTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final String leadingTime;
  final String docID;
   UserListTile({super.key, required this.title, required this.subTitle, required this.leadingTime, required this.docID});

  final FirestoreDatabase firestore = FirestoreDatabase();
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          title: Text(title),
          subtitle: Text(
            "$subTitle . $leadingTime",
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
          trailing: IconButton(onPressed:()=> firestore.deletePost(docID), icon:const Icon(Icons.delete)),
        ),
      ),
    );
  }
}