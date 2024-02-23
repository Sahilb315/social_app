import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/models/comments_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentsProvider extends ChangeNotifier {
  List<CommentModel> _comments = [];
  List<CommentModel> get comments => _comments;
  final firestore = FirebaseFirestore.instance.collection("post");
  User? user;

  Future<void> fetchComments(String docID) async {
    try {
      List<CommentModel> model = [];
      final snap = await firestore.doc(docID).collection('comments').get();
      model = snap.docs.map((doc) => CommentModel.fromFirestore(doc)).toList();
      _comments = model;
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _addComments(CommentModel model, String docID) async {
    await firestore.doc(docID).collection('comments').add({
      "commentedBy": model.commentedBy,
      "commentedEmail": model.commentedEmail,
      "content": model.content,
      "timestamp": model.timestamp,
    });
    fetchComments(docID);
  }

  void addCommentSheet(
    BuildContext context,
    TextEditingController commentController,
    String docID,
    String username,
  ) {
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
                        if (commentController.text.isNotEmpty) {
                          _addComments(
                            CommentModel(
                              commentedBy: user!.displayName.toString(),
                              commentedEmail: user!.email.toString(),
                              content: commentController.text,
                              timestamp: Timestamp.now().toString(),
                            ),
                            docID,
                          );
                        }
                        Navigator.pop(context);
                        commentController.clear();
                      },
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.blue)),
                      child: const Text(
                        "Reply",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 18.0,
                    ),
                    child: SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.05,
                      child: const VerticalDivider(
                        thickness: 1.5,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 22.0),
                    child: RichText(
                      text: TextSpan(
                        text: "Replying to",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontSize: 17),
                        children: [
                          TextSpan(
                            text: " @$username",
                            style: const TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // const SizedBox(
              //   height: 10,
              // ),
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
                              color:
                                  Theme.of(context).colorScheme.inversePrimary),
                          controller: commentController,
                          keyboardType: TextInputType.multiline,
                          cursorColor: Colors.grey.shade400,
                          maxLines: null,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Post your reply",
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
