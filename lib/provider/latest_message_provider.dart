import 'package:flutter/material.dart';

class LatestMessageProvider with ChangeNotifier {
  Map<String, String> _latestMessage = {};

  Map<String, String> get latestMessage => _latestMessage;

  void updateLatestMessage(Map<String, String> value) {
    _latestMessage = value;
    notifyListeners();
  }

}
