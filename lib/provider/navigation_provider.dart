import 'package:flutter/material.dart';
import 'package:social_app/pages/home_page.dart';
import 'package:social_app/pages/search_page.dart';
import 'package:social_app/pages/users_page.dart';

class NavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  final List _pages = [
    const HomePage(),
    const SearchPage(),
    const UsersPage(),
  ];
  List get pages => _pages;

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
