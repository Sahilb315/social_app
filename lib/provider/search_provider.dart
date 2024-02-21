import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/models/user_model.dart';

class SearchProvider extends ChangeNotifier {
  List<UserModel> _users = [];
  List<UserModel> get users => _users;

  List<UserModel> _searchedUsers = [];
  List<UserModel> get searchedUsers => _searchedUsers;

  final userFirebase = FirebaseFirestore.instance.collection('user');

  Future<void> getAllUsers() async {
    final data = await userFirebase
        .where('email', isNotEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();
    _users = data.docs.map((user) => UserModel.fromFirestore(user)).toList();
    notifyListeners();
  }

  void addUser(UserModel model) {
    
    _searchedUsers.add(model);
    notifyListeners();
  }

  void clearList() {
    log('Clear List');
    _searchedUsers.clear();
    notifyListeners();
  }
}
