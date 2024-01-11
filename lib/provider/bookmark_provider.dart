// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:social_app/models/posts_model.dart';
import 'package:flutter/material.dart';

class BookmarkProvider extends ChangeNotifier {
  bool _isBookmarked = false;

  bool get bookmark => _isBookmarked;

  void setBookmark(bool value) {
    _isBookmarked = value;
    notifyListeners();
  }

  // PostModel? postModel;
  // fetchBookmark() async {
  //   final data = await FirebaseFirestore.instance
  //       .collection('post')
  //       // .where('bookmark')
  //       .get();
  //   for (var element in data.docs) {
  //     postModel = PostModel(
  //       username: element.get('username'),
  //       useremail: element.get('useremail'),
  //       postmessage: element.get('postmessage'),
  //       like: element.get('like'),
  //       timestamp: element.get('timestamp'),
  //       bookmark: element.get('bookmark'),
  //     );
  //   print(postModel!.username);
  //   print(postModel!.useremail);
  //   print(postModel!.like);
  //   print(postModel!.bookmark);
  //   print(postModel!.timestamp);
  //   }
  // }
}
