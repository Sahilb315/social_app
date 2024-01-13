import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/models/comments_model.dart';
import 'package:social_app/models/posts_model.dart';

class ProfileProvider extends ChangeNotifier {
  List<PostModel> _usersPostList = [];
  PostModel _userModel = PostModel(
    bookmark: [],
    id: "",
    useremail: "",
    username: "",
    like: [],
    postmessage: "",
    timestamp: Timestamp.now(),
  );
  PostModel get userModel => _userModel;
  List<PostModel> get usersPostList => _usersPostList;

  List<CommentModel> _usersReplies = [];
  List<CommentModel> get usersReplies => _usersReplies;

  User? user = FirebaseAuth.instance.currentUser;
  final firestore = FirebaseFirestore.instance.collection("post");

  Future<void> fetchDetailsOfUser(String? email) async {
    final snapshot = await firestore.where('useremail', isEqualTo: email).get();
    _userModel = snapshot.docs.map((e) => PostModel.fromFirestore(e)).first;
    notifyListeners();
  }

  Future<void> fetchPostsByUser(String? email) async {
    final snapshot = await firestore.where('useremail', isEqualTo: email).get();
    _usersPostList =
        snapshot.docs.map((doc) => PostModel.fromFirestore(doc)).toList();
    notifyListeners();
  }

  Future<void> fetchRepliesByUser(String? email) async {
    final snapshot = await firestore
        .doc("YiMgK6p7EwkQPxVdd8xT")
        .collection('comments')
        .where("commentedEmail", isEqualTo: email)
        .get();
    _usersReplies =
        snapshot.docs.map((doc) => CommentModel.fromFirestore(doc)).toList();
    for (var element in _usersReplies) {
      print(element.toMap());
    }
    notifyListeners();
  }

  // Future<void> deletePost(PostModel model) async {
  //   await firestore.doc(model.id).delete();
  //   fetchPostsByUser();
  // }
}
