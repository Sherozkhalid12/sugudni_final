import 'package:flutter/material.dart';

class CustomerHelpCenterProvider extends ChangeNotifier{

  String _selectedMainIssue=MainIssues.orderIssues;
  String get selectedMainIssue=>_selectedMainIssue;

String _selectedOrderIssue=MainIssues.orderIssues;
  String get selectedOrderIssue=>_selectedOrderIssue;


  changeMainIssue(String i){
    _selectedMainIssue=i;
    notifyListeners();
  }
  changeOrderIssue(String i){
    _selectedOrderIssue=i;
    notifyListeners();
  }
}

class MainIssues{
  static const String orderIssues='Order Issues';
  static const String itemQuantity='Item Quantity';
  static const String paymentIssues='Payment Issues';
  static const String technicalIssues='Technical Issues';
  static const String other='Other';
}
class OrderIssues{
  static const String orderIssues="I didn't receive my parcel";
  static const String itemQuantity='I want to cancel my order';
  static const String paymentIssues='I want to return my order';
  static const String technicalIssues='Package was damaged';
  static const String other='Other';
}