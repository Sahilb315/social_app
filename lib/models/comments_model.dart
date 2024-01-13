import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String commentedBy;
  final String commentedEmail;
  final String content;
  final String timestamp;

  CommentModel({
    required this.commentedBy,
    required this.commentedEmail,
    required this.content,
    required this.timestamp,
  });

  factory CommentModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CommentModel(
      commentedBy: data['commentedBy'],
      commentedEmail: data['commentedEmail'],
      content: data['content'],
      timestamp: data['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['commentedBy'] = commentedBy;
    data['commentedEmail'] = commentedEmail;
    data['content'] = content;
    data['timestamp'] = timestamp;
    return data;
  }
}
