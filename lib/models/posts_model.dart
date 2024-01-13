import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app/helper/format_date.dart';

class PostModel {
  final String id;
  final String username;
  final String useremail;
  final String postmessage;
  final List<dynamic> like;
  final Timestamp timestamp;
  final List bookmark;

  PostModel({
    required this.id,
    required this.username,
    required this.useremail,
    required this.postmessage,
    required this.like,
    required this.timestamp,
    required this.bookmark,
  });

  factory PostModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return PostModel(
      id: data['id'] ?? "",
      username: data['username'],
      useremail: data['useremail'],
      postmessage: data['postmessage'],
      like: data['like'],
      timestamp: data['timestamp'],
      bookmark: data['bookmark'],
    );
  }

  Map<String, dynamic> toMap(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['useremail'] = useremail;
    data['postmessage'] = postmessage;
    data['like'] = like;
    data['timestamp'] = formatDate(timestamp);
    data['bookmark'] = bookmark;
    return data;
  }


}
