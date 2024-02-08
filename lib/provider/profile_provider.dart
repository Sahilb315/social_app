import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_app/models/comments_model.dart';
import 'package:social_app/models/posts_model.dart';
import 'package:social_app/models/user_model.dart';

class ProfileProvider extends ChangeNotifier {
  List<PostModel> _usersPostList = [];
  List<PostModel> get usersPostList => _usersPostList;
  UserModel _userModel = UserModel(
    profileUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTV5lof4YCEqxL3U1KVac7UgbdG6SG8bfs0hWoVkqJ2w4GIeujd_ps78_loMw&s",
    dob: "",
    name: "",
    email: "",
    username: "",
    joined: "",
    bio: "",
    location: "",
    field: "",
    followers: 0,
    following: 0,
  );
  UserModel get userModel => _userModel;

  List<CommentModel> _usersReplies = [];
  List<CommentModel> get usersReplies => _usersReplies;

  final postsFirestore = FirebaseFirestore.instance.collection("post");
  final userFirestore = FirebaseFirestore.instance.collection("user");

  Future<void> editUserProfileDetails({
    required String? email,
    required String name,
    required String bio,
    required String location,
    required String field,
     String? profileUrl,
  }) async {
    await userFirestore.doc(email).update({
      'bio': bio,
      'name': name,
      'field': field,
      'location': location,
      'profileUrl': profileUrl
    });
    log("Updated user ${_userModel.toMap().toString()}");
    fetchDetails(email);
    notifyListeners();
    // log("Updated user ${_userModel.toMap().toString()}");
  }

  Future<void> fetchDetails(String? email) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('user')
        .where('email', isEqualTo: email)
        .get();
    _userModel = snapshot.docs.map((e) => UserModel.fromFirestore(e)).first;
    log(_userModel.toMap().toString());
    notifyListeners();
  }

  Future<void> fetchPostsByUser(String? email) async {
    final snapshot =
        await postsFirestore.where('useremail', isEqualTo: email).get();
    _usersPostList =
        snapshot.docs.map((doc) => PostModel.fromFirestore(doc)).toList();
    notifyListeners();
  }

  Future<void> fetchRepliesByUser(String? email) async {
    final snapshot = await postsFirestore
        .doc("YiMgK6p7EwkQPxVdd8xT")
        .collection('comments')
        .where("commentedEmail", isEqualTo: email)
        .get();
    _usersReplies =
        snapshot.docs.map((doc) => CommentModel.fromFirestore(doc)).toList();
    notifyListeners();
  }

  Future<void> deletePost(String id, String? email) async {
    await postsFirestore.doc(id).delete();
    fetchPostsByUser(email);
    notifyListeners();
  }
}
