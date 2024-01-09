import 'package:flutter/material.dart';

class MyUserListTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final String leadingTime;
  
  const MyUserListTile({
    super.key,
    required this.title,
    required this.subTitle,
    required this.leadingTime,
  });


  @override
  Widget build(BuildContext context) {
    return Padding(
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
          
        ),
      ),
    );
  }
}
