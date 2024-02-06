import 'package:flutter/material.dart';

class AccountTextField extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  const AccountTextField({
    super.key,
    required this.text,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
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
        labelText: text,
        labelStyle: const TextStyle(
          color: Colors.grey,
        ),
        floatingLabelStyle: const TextStyle(color: Colors.blue),
      ),
    );
  }
}
