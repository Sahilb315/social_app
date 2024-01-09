// import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:social_app/components/custom_button.dart';
import 'package:social_app/components/drawer.dart';
import 'package:social_app/components/my_list_tile.dart';
import 'package:social_app/components/my_textfield.dart';
import 'package:social_app/database/firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController postController = TextEditingController();
  FirestoreDatabase firestoreDatabase = FirestoreDatabase();

  void postMessage() {
    if (postController.text.isNotEmpty) {
      firestoreDatabase.addPost(postController.text);
    }
    postController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("P O S T S"),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: const MyDrawer(),
      // floatingActionButton: FloatingActionButton(onPressed: addPost, child:const Icon(Icons.add),),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: MyTextField(
                    hintText: "Say Something",
                    obsecureText: false,
                    controller: postController,
                  ),
                ),
                CustomButton(
                  onTap: postMessage,
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: firestoreDatabase.getPosts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final posts = snapshot.data!.docs;
                if (snapshot.data == null || posts.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(25),
                      child: Text(
                        "No Posts..",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    // print(index);
                    final post = posts[index];
                    final docID = post.id;
                    // int postIndex = index;
                
                    String message = post['postmessage'] ?? "";
                    String userEmail = post['useremail'] ?? "";
                    Timestamp timestamp = post['timestamp'] ?? "";
                    List<dynamic> mylikes = post['like'] ?? "";
                    String username = post['username'] ?? "";
                    DateTime date = timestamp.toDate();
                    final formatDate = DateFormat("yyyy-MM-dd").format(date);
                
                    return MyListTile(
                      index: index,
                      username: username,
                      title: message,
                      useremail: userEmail,
                      leadingTime: formatDate.toString(),
                      docID: docID,
                      likes: mylikes,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
