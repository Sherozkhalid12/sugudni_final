import 'package:shared_preferences/shared_preferences.dart';
import 'package:sugudeni/utils/global-functions.dart';


Future<void> setUserRegistered(bool value)async{
  final sp=await SharedPreferences.getInstance();
  await sp.setBool('isRegistered', value).then((v){
    customPrint("status set");
  }).onError((err,e){
    customPrint("Error white saving user status $err");
  });
}
Future<void> removeUser()async{
  final sp=await SharedPreferences.getInstance();
  await sp.setBool('isRegistered', false).then((v){
    customPrint("User status system");
  }).onError((err,e){
    customPrint("Error white saving user board $err");
  });
}

Future<bool> isUserRegistered()async{
  final sp=await SharedPreferences.getInstance();
  final token= sp.getBool('isRegistered')?? false;
  return token;

}