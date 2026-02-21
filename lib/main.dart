// 2. THE MALL SETUP (Main)
import 'package:flutter/material.dart';
import 'package:my_provider/providers.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

// 3. THE UI
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to ThemeProvider to change the look of the whole app
    final theme = context.watch<ThemeProvider>();

    return MaterialApp(
      theme: theme.isDark ? ThemeData.dark() : ThemeData.light(),
      home: const MultiProviderScreen(),
    );
  }
}

class MultiProviderScreen extends StatelessWidget {
  const MultiProviderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MultiProvider Mall")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Listening to AuthProvider
            Consumer<AuthProvider>(
              builder: (ctx, auth, _) => Text(
                auth.isLoggedIn ? "Welcome back, User! ✅" : "Please log in. ❌",
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 20),
            
            // Listening to CartProvider
            Consumer<CartProvider>(
              builder: (ctx, cart, _) => Text("Items in Mall Cart: ${cart.count}"),
            ),
            
            const SizedBox(height: 40),
            
            // Buttons to trigger changes
            ElevatedButton(
              onPressed: () => context.read<AuthProvider>().toggleLogin(),
              child: const Text("Toggle Login"),
            ),
            ElevatedButton(
              onPressed: () => context.read<CartProvider>().add(),
              child: const Text("Add to Cart"),
            ),
            ElevatedButton(
              onPressed: () => context.read<ThemeProvider>().toggleTheme(),
              child: const Text("Switch Theme"),
            ),
          ],
        ),
      ),
    );
  }
}