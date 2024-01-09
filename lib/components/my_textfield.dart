import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {

    final String hintText;
    final bool obsecureText;
    final TextEditingController controller;
  const MyTextField({ Key? key, required this.hintText, required this.obsecureText, required this.controller }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  TextField(
      obscureText: obsecureText,
      controller: controller,
      decoration: InputDecoration(
        labelText: hintText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15)
        ),
      ),
    );
  }
}