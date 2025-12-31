import 'package:country_flags/country_flags.dart';
import 'package:currency_country_picker/currency_country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/global-functions.dart';

Future<void> updateConversionRate(String selectedCurrencyCode) async {
  final url = Uri.parse("https://api.exchangerate-api.com/v4/latest/USD");
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    var rawRate = data["rates"][selectedCurrencyCode];


    double rate = rawRate is int ? rawRate.toDouble() : rawRate;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble("conversion_rate", rate);
    await prefs.setString("currency_code", selectedCurrencyCode);

    customPrint("Country rate ============================== $rate");
  } else {
    throw Exception("Failed to fetch exchange rate");
  }
}

Future<double> convertUSDToLocal(double usdAmount) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  double rate = prefs.getDouble("conversion_rate") ?? 1.0;
  return usdAmount * rate;
}

Future<String> formatConvertedAmount(double usdAmount) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  double rate = prefs.getDouble("conversion_rate") ?? 1.0;
  String currencyCode = prefs.getString("currency_code") ?? "USD";
  double localAmount = usdAmount * rate;

  NumberFormat format = NumberFormat.simpleCurrency(name: currencyCode);
  return format.format(localAmount);
}
Future<String> getCountryCOde() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String currencyCode = prefs.getString("currency_code") ?? "USD";


  return currencyCode;
}

class FindCurrency extends StatelessWidget {
  final double usdAmount;
  final double? size;
  final FontWeight? fontWeight;
  final Color? color;
  final TextDecoration? textDecoration;
  const FindCurrency({super.key, required this.usdAmount, this.size, this.fontWeight, this.color, this.textDecoration});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: formatConvertedAmount(usdAmount),
        builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return const SizedBox();
          }
          var data=snapshot.data;
          return MyText(text: data??'Invalid',size:size?? 10.sp,fontWeight:fontWeight?? FontWeight.w600,color: color??appPinkColor,textDecoration: textDecoration,);
        });
  }
}
