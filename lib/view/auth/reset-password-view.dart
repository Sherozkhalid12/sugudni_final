import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/providers/reset-password-provider.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/constants/fonts.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/round-button.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/customWidgets/text-field.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';
import '../../l10n/app_localizations.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {


  final RegExp numberOrSymbolRegExp = RegExp(r'[0-9!@#\$&*~]');
  final RegExp lowerCaseRegExp = RegExp(r'[a-z]');
  final RegExp upperCaseRegExp = RegExp(r'[A-Z]');
  @override
  Widget build(BuildContext context) {
    final resetPasswordProvider=Provider.of<ResetPasswordProvider>(context,listen: false);

    return Scaffold(
      backgroundColor: bgColor,
      body: Consumer<ResetPasswordProvider>(builder: (context,provider,child){
        return SafeArea(

          child: SymmetricPadding(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  20.height,
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Image.asset(AppAssets.backArrow,scale: 3,),
                        8.width,
                        MyText(text: AppLocalizations.of(context)!.back,size: 20.sp,fontWeight: FontWeight.w600,fontFamily: AppFonts.jost,),
                      ],
                    ),
                  ),
                  40.height,
                  MyText(
                    overflow: TextOverflow.clip,
                    text: AppLocalizations.of(context)!.resetpassword,color: textPrimaryColor,size: 25.sp,fontWeight: FontWeight.w700,),
                  40.height,

                  MyText(text: AppLocalizations.of(context)!.newpassword,size: 18.sp,fontWeight: FontWeight.w500),
                  5.height,
                  CustomTextFiled(
                    borderRadius: 15.r,
                    controller: provider.passwordController,
                    isShowPrefixIcon: true,
                    isBorder: true,
                    isPassword: true,
                    onChange: (v){
                      provider.notify();
                      return null;
                    },
                    isFilled: true,
                    hintText: AppLocalizations.of(context)!.enternewpassword,
                    isShowPrefixImage: true,
                    prefixImgUrl: AppAssets.passwordIcon,

                  ),
                  /// Password Strength Indicator
                  20.height,
                  Consumer<ResetPasswordProvider>(
                    builder: (context, authProvider, child) {
                      final passwordText = authProvider.passwordController.text;

                      bool containsNumberOrSymbol = numberOrSymbolRegExp.hasMatch(passwordText);
                      bool containsLowerCase = lowerCaseRegExp.hasMatch(passwordText);
                      bool containsUpperCase = upperCaseRegExp.hasMatch(passwordText);
                      bool containsBoth = containsLowerCase && containsUpperCase;
                      double checks = (containsNumberOrSymbol ? 0.5 : 0) +
                          (containsLowerCase ? 0.5 : 0) +
                          (containsUpperCase ? 0.5 : 0) +
                          (passwordText.length >= 8 ? 2 : 0);

                      double passwordStrength = (checks / 4);

                      return LinearProgressIndicator(
                        value: passwordStrength,
                        backgroundColor: Colors.grey[300],
                        minHeight: 4,

                        color: passwordStrength <= 1 / 4
                            ? Colors.red
                            : passwordStrength == 2 / 4
                            ? Colors.yellow
                            : passwordStrength == 3 / 4
                            ? Colors.blue
                            : Colors.green,
                      );
                    },
                  ),
                  10.height,
                  // Password Requirements
                  Consumer<ResetPasswordProvider>(
                    builder: (context, authProvider, child) {
                      final passwordText = authProvider.passwordController.text;

                      bool containsLowerCase = lowerCaseRegExp.hasMatch(passwordText);
                      bool containsUpperCase = upperCaseRegExp.hasMatch(passwordText);
                      bool containsBoth = containsLowerCase && containsUpperCase;

                      return Column(
                        children: [
                          PasswordRequirement(
                            condition: passwordText.length >= 8,
                            text: AppLocalizations.of(context)!.least8characters,
                          ),
                          SizedBox(height: 10.h),
                          PasswordRequirement(
                            condition: numberOrSymbolRegExp.hasMatch(passwordText),
                            text: AppLocalizations.of(context)!.leastonenumber,
                          ),
                          SizedBox(height: 10.h),
                          PasswordRequirement(
                            condition: containsBoth,
                            text: AppLocalizations.of(context)!.lowercaseanduppercase,
                          ),
                        ],
                      );
                    },
                  ),
                  20.height,
                  MyText(text: AppLocalizations.of(context)!.confirmpassword,size: 18.sp,fontWeight: FontWeight.w500),
                  5.height,
                  CustomTextFiled(
                    controller: provider.confirmPasswordController,
                    borderRadius: 15.r,
                    isShowPrefixIcon: true,
                    isBorder: true,
                    isPassword: true,

                    isFilled: true,
                    hintText: AppLocalizations.of(context)!.reenternewpassword,
                    isShowPrefixImage: true,
                    prefixImgUrl: AppAssets.passwordIcon,

                  ),
                  80.height,
                  RoundButton(
                      isLoad: true,
                      title: AppLocalizations.of(context)!.resetpassword,
                      onTap: ()async{
                        final passwordText = resetPasswordProvider.passwordController.text;

                        bool containsLowerCase = lowerCaseRegExp.hasMatch(passwordText);
                        bool containsUpperCase = upperCaseRegExp.hasMatch(passwordText);
                        bool containsBoth = containsLowerCase && containsUpperCase;
                        if(passwordText.length<8 ||containsUpperCase==false ||containsLowerCase==false||containsBoth==false){
                          showSnackbar(context, AppLocalizations.of(context)!.yourpasswordlooksweak,color: redColor);
                          return;
                        }
                        await resetPasswordProvider.setNewPassword(context);
                        //Navigator.pushNamed(context, RoutesNames.loginView);
                  })
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
class PasswordRequirement extends StatelessWidget {
  final bool condition;
  final String text;

  const PasswordRequirement({
    required this.condition,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        condition
            ? Image.asset(
          AppAssets.tick_icon,
          height: 9.6.h,
          width: 13.w,
          color: blackColor,
        )
            : const CircleAvatar(
          radius: 4,
          backgroundColor: blackColor,
        ),
        SizedBox(width: 6.w),
        MyText(text:
          text,
          size: 12.sp,
          fontFamily: AppFonts.jost,
          color:condition ? blackColor: blackColor ,

        ),
      ],
    );
  }
}