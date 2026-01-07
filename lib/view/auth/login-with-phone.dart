import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/providers/auth/auth-provider.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/round-button.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';
import 'package:sugudeni/view/auth/main-login-view.dart';

import '../../utils/constants/app-assets.dart';
import '../../utils/customWidgets/custom-phone-number-field.dart';
import '../../l10n/app_localizations.dart';

import '../../utils/customWidgets/text-field.dart';
class LoginWithPhoneView extends StatelessWidget {
  const LoginWithPhoneView({super.key});

  @override
  Widget build(BuildContext context) {
    final signUpProvider=Provider.of<AuthProvider>(context,listen: false);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SymmetricPadding(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                40.height,
                Row(
                  children: [
                    MyText(text: "${AppLocalizations.of(context)!.hi} !",color: textPrimaryColor,size: 22.sp,fontWeight: FontWeight.w700,),
                  ],
                ),
                MyText(text: AppLocalizations.of(context)!.welcometotelimani,color: textPrimaryColor.withOpacity(0.8),size: 22.sp,fontWeight: FontWeight.w700,),
                MyText(
                  overflow: TextOverflow.clip,
                  text: AppLocalizations.of(context)!.pleaseenteryourmobilenumber,color: textPrimaryColor.withOpacity(0.8),size: 16.sp,fontWeight: FontWeight.w500,),
                20.height,

                Center(
                  child: Image.asset(
                      height: 200.h,
                      width: 300.w,
                      AppAssets.appLogo),
                ),
                60.height,
                Container(
                  decoration: BoxDecoration(
                    color: textFieldColor,
                    borderRadius: BorderRadius.circular(13.r)
                  ),
                  child: Row(
                    children: [
                      CountryCodePicker(
                        onChanged: (CountryCode countryCode) {
                          signUpProvider.changeCountryCode(countryCode.dialCode!);
                          customPrint("Country code ===========${signUpProvider.countryCode}");
                          String message = formatPhoneNumber(signUpProvider.countryCode, signUpProvider.phoneController.text.toString());
                          customPrint("Phone number ===========$message");


                        },
                        padding: EdgeInsets.zero,
                        flagDecoration: const BoxDecoration(
                          shape: BoxShape.rectangle,
                        ),
                        flagWidth: 23.w,
                        initialSelection: 'FR',
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
                        child: Consumer<AuthProvider>(
                          builder: (context, provider, child) {
                            return CustomTextFiled(
                              controller: provider.phoneController,
                              borderRadius: 15.r,
                              isBorder: true,
                              isShowPrefixIcon: false,
                              isFilled: true,
                              hintText: AppLocalizations.of(context)!.yourphonenumber,
                              isShowPrefixImage: false,
                              keyboardType: TextInputType.number,
                              maxLength: getPhoneNumberMaxLength(provider.countryCode),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ), 20.height,
                Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, RoutesNames.forgetPasswordPhoneView);

                      },
                      child: MyText(text: AppLocalizations.of(context)!.forgetpassword,size: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,),
                    )),

                40.height,

                RoundButton(
                    isLoad: true,
                    title: AppLocalizations.of(context)!.send, onTap: ()async{
                  await signUpProvider.signInUserWithPhone(context);
                 // Navigator.pushNamed(context, RoutesNames.enterOTPView);
                }),
                180.height,
                const HaventSignupWidget(),
                10.height,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
