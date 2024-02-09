// ignore_for_file: unrelated_type_equality_checks

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/components/my_button.dart';
import 'package:social_app/pages/create_account/need_account_page.dart';
import 'package:social_app/provider/theme_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  User? user;
  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("S E T T I N G S"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            MyButton(
              text: "Theme",
              onTap: () {
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleThemes();
              },
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                if (!context.mounted) return;
                //? popUntil removes all the routes till the conditions are met and even the NeedAccountPage is removed & then
                //? push to the new page
                Navigator.popUntil(
                    context, (route) => const NeedAccountPage() == route);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const NeedAccountPage()));
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.logout_rounded,
                      size: 30,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      "L O G O U T",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            MyButton(
              text: "Delete Account",
              onTap: () async => await deleteAccount(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> deleteUserInfo() async {
    final posts = await FirebaseFirestore.instance
        .collection("post")
        .where('useremail', isEqualTo: user!.email)
        .get();
    for (QueryDocumentSnapshot doc in posts.docs) {
      await doc.reference.delete();
    }
    final comments = await FirebaseFirestore.instance.collection('post').get();
    for (var element in comments.docs) {
      final commentsQuerySnapshot = await FirebaseFirestore.instance
          .collection('post')
          .doc(element.id)
          .collection('comments')
          .where('commentedBy', isEqualTo: user!.email)
          .get();

      for (var commentDoc in commentsQuerySnapshot.docs) {
        await commentDoc.reference.delete();
      }
    }
  }

  Future<void> deleteAccount(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.background,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Are you sure you want to delete your account?"),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                    try {
                      await user!.delete();
                      await FirebaseFirestore.instance
                          .collection('user')
                          .doc(user!.email)
                          .delete();
                      await deleteUserInfo();
                      if (!context.mounted) return;
                      Navigator.pop(context);
                      Navigator.popUntil(
                          context, (route) => const NeedAccountPage() == route);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const NeedAccountPage(),
                        ),
                      );
                    } catch (e) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            e.toString(),
                          ),
                        ),
                      );
                    }
                  },
                  child: Text(
                    "Delete",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
