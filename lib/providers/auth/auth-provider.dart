import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/models/auth/SignInModel.dart';
import 'package:sugudeni/models/auth/SignInWithPhoneModel.dart';
import 'package:sugudeni/models/auth/SignUpModel.dart';
import 'package:sugudeni/models/auth/VerifySignInOtpModel.dart';
import 'package:sugudeni/models/auth/VerifySignUpOtpModel.dart';
import 'package:sugudeni/providers/loading-provider.dart';
import 'package:sugudeni/providers/select-role-provider.dart';
import 'package:sugudeni/repositories/auth/auth-repository.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';
import 'package:sugudeni/utils/sharePreference/save-user-token.dart';
import 'package:sugudeni/utils/sharePreference/save-user-type.dart';
import 'package:sugudeni/utils/user-roles.dart';
import 'package:sugudeni/services/firebase-messaging-service.dart';

import '../../models/auth/SuccessfullVerifyOtpResponse.dart';
import '../../utils/constants/colors.dart';
import '../../l10n/app_localizations.dart';

class AuthProvider extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final signUpEmailController = TextEditingController();
  final signUpPhoneController = TextEditingController();
  final signUpPasswordController = TextEditingController();
  final otpController = TextEditingController();
  final phoneController = TextEditingController();

  bool isSignUp = true;
  bool isEmail = true; // Toggle between email and phone sign-up
  bool isRemember = false;
  String otpPreference = 'sms'; // Default for phone sign-up
  String countryCode = '+33';

  bool _showPassword = false;

  bool get showPassword => _showPassword;
  ValueKey<bool> get passwordFieldKey => ValueKey(_showPassword);

  void togglePasswordVisibility() {
    _showPassword = !_showPassword;
    print("Password visibility toggled: $_showPassword"); // Add this
    notifyListeners();
  }

  void toggleSignUpMethod(bool useEmail) {
    isEmail = useEmail;
    if (!isEmail) {
      signUpEmailController.clear();
    } else {
      signUpPhoneController.clear();
    }
    notifyListeners();
  }

  void changeCountryCode(String c) {
    countryCode = c;
    notifyListeners();
  }

  void setOptPreferences(String value) {
    if (!isEmail) {
      otpPreference = value;
      notifyListeners();
    }
  }
  Future<void> signUpUser(BuildContext context) async {
    final roleProvider = Provider.of<SelectRoleProvider>(context, listen: false);
    final loadingProvider = Provider.of<LoadingProvider>(context, listen: false);

    if (isEmail) {
      if (signUpEmailController.text.isEmpty || nameController.text.isEmpty || signUpPasswordController.text.isEmpty) {
        showSnackbar(context, AppLocalizations.of(context)!.pleasefillallfields, color: redColor);
        return;
      }
    } else {
      if (signUpPhoneController.text.isEmpty || nameController.text.isEmpty || signUpPasswordController.text.isEmpty) {
        showSnackbar(context, AppLocalizations.of(context)!.pleasefillallfields, color: redColor);
        return;
      }
    }

    try {
      loadingProvider.setLoading(true);
      var model = SignUpModel(
        name: nameController.text.trim(),
        email: isEmail ? signUpEmailController.text.trim() : null,
        phone: !isEmail ? "$countryCode${signUpPhoneController.text.trim()}" : null,
        password: signUpPasswordController.text.trim(),
        otpChannel: !isEmail ? otpPreference : null,
        role: roleProvider.selectedRole,
      );

      print("SignUp Request Body: ${jsonEncode(model.toJson())}"); // Debug log
      await AuthRepository.signUpUser(model, context).then((v) {
        String message = v.message!;
        loadingProvider.setLoading(false);
        if (context.mounted) {
          // Set provider state to match navigation arguments
          isSignUp = true;
          showSnackbar(context, message, color: greenColor);
          Navigator.pushNamed(
            context,
            RoutesNames.enterOTPView,
            arguments: {'isSignUp': true, 'isEmail': isEmail},
          );
        }
      }).onError((err, e) {
        loadingProvider.setLoading(false);
        if (context.mounted) {
          showSnackbar(context, err.toString(), color: redColor);
        }
      });
    } catch (e) {
      if (context.mounted) {
        loadingProvider.setLoading(false);
        showSnackbar(context, e.toString(), color: redColor);
      }
    }
  }  // Future<void> signUpUser(BuildContext context) async {
  //   final roleProvider = Provider.of<SelectRoleProvider>(context, listen: false);
  //   final loadingProvider = Provider.of<LoadingProvider>(context, listen: false);
  //
  //   if (isEmail) {
  //     if (signUpEmailController.text.isEmpty || nameController.text.isEmpty || signUpPasswordController.text.isEmpty) {
  //       showSnackbar(context, AppLocalizations.of(context)!.pleasefillallfields, color: redColor);
  //       return;
  //     }
  //   } else {
  //     if (signUpPhoneController.text.isEmpty || nameController.text.isEmpty || signUpPasswordController.text.isEmpty) {
  //       showSnackbar(context, AppLocalizations.of(context)!.pleasefillallfields, color: redColor);
  //       return;
  //     }
  //   }
  //
  //   try {
  //     loadingProvider.setLoading(true);
  //     var model = SignUpModel(
  //       name: nameController.text.trim(),
  //       email: isEmail ? signUpEmailController.text.trim() : null,
  //       phone: !isEmail ? "$countryCode${signUpPhoneController.text.trim()}" : null,
  //       password: signUpPasswordController.text.trim(),
  //       otpChannel: !isEmail ? otpPreference : null,
  //       role: roleProvider.selectedRole,
  //     );
  //
  //     print("SignUp Request Body: ${jsonEncode(model.toJson())}"); // Debug log
  //     await AuthRepository.signUpUser(model, context).then((v) {
  //       // Do not reset isEmail here
  //       String message = v.message!;
  //       loadingProvider.setLoading(false);
  //       if (context.mounted) {
  //         showSnackbar(context, message, color: greenColor);
  //         Navigator.pushNamed(context, RoutesNames.enterOTPView);
  //       }
  //     }).onError((err, e) {
  //       loadingProvider.setLoading(false);
  //       if (context.mounted) {
  //         showSnackbar(context, err.toString(), color: redColor);
  //       }
  //     });
  //   } catch (e) {
  //     if (context.mounted) {
  //       loadingProvider.setLoading(false);
  //       showSnackbar(context, e.toString(), color: redColor);
  //     }
  //   }
  // }
  // Future<void> signUpUser(BuildContext context) async {
  //   final roleProvider = Provider.of<SelectRoleProvider>(context, listen: false);
  //   final loadingProvider = Provider.of<LoadingProvider>(context, listen: false);
  //
  //   if (isEmail) {
  //     if (signUpEmailController.text.isEmpty || nameController.text.isEmpty || signUpPasswordController.text.isEmpty) {
  //       showSnackbar(context, AppLocalizations.of(context)!.pleasefillallfields, color: redColor);
  //       return;
  //     }
  //   } else {
  //     if (signUpPhoneController.text.isEmpty || nameController.text.isEmpty || signUpPasswordController.text.isEmpty) {
  //       showSnackbar(context, AppLocalizations.of(context)!.pleasefillallfields, color: redColor);
  //       return;
  //     }
  //   }
  //
  //   try {
  //     loadingProvider.setLoading(true);
  //     var model = SignUpModel(
  //       email: isEmail ? signUpEmailController.text.trim() : null,
  //       name: nameController.text.trim(),
  //       phone: !isEmail ? "$countryCode${signUpPhoneController.text.trim()}" : null,
  //       password: signUpPasswordController.text.trim(),
  //       otpChannel: !isEmail ? otpPreference : null,
  //       role: roleProvider.selectedRole,
  //     );
  //
  //     await AuthRepository.signUpUser(model, context).then((v) {
  //       isEmail = true; // Reset for next use
  //       String message = v.message!;
  //       loadingProvider.setLoading(false);
  //       if (context.mounted) {
  //         showSnackbar(context, message, color: greenColor);
  //         Navigator.pushNamed(context, RoutesNames.enterOTPView);
  //       }
  //     }).onError((err, e) {
  //       loadingProvider.setLoading(false);
  //       if (context.mounted) {
  //         showSnackbar(context, err.toString(), color: redColor);
  //       }
  //     });
  //   } catch (e) {
  //     if (context.mounted) {
  //       loadingProvider.setLoading(false);
  //       showSnackbar(context, e.toString(), color: redColor);
  //     }
  //   }
  // }
  // Future<void> verifyOtp(BuildContext context, String otp) async {
  //   final roleProvider = Provider.of<SelectRoleProvider>(context, listen: false);
  //   final loadingProvider = Provider.of<LoadingProvider>(context, listen: false);
  //
  //   if (otp.isEmpty) {
  //     showSnackbar(context, AppLocalizations.of(context)!.emptyotp, color: redColor);
  //     return;
  //   }
  //
  //   try {
  //     loadingProvider.setLoading(true);
  //     var model = isEmail
  //         ? VerifySignUpOtpModel(email: signUpEmailController.text.trim(), otp: otp)
  //         : VerifySignInOtpModel(phone: "$countryCode${signUpPhoneController.text.trim()}", otp: otp);
  //
  //     await (isEmail
  //         ? AuthRepository.verifySignUpOtp(
  //       VerifySignUpOtpModel(email: signUpEmailController.text.trim(), otp: otp),
  //       context,
  //     )
  //         : AuthRepository.verifySignInOtp(
  //       VerifySignInOtpModel(phone: "$countryCode${signUpPhoneController.text.trim()}", otp: otp),
  //       context,
  //     )).then((v) async {
  //       loadingProvider.setLoading(false);
  //       String message;
  //       String userId;
  //       if (isEmail) {
  //         final response = v as SuccessfulVerifyOtpResponse;
  //         message = response.message!;
  //         userId = response.id!; // Assuming SuccessfulVerifyOtpResponse has an id field
  //         await saveSessionToken(response.token!);
  //         await saveUserId(userId);
  //         await saveUserType(roleProvider.selectedRole);
  //       } else {
  //         final response = v as SuccessfullVerifySignInOtpModel;
  //         message = response.message!;
  //         userId = response.user.id; // Get id from the user object
  //         await saveSessionToken(response.token!);
  //         await saveUserId(userId);
  //         await saveUserType(response.role); // Use role from the response
  //       }
  //       if (context.mounted) {
  //         showSnackbar(context, message, color: greenColor);
  //         navigateBasedOnRole(roleProvider.selectedRole, context);
  //         clearSignUpResources();
  //       }
  //     }).onError((err, e) {
  //       loadingProvider.setLoading(false);
  //       if (context.mounted) {
  //         showSnackbar(context, err.toString(), color: redColor);
  //       }
  //     });
  //   } catch (e) {
  //     if (context.mounted) {
  //       loadingProvider.setLoading(false);
  //       showSnackbar(context, e.toString(), color: redColor);
  //     }
  //   }
  // }

  Future<void> verifyOtp(BuildContext context, String otp, {bool? useEmail}) async {
    final roleProvider = Provider.of<SelectRoleProvider>(context, listen: false);
    final loadingProvider = Provider.of<LoadingProvider>(context, listen: false);

    if (otp.isEmpty) {
      showSnackbar(context, AppLocalizations.of(context)!.emptyotp, color: redColor);
      return;
    }

    // Use provided useEmail parameter, or fallback to provider's isEmail
    final bool shouldUseEmail = useEmail ?? isEmail;
    
    // Validate that we have the required field (email or phone)
    if (shouldUseEmail) {
      String email = signUpEmailController.text.trim();
      if (email.isEmpty) {
        showSnackbar(context, 'Email is required for verification', color: redColor);
        return;
      }
    } else {
      String phone = signUpPhoneController.text.trim();
      if (phone.isEmpty) {
        showSnackbar(context, 'Phone number is required for verification', color: redColor);
        return;
      }
    }

    try {
      loadingProvider.setLoading(true);
      VerifySignUpOtpModel model;
      if (shouldUseEmail) {
        // When using email, explicitly set email and leave phone as null
        String email = signUpEmailController.text.trim();
        customPrint("VerifySignUpOtp - Using EMAIL: $email");
        model = VerifySignUpOtpModel(email: email, phone: null, otp: otp);
      } else {
        // When using phone, explicitly set phone and leave email as null
        String phone = "$countryCode${signUpPhoneController.text.trim()}";
        customPrint("VerifySignUpOtp - Using PHONE: $phone");
        model = VerifySignUpOtpModel(email: null, phone: phone, otp: otp);
      }
      
      // Debug: Print the model to verify correct fields are being sent
      customPrint("VerifySignUpOtpModel toJson: ${model.toJson()}");

      await AuthRepository.verifySignUpOtp(model, context).then((v) async {
        loadingProvider.setLoading(false);
        final response = v;
        String message = response.message!;
        String userId = response.id!;
        await saveSessionToken(response.token!);
        await saveUserId(userId);
        await saveUserType(roleProvider.selectedRole);
        
        // Send FCM token to backend
        _sendFcmTokenToBackend(context);
        
        if (context.mounted) {
          // Show success message only if context is still mounted and not navigating
          Future.microtask(() {
            if (context.mounted) {
              showSnackbar(context, message, color: greenColor);
            }
          });
          // Navigate immediately to prevent showing message after navigation
          navigateBasedOnRole(roleProvider.selectedRole, context);
          clearSignUpResources(); // Clear resources after successful verification
        }
      }).onError((err, e) {
        loadingProvider.setLoading(false);
        if (context.mounted) {
          showSnackbar(context, err.toString(), color: redColor);
        }
      });
    } catch (e) {
      if (context.mounted) {
        loadingProvider.setLoading(false);
        showSnackbar(context, e.toString(), color: redColor);
      }
    }
  }  // Future<void> verifyOtp(BuildContext context, String otp) async {
  //   final roleProvider = Provider.of<SelectRoleProvider>(context, listen: false);
  //   final loadingProvider = Provider.of<LoadingProvider>(context, listen: false);
  //
  //   if (otp.isEmpty) {
  //     showSnackbar(context, AppLocalizations.of(context)!.emptyotp, color: redColor);
  //     return;
  //   }
  //
  //   try {
  //     loadingProvider.setLoading(true);
  //     var model = isEmail
  //         ? VerifySignUpOtpModel(email: signUpEmailController.text.trim(), otp: otp)
  //         : VerifySignInOtpModel(phone: "$countryCode${signUpPhoneController.text.trim()}", otp: otp);
  //
  //     await (isEmail
  //         ? AuthRepository.verifySignUpOtp(model, context)
  //         : AuthRepository.verifySignInOtp(model, context)).then((v) async {
  //       String message = v.message!;
  //       loadingProvider.setLoading(false);
  //       await saveSessionToken(v.token!);
  //       await saveUserId(v.id!);
  //       await saveUserType(roleProvider.selectedRole);
  //       if (context.mounted) {
  //         showSnackbar(context, message, color: greenColor);
  //         navigateBasedOnRole(roleProvider.selectedRole, context);
  //         clearSignUpResources();
  //       }
  //     }).onError((err, e) {
  //       loadingProvider.setLoading(false);
  //       if (context.mounted) {
  //         showSnackbar(context, err.toString(), color: redColor);
  //       }
  //     });
  //   } catch (e) {
  //     if (context.mounted) {
  //       loadingProvider.setLoading(false);
  //       showSnackbar(context, e.toString(), color: redColor);
  //     }
  //   }
  // }

  Future<void> verifySignOtp(BuildContext context, String otp, {bool isEmail = false, bool isSignUp = false}) async {
    final loadingProvider = Provider.of<LoadingProvider>(context, listen: false);
    if (otp.isEmpty) {
      showSnackbar(context, AppLocalizations.of(context)!.emptyotp, color: redColor);
      return;
    }
    try {
      loadingProvider.setLoading(true);
      
      VerifySignInOtpModel model;
      if (isEmail) {
        // Use signUpEmailController for signup, emailController for sign-in
        String email = isSignUp 
            ? signUpEmailController.text.trim() 
            : emailController.text.trim();
        
        // Validate email is not empty
        if (email.isEmpty) {
          loadingProvider.setLoading(false);
          showSnackbar(context, 'Email is required for verification', color: redColor);
          return;
        }
        
        customPrint("verifySignOtp - Using EMAIL: $email (isSignUp=$isSignUp, isEmail=$isEmail)");
        // Explicitly set email and ensure phone is null
        model = VerifySignInOtpModel(email: email, otp: otp);
      } else {
        // When isEmail is false, use phone
        String phoneNumber = "$countryCode${phoneController.text.trim()}";
        
        // Validate phone is not empty
        if (phoneController.text.trim().isEmpty) {
          loadingProvider.setLoading(false);
          showSnackbar(context, 'Phone number is required for verification', color: redColor);
          return;
        }
        
        customPrint("verifySignOtp - Using PHONE: $phoneNumber (isSignUp=$isSignUp, isEmail=$isEmail)");
        // Explicitly set phone and ensure email is null
        model = VerifySignInOtpModel(phone: phoneNumber, otp: otp);
      }
      
      // Debug: Print the model to verify correct fields are being sent
      customPrint("VerifySignInOtpModel toJson: ${model.toJson()}");
      
      await AuthRepository.verifySignInOtp(model, context).then((v) async {
        loadingProvider.setLoading(false);
        await saveSessionToken(v.token);
        await saveUserId(v.user.id);
        await saveUserType(v.role);
        
        // Send FCM token to backend
        _sendFcmTokenToBackend(context);
        
        if (context.mounted) {
          showSnackbar(context, AppLocalizations.of(context)!.loggedinsuccessfully, color: greenColor);
          navigateBasedOnRole(v.role, context);
          clearSignUpResources(); // Clear resources after successful verification
        }
      }).onError((err, e) {
        loadingProvider.setLoading(false);
        if (context.mounted) {
          showSnackbar(context, err.toString(), color: redColor);
        }
      });
    } catch (e) {
      if (context.mounted) {
        loadingProvider.setLoading(false);
        showSnackbar(context, e.toString(), color: redColor);
      }
    }
  }  Future<void> signInUser(BuildContext context) async {
    final loadingProvider = Provider.of<LoadingProvider>(context, listen: false);
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      showSnackbar(context, AppLocalizations.of(context)!.pleasefillallfields, color: redColor);
      return;
    }
    try {
      FocusManager.instance.primaryFocus!.unfocus();
      loadingProvider.setLoading(true);
      var model = SignInModel(email: emailController.text.trim(), password: passwordController.text.trim());
      await AuthRepository.signInUser(model, context).then((v) async {
        isEmail = true;
        customPrint("Get data =========================================${v.user}");
        String message = AppLocalizations.of(context)!.loggedinsuccessfully;
        String role = v.role;
        await saveSessionToken(v.token!);
        await saveUserId(v.user.id);
        saveUserType(v.role);
        
        // Send FCM token to backend
        _sendFcmTokenToBackend(context);
        
        loadingProvider.setLoading(false);
        if (context.mounted) {
          showSnackbar(context, message, color: greenColor);
          if (v.role == UserRoles.driver) {
            if (v.user.name.isEmpty) {
              Navigator.pushNamedAndRemoveUntil(context, RoutesNames.driverSignUpView, (route) => false);
            } else {
              Navigator.pushNamedAndRemoveUntil(context, RoutesNames.driverHomeView, (route) => false);
            }
          } else {
            navigateBasedOnRole(role, context);
          }
          clearResources();
        }
      }).onError((err, e) {
        loadingProvider.setLoading(false);
        if (context.mounted) {
          if (err.toString() == 'Verify your email') {
            signUpEmailController.text = emailController.text;
            // Set provider state to match navigation arguments
            isSignUp = false;
            isEmail = true;
            Navigator.pushNamed(
              context,
              RoutesNames.enterOTPView,
              arguments: {'isSignUp': false, 'isEmail': true},
            );
          }
          showSnackbar(context, err.toString(), color: redColor);
        }
      });
    } catch (e) {
      if (context.mounted) {
        loadingProvider.setLoading(false);
        showSnackbar(context, e.toString(), color: redColor);
      }
    }
  }

  // Future<void> signInUserWithPhone(BuildContext context) async {
  //   final loadingProvider = Provider.of<LoadingProvider>(context, listen: false);
  //   if (phoneController.text.isEmpty) {
  //     showSnackbar(context, AppLocalizations.of(context)!.phonenumberrequired, color: redColor);
  //     return;
  //   }
  //   try {
  //     String phoneNumber = "$countryCode${phoneController.text.trim().toString()}";
  //     loadingProvider.setLoading(true);
  //     var model = SignInWithPhoneModel(phone: phoneNumber);
  //     await AuthRepository.signInUserWithPhoneNumber(model, context).then((v) async {
  //       customPrint("Get data =========================================${v.message}");
  //       String message = v.message;
  //       loadingProvider.setLoading(false);
  //       if (context.mounted) {
  //         showSnackbar(context, message, color: greenColor);
  //         Navigator.pushNamed(
  //           context,
  //           RoutesNames.enterOTPView,
  //           arguments: {'isSignUp': false, 'isEmail': false}, // Pass context for sign-in
  //         );
  //       }
  //     }).onError((err, e) {
  //       loadingProvider.setLoading(false);
  //       if (context.mounted) {
  //         if (err.toString() == 'Verify your phone') {
  //           Navigator.pushNamed(
  //             context,
  //             RoutesNames.enterOTPView,
  //             arguments: {'isSignUp': false, 'isEmail': false},
  //           );
  //         }
  //         showSnackbar(context, err.toString(), color: redColor);
  //       }
  //     });
  //   } catch (e) {
  //     if (context.mounted) {
  //       loadingProvider.setLoading(false);
  //       showSnackbar(context, e.toString(), color: redColor);
  //     }
  //   }
  // }
  Future<void> signInUserWithPhone(BuildContext context) async {
    final loadingProvider = Provider.of<LoadingProvider>(context, listen: false);
    if (phoneController.text.isEmpty) {
      showSnackbar(context, AppLocalizations.of(context)!.phonenumberrequired, color: redColor);
      return;
    }
    try {
      String phoneNumber = "$countryCode${phoneController.text.trim()}";
      loadingProvider.setLoading(true);
      var model = SignInWithPhoneModel(phone: phoneNumber);
      await AuthRepository.signInUserWithPhoneNumber(model, context).then((v) async {
        customPrint("Get data =========================================${v.message}");
        String message = v.message;
        loadingProvider.setLoading(false);
        if (context.mounted) {
          // Set provider state to match navigation arguments
          isSignUp = false;
          isEmail = false;
          showSnackbar(context, message, color: greenColor);
          Navigator.pushNamed(
            context,
            RoutesNames.enterOTPView,
            arguments: {'isSignUp': false, 'isEmail': false},
          );
        }
      }).onError((err, e) {
        loadingProvider.setLoading(false);
        if (context.mounted) {
          if (err.toString() == 'Verify your phone') {
            // Set provider state to match navigation arguments
            isSignUp = false;
            isEmail = false;
            Navigator.pushNamed(
              context,
              RoutesNames.enterOTPView,
              arguments: {'isSignUp': false, 'isEmail': false},
            );
          }
          showSnackbar(context, err.toString(), color: redColor);
        }
      });
    } catch (e) {
      if (context.mounted) {
        loadingProvider.setLoading(false);
        showSnackbar(context, e.toString(), color: redColor);
      }
    }
  }  void toggleRemember(bool value) {
    isRemember = value;
    notifyListeners();
  }

  void clearResources() {
    emailController.clear();
    passwordController.clear();
    isSignUp = true;
    isEmail = true;
  }

  void clearSignUpResources() {
    signUpEmailController.clear();
    nameController.clear();
    signUpPasswordController.clear();
    signUpPhoneController.clear();
    phoneController.clear();
    otpController.clear();
    _showPassword = false;
    isSignUp = true;
    isEmail = true;
  }

  /// Helper function to send FCM token to backend after login/signup
  Future<void> _sendFcmTokenToBackend(BuildContext? context) async {
    try {
      final fcmToken = await FirebaseMessagingService().getFCMToken();
      if (fcmToken != null && fcmToken.isNotEmpty) {
        await AuthRepository.setFcmToken(fcmToken, context);
      } else {
        customPrint('FCM token is null or empty, skipping backend update');
      }
    } catch (e) {
      customPrint('Error sending FCM token to backend: $e');
      // Don't throw - this is not critical for login flow
    }
  }
}