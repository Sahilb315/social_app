import 'package:flutter/material.dart';

class LoginRegisterProvider extends ChangeNotifier {
  bool _showLoginPage = true;
  bool get showLoginPage => _showLoginPage;

  void togglePages() {
    _showLoginPage = !_showLoginPage;
    notifyListeners();
  }
}
