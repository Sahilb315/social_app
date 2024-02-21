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
    profileUrl:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTV5lof4YCEqxL3U1KVac7UgbdG6SG8bfs0hWoVkqJ2w4GIeujd_ps78_loMw&s",
    dob: "",
    name: "",
    email: "",
    username: "",
    joined: "",
    bio: "",
    location: "",
    field: "",
    followers: [],
    following: [],
  );
  UserModel get userModel => _userModel;

  UserModel _currentUserModel = UserModel(
    profileUrl:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTV5lof4YCEqxL3U1KVac7UgbdG6SG8bfs0hWoVkqJ2w4GIeujd_ps78_loMw&s",
    dob: "",
    name: "",
    email: "",
    username: "",
    joined: "",
    bio: "",
    location: "",
    field: "",
    followers: [],
    following: [],
  );
  UserModel get currentUserModel => _userModel;

  List<CommentModel> _usersReplies = [];
  List<CommentModel> get usersReplies => _usersReplies;

  final postsFirestore = FirebaseFirestore.instance.collection("post");
  final userFirestore = FirebaseFirestore.instance.collection("user");

  Future<void> followOrUnfollowUser(
      UserModel model, String currentUserEmail) async {
    if (model.followers.contains(currentUserEmail)) {
      /// Updating the value locally in the models

      /// Updating the followers of the user whom the current user followed/unfollowed
      _userModel.followers.remove(currentUserEmail);

      /// Updating the follwoing of the current user whom the current user followed/unfollowed
      _currentUserModel.following.remove(model.email);

      /// Updating the follwoing of the current user whom the current user followed/unfollowed in firestore
      await userFirestore.doc(currentUserEmail).update({
        'following': FieldValue.arrayRemove([model.email]),
      });

      /// Updating the followers of the user whom the current user followed/unfollowed in firestore
      await userFirestore.doc(model.email).update({
        'followers': FieldValue.arrayRemove([currentUserEmail]),
      });
    } else {
      /// Updating the followers of the user whom the current user followed/unfollowed
      _userModel.followers.add(currentUserEmail);

      /// Updating the follwoing of the current user whom the current user followed/unfollowed
      _currentUserModel.following.add(model.email);

      /// Updating the following of the current user whom the current user followed/unfollowed in firestore
      await userFirestore.doc(currentUserEmail).update({
        'following': FieldValue.arrayUnion([model.email]),
      });
      /// Updating the followers of the user whom the current user followed/unfollowed in firestore
      await userFirestore.doc(model.email).update({
        'followers': FieldValue.arrayUnion([currentUserEmail]),
      });
    }
    notifyListeners();
  }

  Future<void> updateCurrentUserFollowing(
      String currentUserEmail, UserModel model) async {
    if (_currentUserModel.following.contains(model.email)) {
      _currentUserModel.following.remove(model.email);
      await userFirestore.doc(currentUserEmail).update({
        'following': FieldValue.arrayRemove([model.email]),
      });
    } else {
      log("adding following ${_currentUserModel.following.contains(model.email)}");
      _currentUserModel.following.add(model.email);
      await userFirestore.doc(currentUserEmail).update({
        'following': FieldValue.arrayUnion([model.email]),
      });
    }
  }

  Future<void> getCurrentUsersModel(String currentUserEmail) async {
    final snap = await userFirestore.doc(currentUserEmail).get();
    _currentUserModel = UserModel.fromFirestore(snap);
    notifyListeners();
  }

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
