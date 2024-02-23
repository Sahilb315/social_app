import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/components/drawer.dart';
import 'package:social_app/pages/searching_page.dart';
import 'package:social_app/pages/search_tab_pages/for_you_tab_page.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 5, vsync: this);
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      drawer: const MyDrawer(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: GestureDetector(
          onTap: () => _scaffoldState.currentState!.openDrawer(),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: CircleAvatar(
              foregroundImage: NetworkImage(
                FirebaseAuth.instance.currentUser!.photoURL.toString(),
              ),
            ),
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 14.0),
            child: Icon(Icons.settings),
          ),
        ],
        title: GestureDetector(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const SearchingPage())),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: 24.0,
                    top: 10.0,
                    bottom: 10.0,
                    left: 10,
                  ),
                  child: Text(
                    "Seach X",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.grey.shade300,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TabBar(
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.white,
            indicatorColor: Colors.blue,
            indicatorPadding: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            tabs: const [
              Tab(icon: Text("For you")),
              Tab(icon: Text("Trending")),
              Tab(icon: Text("News")),
              Tab(icon: Text("Sports")),
              Tab(icon: Text("Entertainment")),
            ],
            controller: tabController,
            indicatorSize: TabBarIndicatorSize.tab,
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: const [
                ForYouTabPage(),
                Icon(Icons.headphones),
                Icon(Icons.camera_alt_outlined),
                Icon(Icons.car_crash_outlined),
                Icon(Icons.mobile_friendly),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RecentUsers extends StatelessWidget {
  const RecentUsers({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 18.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 24,
          ),
          Text(
            "data",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            "data",
            style: TextStyle(
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
