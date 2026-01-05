import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';
import 'package:sugudeni/utils/user-roles.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'constants/colors.dart';

void customPrint(String message){
  debugPrint(message);
}
String dateFormat(DateTime dateTime){
  return DateFormat('d, MMM yyyy').format(dateTime);
}
String timeFormat(DateTime dateTime){
  return DateFormat('hh:mm a').format(dateTime);
}
String capitalizeFirstLetter(String text) {
  if (text.isEmpty) {
    return text;
  }
  return text[0].toUpperCase() + text.substring(1);
}
String changeDateFormat(DateTime date) {
  final DateFormat formatter = DateFormat('MM-dd-yyyy');
  return formatter.format(date);
}

DateTime convertToDateTime(TimeOfDay time) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day, time.hour, time.minute);
}
String firstTwoLetters(String input) {
  return input.length >= 2 ? input.substring(0, 2) : input;
}
String capitalizeEachWord(String text) {
  if (text.isEmpty) {
    return text;
  }

  List<String> words = text.split(' ');

  /// Capitalize the first letter of each word
  List<String> capitalizedWords =
  words.map((word) => capitalizeFirstLetter(word)).toList();

  return capitalizedWords.join(' ');
}
String getReminderType(String type){
  if(type=='minutesBefore'){
    return 'Minutes before';
  }else if(type=='hoursBefore'){
    return 'Hours before';
  }else if(type=='daysBefore'){
    return 'Days before';
  }else{
    return 'Weeks before';
  }
}
bool isValidEmail(String email) {
  // Regular expression for validating an email
  String pattern =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  RegExp regex = RegExp(pattern);
  return regex.hasMatch(email);
}
String zeroNonZero(int number) {
  return number < 10 ? '0$number' : '$number';
}
String? getMimeType(String filePath) {
  return lookupMimeType(filePath);
}
String mergeAndSortStrings(String str1, String str2) {
  String concatenated = str1 + str2;

  List<String> characters = concatenated.split('');

  characters.sort();

  return characters.join('');
}
double calculateDentistShare(String percentage, double amount) {
  double parsePercentage=double.parse(percentage);
  return (parsePercentage / 100) * amount;

}String listToString(List<String> strings) {
  return strings.join(',');
}
double divideByThousand(double value) {
  return value / 1000;
}
String getSenderId(List<String> ids, String id) {
  for (String item in ids) {
    if (item != id) {
      return item;
    }
  }
  return '';
}
void showSnackbar(BuildContext context, String message, {Duration duration = const Duration(seconds: 2),Color? color=blackColor}) {
  // Use addPostFrameCallback to ensure context is valid
  WidgetsBinding.instance.addPostFrameCallback((_) {
    try {
      // First try maybeOf to avoid throwing if context is invalid
      final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
      if (scaffoldMessenger != null) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(message),
            duration: duration,
            backgroundColor: color,
            clipBehavior: Clip.hardEdge,
            behavior: SnackBarBehavior.floating,
          ),
        );
        customPrint("Snackbar displayed successfully: $message");
        return;
      }
      
      // Fallback to of() if maybeOf returns null but context might still be valid
      try {
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(message),
            duration: duration,
            backgroundColor: color,
            clipBehavior: Clip.hardEdge,
            behavior: SnackBarBehavior.floating,
          ),
        );
        customPrint("Snackbar displayed using of(): $message");
      } catch (e) {
        customPrint("Error showing snackbar with of(): $e");
      }
    } catch (e) {
      customPrint("Error showing snackbar: $e");
    }
  });
}
String timeAgo(DateTime messageTime) {
  DateTime now = DateTime.now();
  Duration difference = now.difference(messageTime);

  if (difference.inSeconds < 60) {
    return "Now";
  } else if (difference.inMinutes == 1) {
    return "One minute ago";
  } else if (difference.inMinutes < 60) {
    return "${difference.inMinutes} minutes ago";
  } else if (difference.inHours == 1) {
    return "One hour ago";
  } else if (difference.inHours < 24) {
    return "${difference.inHours} hours ago";
  } else if (difference.inDays == 1) {
    return "Yesterday";
  } else if (difference.inDays < 7) {
    return "${difference.inDays} days ago";
  } else {
    return "${messageTime.day}/${messageTime.month}/${messageTime.year}";
  }
}
DateTime mergeDateAndTime(DateTime date, String time) {
  List<String> timeParts = time.split(' ');
  String timeOfDay = timeParts[1]; // AM or PM
  List<String> hourMinute = timeParts[0].split(':');

  int hour = int.parse(hourMinute[0]);
  int minute = int.parse(hourMinute[1]);

  if (timeOfDay == 'PM' && hour != 12) {
    hour += 12; // Convert PM hour to 24-hour format
  } else if (timeOfDay == 'AM' && hour == 12) {
    hour = 0; // Midnight case (12 AM)
  }

  return DateTime(date.year, date.month, date.day, hour, minute);
}
void navigateBasedOnRole(String role,BuildContext context)async{
  if(role==UserRoles.admin){
    // Admin role removed from selection, redirect to customer
    Navigator.pushNamedAndRemoveUntil(context, RoutesNames.customerBottomNav, (route) => false);
  }else if(role==UserRoles.seller){
    Navigator.pushNamedAndRemoveUntil(context, RoutesNames.sellerBottomNav, (route) => false);
  }else if(role==UserRoles.driver){
    Navigator.pushNamedAndRemoveUntil(context, RoutesNames.driverHomeView, (route) => false);
  }else {
    Navigator.pushNamedAndRemoveUntil(context, RoutesNames.customerBottomNav, (route) => false);
  }
}
// void navigateBasedOnRole(String role,BuildContext context)async{
//   if(role==UserRoles.admin){
//     Navigator.pushNamed(context, RoutesNames.signUpView);
//   }else if(role==UserRoles.seller){
//     Navigator.pushNamed(context, RoutesNames.sellerBottomNav);
//
//   }else if(role==UserRoles.driver){
//     Navigator.pushNamed(context, RoutesNames.driverSignUpView);
//   }else {
//     Navigator.pushNamed(context, RoutesNames.customerBottomNav);
//
//     // bool isRegestered=await isUserRegistered()??false;
//     // if(isRegestered==false){
//     //   Navigator.pushNamed(context, RoutesNames.signUpView);
//     //
//     // }else{
//     //   Navigator.pushNamed(context, RoutesNames.customerBottomNav);
//     //
//     // }
//
//   }
// }

