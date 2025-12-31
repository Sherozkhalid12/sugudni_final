import 'package:shared_preferences/shared_preferences.dart';
import 'package:sugudeni/utils/global-functions.dart';

Future<void> saveSessionToken(String token)async{
  final sp=await SharedPreferences.getInstance();
  await sp.setString('sessionToken', token).then((v){
    customPrint("Token Saved");
  }).onError((err,e){
    customPrint("Error white saving token $err");
  });
}

Future<String> getSessionTaken()async{
  final sp=await SharedPreferences.getInstance();
  final token= sp.getString('sessionToken')?? '';
  return token;
}

Future<void> clearSessionToken() async {
  final sp = await SharedPreferences.getInstance();
  await sp.remove('sessionToken').then((v) {
    customPrint("Token Cleared");
  }).onError((err, e) {
    customPrint("Error while clearing token $err");
  });
}
Future<void> saveUserId(String id)async{
  final sp=await SharedPreferences.getInstance();
  await sp.setString('userId', id).then((v){
    customPrint("userId Saved");
  }).onError((err,e){
    customPrint("Error white saving userId $err");
  });
}

Future<String> getUserId()async{
  final sp=await SharedPreferences.getInstance();
  final token= sp.getString('userId')?? '';
  return token;
}

Future<void> clearUserId() async {
  final sp = await SharedPreferences.getInstance();
  await sp.remove('userId').then((v) {
    customPrint("userId Cleared");
  }).onError((err, e) {
    customPrint("Error while clearing userId $err");
  });
}
Future<void> saveSessionTokenAndUserId(String token,String id)async{
  final sp=await SharedPreferences.getInstance();
  await sp.setString('sessionToken', token).then((v){
    customPrint("userId Saved");
  }).onError((err,e){
    customPrint("Error white saving token $err");
  });
  await sp.setString('userId', id).then((v){
    customPrint("userId Saved");
  }).onError((err,e){
    customPrint("Error white saving userId $err");
  });
}


Future<void> clearSessionTokenAndUserId() async {
  final sp = await SharedPreferences.getInstance();
  await sp.remove('sessionToken').then((v) {
    customPrint("sessionToken Cleared");
  }).onError((err, e) {
    customPrint("Error while clearing sessionToken $err");
  });
  await sp.remove('userId').then((v) {
    customPrint("userId Cleared");
  }).onError((err, e) {
    customPrint("Error while clearing userId $err");
  });
}
