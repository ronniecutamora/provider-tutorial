import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 1. THE PARENT: AuthProvider (The Rain Sensor)
class AuthProvider extends ChangeNotifier {
  String? _userId;
  String? get userId => _userId;

  void login(String id) {
    _userId = id;
    print("Auth: User logged in as $id");
    notifyListeners();
  }

  void logout() {
    _userId = null;
    notifyListeners();
  }
}

// 2. THE DEPENDENT: CartProvider (The Sprinkler)
class CartProvider extends ChangeNotifier {
  String? _currentUserId;
  List<String> _items = [];

  List<String> get items => _items;

  // This is the method the ProxyProvider will call
  void updateUserId(String? newId) {
    // Only fetch if the ID actually changed to avoid infinite loops
    if (_currentUserId != newId) {
      _currentUserId = newId;
      _fetchUserCart();
    }
  }

  void _fetchUserCart() {
    if (_currentUserId == null) {
      _items = [];
    } else {
      // Mocking a database fetch
      _items = ["Laptop for $_currentUserId", "Mouse for $_currentUserId"];
    }
    notifyListeners();
  }
}

// 3. THE MAIN SETUP
void main() {
  runApp(
    MultiProvider(
      providers: [
        // Parent must be first
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        
        // Dependent uses ProxyProvider
        ChangeNotifierProxyProvider<AuthProvider, CartProvider>(
          create: (_) => CartProvider(),
          update: (context, auth, cart) {
            // We 'inject' the userId from Auth into the Cart
            return cart!..updateUserId(auth.userId);
          },
        ),
      ],
      child: const MaterialApp(home: ProxyScreen()),
    ),
  );
}

// 4. THE UI
class ProxyScreen extends StatelessWidget {
  const ProxyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("ProxyProvider Bridge")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              auth.userId == null ? "Status: Logged Out" : "User ID: ${auth.userId}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ...cart.items.map((item) => Text(item)).toList(),
            const SizedBox(height: 30),
            
            if (auth.userId == null)
              ElevatedButton(
                onPressed: () => context.read<AuthProvider>().login("User_99"),
                child: const Text("Login as User_99"),
              )
            else
              ElevatedButton(
                onPressed: () => context.read<AuthProvider>().logout(),
                child: const Text("Logout"),
              ),
          ],
        ),
      ),
    );
  }
}