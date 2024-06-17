import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  double hourlyRate = 27.7;
  String currency = 'PLN';
  double shiftHours = 8.0;

  final List<String> currencies = [
    'USD',
    'EUR',
    'GBP',
    'JPY',
    'AUD',
    'CAD',
    'CHF',
    'CNY',
    'SEK',
    'NZD',
    'PLN'
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      hourlyRate = prefs.getDouble('hourlyRate') ?? 27.7;
      currency = prefs.getString('currency') ?? 'PLN';
      shiftHours = prefs.getDouble('shiftHours') ?? 8.0;
    });
  }

  Future<void> _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('hourlyRate', hourlyRate);
    await prefs.setString('currency', currency);
    await prefs.setDouble('shiftHours', shiftHours);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Settings Saved'),
          content: Text('Your settings have been saved successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _updateHourlyRate(String value) {
    double? rate = double.tryParse(value);
    if (rate != null) {
      setState(() {
        hourlyRate = rate;
      });
    }
  }

  void _updateShiftHours(String value) {
    double? hours = double.tryParse(value);
    if (hours != null) {
      setState(() {
        shiftHours = hours;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: 'Hourly Rate',
                hintText: '\ zł27.00',
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: _updateHourlyRate,
            ),
            DropdownButton<String>(
              value: currency,
              onChanged: (String? newValue) {
                setState(() {
                  currency = newValue!;
                });
              },
              items: currencies.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Shift Hours',
                hintText: '8.0',
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: _updateShiftHours,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveSettings,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
