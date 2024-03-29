import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:social_app/components/acc_textfield.dart';
import 'package:social_app/pages/create_account/enter_password_page.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  Future<void> pickDateOfBirth() async {
    var currentDate = DateTime.now();
    var newDate = DateTime(currentDate.year - 16);
    log(newDate.toString());
    final DateTime? datePicked = await showDatePicker(
      context: context,
      lastDate: newDate,
      firstDate: DateTime(1950),
      initialDate: newDate,
    );
    if (datePicked != null && datePicked != selectedDate) {
      setState(() {
        selectedDate = datePicked;
        var dateFormat = DateFormat("yyyy-MM-dd").format(selectedDate);
        log(dateFormat.toString());

        dateOfBirthController = TextEditingController(text: dateFormat);
      });
    }
  }

  final _formKey = GlobalKey<FormState>();
  // final RegExp _emailRegex = RegExp("r'^S+@S+\$'");

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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Create your account",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  AccountTextField(
                    text: "Name",
                    controller: nameController,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  // AccountTextField(
                  //   text: "Email",
                  //   controller: emailController,
                  // ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter email";
                      } else if (!value.contains("@") ||
                          !value.contains(".com")) {
                        return "Invalid Format";
                      }
                      return null;
                    },
                    controller: emailController,
                    cursorColor: Colors.blue,
                    cursorRadius: const Radius.circular(12),
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
                      labelText: "Email",
                      labelStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                      floatingLabelStyle: const TextStyle(color: Colors.blue),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: dateOfBirthController,
                    cursorColor: Colors.blue,
                    readOnly: true,
                    cursorRadius: const Radius.circular(12),
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
                      labelText: "Date of Birth",
                      labelStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                      floatingLabelStyle: const TextStyle(color: Colors.blue),
                      suffixIcon: GestureDetector(
                        onTap: () => pickDateOfBirth(),
                        child: const Icon(CupertinoIcons.calendar),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (nameController.text.isEmpty &&
                          emailController.text.isEmpty &&
                          dateOfBirthController.text.isEmpty) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Please fill all the fields'),
                        ));
                        return;
                      }
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  EnterPasswordPage(
                            name: nameController.text,
                            email: emailController.text,
                            dateOfBirth: dateOfBirthController.text,
                          ),
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
        ),
      ),
    );
  }
}
