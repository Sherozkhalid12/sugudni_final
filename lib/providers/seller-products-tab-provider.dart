

import 'package:flutter/material.dart';
import 'package:sugudeni/view/seller/products/tabsScreens/active-tab.dart';
import 'package:sugudeni/view/seller/products/tabsScreens/draft-tab.dart';
import 'package:sugudeni/view/seller/products/tabsScreens/inactive-tab.dart';
import 'package:sugudeni/view/seller/products/tabsScreens/out-of-stock-tab.dart';
import 'package:sugudeni/view/seller/products/tabsScreens/pending-tab.dart';
import 'package:sugudeni/view/seller/products/tabsScreens/violation-tab.dart';

class SellerProductsTabProvider extends ChangeNotifier{
  String _selectedProductTab=SellerProductTabs.active;
  String get selectedProductTab=>_selectedProductTab;

  changeProductTab(String t){
    _selectedProductTab=t;
    notifyListeners();
  }

  List<Widget> productsTabs=[
    const ActiveTab(),
    const InActiveTab(),
    const DraftTab(),
    const PendingTab(),
    const ViolationTab(),
    const OutOfStockTab()
  ];


  Widget showTab(){
    if(selectedProductTab==SellerProductTabs.active){
      return productsTabs[0];

    }else if(selectedProductTab==SellerProductTabs.inActive){
      return productsTabs[1];

    }else if(selectedProductTab==SellerProductTabs.draft){
      return productsTabs[2];

    }else if(selectedProductTab==SellerProductTabs.pendingQc){
      return productsTabs[3];

    }
    else if(selectedProductTab==SellerProductTabs.violation){
      return productsTabs[4];

    }
    else{
      return productsTabs[5];

    }
  }

  clearResources(){
    _selectedProductTab=SellerProductTabs.active;
  }
}

class SellerProductTabs{
  static const String active='Active';
  static const String inActive='Inactive';
  static const String draft='Draft';
  static const String pendingQc='Pending Qc';
  static const String violation='Violation';
  static const String outOfStock='Out of Stock';
}