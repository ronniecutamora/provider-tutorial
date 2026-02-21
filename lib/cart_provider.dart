import 'package:flutter/material.dart';

// Simple item model
class Product {
  final String name;
  final double price;
  Product({required this.name, required this.price});
}

class CartProvider extends ChangeNotifier {
  // Our private list of items
  final List<Product> _items = [];

  // A way for the UI to see the items without changing them directly
  List<Product> get items => _items;

  // Calculate total price on the fly
  double get totalPrice => _items.fold(0, (sum, item) => sum + item.price); 

  void addToCart(Product product) {
    _items.add(product);
    
    // THE MAGIC MOMENT:
    // This tells every widget listening to 'CartProvider' to rebuild.
    notifyListeners();
  }
}