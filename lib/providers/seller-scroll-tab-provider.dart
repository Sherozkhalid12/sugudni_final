import 'package:flutter/material.dart';
import 'package:sugudeni/view/seller/home/ordertabs/all-order-tab.dart';
import 'package:sugudeni/view/seller/home/ordertabs/delivered-tab.dart';
import 'package:sugudeni/view/seller/home/ordertabs/failure-tab.dart';
import 'package:sugudeni/view/seller/home/ordertabs/shipping-tab.dart';
import 'package:sugudeni/view/seller/home/ordertabs/to-ship-tab.dart';
import 'package:sugudeni/view/seller/home/ordertabs/un-paid.dart';

class SellerScrollTabProvider extends ChangeNotifier{
  String _selectHomeTab=SellerHomeTabs.all;
  String get selectedHomeTab=>_selectHomeTab;

  changeHomeTab(String t){
    _selectHomeTab=t;
    notifyListeners();
  }

 Widget getTab(){
    if(selectedHomeTab==SellerHomeTabs.all){
      return const SellerAllOrderTab();
    }
    if(selectedHomeTab==SellerHomeTabs.toShip){
      return const SellerToShipOrderTab();
    }if(selectedHomeTab==SellerHomeTabs.unPaid){
      return const SellerUnpaidOrderTab();
    }
    if(selectedHomeTab==SellerHomeTabs.shipping){
      return const SellerShippingOrderTab();
    }
    if(selectedHomeTab==SellerHomeTabs.delivered){
      return const SellerDeliveredOrderTab();
    }
    if(selectedHomeTab==SellerHomeTabs.failure){
      return const SellerFailedOrderTab();
    }
    return const Text("data");
  }
}

class SellerHomeTabs{
  static const String all='All';
  static const String unPaid='Unpaid';
  static const String toShip='To Ship';
  static const String shipping='Shipping';
  static const String delivered='Delivered';
  static const String failure='Failure';
}