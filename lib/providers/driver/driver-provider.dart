import 'package:flutter/material.dart';
import 'package:sugudeni/repositories/auth/driver-auth-repository.dart';
import 'package:sugudeni/utils/global-functions.dart';

import '../../utils/constants/colors.dart';
import '../../utils/sharePreference/isDriver-online.dart';

class DriverProvider extends ChangeNotifier{

  bool isDriver=false;
  bool isToggling = false;

  Future<void>toggleDriver(BuildContext context)async{
    if (isToggling) return; // Prevent multiple simultaneous toggles
    
    isToggling = true;
    notifyListeners();
    
    try{
      await DriverAuthRepository.toggleDriver(context).then((v){
        setDriverOnlineStatus(v.driverOnline);
        notifyListeners();
        isToggling = false;
        notifyListeners();
      }).catchError((error) {
        customPrint("Driver toggle error caught in provider: $error");
        isToggling = false;
        notifyListeners();
        
        // Always show snackbar for errors in provider as primary method
        if (context.mounted) {
          String errorMessage = error.toString().replaceAll('Exception: ', '');
          
          // Format the message for approval errors
          if (errorMessage.toLowerCase().contains('not approved') || 
              errorMessage.toLowerCase().contains('approval') ||
              errorMessage.toLowerCase().contains('pending approval')) {
            errorMessage = 'Your driver account is pending approval. Please wait for admin approval before going online.';
          }
          
          // Use WidgetsBinding to ensure snackbar shows after current frame
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              try {
                customPrint("Attempting to show snackbar in provider: $errorMessage");
                // Check if ScaffoldMessenger is available
                final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
                if (scaffoldMessenger != null) {
                  showSnackbar(context, errorMessage, color: redColor);
                  customPrint("Snackbar call completed in provider for error: $errorMessage");
                } else {
                  customPrint("ScaffoldMessenger not available, trying with delay");
                  // Try again with a small delay to allow widget tree to settle
                  Future.delayed(const Duration(milliseconds: 200), () {
                    if (context.mounted) {
                      try {
                        showSnackbar(context, errorMessage, color: redColor);
                        customPrint("Snackbar shown after delay");
                      } catch (e2) {
                        customPrint("Error showing snackbar after delay: $e2");
                      }
                    }
                  });
                }
              } catch (e) {
                customPrint("Error showing snackbar in provider: $e");
                // Try again with a small delay
                Future.delayed(const Duration(milliseconds: 200), () {
                  if (context.mounted) {
                    try {
                      showSnackbar(context, errorMessage, color: redColor);
                    } catch (e2) {
                      customPrint("Second attempt to show snackbar also failed: $e2");
                    }
                  }
                });
              }
            } else {
              customPrint("Context not mounted when trying to show snackbar");
            }
          });
        }
      });
    }catch(e){
      customPrint("Driver toggle exception caught in provider: $e");
      isToggling = false;
      notifyListeners();
      
      // Always show snackbar for errors in provider as primary method
      if (context.mounted) {
        String errorMessage = e.toString().replaceAll('Exception: ', '');
        
        // Format the message for approval errors
        if (errorMessage.toLowerCase().contains('not approved') || 
            errorMessage.toLowerCase().contains('approval') ||
            errorMessage.toLowerCase().contains('pending approval')) {
          errorMessage = 'Your driver account is pending approval. Please wait for admin approval before going online.';
        }
        
        // Use WidgetsBinding to ensure snackbar shows after current frame
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            try {
              customPrint("Attempting to show snackbar in provider for exception: $errorMessage");
              // Check if ScaffoldMessenger is available
              final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
              if (scaffoldMessenger != null) {
                showSnackbar(context, errorMessage, color: redColor);
                customPrint("Snackbar call completed in provider for exception: $errorMessage");
              } else {
                customPrint("ScaffoldMessenger not available, trying with delay");
                // Try again with a small delay to allow widget tree to settle
                Future.delayed(const Duration(milliseconds: 200), () {
                  if (context.mounted) {
                    try {
                      showSnackbar(context, errorMessage, color: redColor);
                      customPrint("Snackbar shown after delay");
                    } catch (e2) {
                      customPrint("Error showing snackbar after delay: $e2");
                    }
                  }
                });
              }
            } catch (err) {
              customPrint("Error showing snackbar in provider: $err");
              // Try again with a small delay
              Future.delayed(const Duration(milliseconds: 200), () {
                if (context.mounted) {
                  try {
                    showSnackbar(context, errorMessage, color: redColor);
                  } catch (e2) {
                    customPrint("Second attempt to show snackbar also failed: $e2");
                  }
                }
              });
            }
          } else {
            customPrint("Context not mounted when trying to show snackbar for exception");
          }
        });
      }
    }
  }
}