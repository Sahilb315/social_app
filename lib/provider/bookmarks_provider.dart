import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:social_app/models/posts_model.dart';

class BookmarkProvider extends ChangeNotifier {
  List<PostModel> _bookmarks = [];
  List<PostModel> get bookmarks => _bookmarks;

  final firestore = FirebaseFirestore.instance.collection('post');
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> fetchUsersBookmarks() async {
    final snap =
        await firestore.where('bookmark', arrayContains: user!.email).get();
    _bookmarks = snap.docs.map((doc) => PostModel.fromFirestore(doc)).toList();
    notifyListeners();
  }
}
