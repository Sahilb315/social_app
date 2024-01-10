import 'package:flutter/material.dart';
import 'package:social_app/components/drawer.dart';
import 'package:social_app/components/my_list_tile.dart';
import 'package:social_app/database/firestore.dart';
import 'package:social_app/models/posts_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController postController = TextEditingController();
  FirestoreDatabase firestoreDatabase = FirestoreDatabase();
  List<PostModel> postList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        toolbarHeight: MediaQuery.sizeOf(context).height * 0.08,
        title: const Text("P O S T S"),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        shape: const StadiumBorder(),
        onPressed: () => firestoreDatabase.postMessage(context, postController),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
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
                postList = posts
                    .map(
                      (doc) => PostModel.fromJson(
                          doc.data() as Map<String, dynamic>),
                    )
                    .toList();
                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final newPosts = postList[index];
                    final post = posts[index];
                    final docID = post.id;
                    final date =
                        newPosts.formatDate(newPosts.timestamp).toString();

                    return MyListTile(
                      index: index,
                      date: date,
                      docID: docID,
                      postModel: newPosts,
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
