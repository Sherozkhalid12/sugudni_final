import 'package:shared_preferences/shared_preferences.dart';
import 'package:sugudeni/utils/global-functions.dart';

Future<void> saveUserType(String token)async{
  final sp=await SharedPreferences.getInstance();
  await sp.setString('userType', token).then((v){
    customPrint("User Type Saved");
  }).onError((err,e){
    customPrint("Error white saving User Type $err");
  });
}

Future<String> getUserType()async{
  final sp=await SharedPreferences.getInstance();
  final token= sp.getString('userType')?? '';
  return token;
}

Future<void> clearUserType() async {
  final sp = await SharedPreferences.getInstance();
  await sp.remove('userType').then((v) {
    customPrint("User Type Cleared");
  }).onError((err, e) {
    customPrint("Error while User Type $err");
  });
}