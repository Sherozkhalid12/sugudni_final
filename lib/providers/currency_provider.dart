import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyProvider extends ChangeNotifier {
  String _currencyCode = 'USD';
  double _conversionRate = 1.0;
  bool _isLoading = false;

  String get currencyCode => _currencyCode;
  double get conversionRate => _conversionRate;
  bool get isLoading => _isLoading;

  CurrencyProvider() {
    loadCurrencyData();
  }

  Future<void> loadCurrencyData() async {
    _isLoading = true;
    notifyListeners();

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _currencyCode = prefs.getString("currency_code") ?? "USD";
      _conversionRate = prefs.getDouble("conversion_rate") ?? 1.0;
    } catch (e) {
      _currencyCode = "USD";
      _conversionRate = 1.0;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateConversionRate(String selectedCurrencyCode) async {
    _isLoading = true;
    notifyListeners();

    try {
      final url = Uri.parse("https://api.exchangerate-api.com/v4/latest/USD");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        var rawRate = data["rates"][selectedCurrencyCode];

        double rate = rawRate is int ? rawRate.toDouble() : rawRate;

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setDouble("conversion_rate", rate);
        await prefs.setString("currency_code", selectedCurrencyCode);

        _currencyCode = selectedCurrencyCode;
        _conversionRate = rate;

        print("Country rate ============================== $rate");
      } else {
        throw Exception("Failed to fetch exchange rate");
      }
    } catch (e) {
      print("Error updating conversion rate: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<double> convertUSDToLocal(double usdAmount) async {
    return usdAmount * _conversionRate;
  }

  Future<String> formatConvertedAmount(double usdAmount) async {
    double localAmount = usdAmount * _conversionRate;
    // Simple currency formatting for now
    return "${_currencyCode} ${localAmount.toStringAsFixed(2)}";
  }

  String getCountryCode() {
    return _currencyCode;
  }
}
