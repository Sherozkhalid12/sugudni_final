import 'package:flutter/material.dart';
import 'package:sugudeni/models/messages/SellerThreadsResponse.dart';
import 'package:sugudeni/repositories/messages/seller-messages-repository.dart';

class SellerMessagesProvider extends ChangeNotifier{
  String _selectMessageTab=SellerMessagesTabs.customer;
  String get selectMessageTab=>_selectMessageTab;

  changeMessageTab(String t){
    _selectMessageTab=t;
    notifyListeners();
  }
}

class SellerMessagesTabs{
  static const String customer='Customer';
  static const String system='System';

}