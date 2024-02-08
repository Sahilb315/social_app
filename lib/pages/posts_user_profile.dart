import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/models/posts_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/pages/profile_tab_page/posts_tab.dart';
import 'package:social_app/pages/profile_tab_page/replies_tab.dart';
import 'package:social_app/provider/profile_provider.dart';

class PostUserProfile extends StatefulWidget {
  final UserModel userModel;
  final PostModel postModel;
  const PostUserProfile({
    super.key,
    required this.userModel,
    required this.postModel,
  });

  @override
  State<PostUserProfile> createState() => _PostUserProfileState();
}

class _PostUserProfileState extends State<PostUserProfile>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    Provider.of<ProfileProvider>(context, listen: false)
        .fetchDetails(widget.userModel.email);
    Provider.of<ProfileProvider>(context, listen: false)
        .fetchPostsByUser(widget.userModel.email);
    Provider.of<ProfileProvider>(context, listen: false)
        .fetchRepliesByUser(widget.userModel.email);
    tabController = TabController(length: 2, vsync: this);
    userModel = widget.userModel;
    postModel = widget.postModel;
    super.initState();
  }

  Future<void> _refresh() async {
    Provider.of<ProfileProvider>(context, listen: false)
        .fetchDetails(widget.userModel.email);
    Provider.of<ProfileProvider>(context, listen: false)
        .fetchPostsByUser(widget.userModel.email);
    Provider.of<ProfileProvider>(context, listen: false)
        .fetchRepliesByUser(widget.userModel.email);
  }

  late UserModel userModel;
  late PostModel postModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("P R O F I L E"),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: RefreshIndicator.adaptive(
        onRefresh: _refresh,
        color: Colors.black,
        child: ListView(
          children: [
            // Consumer<ProfileProvider>(
            //   builder: (context, value, child) =>
            Container(
              height: MediaQuery.sizeOf(context).height * 0.2,
              decoration: BoxDecoration(
                //? Banner Image
                image: DecorationImage(
                  image: Image.network(
                          "https://imgs.search.brave.com/R3bGwA4un2aVaeeVdn4HdZROk8LSjWjAwpPZVvXHRww/rs:fit:500:0:0/g:ce/aHR0cHM6Ly9tYXJr/ZXRwbGFjZS5jYW52/YS5jb20vRUFEYXBD/X1dtaUkvNC8wLzE2/MDB3L2NhbnZhLXJl/c29ydC1waG90by10/d2l0dGVyLWhlYWRl/ci11OTZzNHVvTFJ1/US5qcGc")
                      .image,
                  fit: BoxFit.fill,
                ),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(7.0),
                        //? Profile Image
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          foregroundImage: NetworkImage(
                            userModel.profileUrl,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
              child:
                  // Consumer<ProfileProvider>(
                  //   builder: (context, value, child) {
                  //     var profile = value.userModel;
                  //     return
                  Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userModel.name,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "@${userModel.username}",
                          ),
                        ],
                      ),
                      MaterialButton(
                        color: Colors.blue,
                        onPressed: () {},
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Text(
                          "Follow +",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //? BIO
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      userModel.bio,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //? FIELD
                  Row(
                    children: [
                      const Icon(
                        CupertinoIcons.briefcase,
                        size: 16,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Text(
                          userModel.field,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //? DOB
                  Row(
                    children: [
                      Image.asset(
                        "assets/balloon.png",
                        width: 20,
                        height: 17,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                      Text(
                        "Born ${userModel.dob}",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //? Joined
                  Row(
                    children: [
                      const Icon(
                        CupertinoIcons.calendar,
                        size: 16,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Text(
                          "Joined ${userModel.joined}",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //? Following
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                          text: userModel.following.toString(),
                          children: const [
                            TextSpan(
                              text: " Following",
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      //? Followers
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                          text: userModel.followers.toString(),
                          children: const [
                            TextSpan(
                              text: " Followers",
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
              //   },
              // ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              child: TabBar(
                unselectedLabelColor: Colors.grey,
                labelColor: Theme.of(context).colorScheme.inversePrimary,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 4,
                indicator: UnderlineTabIndicator(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.blue, width: 4),
                ),
                indicatorPadding: const EdgeInsets.symmetric(horizontal: 8),
                indicatorColor: Colors.blue,
                controller: tabController,
                tabs: const [
                  Tab(text: "Posts"),
                  Tab(text: "Replies"),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height,
              child: TabBarView(
                controller: tabController,
                children: [
                  ProfilePostsTabPage(
                    userPostList:
                        Provider.of<ProfileProvider>(context, listen: false)
                            .usersPostList,
                  ),
                  const ProfileRepliesTabPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
