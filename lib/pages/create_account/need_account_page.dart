import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_app/pages/create_account/create_acc_page.dart';
import 'package:social_app/pages/login_user/login_user_page.dart';

class NeedAccountPage extends StatefulWidget {
  const NeedAccountPage({super.key});

  @override
  State<NeedAccountPage> createState() => _NeedAccountPageState();
}

class _NeedAccountPageState extends State<NeedAccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      appBar: AppBar(
        backgroundColor: const Color(0xFF171717),
        title: const Text(''),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.07,
                ),
                const Text(
                  "Need another",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  "account?",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Whether you need another account for work or just don't want your mum seeing your takes, we've got you covered that.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await signInWithGoogle();
                  },
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.white),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/icon.png",
                        height: 22,
                      ),
                      const Text(
                        "  Continue with Google",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        "or",
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          // fontSize: 16,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const CreateAccountPage(),
                        transitionDuration: const Duration(milliseconds: 300),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
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
                    );
                  },
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.white),
                  ),
                  child: const Text(
                    "Create account",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                RichText(
                  text: const TextSpan(
                    text: "By signing up, you agree to our ",
                    style: TextStyle(color: Colors.grey),
                    children: [
                      TextSpan(
                        text: "Terms, Privacy Policy ",
                        style: TextStyle(color: Colors.blue),
                      ),
                      TextSpan(
                        text: "and",
                      ),
                      TextSpan(
                        text: " Cookie Use.",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  children: [
                    const Text(
                      "Have an account already?",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      // onTap: () => Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (_) => const LoginUserPage())),\
                      onTap: () => Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const LoginUserPage(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            var begin = const Offset(0.0, 1.0);
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
                      child: const Text(
                        " Log in",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? signInUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? signInAuthentication =
        await signInUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: signInAuthentication?.accessToken,
      idToken: signInAuthentication?.idToken,
    );

    log("${signInUser!.email}  ${signInUser.displayName}  ${signInUser.photoUrl}");
    return FirebaseAuth.instance.signInWithCredential(credential);
  }

    // Future<void> createUserDocument(UserCredential? userCredential) async {
    // if (userCredential != null && userCredential.user != null) {
    //   await FirebaseFirestore.instance
    //       .collection('user')
    //       .doc(userCredential.user!.email)
    //       .set({
    //     'name': widget.name,
    //     'email': userCredential.user!.email,
    //     'username': usernameController.text,
    //     'dob': widget.dateOfBirth,
    //     'joined': formatDate(Timestamp.now()),
    //     'profileUrl':
    //         "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTV5lof4YCEqxL3U1KVac7UgbdG6SG8bfs0hWoVkqJ2w4GIeujd_ps78_loMw&s"
    //   });
    // }
  // }
}
