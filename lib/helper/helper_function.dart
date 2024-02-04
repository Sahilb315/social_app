import 'package:flutter/material.dart';

void diplayMessageToUser(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 2),
      content: Text(message),
    ),
  );
  // showDialog(
  //   context: context,
  //   builder: ((context) => AlertDialog(
  //         title: Text(message),
  //       )),
  // );
}
