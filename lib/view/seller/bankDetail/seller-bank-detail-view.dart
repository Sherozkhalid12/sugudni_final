import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/providers/image-pickers-provider.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/screen-sizes.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/media-query.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/view/seller/products/seller-my-products-view.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/fonts.dart';
import '../../../utils/customWidgets/app-bar-title-widget.dart';
import '../../../utils/customWidgets/my-text.dart';
import '../../../utils/customWidgets/round-button.dart';

class SellerBankDetailView extends StatelessWidget {
  const SellerBankDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.h,
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,

        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            RoundIconButton(onPressed: (){
              Navigator.pop(context);
            },iconUrl: AppAssets.arrowBack),
            20.width,
             AppBarTitleWidget(title: AppLocalizations.of(context)!.bankdetail),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Container(
             color: whiteColor,
             child: Padding(
               padding:  EdgeInsets.symmetric(horizontal: 15.w,vertical: 10.h),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   text(title: AppLocalizations.of(context)!.accounttitle),
                    BankDetailTextField(hintText: AppLocalizations.of(context)!.accountholdername),
                   text(title: AppLocalizations.of(context)!.accountnumber),
                   const BankDetailTextField(hintText: "i.e 0255011541121582"),

                   text(title: AppLocalizations.of(context)!.bankname),
                    BankDetailTextField(hintText: AppLocalizations.of(context)!.thenameofyourbank),

                   text(title: AppLocalizations.of(context)!.bankcode),
                   const BankDetailTextField(hintText: "i.e 0123"),

                   Row(
                     children: [
                       MyText(text: "*",size: 12.sp,fontWeight: FontWeight.w500,color: appRedColor,),
                       MyText(text: "IBAN ",size: 12.sp,fontWeight: FontWeight.w500,),
                       MyText(text: "(e.g AS121DA210002155101)",size: 12.sp,fontWeight: FontWeight.w500,color: textPrimaryColor.withOpacity(0.8),),
                     ],
                   ),
                   const BankDetailTextField(hintText: "i.e AAS2255SD2255S22S55"),

                   text(title: AppLocalizations.of(context)!.uploadchequecopy),
                   10.height,
                   GestureDetector(
                     onTap: (){
                       final provider=Provider.of<ImagePickerProviders>(context,listen: false);
                         provider.pickChequeImage();
                     },
                     child: Container(
                       height: 60.h,
                       width: 60.w,
                       margin: const EdgeInsets.only(right: 10),

                       decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(5.r),
                           border: Border.all(color: borderColor),
                           image: const DecorationImage(image: AssetImage(AppAssets.selectProductIcon),scale: 3)
                       ),
                     ),
                   ),
                   10.height,
                   Consumer<ImagePickerProviders>(builder: (context,provider,child){
                     return provider.chequeImage!=null? Container(
                       height: 150.h,
                       width: double.infinity,
                       decoration: BoxDecoration(
                           color: redColor,
                           image: DecorationImage(image: FileImage(File(provider.chequeImage!.path)),fit: BoxFit.cover),
                           borderRadius: BorderRadius.circular(3.r)
                       ),
                     ):const SizedBox();
                   })

                 ],
               ),
             ),
           ),
            130.height,
            SymmetricPadding(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RoundButton(title: AppLocalizations.of(context)!.savechanges, onTap: (){}),
                20.height,
                Row(
                  children: [
                    Container(
                      height: 15.h,
                      width: 15.w,
                      decoration: BoxDecoration(
                          color: appRedColor,
                          borderRadius: BorderRadius.circular(2.r),
                          image: const DecorationImage(image: AssetImage(AppAssets.productRemoveIcon),scale: 2)
                      ),
                    ),
                    5.width,
                    RichText(

                      textAlign: TextAlign.center,

                      text: TextSpan(

                        text: AppLocalizations.of(context)!.delete,
                        style: TextStyle(
                          fontSize: 12.sp,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w600,
                          color: blackColor,
                          fontFamily: AppFonts.poppins,

                        ),
                        children: [

                          TextSpan(
                            text: ' ${AppLocalizations.of(context)!.bankaccount}',
                            style: TextStyle(
                              color: blackColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp,
                              fontFamily: AppFonts.poppins,

                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                10.height,
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    text: '${AppLocalizations.of(context)!.asyouareupdatingaccountsettingyoualreadyreadandaccepted} ',
                    style: TextStyle(
                      fontSize: 12.sp,

                      fontWeight: FontWeight.w400,
                      color: blackColor,
                      fontFamily: AppFonts.poppins,

                    ),
                    children: [
                      TextSpan(
                        text: ' ${AppLocalizations.of(context)!.termsandcondition}',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                          fontFamily: AppFonts.poppins,

                        ),
                      ),
                    ],
                  ),
                ),
                20.height,
              ],
            ))
          ],
        ),
      ),
    );
  }

  Widget text({required String title}){
    return             Row(
      children: [
        MyText(text: "*",size: 12.sp,fontWeight: FontWeight.w500,color: appRedColor,),
        MyText(text: title,size: 12.sp,fontWeight: FontWeight.w500,),
      ],
    );

  }
}
class BankDetailTextField extends StatelessWidget {
  final String hintText;
  const BankDetailTextField({super.key, required this.hintText});

  @override
  Widget build(BuildContext context) {
    final screenWidth=context.screenWidth;
    final screenHeight=context.screenHeight;
    return   Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
      child: SizedBox(
        height:screenWidth<ScreenSizes.width380? 35.h:25.h,
        child: TextFormField(
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14.sp,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14.sp,
            ),

          ),
        ),
      ),
    );
  }
}
