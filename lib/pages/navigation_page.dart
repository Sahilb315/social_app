import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/provider/navigation_provider.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, provider, child) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        bottomNavigationBar: NavigationBar(
          indicatorShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          indicatorColor: Colors.transparent,
          backgroundColor: Theme.of(context).colorScheme.background,
          surfaceTintColor: Theme.of(context).colorScheme.background,
          onDestinationSelected: (value) => provider.setCurrentIndex(value),
          selectedIndex: provider.currentIndex,
          destinations: [
            NavigationDestination(
              tooltip: "Home",
              icon: Icon(
                CupertinoIcons.home,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              label: "",
            ),
            NavigationDestination(
              tooltip: "Search",
              selectedIcon: Icon(
                CupertinoIcons.search,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              icon: Icon(
                CupertinoIcons.search,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              label: "",
            ),
            NavigationDestination(
              tooltip: "Chat",
              selectedIcon: Icon(
                CupertinoIcons.mail_solid,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              icon: Icon(
                CupertinoIcons.mail,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              label: "",
            ),
          ],
        ),
        body: provider.pages[provider.currentIndex],
      ),
    );
  }
}
