import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String dob;
  final String email;
  final String name;
  final String username;
  final String joined;
  final String location;
  final String bio;
  final String field;
  final List followers;
  final List following;
  final String profileUrl;

  UserModel({
    required this.location,
    required this.profileUrl,
    required this.followers,
    required this.following,
    required this.bio,
    required this.field,
    required this.joined,
    required this.dob,
    required this.name,
    required this.email,
    required this.username,
  });

  @override
  String toString() {
    return 'UserModel{dob: $dob, email: $email, name: $name, username: $username, joined: $joined, location: $location, bio: $bio, field: $field, followers: $followers, following: $following, profileUrl: $profileUrl}';
  }

  @override
  bool operator ==(covariant UserModel other) => name == other.name && username == other.username;

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      profileUrl: data['profileUrl'],
      followers: data['followers'] ?? [],
      following: data['following'] ?? [],
      location: data['location'] ?? "",
      bio: data['bio'] ?? "",
      field: data['field'] ?? "",
      joined: data['joined'] ?? "",
      dob: data["dob"],
      email: data['email'],
      name: data['name'],
      username: data['username'],
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['username'] = username;
    data['name'] = name;
    data['dob'] = dob;
    data['joined'] = joined;
    data['location'] = location;
    data['bio'] = bio;
    data['field'] = field;
    data['followers'] = followers;
    data['following'] = following;
    data['profileUrl'] = profileUrl;
    return data;
  }
  
  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;
  
}
