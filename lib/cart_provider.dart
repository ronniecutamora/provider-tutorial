import 'package:flutter/cupertino.dart';

class CartProvider extends ChangeNotifier{
  int _items = 0;
  int get items => _items;

  void addNewItem(){
    _items++;
    notifyListeners();
  }
}