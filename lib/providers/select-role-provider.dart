import 'package:flutter/material.dart';
import 'package:sugudeni/utils/user-roles.dart';

class SelectRoleProvider extends ChangeNotifier{
  String _selectedRole=UserRoles.customer;
  String get selectedRole=>_selectedRole;

  void changeRole(String role){
    _selectedRole=role;
    notifyListeners();
  }


  void clearResources(){
    _selectedRole=UserRoles.customer;
  }

}