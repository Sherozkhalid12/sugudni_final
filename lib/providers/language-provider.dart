
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeLanguageProvider with ChangeNotifier{

  Locale? _appLocale;
  Locale? get appLocal =>_appLocale;

  void changeLanguage(Locale type) async{
    SharedPreferences sp=await SharedPreferences.getInstance();
    _appLocale=type;
    if(type==const Locale('en')){
      await sp.setString("language_code", 'en');
    }else{
      await sp.setString("language_code", 'fr');
    }
    notifyListeners();
  }

}
Future<String> getUserLanguage()async{
  final sp=await SharedPreferences.getInstance();
  final token= sp.getString('language_code')?? 'en';
  return token;
}
