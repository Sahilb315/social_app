// ignore_for_file: prefer_final_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  List<UserModel> _usersList = [];

  List<UserModel> get usersList => _usersList;

  List<UserModel> _chattedUserList = [];

  List<UserModel> get chattedUserList => _chattedUserList;

  final userFirebase = FirebaseFirestore.instance.collection('user');
  final chatroomFirebase = FirebaseFirestore.instance.collection('chatroom');

  Future<void> getAllNonChattedUsers() async {
    final data = await userFirebase
        .where('email', isNotEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();

    /// [Users with whom the current user has not chatted]
    
    // List<UserModel> allUsersList =
    //     data.docs.map((user) => UserModel.fromFirestore(user)).toList();
    // for (var element in allUsersList) {
    //   if (!_chattedUserList.contains(element) &&
    //       /!_usersList.contains(element)) {
    //     _usersList.add(element);
    //   }
    // }

    /// All Users using the App
    _usersList = data.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
    notifyListeners();
  }

  Future<void> getChattedUsers() async {
    _chattedUserList.clear();
    final chatroom = await chatroomFirebase.get();

    List<String> docsID = [];

    /// Getting all the docID's from the chatroom collection
    for (var element in chatroom.docs) {
      docsID.add(element.id);
    }
    // This contains the splitted Emails(DocIDs)
    List<List<String>> allUsers = [];
    // Splitting all the docIDs which contains his email
    for (var i = 0; i < docsID.length; i++) {
      if (docsID[i]
          .contains(FirebaseAuth.instance.currentUser!.email.toString())) {
        allUsers.add(docsID[i].split('_'));
      }
    }
    // All users emails with whom the current has chatted even once
    List<String> otherUsersEmails = [];
    for (int i = 0; i < allUsers.length; i++) {
      /// DocID eg. :- rohan@gmail.com_sahil@gmail.com
      // This is how allUsers list looks like [[rohan@gmail.com, sahil@gmail.com],[...], [...],..]
      /// In this if statement it checks if the list inside the allUsersList contains the current user email & if it does not
      /// contains the current user email that means the user has never chatted with that user
      if (allUsers[i]
          .contains(FirebaseAuth.instance.currentUser!.email.toString())) {
        for (int j = 0; j <= 1; j++) {
          /// In the below if statement it just filter outs the current user email and adds only the other user emailID
          if (allUsers[i][j] !=
              FirebaseAuth.instance.currentUser!.email.toString()) {
            otherUsersEmails.add(allUsers[i][j]);
          }
        }
      }
    }
    // This is the Last Step: Adding all the Users from the otherUserEmail list in my chattedUsersList
    for (int i = 0; i < otherUsersEmails.length; i++) {
      final userEmails = await userFirebase.doc(otherUsersEmails[i]).get();
      if (_chattedUserList.contains(UserModel.fromFirestore(userEmails))) {
        return;
      }
      _chattedUserList.add(UserModel.fromFirestore(userEmails));
    }
    notifyListeners();
  }

  Future<Map<String, String>> getLatestMessage() async {
    String firstID = FirebaseAuth.instance.currentUser!.email.toString();
    List allIDs = [];
    for (var item in _usersList) {
      allIDs.add(item);
    }

    Map<String, String> messages = {};
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
        messages.addAll({
          data.docs.first.data()['receiverEmail']:
              data.docs.first.data()['message']
        });
      }
    }
    return messages;
  }
}
