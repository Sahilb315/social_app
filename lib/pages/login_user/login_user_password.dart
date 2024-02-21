// ignore_for_file: unrelated_type_equality_checks

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/pages/navigation_page.dart';
import 'package:social_app/provider/show_password.dart';

class LoginUserPasswordPage extends StatefulWidget {
  final String email;
  const LoginUserPasswordPage({super.key, required this.email});

  @override
  State<LoginUserPasswordPage> createState() => _LoginUserPasswordPageState();
}

class _LoginUserPasswordPageState extends State<LoginUserPasswordPage> {
  final passwordController = TextEditingController();

  Future<bool> loginUser(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    if (passwordController.text.isEmpty) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter your password"),
        ),
      );
      return false;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: widget.email,
        password: passwordController.text,
      );
      if (!context.mounted) return true;
      Navigator.pop(context);
      return true;
    } catch (e) {
      if (!context.mounted) return false;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      appBar: AppBar(
        leading: const SizedBox.shrink(),
        backgroundColor: const Color(0xFF171717),
        title: const Text(''),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Enter your password",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Consumer<ShowPasswordProvider>(
                  builder: (context, value, child) => TextField(
                    controller: passwordController,
                    cursorColor: Colors.blue,
                    cursorRadius: const Radius.circular(12),
                    obscureText: value.showPasswordLogin,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 2,
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 2,
                          color: Colors.blue,
                        ),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.blue,
                        ),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          value.togglePasswordLogin();
                        },
                        icon: const Icon(CupertinoIcons.eye),
                        color: Colors.grey,
                      ),
                      labelText: "Password",
                      labelStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                      floatingLabelStyle: const TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Divider(
                  color: Colors.grey.shade700,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                            side: const BorderSide(color: Colors.white),
                          ),
                        ),
                        backgroundColor:
                            const MaterialStatePropertyAll(Colors.transparent),
                      ),
                      child: const Text(
                        "Forgot password?",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (await loginUser(context) == true) {
                          if (!context.mounted) return;
                          Navigator.popUntil(
                            context,
                            (route) => const NavigationPage() == route,
                          );
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const NavigationPage(),
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
                          );
                          log("User Logged In");
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Invalid"),
                            ),
                          );
                        }
                        // await loginUser(context);
                        // if (!context.mounted) return;
                        // Navigator.popUntil(
                        //   context,
                        //   (route) => const NavigationPage() == route,
                        // );
                        // Navigator.push(
                        //   context,
                        //   PageRouteBuilder(
                        //     pageBuilder:
                        //         (context, animation, secondaryAnimation) =>
                        //             const NavigationPage(),
                        //     transitionsBuilder: (context, animation,
                        //         secondaryAnimation, child) {
                        //       var begin = const Offset(1.0, 0.0);
                        //       var end = Offset.zero;
                        //       var curve = Curves.easeIn;

                        //       var tween = Tween(begin: begin, end: end)
                        //           .chain(CurveTween(curve: curve));
                        //       return SlideTransition(
                        //         position: animation.drive(tween),
                        //         child: child,
                        //       );
                        //     },
                        //   ),
                        // );
                      },
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.white),
                      ),
                      child: const Text(
                        "Log in",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
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
}
