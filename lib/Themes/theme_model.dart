import 'package:flutter/material.dart';

class ThemeModel extends ChangeNotifier {
  bool _isdarkMode = false;

  bool get isDarkMode => _isdarkMode;

  void toggleTheme() {
    _isdarkMode = !_isdarkMode;
    notifyListeners();
  }
}
