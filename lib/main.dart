import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 1. THE DATA (ChangeNotifier)
class UserProvider extends ChangeNotifier {
  String _name = "Guest";
  String get name => _name;

  void changeName(String newName) {
    _name = newName;
    notifyListeners(); // This is the 'shout' that watch() hears!
  }
}

// 2. THE APP SETUP
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: const MaterialApp(home: WatchReadScreen()),
    ),
  );
}

// 3. THE UI
class WatchReadScreen extends StatelessWidget {
  const WatchReadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // PRINT TO CONSOLE: This shows us when the WHOLE build method runs
    print("Building the entire Screen widget!");

    // WATCH: Staring at the screen. 
    // This widget will rebuild every time notifyListeners() is called.
    final String currentName = context.watch<UserProvider>().name;

    return Scaffold(
      appBar: AppBar(title: const Text("Watch vs Read Demo")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Hello, $currentName!", style: const TextStyle(fontSize: 30)),
            const SizedBox(height: 20),
            
            ElevatedButton(
              onPressed: () {
                // READ: Taking a Polaroid.
                // We don't need to rebuild the button, we just want to call the method.
                context.read<UserProvider>().changeName("Flutter Hero");
              },
              child: const Text("Change Name to Hero"),
            ),
          ],
        ),
      ),
    );
  }
}