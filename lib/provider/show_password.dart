import 'package:flutter/material.dart';

class ShowPasswordProvider extends ChangeNotifier {
  bool _showPasswordLogin = true;
  bool get showPasswordLogin => _showPasswordLogin;

  bool _showPasswordRegister = true;
  bool get showPasswordRegister => _showPasswordRegister;

  void togglePasswordLogin() {
    _showPasswordLogin = !_showPasswordLogin;
    notifyListeners();
  }

  void togglePasswordRegister() {
    _showPasswordRegister = !_showPasswordRegister;
    notifyListeners();
  }
}
