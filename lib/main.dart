import 'package:flutter/material.dart';
import 'package:grind_app/pages/exchangeRate_page.dart';
import 'package:grind_app/pages/main_page.dart';
import 'package:grind_app/pages/settings_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Job Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
      routes: {
        '/exchangeRates': (context) => ExchangeRatesPage(),
        '/settings': (context) =>
            SettingsPage(), // Ensure you implement SettingsPage
      },
    );
  }
}
