import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/pages/edit_profile_page.dart';
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
  final user = FirebaseAuth.instance.currentUser!;
  @override
  void initState() {
    Provider.of<ProfileProvider>(context, listen: false)
        .fetchDetails(user.email);
    Provider.of<ProfileProvider>(context, listen: false)
        .fetchPostsByUser(user.email);
    Provider.of<ProfileProvider>(context, listen: false)
        .fetchRepliesByUser(user.email);
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  Future<void> _refresh() async {
    Provider.of<ProfileProvider>(context, listen: false)
        .fetchDetails(user.email);
    Provider.of<ProfileProvider>(context, listen: false)
        .fetchPostsByUser(user.email);
    Provider.of<ProfileProvider>(context, listen: false)
        .fetchRepliesByUser(user.email);
  }

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
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: Image.network(
                          "https://imgs.search.brave.com/R3bGwA4un2aVaeeVdn4HdZROk8LSjWjAwpPZVvXHRww/rs:fit:500:0:0/g:ce/aHR0cHM6Ly9tYXJr/ZXRwbGFjZS5jYW52/YS5jb20vRUFEYXBD/X1dtaUkvNC8wLzE2/MDB3L2NhbnZhLXJl/c29ydC1waG90by10/d2l0dGVyLWhlYWRl/ci11OTZzNHVvTFJ1/US5qcGc")
                      .image,
                  fit: BoxFit.fill,
                ),
              ),
              child: const Stack(
                children: [
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.all(7.0),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          foregroundImage: NetworkImage(
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTvi7HpQ-_PMSMOFrj1hwjp6LDcI-jm3Ro0Xw&usqp=CAU",
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
              child: Consumer<ProfileProvider>(
                builder: (context, value, child) {
                  var profile = value.userModel;
                  return Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile.name,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "@${profile.username}",
                              ),
                            ],
                          ),
                          OutlinedButton(
                            onPressed: () => Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        EditProfilePage(
                                  name: profile.name,
                                  location: profile.location,
                                  bio: profile.bio,
                                  field: profile.field,
                                ),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  var begin = const Offset(1.0, 0.0);
                                  var end = Offset.zero;
                                  var curve = Curves.easeIn;

                                  var tween = Tween(begin: begin, end: end)
                                      .chain(CurveTween(curve: curve));
                                  return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child,
                                  );
                                },
                              ),
                            ),
                            child: Text(
                              "Edit Profile",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
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
                          profile.bio,
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
                              profile.field,
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
                            "Born ${profile.dob}",
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
                              "Joined ${profile.joined}",
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
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                              text: profile.following.toString(),
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
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                              text: profile.followers.toString(),
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
                  );
                },
              ),
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
