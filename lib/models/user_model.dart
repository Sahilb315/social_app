import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String username;

  UserModel({
    required this.email,
    required this.username,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      email: data['email'],
      username: data['username'],
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['username'] = username;
    return data;
  }
}
