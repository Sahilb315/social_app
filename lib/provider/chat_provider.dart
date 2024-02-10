import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_app/models/message_model.dart';

class ChatProvider extends ChangeNotifier {
  List<MessageModel> _messagesList = [];
  List<MessageModel> get messagesList => _messagesList;

  Future<void> addMessage(MessageModel model) async {
    List ids = [model.senderEmail, model.receiverEmail];
    ids.sort();
    String chatroomID = ids.join('_');
    FirebaseFirestore.instance
        .collection('chatroom')
        .doc(chatroomID)
        .collection('messages')
        .add({
      'message': model.message,
      'senderEmail': model.senderEmail,
      'receiverEmail': model.receiverEmail,
      'messageSent': model.messageSent,
    });
    getMessages(receiverEmail: model.receiverEmail, senderEmail: model.senderEmail);
  }

  Future<void> getMessages(
      {required String receiverEmail, required String senderEmail}) async {
    List ids = [senderEmail, receiverEmail];
    ids.sort();
    String chatroomID = ids.join('_');
    final data = await FirebaseFirestore.instance
        .collection('chatroom')
        .doc(chatroomID)
        .collection('messages')
        .orderBy('messageSent')
        .get();

    _messagesList =
        data.docs.map((doc) => MessageModel.fromMap(doc.data())).toList();
    notifyListeners();
  }
}
