import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/pages/profile_tab_page/posts_tab.dart';
import 'package:social_app/pages/profile_tab_page/replies_tab.dart';
import 'package:social_app/provider/profile_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  final user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    context.read<ProfileProvider>().fetchDetailsOfUser(user!.email);
    context.read<ProfileProvider>().fetchPostsByUser(user!.email);
    context.read<ProfileProvider>().fetchRepliesByUser(user!.email);
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("P R O F I L E"),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Theme.of(context).colorScheme.primary),
            padding: const EdgeInsets.all(25),
            child: const Icon(
              Icons.person_outline_rounded,
              size: 50,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            context.watch<ProfileProvider>().userModel.username,
            style: const TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            context.watch<ProfileProvider>().userModel.useremail,
            style: const TextStyle(
              fontSize: 25,
            ),
          ),
          SizedBox(
            child: TabBar(
              unselectedLabelColor: Colors.grey,
              labelColor: Colors.black,
              indicatorColor: Colors.black,
              controller: tabController,
              tabs: const [
                Tab(text: "Posts"),
                Tab(text: "Replies"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: const [
                ProfilePostsTabPage(),
                ProfileRepliesTabPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}




// docID: value.usersPostList[index].id,
//                       index: index,
//                       postModel: value.usersPostList[index],
//                       date: value.usersPostList[index].timestamp.toString(),