import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  List<UserModel> _usersList = [];

  List<UserModel> get usersList => _usersList;

  final userFirebase = FirebaseFirestore.instance.collection('user');

  Future<void> getAllUsers() async {
    final data = await userFirebase
        .where('email', isNotEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();
    _usersList =
        data.docs.map((user) => UserModel.fromFirestore(user)).toList();
    notifyListeners();
  }

  Future<Map<int, String>> getLatestMessage() async {
    String firstID = FirebaseAuth.instance.currentUser!.email.toString();
    List allIDs = [];
    for (var item in _usersList) {
      allIDs.add(item);
    }
    Map<int, String> messages = {};
    for (int i = 0; i < allIDs.length; i++) {
      String secondID = allIDs[i].email.toString();
      List ids = [firstID, secondID];
      ids.sort();
      String chatroomID = ids.join('_');
      final data = await FirebaseFirestore.instance
          .collection('chatroom')
          .doc(chatroomID)
          .collection('messages')
          .orderBy('messageSent', descending: true)
          .limit(1)
          .get();
      if (data.docs.isNotEmpty) {
        messages.addAll({i: data.docs.first.data()['message']});
      }
    }
    return messages;
  }
}

