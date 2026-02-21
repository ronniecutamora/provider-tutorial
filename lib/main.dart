import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'counter_provider.dart';

void main() {
  runApp(
    // Wrap the whole app so the Counter is available everywhere
    ChangeNotifierProvider(
      create: (context) => CounterProvider(),
      child: const MaterialApp(home: CounterScreen()),
    ),
  );
}

class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Simple Counter")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("You have pushed the button this many times:"),
            
            // THE CONSUMER: This is the specific "Radio" tuning in.
            // Only this Text widget rebuilds when notifyListeners() is called.
            Consumer<CounterProvider>(
              builder: (context, counter, child) => Text(
                '${counter.count}',
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Use context.read to trigger the action.
          // We don't need the button to rebuild, just to "DO" something.
          context.read<CounterProvider>().increment();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}