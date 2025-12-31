import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/providers/reset-password-provider.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/round-button.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';

import '../../l10n/app_localizations.dart';
import '../../utils/constants/app-assets.dart';
import '../../utils/constants/fonts.dart';
import '../../utils/customWidgets/my-text.dart';
import '../../utils/customWidgets/text-field.dart';


class ForgetPasswordEmailView extends StatelessWidget {
  const ForgetPasswordEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    final resetPasswordProvider=Provider.of<ResetPasswordProvider>(context,listen: false);
    return Scaffold(
      backgroundColor: bgColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SymmetricPadding(
          child: Column(
            children: [
              70.height,
              Image.asset(
                  width: 180.w,
                  height: 110.h,
                  AppAssets.forgetPasswordIcon),
              40.height,
              Center(child: MyText(text: AppLocalizations.of(context)!.enteryouremail,color: textPrimaryColor,size: 22.sp,fontWeight: FontWeight.w700,)),
              Center(child: MyText(
                textAlignment: TextAlign.center,
                overflow: TextOverflow.clip,
                text: AppLocalizations.of(context)!.pleaseenteraemailaddresstorequestapasswordreset,
                color: textPrimaryColor,size: 18.sp,fontWeight: FontWeight.w500,)),
              20.height,
              CustomTextFiled(
                controller: resetPasswordProvider.emailController,
                borderRadius: 15.r,
                isBorder: true,
                isShowPrefixIcon: true,
                isFilled: true,
                hintText: AppLocalizations.of(context)!.enteryouremail,
                isShowPrefixImage: true,
                prefixImgUrl: AppAssets.emailIcon,

              ),
              60.height,

              RoundButton(
                isLoad: true,
                  title: AppLocalizations.of(context)!.send,
                  onTap: ()async{
                 await resetPasswordProvider.resetPasswordRequestUsingEmail(context);
               // Navigator.pushNamed(context, RoutesNames.forgetPasswordPhoneView);
              }),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyText(text: AppLocalizations.of(context)!.donthaveandaccount,size: 14.sp,fontFamily: AppFonts.poppins),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, RoutesNames.selectRoleView);
                    },
                    child: MyText(text: " ${AppLocalizations.of(context)!.signup}",size: 20.sp,fontFamily: AppFonts.jost,color: primaryColor,fontWeight: FontWeight.w600,),

                  ),
                ],
              ),
              20.height,


            ],
          ),
        ),
      ),
    );
  }
}