int getAlpha(double opacity){
  double op=opacity*255.0;
  return op.round();
}

Future<bool> checkInternetConnection() async {
  try {
    // Check the connectivity status
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      return false; // No connectivity
    }

    // Perform an actual internet check by pinging a server
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true; // Connected
    } else {
      return false; // Not connected
    }
  } catch (e) {
    return false; // Error occurred
  }
}
String calculateDiscountPercentage(double previousPrice, double discountedPrice) {
  if (previousPrice <= 0 || discountedPrice < 0 || discountedPrice > previousPrice) {
    return "Invalid";
  }
  double discount = ((previousPrice - discountedPrice) / previousPrice) * 100;
  return "${discount.toStringAsFixed(2)}%";
}
void showToast(String? msg,Color? bgColor){
  Fluttertoast.showToast(msg: msg?? "Invalid",backgroundColor:bgColor??blackColor);
}


String orderFormatDate(DateTime date) {
  return DateFormat('MM-dd-yyyy').format(date);
}
String formatDateTime(DateTime dateTime) {
  String day = DateFormat('d').format(dateTime);
  String suffix = getDaySuffix(int.parse(day));
  String formattedDate = DateFormat("MMM yyyy HH:mm").format(dateTime);

  return "$day$suffix $formattedDate";
}

String getDaySuffix(int day) {
  if (day >= 11 && day <= 13) return "th";
  switch (day % 10) {
    case 1:
      return "st";
    case 2:
      return "nd";
    case 3:
      return "rd";
    default:
      return "th";
  }
}
String tokenEmpty='Token is empty';
// Function to get the month abbreviation (e.g., OCT)
String getMonthAbbreviation(DateTime dateTime) {
  return DateFormat('MMM').format(dateTime).toUpperCase();
}

// Function to get the day of the week (e.g., SAT)
String getDayAbbreviation(DateTime dateTime) {
  return DateFormat('EEE').format(dateTime).toUpperCase();
}

// Function to get the formatted date (e.g., 01, 02)
String getFormattedDate(DateTime dateTime) {
  return DateFormat('dd').format(dateTime);
}

// Function to get the formatted time (e.g., 14:54)
String getFormattedTime(DateTime dateTime) {
  return DateFormat('HH:mm').format(dateTime);
}