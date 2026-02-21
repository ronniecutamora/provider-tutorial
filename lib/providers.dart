import 'package:flutter/material.dart';

// 1. THE STORES (Providers)
class AuthProvider extends ChangeNotifier {
  bool isLoggedIn = false;
  void toggleLogin() {
    isLoggedIn = !isLoggedIn;
    notifyListeners();
  }
}

class CartProvider extends ChangeNotifier {
  int count = 0;
  void add() {
    count++;
    notifyListeners();
  }
}

class ThemeProvider extends ChangeNotifier {
  bool isDark = false;
  void toggleTheme() {
    isDark = !isDark;
    notifyListeners();
  }
}