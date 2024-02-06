import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_app/pages/create_account/username_page.dart';

class EnterPasswordPage extends StatefulWidget {
  final String name;
  final String email;
  final String dateOfBirth;
  const EnterPasswordPage(
      {super.key,
      required this.name,
      required this.email,
      required this.dateOfBirth});

  @override
  State<EnterPasswordPage> createState() => _EnterPasswordPageState();
}

class _EnterPasswordPageState extends State<EnterPasswordPage> {
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      appBar: AppBar(
        backgroundColor: const Color(0xFF171717),
        title: const Text(''),
        centerTitle: true,
        leading: const SizedBox.shrink(),
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
                  "You'll need a password",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Make sure it's 6 characters or more.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: passwordController,
                  cursorColor: Colors.blue,
                  cursorRadius: const Radius.circular(12),
                  obscureText: true,
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
                    suffixIcon: const Icon(
                      CupertinoIcons.eye,
                      color: Colors.grey,
                    ),
                    labelText: "Password",
                    labelStyle: const TextStyle(
                      color: Colors.grey,
                    ),
                    floatingLabelStyle: const TextStyle(color: Colors.blue),
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (passwordController.text.isEmpty) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Please enter a password'),
                          ));
                          return;
                        }
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    UsernamePage(
                              name: widget.name,
                              email: widget.email,
                              dateOfBirth: widget.dateOfBirth,
                              password: passwordController.text,
                            ),
                            transitionDuration:
                                const Duration(milliseconds: 300),
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
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (_) => UsernamePage(
                        //       name: widget.name,
                        //       email: widget.email,
                        //       dateOfBirth: widget.dateOfBirth,
                        //       password: passwordController.text,
                        //     ),
                        //   ),
                        // );
                      },
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.white),
                      ),
                      child: const Text(
                        "Next",
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
