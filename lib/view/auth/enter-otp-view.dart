import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/providers/auth/auth-provider.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/constants/fonts.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/round-button.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';

import '../../l10n/app_localizations.dart';

class EnterOtpView extends StatefulWidget {
  const EnterOtpView({super.key});

  @override
  State<EnterOtpView> createState() => _EnterOtpViewState();
}

class _EnterOtpViewState extends State<EnterOtpView> {
  final otpController = TextEditingController();
  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final signUpProvider = Provider.of<AuthProvider>(context, listen: false);

    // Retrieve navigation arguments
    final arguments = ModalRoute.of(context)!.settings.arguments;
    Map<String, dynamic>? argsMap;
    if (arguments != null) {
      if (arguments is Map<String, dynamic>) {
        argsMap = arguments;
      } else {
        // Try to cast if it's a different type
        try {
          argsMap = arguments as Map<String, dynamic>?;
        } catch (e) {
          argsMap = null;
        }
      }
    }
    
    // Use arguments if available, otherwise fallback to provider state
    // IMPORTANT: For sign-in with phone, we must use arguments, not provider state
    final bool isSignUp = argsMap?['isSignUp'] ?? signUpProvider.isSignUp;
    // When arguments are provided, always use them (don't fallback to provider for isEmail)
    final bool isEmail = argsMap != null && argsMap.containsKey('isEmail') 
        ? argsMap['isEmail'] as bool 
        : signUpProvider.isEmail;

    // Debug log to confirm arguments
    customPrint("EnterOtpView Arguments: isSignUp=$isSignUp (from args: ${argsMap?['isSignUp']}, from provider: ${signUpProvider.isSignUp}), isEmail=$isEmail (from args: ${argsMap?['isEmail']}, from provider: ${signUpProvider.isEmail})");

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.height,
            Padding(
              padding: EdgeInsets.all(15.sp),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    Image.asset(AppAssets.backArrow, scale: 3, color: primaryColor),
                    8.width,
                    MyText(
                      text: AppLocalizations.of(context)!.back,
                      color: primaryColor,
                      size: 20.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppFonts.jost,
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              height: 10,
              thickness: 2,
              color: textPrimaryColor.withOpacity(0.23),
            ),
            SymmetricPadding(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  25.height,
                  Center(
                    child: MyText(
                      text: AppLocalizations.of(context)!.enterotp,
                      color: textPrimaryColor,
                      size: 25.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  10.height,
                  MyText(
                    overflow: TextOverflow.clip,
                    text: isEmail
                        ? AppLocalizations.of(context)!.enter5digitcondewetexttoyouremail
                        : AppLocalizations.of(context)!.enter5digitcondewetexttoyourphonenumber,
                    color: textPrimaryColor,
                    size: 16.sp,
                    fontFamily: AppFonts.jost,
                    fontWeight: FontWeight.w600,
                  ),
                  20.height,
                  PinCodeTextField(
                    appContext: context,
                    length: 4,
                    keyboardType: TextInputType.number,
                    animationType: AnimationType.scale,
                    controller: otpController,
                    pinTheme: PinTheme(
                      borderRadius: BorderRadius.circular(11.38.r),
                      borderWidth: 1,
                      activeFillColor: blackColor,
                      shape: PinCodeFieldShape.box,
                      activeColor: blackColor,
                      selectedColor: blackColor,
                      inactiveColor: textPrimaryColor.withOpacity(0.50),
                      fieldHeight: 53.h,
                      fieldWidth: 53.w,
                    ),
                  ),
                  20.height,
                  RoundButton(
                    isLoad: true,
                    title: AppLocalizations.of(context)!.conti,
                    onTap: () {
                      if (_isDisposed || !mounted) return;
                      if (isSignUp) {
                        customPrint('Calling verifyOtp for sign-up, isEmail=$isEmail');
                        // Pass isEmail explicitly to ensure correct verification method
                        signUpProvider.verifyOtp(context, otpController.text, useEmail: isEmail);
                      } else {
                        customPrint('Calling verifySignOtp for sign-in, isEmail=$isEmail');
                        signUpProvider.verifySignOtp(context, otpController.text, isEmail: isEmail, isSignUp: false);
                      }
                    },
                  ),                  20.height,
                  RoundButton(
                    borderRadius: BorderRadius.circular(13.r),
                    bgColor: transparentColor,
                    borderColor: primaryColor,
                    textColor: blackColor,
                    title: AppLocalizations.of(context)!.resendcode,
                    onTap: () {
                      if (isSignUp) {
                        signUpProvider.signUpUser(context); // Resend OTP for sign-up
                      } else {
                        if (isEmail) {
                          signUpProvider.signInUser(context); // Resend OTP for email sign-in
                        } else {
                          signUpProvider.signInUserWithPhone(context); // Resend OTP for phone sign-in
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}