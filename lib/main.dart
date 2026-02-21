import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 1. THE SOURCE: ThemeProvider (ChangeNotifier)
class ThemeProvider extends ChangeNotifier {
  String _colorName = "Blue";
  Color _actualColor = Colors.blue;

  String get colorName => _colorName;
  Color get actualColor => _actualColor;

  void switchToRed() {
    _colorName = "Red";
    _actualColor = Colors.red;
    notifyListeners();
  }
}

// 2. THE DEPENDENT: AppSettings (Simple Class - NO ChangeNotifier)
// This class is just a "container" for data.
class AppSettings {
  final String themeTitle;
  final Color displayColor;

  AppSettings({required this.themeTitle, required this.displayColor});
}

// 3. THE MAIN SETUP
void main() {
  runApp(
    MultiProvider(
      providers: [
        // Source Provider
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        
        // ProxyProvider: Listens to ThemeProvider, creates AppSettings
        ProxyProvider<ThemeProvider, AppSettings>(
          update: (context, theme, previous) => AppSettings(
            themeTitle: "Current Mood: ${theme.colorName}",
            displayColor: theme.actualColor,
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

// 4. THE UI
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // We listen to the Simple Class (AppSettings), NOT the ThemeProvider directly
    final settings = context.watch<AppSettings>();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(settings.themeTitle),
          backgroundColor: settings.displayColor,
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              // We change the source, and ProxyProvider updates the Dependent
              context.read<ThemeProvider>().switchToRed();
            },
            child: const Text("Switch Theme Source"),
          ),
        ),
      ),
    );
  }
}