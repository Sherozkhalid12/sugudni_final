import 'package:flutter/material.dart';

class ReviewTabProvider extends ChangeNotifier{

  String _selectedTab=ReviewTabs.all;
  String get selectedTab=>_selectedTab;


  changeTab(String t){
    _selectedTab=t;
    notifyListeners();
  }

}

class ReviewTabs{
  static const String all='All';
  static const String withPhotos='with photos';
  static const String withVideos='with videos';
}