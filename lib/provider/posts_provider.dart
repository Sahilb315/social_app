import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/models/posts_model.dart';

enum DataStatus {
  fetching,
  fetched,
  error,
  initial;
}

class PostsProvider extends ChangeNotifier {
  bool _dataIsFetched = false;
  bool get dataIsFetched => _dataIsFetched;

  void setDataFetch(bool value) {
    _dataIsFetched = value;
  }

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

  User? user;
  final firestore = FirebaseFirestore.instance.collection("post");

  Future<void> updatePostLike(String docID, int index) async {
    if (_postList[index].like.contains(user!.email)) {
      _postList[index].like.remove(user!.email);
      await firestore.doc(docID).update({
        'like': FieldValue.arrayRemove([user!.email]),
      });
    } else {
      _postList[index].like.add(user!.email);
      await firestore.doc(docID).update({
        'like': FieldValue.arrayUnion([user!.email]),
      });
    }
    notifyListeners();
  }
  //? This will not work until i pass the model from the list rather then passing the model from the
  //? home screen(Like this widget.postModel) bcoz the consumer will not update
  // Future<void> updateBookmark(
  //     {required PostModel postModel, int? index}) async {
  //       log("Update Bookmark ${postModel.toMap().toString()}");
  //   log("Bookmark  ${postModel.id}");
  // if (postModel.bookmark.contains(user!.email)) {
  // //   if (_postList[index!].bookmark.contains(user!.email)) {
  //     log("Removing bookmark");
  //     await firestore.doc(postModel.id).update({
  //       'bookmark': FieldValue.arrayRemove([user!.email]),
  //     });
  //   } else {
  //     log("Adding bookmark");
  //     await firestore.doc(postModel.id).update({
  //       'bookmark': FieldValue.arrayUnion([user!.email]),
  //     });
  //   }
  //   fetchPosts();
  // }

  Future<void> updatePostBookmark(String docID, int index) async {
    if (_postList[index].bookmark.contains(user!.email)) {
      log("Remove Bookmark");
      _postList[index].bookmark.remove(user!.email);
      await firestore.doc(docID).update({
        'bookmark': FieldValue.arrayRemove([user!.email]),
      });
    } else {
      log("Add Bookmark");
      _postList[index].bookmark.add(user!.email);
      await firestore.doc(docID).update({
        'bookmark': FieldValue.arrayUnion([user!.email]),
      });
    }
    notifyListeners();
  }

  Future<void> updateSinglePostBookmark(String docID) async {
    // Getting the the Specific Post from the Post List by matching the Post's DocID within the whole list
    // without using the index
    final postBookmark =
        _postList.where((element) => element.id == docID).first.bookmark;
    if (postBookmark.contains(user!.email)) {
      log("Open Post Remove Bookmark");
      postBookmark.remove(user!.email);
      await firestore.doc(docID).update({
        'bookmark': FieldValue.arrayRemove([user!.email]),
      });
    } else {
      log("Open Post Add Bookmark");
      postBookmark.add(user!.email);
      await firestore.doc(docID).update({
        'bookmark': FieldValue.arrayUnion([user!.email]),
      });
    }
    notifyListeners();
  }

  Future<void> updateSinglePostLike(String docID) async {
    // Getting the the Specific Post from the Post List by matching the Post's DocID within the whole list
    // without using the index
    final postLike =
        _postList.where((element) => element.id == docID).first.like;
    if (postLike.contains(user!.email)) {
      log("Open Post Remove Like");
      postLike.remove(user!.email);
      await firestore.doc(docID).update({
        'like': FieldValue.arrayRemove([user!.email]),
      });
    } else {
      log("Open Post Add Like");
      postLike.add(user!.email);
      await firestore.doc(docID).update({
        'like': FieldValue.arrayUnion([user!.email]),
      });
    }
    notifyListeners();
  }

  var currentStatus = DataStatus.initial;
  void changeDataStatus(DataStatus status) {
    currentStatus = status;
  }

  Future<void> fetchPosts() async {
    changeDataStatus(DataStatus.fetching);
    try {
      final snapshot =
          await firestore.orderBy('timestamp', descending: true).get();
      _postList = snapshot.docs.map((doc) {
        return PostModel.fromFirestore(doc);
      }).toList();
      changeDataStatus(DataStatus.fetched);
      notifyListeners();
    } catch (e) {
      changeDataStatus(DataStatus.error);
      log(e.toString());
    }
  }

  Future<void> addPost(PostModel model) async {
    try {
      await firestore.add({
        "id": "",
        'useremail': model.useremail,
        'postmessage': model.postmessage,
        'timestamp': model.timestamp,
        'bookmark': [],
        'like': [],
        'username': model.username,
      }).then(
        (value) async {
          await firestore.doc(value.id).update({'id': value.id});
          _postList.add(
            PostModel(
              id: value.id,
              username: model.username,
              useremail: model.useremail,
              postmessage: model.postmessage,
              like: [],
              timestamp: model.timestamp,
              bookmark: [],
            ),
          );
        },
      );
      notifyListeners();
      log("Adding Posts");
      log("Posts Added");
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> fetchPostDocumentById(String docID) async {
    try {
      final snap = await firestore.doc(docID).get();
      _postModel = PostModel.fromFirestore(snap);
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  void addPostsSheet(
      BuildContext context, TextEditingController postController) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SizedBox(
        height: MediaQuery.sizeOf(context).height * 1,
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(
            left: 10,
            right: 5,
            top: MediaQuery.sizeOf(context).height * 0.05,
          ),
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
                        log(user!.displayName.toString());
                        log(user!.email.toString());
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
                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 26,
                    foregroundImage: NetworkImage(user!.photoURL.toString()),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
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
