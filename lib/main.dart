import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 1. THE SOURCE: LanguageProvider
class LanguageProvider extends ChangeNotifier {
  String _currentLang = "EN";
  String get currentLang => _currentLang;

  void toggleLanguage() {
    _currentLang = (_currentLang == "EN") ? "FR" : "EN";
    notifyListeners(); // Tells ProxyProvider to update
  }
}

// 2. THE DEPENDENT: TranslationsService (Also a ChangeNotifier!)
class TranslationsService extends ChangeNotifier {
  String _lang = "EN";
  
  // Our simple dictionary
  final Map<String, Map<String, String>> _data = {
    "EN": {"hello": "Hello", "subtitle": "Welcome to our app"},
    "FR": {"hello": "Bonjour", "subtitle": "Bienvenue dans notre application"},
  };

  // Called by ProxyProvider
  void updateLanguage(String newLang) {
    if (_lang != newLang) {
      _lang = newLang;
      // We could do an API call or load a JSON file here!
      notifyListeners(); // Tells the UI to turn French
    }
  }

  String translate(String key) => _data[_lang]?[key] ?? key;
}

// 3. THE SETUP
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        
        // This bridge watches LanguageProvider and updates TranslationsService
        ChangeNotifierProxyProvider<LanguageProvider, TranslationsService>(
          create: (_) => TranslationsService(),
          update: (context, langProvider, transService) {
            return transService!..updateLanguage(langProvider.currentLang);
          },
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
    // We only need to watch the Translation service for the text
    final translator = context.watch<TranslationsService>();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text(translator.translate("hello"))),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                translator.translate("subtitle"),
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // We read the Language provider to trigger the change
                  context.read<LanguageProvider>().toggleLanguage();
                },
                child: const Text("Switch Language"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}