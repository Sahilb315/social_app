import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/*
This database stores posts that users have published in the app.
It is stored in a collection called 'Posts' in Firebase

Each post contains;

- a message
- email of user
- timestamp
*/

class FirestoreDatabase {
// current logged in user
  User? user = FirebaseAuth.instance.currentUser;

// get collection of posts from firebase
  final CollectionReference posts =
      FirebaseFirestore.instance.collection('post');

  final CollectionReference users =
      FirebaseFirestore.instance.collection('user');

  Future<void> deletePost(String docID) {
    return posts.doc(docID).delete();
  }
}
