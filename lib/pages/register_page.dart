// ignore_for_file: unused_local_variable

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social_app/components/my_button.dart';
import 'package:social_app/components/my_textfield.dart';
import 'package:social_app/helper/helper_function.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController email = TextEditingController();
  final TextEditingController pass = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController confirmPass = TextEditingController();

  final user = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    email.dispose();
    pass.dispose();
    username.dispose();
    confirmPass.dispose();
    super.dispose();
  }

  void registerUser(BuildContext context) async {
    // loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    // pass and confirm pass
    if (pass.text != confirmPass.text) {
      Navigator.pop(context);

      diplayMessageToUser("Password's dont match", context);
    } else if (pass.text.isEmpty ||
        email.text.isEmpty ||
        username.text.isEmpty ||
        confirmPass.text.isEmpty) {
      Navigator.pop(context);
      diplayMessageToUser("Enter Information", context);
      log("Enter Information");
    } else {
      try {
        UserCredential? userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text,
          password: pass.text,
        );

        await userCredential.user!.updateDisplayName(username.text);
        await user!.reload();

        // Navigator.pop(context);
        createUserDocument(userCredential);
        // pop loading circle
        if (context.mounted) Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        if (context.mounted) {
          Navigator.pop(context);
          diplayMessageToUser(e.message ?? "An error occurred", context);
        }
      } on PlatformException catch (e) {
        if (context.mounted) {
          Navigator.pop(context);
          diplayMessageToUser(e.toString(), context);
        }
      } catch (e) {
        if (context.mounted) {
          Navigator.pop(context);
          diplayMessageToUser(e.toString(), context);
        }
      }
    }
  }

  Future<void> createUserDocument(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(userCredential.user!.email)
          .set({
        'email': userCredential.user!.email,
        'username': username.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // logo
                Icon(
                  Icons.person,
                  size: 80,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                const SizedBox(
                  height: 20,
                ),
                // app name
                const Text(
                  "R E G I S T E R",
                  style: TextStyle(fontSize: 20),
                ),

                const SizedBox(
                  height: 50,
                ),
                // username field
                MyTextField(
                  hintText: "Username",
                  obsecureText: false,
                  controller: username,
                ),
                const SizedBox(height: 10),
                // email field
                MyTextField(
                  hintText: "Email",
                  obsecureText: false,
                  controller: email,
                ),
                const SizedBox(height: 10),
                // pass field
                MyTextField(
                  hintText: "Password",
                  obsecureText: true,
                  controller: pass,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  hintText: "Confirm Password",
                  obsecureText: true,
                  controller: confirmPass,
                ),
                const SizedBox(height: 10),
                // const SizedBox(height: 25),
                // sign in btn
                MyButton(
                  text: "Register",
                  onTap:()=> registerUser(context),
                ),
                const SizedBox(
                  height: 18,
                ),
                // dont have acc? register
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary),
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        " Login Here",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
