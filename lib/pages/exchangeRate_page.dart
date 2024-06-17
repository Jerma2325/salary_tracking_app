import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ExchangeRatesPage extends StatefulWidget {
  @override
  _ExchangeRatesPageState createState() => _ExchangeRatesPageState();
}

class _ExchangeRatesPageState extends State<ExchangeRatesPage> {
  final TextEditingController _amountController = TextEditingController();
  String _selectedCurrencyFrom = 'USD';
  String _selectedCurrencyTo = 'EUR';
  double _convertedAmount = 0.0;
  bool _isLoading = false;
  Map<String, dynamic> _conversionRates = {};

  final List<String> _currencies = [
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
    fetchConversionRates();
  }

  Future<void> fetchConversionRates() async {
    setState(() {
      _isLoading = true;
    });

    final apiKey = 'd50ed006cefdd5a43e7b9b6d';
    final response = await http.get(
      Uri.parse('https://v6.exchangerate-api.com/v6/$apiKey/latest/USD'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _conversionRates = data['conversion_rates'];
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  void _convertCurrency() {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || _conversionRates.isEmpty) {
      return;
    }

    final rateFrom = _conversionRates[_selectedCurrencyFrom] ?? 1.0;
    final rateTo = _conversionRates[_selectedCurrencyTo] ?? 1.0;
    setState(() {
      _convertedAmount = amount * (rateTo / rateFrom);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Exchange Rates'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButton<String>(
                          value: _selectedCurrencyFrom,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedCurrencyFrom = newValue!;
                            });
                          },
                          items: _currencies
                              .map<DropdownMenuItem<String>>(
                                  (String value) => DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      ))
                              .toList(),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Amount',
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButton<String>(
                          value: _selectedCurrencyTo,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedCurrencyTo = newValue!;
                            });
                          },
                          items: _currencies
                              .map<DropdownMenuItem<String>>(
                                  (String value) => DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      ))
                              .toList(),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Converted: ${_convertedAmount.toStringAsFixed(2)} $_selectedCurrencyTo',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _convertCurrency,
                    child: Text('Convert'),
                  ),
                ],
              ),
      ),
    );
  }
}
