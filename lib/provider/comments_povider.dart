import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/models/comments_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentsProvider extends ChangeNotifier {
  List<CommentModel> _comments = [];
  List<CommentModel> get comments => _comments;
  final firestore = FirebaseFirestore.instance.collection("post");
  final user = FirebaseAuth.instance.currentUser;

 Future<void> fetchComments(
    String docID,
  ) async {
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

  Future<void> addComments(CommentModel model, String docID) async {
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
  showBottomSheet(
    backgroundColor: Theme.of(context).colorScheme.background,
    context: context,
    builder: (context) => SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 5),
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
                        addComments(
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
                        backgroundColor: MaterialStatePropertyAll(Colors.blue)),
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
                      style: const TextStyle(color: Colors.black, fontSize: 17),
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
