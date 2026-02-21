import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 1. THE DATA (Weather Station)
class WeatherProvider extends ChangeNotifier {
  double _temp = 25.0;
  double _humidity = 60.0;

  double get temp => _temp;
  double get humidity => _humidity;

  void changeTemp() {
    _temp++;
    notifyListeners();
  }

  void changeHumidity() {
    _humidity++;
    notifyListeners();
  }
}

// 2. THE MAIN METHOD (The Engine)
void main() {
  runApp(
    // We must provide the WeatherProvider at the very top!
    ChangeNotifierProvider(
      create: (_) => WeatherProvider(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: PerformanceScreen(),
      ),
    ),
  );
}

// 3. THE UI
class PerformanceScreen extends StatelessWidget {
  const PerformanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // This print will ONLY run once when the app starts.
    print("Main build method: I am staying still! ✅");

    return Scaffold(
      appBar: AppBar(title: const Text("Consumer vs Selector")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // --- THE CONSUMER (Soundproof Booth) ---
            Consumer<WeatherProvider>(
              builder: (context, weather, child) {
                print("Consumer: Rebuilding for ANY change...");
                return Text(
                  "Humidity: ${weather.humidity}%",
                  style: const TextStyle(fontSize: 20),
                );
              },
            ),

            const SizedBox(height: 20),

            // --- THE SELECTOR (Smart Filter) ---
            Selector<WeatherProvider, double>(
              selector: (context, weather) => weather.temp,
              builder: (context, temp, child) {
                print("Selector: Rebuilding ONLY for Temp! 🔥");
                return Text(
                  "Temperature: $temp°C", 
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
                );
              },
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () => context.read<WeatherProvider>().changeTemp(),
              child: const Text("Change Temp (Both Rebuild)"),
            ),
            ElevatedButton(
              onPressed: () => context.read<WeatherProvider>().changeHumidity(),
              child: const Text("Change Humidity (Only Consumer Rebuilds)"),
            ),
          ],
        ),
      ),
    );
  }
}