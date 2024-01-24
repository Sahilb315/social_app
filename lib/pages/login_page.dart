import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social_app/components/my_button.dart';
import 'package:social_app/components/my_textfield.dart';
import 'package:social_app/helper/helper_function.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController email = TextEditingController();
  final TextEditingController pass = TextEditingController();

  void loginUser(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email.text, password: pass.text);
      if (context.mounted) Navigator.pop(context);
    } on PlatformException catch (e) {
      // Catch specific exception type
      if (context.mounted) {
        Navigator.pop(context);
        diplayMessageToUser(e.toString(), context);
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        diplayMessageToUser(e.code, context);
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        diplayMessageToUser(e.toString(), context);
      }
    }
  }

  @override
  void dispose() {
    email.dispose();
    pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
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
                "L O G I N",
                style: TextStyle(fontSize: 20),
              ),

              const SizedBox(
                height: 50,
              ),

              // email field
              MyTextField(
                hintText: "Email",
                obsecureText: false,
                controller: email,
              ),
              const SizedBox(
                height: 10,
              ),
              // pass field
              MyTextField(
                hintText: "Password",
                obsecureText: true,
                controller: pass,
              ),
              const SizedBox(
                height: 10,
              ),
              // forgot pass
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Forgot Password",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              // sign in btn
              MyButton(
                text: "Login",
                onTap: () => loginUser(context),
              ),
              const SizedBox(height: 18),
              // dont have acc? register
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Dont have an account?",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      " Register Here",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
