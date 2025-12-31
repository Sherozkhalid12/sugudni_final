
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';
import 'package:sugudeni/utils/sharePreference/is-user-registered.dart';
import 'package:sugudeni/utils/sharePreference/save-user-token.dart';
import 'package:sugudeni/utils/sharePreference/save-user-type.dart';
import 'package:sugudeni/utils/user-roles.dart';

class SplashServices{

  void isLoggedIn(BuildContext context)async{
   String userId=await getUserId();
   String userType=await getUserType();
   customPrint("User Id in splash ===================================$userId");
   customPrint("User type in splash ===================================$userType");
   if(userId.isNotEmpty){
     if(userType==UserRoles.customer){
       Timer(const Duration(seconds: 3), () => Navigator.pushNamedAndRemoveUntil(context,RoutesNames.customerBottomNav,(route) => false,));

     }else if(userType==UserRoles.seller){
       Timer(const Duration(seconds: 3), () => Navigator.pushNamedAndRemoveUntil(context,RoutesNames.sellerBottomNav,(route) => false,));

     }else{
       Timer(const Duration(seconds: 3), () => Navigator.pushNamedAndRemoveUntil(context,RoutesNames.driverHomeView,(route) => false,));
     }
   }else{
     Timer(const Duration(seconds: 3), () => Navigator.pushNamedAndRemoveUntil(context,RoutesNames.customerBottomNav,(route) => false,));

   }
  }

}