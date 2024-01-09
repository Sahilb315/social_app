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

  Future<DocumentSnapshot> getUserName() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('user')
        .doc(user!.email)
        .get();

    // Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    return documentSnapshot;
  }

  Stream<QuerySnapshot> getOpenPosts() {
    final postStream =
        FirebaseFirestore.instance.collection('post').snapshots();

    return postStream;
  }

  Future addComments({required String content,required String docID}) async {
    await posts.doc(docID).collection('comments').add({
      "content": content,
      "commentedBy": user!.displayName,
      "commentedEmail" : user!.email,
      "timestamp": Timestamp.now().toDate().toString(),
    });
  }

  Stream<QuerySnapshot> getComments(String docID) {
    final postStream =  FirebaseFirestore.instance
        .collection('post')
        .doc(docID)
        .collection('comments')
        .snapshots();

    return postStream;
  }

  Future<DocumentSnapshot> getPostDocumentById(String docID) async {
    final DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('post').doc(docID).get();
    return doc;
  }

// post a message
  Future<void> addPost(String message) {
    return posts.add({
      'useremail': user!.email,
      'postmessage': message,
      'timestamp': Timestamp.now(),
      'bookmark': false,
      'like': <String>[],
      'username': user!.displayName,
    });
  }

//read posts from database
  Stream<QuerySnapshot> getPosts() {
    final postStream = FirebaseFirestore.instance
        .collection('post')
        .orderBy('timestamp', descending: true)
        .snapshots();

    return postStream;
  }
  // Stream<QuerySnapshot> getOpenPosts() {
  //   final postStream = FirebaseFirestore.instance
  //       .collection('post')
  //       .doc()
  //       .snapshots();

  //   return postStream;
  // }
  Future<void> deletePost(String docID) {
    return posts.doc(docID).delete();
  }

  Stream<QuerySnapshot> showPosts() {
    final postStream = FirebaseFirestore.instance
        .collection('post')
        .where('useremail', isEqualTo: user!.email)
        .snapshots();

    return postStream;
  }

  Future<void> updatePostData(String docID, bool bookmark) {
    return posts.doc(docID).update({
      'bookmark': bookmark,
    });
  }

  Stream<QuerySnapshot> showBookmarkPosts() {
    final postStream = FirebaseFirestore.instance
        .collection('post')
        .where('bookmark', isEqualTo: true)
        .snapshots();

    return postStream;
  }
}
