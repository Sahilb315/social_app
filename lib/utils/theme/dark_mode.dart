import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
      // background: Colors.grey.shade900,
      background: Colors.black,
      // background: Color(0xFF171717),
      primary: Colors.grey.shade600,
      secondary: Colors.grey.shade400,
      inversePrimary: Colors.grey.shade200),
  textTheme: ThemeData.dark()
      .textTheme
      .apply(bodyColor: Colors.grey[300], displayColor: Colors.white),
);
