import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  Future addComments({required String content, required String docID}) async {
    await posts.doc(docID).collection('comments').add({
      "content": content,
      "commentedBy": user!.displayName,
      "commentedEmail": user!.email,
      "timestamp": Timestamp.now().toDate().toString(),
    });
  }

  Stream<QuerySnapshot> getComments(String docID) {
    final postStream = FirebaseFirestore.instance
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

  Future<void> deletePost(String docID) {
    return posts.doc(docID).delete();
  }

  Stream<QuerySnapshot> getPostsByUser() {
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

//  Displaying sheet for adding posts
  void postMessage(BuildContext context, TextEditingController postController) {
    showBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.background,
      context: context,
      builder: (context) => SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(top: 42, left: 10, right: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.clear_rounded),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (postController.text.isNotEmpty) {
                          addPost(postController.text);
                        }
                        Navigator.pop(context);
                        postController.clear();
                      },
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.blue)),
                      child: const Text(
                        "Post",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 26,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: postController,
                          keyboardType: TextInputType.multiline,
                          cursorColor: Colors.grey.shade400,
                          maxLines: null,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Whats happening?",
                            hintStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
