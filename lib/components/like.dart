import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/database/firestore.dart';

class LikeButton extends StatefulWidget {
  final String postID;
  final List<dynamic> likes;
  const LikeButton({
    super.key,
    required this.postID,
    required this.likes,
  });

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  FirestoreDatabase firestoreDatabase = FirestoreDatabase();
  final currentUser = FirebaseAuth.instance.currentUser;
  bool isLiked = false;

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    // Access the document in firebase
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('post').doc(widget.postID);

    if (isLiked) {
      // if the post is liked , add the user's email  to the 'Likes' field
      postRef.update({
        'like': FieldValue.arrayUnion([currentUser!.email])
      });
    } else {
      // if the post is unliked , remove the user's email  from the 'Likes' field
      postRef.update({
        'like': FieldValue.arrayRemove([currentUser!.email])
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // here we are checking if the current users email is there in the list of emails that have liked
    isLiked = widget.likes.contains(currentUser!.email);
    // if(widget.likes.contains(currentUser!.email)){
    //   isLiked = true;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: toggleLike,
          icon: isLiked
              ? const Icon(Icons.favorite, color: Colors.red)
              : const Icon(
                  Icons.favorite_border,
                ),
        ),
        Text(widget.likes.length.toString()),
      ],
    );
  }
}
