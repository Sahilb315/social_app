import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/pages/login_page.dart';
import 'package:social_app/pages/register_page.dart';
import 'package:social_app/provider/login_register_provider.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginRegisterProvider>(
      builder: (context, value, child) {
        if (value.showLoginPage) {
          return LoginPage(onTap: value.togglePages);
        } else {
          return RegisterPage(onTap: value.togglePages);
        }
      },
    );
  }
}
