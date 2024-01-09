import 'package:flutter/material.dart';
import 'package:social_app/database/firestore.dart';

class Comment extends StatefulWidget {
  final String docID;
  const Comment({super.key, required this.docID});

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  final firestoreDatabase = FirestoreDatabase();
  final commentsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> onPressedComment() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: [
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: commentsController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter a reply";
                    }
                    return null; // Return null when the input is valid
                  },
                  decoration: InputDecoration(
                    hintText: "Post Your Reply",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        firestoreDatabase.addComments(
                          content: commentsController.text,
                          docID: widget.docID,
                        );
                        Navigator.pop(context);
                        commentsController.clear();
                      }
                    },
                    child: Text(
                      "Reply",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressedComment,
      icon: const Icon(Icons.comment),
    );
  }
}
