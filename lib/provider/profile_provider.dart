import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  User? user = FirebaseAuth.instance.currentUser;
  final firestore = FirebaseFirestore.instance.collection("post");

  Future<void> fetchDetailsOfUser() async {
    final snapshot =
        await firestore.where('useremail', isEqualTo: user!.email).get();
    _userModel = snapshot.docs.map((e) => PostModel.fromFirestore(e)).first;
    notifyListeners();
  }

  Future<void> fetchPostsByUser() async {
    final snapshot =
        await firestore.where('useremail', isEqualTo: user!.email).get();
    _usersPostList =
        snapshot.docs.map((doc) => PostModel.fromFirestore(doc)).toList();
    notifyListeners();
  }

  
  Future<void> deletePost(PostModel model) async {
    await firestore.doc(model.id).delete();
    fetchPostsByUser();
  }
}
