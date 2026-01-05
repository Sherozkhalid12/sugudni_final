import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/providers/select-role-provider.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/fonts.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/round-button.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';
import 'package:sugudeni/utils/user-roles.dart';

import '../../l10n/app_localizations.dart';
import '../../utils/constants/colors.dart';

class SelectRoleView extends StatelessWidget {
  const SelectRoleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 250.h,
              decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage(AppAssets.roleEllipse))
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(AppAssets.selectRoleIcon,
                  width: 144.w,
                    height: 150.h,
                  ),
                  MyText(text: AppLocalizations.of(context)!.selectrole,color: textPrimaryColor,size: 25.sp,fontWeight: FontWeight.w700,)
                ],
              ),
            ),
            20.height,
            SymmetricPadding(
              child: Column(
                children: [

                 // Top row: Customer centered
                 Center(
                   child: Consumer<SelectRoleProvider>(builder: (context,provider,child){
                     return SelectRoleWidget(
                         title: capitalizeFirstLetter('Customer'),
                         isSelected: provider.selectedRole==UserRoles.customer,
                         onPressed: (){
                       provider.changeRole(UserRoles.customer);
                     }, img: AppAssets.customerIcon);
                   }),
                 ),
                 30.height,
                 // Bottom row: Seller and Driver
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: [
                     Consumer<SelectRoleProvider>(builder: (context,provider,child){
                       return SelectRoleWidget(
                           title: capitalizeFirstLetter(UserRoles.seller),
                           isSelected: provider.selectedRole==UserRoles.seller,
                           onPressed: (){
                         provider.changeRole(UserRoles.seller);
                       }, img: AppAssets.sellerIcon);
                     }),
                     Consumer<SelectRoleProvider>(builder: (context,provider,child){
                       return SelectRoleWidget(
                           title: capitalizeFirstLetter(UserRoles.driver),
                           isSelected: provider.selectedRole==UserRoles.driver,
                           onPressed: (){
                         provider.changeRole(UserRoles.driver);
                       }, img: AppAssets.driverIcon);
                     })
                   ],
                 ),
                  20.height,
                  RoundButton(title: AppLocalizations.of(context)!.conti, onTap: (){
                    Navigator.pushNamed(context, RoutesNames.signUpView);
                   // navigateBasedOnRole(provider.selectedRole, context);
                  }),
                  10.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyText(text: AppLocalizations.of(context)!.alreadyhaveanaccount,size: 14.sp,fontFamily: AppFonts.jost),
                      GestureDetector(
                        onTap: (){
                          Navigator.pushNamed(context, RoutesNames.loginView);
                        },
                        child: MyText(text: " ${AppLocalizations.of(context)!.signin}",size: 16.sp,fontFamily: AppFonts.jost,color: primaryColor,fontWeight: FontWeight.w600,),

                      ),
                    ],
                  ),
                  10.height,
                  Center(
                    child: SizedBox(
                      width: 320.w,
                      child: RichText(
                        textAlign: TextAlign.center,

                        text: TextSpan(
                          text: '${AppLocalizations.of(context)!.bysigningupyouagreetoour} ',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: blackColor,
                            fontFamily: AppFonts.poppins,

                          ),
                          children: [

                            TextSpan(
                              text: AppLocalizations.of(context)!.termsofservices,
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                                fontFamily: AppFonts.poppins,
                              ),
                              recognizer: TapGestureRecognizer()..onTap = () {

                                // Navigate to Terms & Conditions
                              },
                            ),
                            TextSpan(
                              text: ' ${AppLocalizations.of(context)!.and} ',
                              style: TextStyle(
                                color: blackColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                                fontFamily: AppFonts.poppins,

                              ),
                            ),
                            TextSpan(
                              text: '${AppLocalizations.of(context)!.privacypolicy}.',
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                                fontFamily: AppFonts.poppins,
                              ),
                              recognizer: TapGestureRecognizer()..onTap = () {
                                // Navigate to Privacy Policy
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  10.height,


                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
class SelectRoleWidget extends StatelessWidget {
  final String title;
  final String img;
  final bool isSelected;
  final VoidCallback onPressed;
  const SelectRoleWidget({super.key, required this.title, required this.isSelected, required this.onPressed, required this.img});

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 167.h,
        width: 146.w,
        decoration: BoxDecoration(
            color:isSelected==true? whiteColor:transparentColor,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color:isSelected==true? primaryColor:transparentColor)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 92.h,
              width: 80.w,
              decoration:  BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                  image: DecorationImage(image: AssetImage(img),scale: 2.5)
              ),
            ),
            MyText(text: title,color: textPrimaryColor,fontWeight: FontWeight.w600,size: 16.sp,)
          ],
        ),
      ),
    );
  }
}
