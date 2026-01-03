import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CardModel {
  final String cardHolder;
  final String cardNumber;
  final String expiryDate;
  final String cvv;
  final String id;

  CardModel({
    required this.cardHolder,
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
    required this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      'cardHolder': cardHolder,
      'cardNumber': cardNumber,
      'expiryDate': expiryDate,
      'cvv': cvv,
      'id': id,
    };
  }

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      cardHolder: json['cardHolder'],
      cardNumber: json['cardNumber'],
      expiryDate: json['expiryDate'],
      cvv: json['cvv'],
      id: json['id'],
    );
  }

  String getMaskedNumber() {
    if (cardNumber.length >= 4) {
      return "**** **** **** ${cardNumber.substring(cardNumber.length - 4)}";
    }
    return cardNumber;
  }
}

class CardProvider extends ChangeNotifier {
  List<CardModel> _cards = [];
  bool _isLoading = false;

  List<CardModel> get cards => _cards;
  bool get isLoading => _isLoading;

  CardProvider() {
    loadCards();
  }

  Future<void> loadCards() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final cardsJson = prefs.getStringList('saved_cards') ?? [];

      _cards = cardsJson.map((cardJson) {
        final cardMap = json.decode(cardJson);
        return CardModel.fromJson(cardMap);
      }).toList();
    } catch (e) {
      print('Error loading cards: $e');
      _cards = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addCard(CardModel card) async {
    _cards.add(card);
    await _saveCards();
    notifyListeners();
  }

  Future<void> removeCard(String cardId) async {
    _cards.removeWhere((card) => card.id == cardId);
    await _saveCards();
    notifyListeners();
  }

  Future<void> _saveCards() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cardsJson = _cards.map((card) => json.encode(card.toJson())).toList();
      await prefs.setStringList('saved_cards', cardsJson);
    } catch (e) {
      print('Error saving cards: $e');
    }
  }

  Future<void> clearAllCards() async {
    _cards.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('saved_cards');
    notifyListeners();
  }
}
