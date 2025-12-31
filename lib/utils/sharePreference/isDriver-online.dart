import 'package:shared_preferences/shared_preferences.dart';
import 'package:sugudeni/utils/global-functions.dart';


Future<void> setDriverOnlineStatus(bool value)async{
  final sp=await SharedPreferences.getInstance();
  await sp.setBool('isDriverOnline', value).then((v){
    customPrint("status set");
  }).onError((err,e){
    customPrint("Error white saving user status $err");
  });
}
Future<void> removeDriverOnlineStatus()async{
  final sp=await SharedPreferences.getInstance();
  await sp.setBool('isDriverOnline', false).then((v){
    customPrint("User status system");
  }).onError((err,e){
    customPrint("Error white saving user board $err");
  });
}

Future<bool> isDriverOnline()async{
  final sp=await SharedPreferences.getInstance();
  final token= sp.getBool('isDriverOnline')?? false;
  return token;

}