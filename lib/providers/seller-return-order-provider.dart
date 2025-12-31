import 'package:flutter/material.dart';

class SellerReturnOrderProvider extends ChangeNotifier{
  String _selectReturnOrderTab=SellerReturnOrderTabs.inProcess;
  String get selectReturnOrderTab=>_selectReturnOrderTab;
  String _selectOrderTab=SellerOrderTabs.completed;
  String get selectOrderTab=>_selectOrderTab;

  changeReturnOrderTab(String t){
    _selectReturnOrderTab=t;
    notifyListeners();
  }
  changeOrderTab(String t){
    _selectOrderTab=t;
    notifyListeners();
  }
}

class SellerReturnOrderTabs{
  static const String inProcess='In Process (47)';
  static const String received='Received (02)';

}
class SellerOrderTabs{
  static const String completed='Completed (47)';
  static const String pending='Pending (02)';

}