import 'package:country_code_picker/country_code_picker.dart';
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
import '../../utils/customWidgets/custom-phone-number-field.dart';
import '../../utils/customWidgets/my-text.dart';

import '../../utils/customWidgets/text-field.dart';

class ForgetPasswordPhoneView extends StatelessWidget {
  const ForgetPasswordPhoneView({super.key});

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
              Center(child: MyText(
                textAlignment: TextAlign.center,
                overflow: TextOverflow.clip,
                text: AppLocalizations.of(context)!.enteryourphonenumber,color: textPrimaryColor,size: 22.sp,fontWeight: FontWeight.w700,)),
              Center(child: MyText(
                textAlignment: TextAlign.center,
                overflow: TextOverflow.clip,
                text: AppLocalizations.of(context)!.pleaseenterphonenumbertorequestapasswordreset,
                color: textPrimaryColor,size: 18.sp,fontWeight: FontWeight.w500,)),
              20.height,
              Container(
                decoration: BoxDecoration(
                    color: textFieldColor,
                    borderRadius: BorderRadius.circular(13.r)
                ),
                child: Row(
                  children: [
                    CountryCodePicker(
                      onChanged: (CountryCode countryCode) {
                        resetPasswordProvider.setDialCode(countryCode.dialCode!);
                      },
                      padding: EdgeInsets.zero,
                      flagDecoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                      ),
                      flagWidth: 23.w,
                      //initialSelection: 'FR',
                      initialSelection: resetPasswordProvider.dialCode,

                      favorite: const ['+351',''],
                      showCountryOnly: false,
                      showOnlyCountryWhenClosed: false,
                      alignLeft: false,

                      textStyle: TextStyle(
                          fontSize: 13.sp,
                          color: blackColor,
                          fontWeight: FontWeight.w500
                      ),
                      dialogBackgroundColor: whiteColor,
                    ),

                    Flexible(
                      child: CustomTextFiled(
                        controller: resetPasswordProvider.phoneController,
                        borderRadius: 15.r,
                        isBorder: true,
                        isShowPrefixIcon: false,
                        isFilled: true,
                        hintText:AppLocalizations.of(context)!.yourphonenumber,
                        isShowPrefixImage: false,
                        keyboardType: TextInputType.number,

                      ),
                    ),
                  ],
                ),
              ),
              10.height,
              Consumer<ResetPasswordProvider>(builder: (context,provider,child){
                return Row(
                  children: [
                    Flexible(
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('SMS'),
                        leading: Radio<String>(
                          value: 'sms',
                          groupValue: provider.otpPreference,
                          onChanged: (value) {
                            provider.setOptPreferences(value!);

                          },
                        ),
                      ),
                    ),
                    Flexible(
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('WhatsApp'),
                        leading: Radio<String>(
                          value: 'whatsapp',
                          groupValue: provider.otpPreference,
                          onChanged: (value) {
                            provider.setOptPreferences(value!);
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }),

              60.height,

              RoundButton(
                  isLoad: true,
                  title: AppLocalizations.of(context)!.send,
                  onTap: ()async{
                    await resetPasswordProvider.resetPasswordRequestUsingPhone(context);
              }),

              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyText(text: AppLocalizations.of(context)!.donthaveandaccount,size: 14.sp,fontFamily: AppFonts.poppins),
                  GestureDetector(
                    onTap: (){
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
