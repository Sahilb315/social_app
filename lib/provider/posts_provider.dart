import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/models/posts_model.dart';

class PostsProvider extends ChangeNotifier {
  List<PostModel> _postList = [];
  List<PostModel> get list => _postList;

  PostModel _postModel = PostModel(
    id: "",
    username: "",
    useremail: "",
    postmessage: "",
    like: [],
    timestamp: Timestamp.now(),
    bookmark: [],
  );
  PostModel get post => _postModel;

  Future<void> updatePostLike(String docID, int index) async {
    // log(docID);
    if (_postList[index].like.contains(user!.email)) {
      await firestore.doc(docID).update({
        'like': FieldValue.arrayRemove([user!.email]),
      });
    } else {
      await firestore.doc(docID).update({
        'like': FieldValue.arrayUnion([user!.email]),
      });
    }
    fetchPosts();
  }

   updatePostBookmark(String docID, int index) async {
    log(docID);
    if (_postList[index].bookmark.contains(user!.email)) {
      log("Remove");
      await firestore.doc(docID).update({
        'bookmark': FieldValue.arrayRemove([user!.email]),
      });
    } else {
      log("Add");
      await firestore.doc(docID).update({
        'bookmark': FieldValue.arrayUnion([user!.email]),
      });
    }
    fetchPosts();
  }

  User? user = FirebaseAuth.instance.currentUser;
  final firestore = FirebaseFirestore.instance.collection("post");

  void fetchPosts() async {
    try {
      final snapshot =
          await firestore.orderBy('timestamp', descending: true).get();
      // _postList = snapshot.docs.map((doc) {
      //   return PostModel.fromFirestore(doc);
      // }).toList();
      _postList = snapshot.docs.map((doc) {
        return PostModel(
          id: doc.id,
          username: doc.data()['username'],
          useremail: doc.data()['useremail'],
          postmessage: doc.data()['postmessage'],
          like: doc.data()['like'],
          timestamp: doc.data()['timestamp'],
          bookmark: doc.data()['bookmark'],
        );
      }).toList();
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> addPost(PostModel model) async {
    try {
      await firestore.add({
        'useremail': model.useremail,
        'postmessage': model.postmessage,
        'timestamp': model.timestamp,
        'bookmark': model.bookmark,
        'like': model.like,
        'username': model.username,
      });
      fetchPosts();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> fetchPostDocumentById(String docID) async {
    try {
      final snap = await firestore.doc(docID).get();
      _postModel = PostModel.fromFirestore(snap);
      // print(_postModel.toMap());

      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  void showDailog(BuildContext context, TextEditingController postController) {
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
                          addPost(
                            PostModel(
                              id: "",
                              username: user!.displayName.toString(),
                              useremail: user!.email.toString(),
                              postmessage: postController.text,
                              like: [],
                              timestamp: Timestamp.now(),
                              bookmark: [],
                            ),
                          );
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
