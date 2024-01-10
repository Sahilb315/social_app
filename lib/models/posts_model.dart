import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PostModel {
  String? username;
  String? useremail;
  String? postmessage;
  List<dynamic>? like;
  Timestamp? timestamp;

  PostModel({
    required this.username,
    required this.useremail,
    required this.postmessage,
    required this.like,
    required this.timestamp,
  });

  formatDate(Timestamp? timestamp) {
    final date = timestamp!.toDate();
    final formatDate = DateFormat("yyyy-MM-dd").format(date);
    return formatDate;
  }

  PostModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    useremail = json['useremail'];
    postmessage = json['postmessage'];
    timestamp = json['timestamp'];
    like = json['like'];
  }
}
