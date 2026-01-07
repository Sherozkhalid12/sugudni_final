import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/models/auth/ResetPasswordModel.dart';
import 'package:sugudeni/providers/reset-password-provider.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/round-button.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';

import '../../l10n/app_localizations.dart';

class EnterCodeView extends StatelessWidget {
  const EnterCodeView({super.key});

  @override
  Widget build(BuildContext context) {
    final resetPasswordProvider=Provider.of<ResetPasswordProvider>(context,listen: false);
    final otpController=TextEditingController();
    String phone=formatPhoneNumber(resetPasswordProvider.dialCode, resetPasswordProvider.phoneController.text.toString());

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SymmetricPadding(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              80.height,
              MyText(
                text: AppLocalizations.of(context)!.authenticationcode,
                color: textPrimaryColor,
                size: 25.sp,fontWeight: FontWeight.w700,),
              10.height,
              MyText(
                overflow: TextOverflow.clip,
                text:resetPasswordProvider.usingEmail==true?
                "${AppLocalizations.of(context)!.enter4digitcodeforemail} ${resetPasswordProvider.emailController.text}"
                    :"${AppLocalizations.of(context)!.enter4digitcodeforphone} $phone",
                color: textPrimaryColor,size: 18.sp,fontWeight: FontWeight.w600,),
              20.height,
              PinCodeTextField(
                controller: otpController,
                appContext: context,
                length:4 ,
                keyboardType: TextInputType.number,
                animationType: AnimationType.scale,
                pinTheme: PinTheme(
                    borderRadius: BorderRadius.circular(11.38.r),
                    borderWidth: 1,
                    activeFillColor: blackColor,
                    shape: PinCodeFieldShape.box,
                    activeColor: blackColor,
                    selectedColor: blackColor,
                    inactiveColor: textPrimaryColor.withOpacity(0.50),
                    fieldHeight: 53.h,
                    fieldWidth: 53.w),
              ),
         //   20.height,
             // MyText(text: "Use different email address",color: textPrimaryColor,size: 15.sp,fontWeight: FontWeight.w700,fontFamily: AppFonts.jost,),
              20.height,
              RoundButton(
                  isLoad: true,
                  title: AppLocalizations.of(context)!.conti, onTap: ()async{

                if(resetPasswordProvider.usingEmail==true){
                  if(otpController.text.isEmpty){
                    showSnackbar(context, AppLocalizations.of(context)!.pleaseenterotp,color: redColor);
                    return;
                  }
                  var model=ResetPasswordModel(
                    email: resetPasswordProvider.emailController.text.trim(),
                    otp: otpController.text.toString()
                  );
                  await resetPasswordProvider.verifyResetPasswordRequest(context, model);
                }else{
                  if(otpController.text.isEmpty){
                    showSnackbar(context, AppLocalizations.of(context)!.pleaseenterotp,color: redColor);
                    return;
                  }
                  String phone=formatPhoneNumber(resetPasswordProvider.dialCode, resetPasswordProvider.phoneController.text.toString());

                  var model=ResetPasswordModel(
                      phone: phone,
                      otp: otpController.text.toString()
                  );
                  await resetPasswordProvider.verifyResetPasswordRequest(context, model);
                }
              }),
              20.height,
              Center(
                child: TextButton(
                  onPressed: () {
                    // Resend OTP logic for password reset
                    if (resetPasswordProvider.usingEmail) {
                      // Resend email OTP
                      resetPasswordProvider.resetPasswordRequestUsingEmail(context);
                    } else {
                      // Resend phone OTP
                      resetPasswordProvider.resetPasswordRequestUsingPhone(context);
                    }
                  },
                  child: MyText(
                    text: AppLocalizations.of(context)!.resendcode,
                    color: primaryColor,
                    size: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
