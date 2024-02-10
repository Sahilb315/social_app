import 'package:flutter/material.dart';

class LatestMessageProvider with ChangeNotifier {
  Map<int, String> _latestMessage = {};

  Map<int, String> get latestMessage => _latestMessage;

  void updateLatestMessage(Map<int, String> value) {
    _latestMessage = value;
    notifyListeners();
  }

}
