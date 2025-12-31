import 'package:flutter/material.dart';

class SellerProductReviewProvider extends ChangeNotifier{
  String _selectProductReviewTab=SellerProductReviewTabs.products;
  String get selectProductReviewTab=>_selectProductReviewTab;

  changeProductReviewTab(String t){
    _selectProductReviewTab=t;
    notifyListeners();
  }
}

class SellerProductReviewTabs{
  static const String products='Products (47)';
  static const String delivery='Delivery (02)';

}