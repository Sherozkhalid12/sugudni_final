import 'package:flutter/material.dart';

class BottomNavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void navigateToProfile() {
    setIndex(3); // Profile/Account is at index 3
  }
}
