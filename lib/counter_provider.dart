import 'package:flutter/material.dart';

class CounterProvider extends ChangeNotifier {
  int count = 0;

  void increment() {
    count++;
    // This is the most important line. 
    // Without it, the UI stays frozen even if the number changes.
    notifyListeners(); 
  }
}