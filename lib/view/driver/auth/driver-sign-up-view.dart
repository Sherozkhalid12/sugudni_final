import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/providers/auth/driver-sign-up-provider.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/constants/fonts.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/round-button.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/customWidgets/text-field.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';
import 'package:sugudeni/utils/global-functions.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/customWidgets/custom-phone-number-field.dart';

class DriverSignUpView extends StatelessWidget {
  const DriverSignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final driverSignUpProvider=Provider.of<DriverSignUpProvider>(context,listen: false);

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        leadingWidth: 50.w,
        leading:  Padding(
          padding:  EdgeInsets.only(left: 15.w),
          child: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Container(
              width: 35.w,
              height: 35.h,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: textFieldColor,
                  image: DecorationImage(image: AssetImage(AppAssets.backArrow),scale: 3)
              ),
            ),
          ),
        ),
        title: MyText(text: AppLocalizations.of(context)!.driverinfo,fontWeight: FontWeight.w700,size: 18.sp,),
      ),
      body: SafeArea(
        child: SymmetricPadding(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                20.height,
                // Row(
                //   children: [
                //     Container(
                //       width: 38.w,
                //       height: 38.h,
                //       decoration: const BoxDecoration(
                //         shape: BoxShape.circle,
                //         color: textFieldColor,
                //         image: DecorationImage(image: AssetImage(AppAssets.backArrow),scale: 3)
                //       ),
                //     ),
                //     15.width,
                //     MyText(text: "Driver Info",fontWeight: FontWeight.w700,size: 26.sp,),
                //   ],
                // ),
                // 20.height,
                testWidget(title: AppLocalizations.of(context)!.enteryourname),
                5.height,
                Row(
                  children: [
                     Flexible(
                        child: CustomTextFiled(
                          controller: driverSignUpProvider.firstNameController,
                          isShowPrefixImage: true,
                          prefixImgUrl: AppAssets.personIcon,
                          prefixImageColor: textPrimaryColor,
                          hintText: AppLocalizations.of(context)!.firstname,
            
                    )),
                    10.width,
                     Flexible(
                        child: CustomTextFiled(
                          controller: driverSignUpProvider.lastNameController,

                          isShowPrefixImage: true,
                          prefixImgUrl: AppAssets.personIcon,
                          prefixImageColor: textPrimaryColor,
                          hintText: AppLocalizations.of(context)!.lastname,
            
                    )),
                  ],
                ),
                15.height,
                testWidget(title: AppLocalizations.of(context)!.enterphonenumber),
                5.height,
                CustomPhoneNumberField(
                  isFilled: true,
                  controller: driverSignUpProvider.phoneNumberController,

                  childWidget:  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CountryCodePicker(
                        onChanged: (CountryCode countryCode) {
            
                        },
                        padding: EdgeInsets.zero,
                        flagDecoration: const BoxDecoration(
                          shape: BoxShape.rectangle,
                        ),
                        flagWidth: 23.w,
                        initialSelection: 'PRT',
                        favorite: const ['+351',''],
                        showCountryOnly: false,
                        showOnlyCountryWhenClosed: false,
                        alignLeft: false,
            
                        textStyle: TextStyle(
                            fontSize: 14.sp,
                            color: blackColor,
                            fontWeight: FontWeight.w500
                        ),
                        dialogBackgroundColor: whiteColor,
                      ),
                    ],
                  ),
                  hintText:AppLocalizations.of(context)!.yourphonenumber,
                  keyboardType: TextInputType.number,
                  hintColor: blackColor,
                  hintTextSize: 14.sp,
                ),
                // 15.height,
                // Row(
                //   children: [
                //     Flexible(
                //         child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             testWidget(title: "Enter Email"),
                //             5.height,
                //             CustomTextFiled(
                //
                //               borderRadius: 15.r,
                //               isBorder: true,
                //               isShowPrefixIcon: true,
                //               isFilled: true,
                //               hintText: 'Email',
                //               isShowPrefixImage: true,
                //               prefixImgUrl: AppAssets.emailIcon,
                //               prefixImageColor: textPrimaryColor,
                //
                //             ),
                //       ],
                //     )),
                //     10.width,
                //     Flexible(
                //         child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             testWidget(title: "Enter Password"),
                //             5.height,
                //             CustomTextFiled(
                //               borderRadius: 15.r,
                //               isBorder: true,
                //               isShowPrefixIcon: true,
                //               isFilled: true,
                //               hintText: 'Password',
                //               isShowPrefixImage: true,
                //               prefixImgUrl: AppAssets.passwordIcon,
                //               hintTextSize: 12.sp,
                //               prefixImageColor: textPrimaryColor,
                //
                //             ),
                //       ],
                //     )),
                //   ],
                // ),
                15.height,
                testWidget(title: AppLocalizations.of(context)!.enterdrivinglicencedetails),
                5.height,
                Row(
                  children: [
                    Flexible(
                        child: CustomTextFiled(
                         isShowPrefixIcon: false,
                          controller: driverSignUpProvider.licenseNumberController,

                          hintText: AppLocalizations.of(context)!.drivinglicensenumber,
                          textAlign: TextAlign.center,
                          hintTextSize: 10.sp,
            
            
                        )),
                    10.width,
                    Flexible(
                        child: CustomTextFiled(
                          isShowPrefixIcon: false,
                          controller: driverSignUpProvider.bikeRegistrationNumberController,

                          hintText:AppLocalizations.of(context)!.bikeregistrationnumber,
                          textAlign: TextAlign.center,
                          hintTextSize: 10.sp,
            
            
                        )),
                  ],
                ),
                15.height,
                MyText(text: AppLocalizations.of(context)!.uploadyourdriverlicences,fontWeight: FontWeight.w600,size: 19.sp,),
                10.height,
               Consumer<DriverSignUpProvider>(
                   builder: (context,provider,child){
                     print('=== Consumer builder called, frontImage is null: ${provider.frontImage == null} ===');
                     customPrint('=== Consumer builder called, frontImage is null: ${provider.frontImage == null} ===');
                 return provider.frontImage==null?  GestureDetector(
                   behavior: HitTestBehavior.opaque,
                   onTap: () async {
                     print('=== TAP DETECTED: Upload Front Image ===');
                     customPrint('=== TAP DETECTED: Upload Front Image ===');
                     if (context.mounted) {
                       print('=== Context is mounted, calling pickFrontImage ===');
                       customPrint('=== Context is mounted, calling pickFrontImage ===');
                       await provider.pickFrontImage(context);
                       print('=== pickFrontImage completed ===');
                       customPrint('=== pickFrontImage completed ===');
                     } else {
                       print('=== ERROR: Context is not mounted ===');
                       customPrint('=== ERROR: Context is not mounted ===');
                     }
                   },
                   child: Container(
                     height: 200.h,
                     width: double.infinity,
                     decoration: BoxDecoration(
                         color: textFieldColor,
                         borderRadius: BorderRadius.circular(12.r),
                         border: Border.all(color: blackColor)
                     ),
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Icon(Icons.cloud_upload_outlined,size: 30.sp,color: textPrimaryColor,),
                         MyText(text: AppLocalizations.of(context)!.uploadfrontimage,size: 15.sp,fontWeight: FontWeight.w700,fontFamily: AppFonts.jost,)
                       ],
                     ),
                   ),
                 ):GestureDetector(
                   behavior: HitTestBehavior.opaque,
                   onTap: () async {
                     print('=== TAP DETECTED: Upload Front Image (existing image) ===');
                     customPrint('=== TAP DETECTED: Upload Front Image (existing image) ===');
                     if (context.mounted) {
                       await provider.pickFrontImage(context);
                     }
                   },
                   child: Container(
                     height: 200.h,
                     width: double.infinity,
                     decoration: BoxDecoration(
                         image: DecorationImage(image: FileImage(provider.frontImage!),fit: BoxFit.cover),
                         color: textFieldColor,
                         borderRadius: BorderRadius.circular(12.r),
                         border: Border.all(color: blackColor)
                     ),
                   ),
                 );
               }),
                10.height,
               Consumer<DriverSignUpProvider>(
                   builder: (context,provider,child){
                 return provider.backImage==null?  GestureDetector(
                   onTap: () async {
                     if (context.mounted) {
                       await provider.pickBackImage(context);
                     }
                   },
                   child: Container(
                     height: 200.h,
                     width: double.infinity,
                     decoration: BoxDecoration(
                         color: textFieldColor,
                         borderRadius: BorderRadius.circular(12.r),
                         border: Border.all(color: blackColor)
                     ),
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Icon(Icons.cloud_upload_outlined,size: 30.sp,color: textPrimaryColor,),
                         MyText(text: AppLocalizations.of(context)!.uploadbackimage,size: 15.sp,fontWeight: FontWeight.w700,fontFamily: AppFonts.jost,)
                       ],
                     ),
                   ),
                 ):GestureDetector(
                   onTap: () async {
                     if (context.mounted) {
                       await provider.pickBackImage(context);
                     }
                   },
                   child: Container(
                     height: 200.h,
                     width: double.infinity,
                     decoration: BoxDecoration(
                         image: DecorationImage(image: FileImage(provider.backImage!),fit: BoxFit.cover),
                         color: textFieldColor,
                         borderRadius: BorderRadius.circular(12.r),
                         border: Border.all(color: blackColor)
                     ),
                   ),
                 );
               }),
                15.height,
                Row(
                  children: [
                    Flexible(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        testWidget(title: AppLocalizations.of(context)!.drivingsince),
                        5.height,
                        Consumer<DriverSignUpProvider>(builder: (context,provider,child){
                          return GestureDetector(
                            onTap: ()async{
                              var date= await showDatePicker(context: context,
            
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime.now());
                              if(date!=null){
                                provider.changeDrivingDate(date);
                              }
                            },
                            child: Container(
                              height: 48.h,
                              decoration: BoxDecoration(
                                  color: textFieldColor,
                                  borderRadius: BorderRadius.circular(13.r)
                              ),
                              child: Row(
                                children: [
                                  10.width,
                                  Icon(Icons.calendar_month_outlined,size: 25.sp,),
                                  10.width,
                                  MyText(text: provider.drivingText,size: 12.sp,)
                                ],
                              ),
                            ),
                          );
                        })
                      ],
                    )),
                    10.width,
                    Flexible(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        testWidget(title: AppLocalizations.of(context)!.birthdate),
                        5.height,
                       Consumer<DriverSignUpProvider>(builder: (context,provider,child){
                         return  GestureDetector(
                           onTap: ()async{
                             var date= await showDatePicker(context: context,
            
                                 firstDate: DateTime(2000),
                                 lastDate: DateTime.now());
                             if(date!=null){
                               provider.changeDOB(date);
                             }
                           },
                           child: Container(
                             height: 48.h,
                             decoration: BoxDecoration(
                                 color: textFieldColor,
                                 borderRadius: BorderRadius.circular(13.r)
                             ),
                             child: Row(
                               children: [
                                 10.width,
                                 Icon(Icons.calendar_month_outlined,size: 25.sp,),
                                 10.width,
                                 MyText(text: provider.dateOfBirth,size: 12.sp,)
                               ],
                             ),
                           ),
                         );
                       })
                      ],
                    )),

                  ],
                ),
                15.height,
            driverSignUpProvider.isUpdate==true? const SizedBox():    Row(
                  children: [
                    Consumer<DriverSignUpProvider>(builder: (context,provider,child){
                      return Checkbox(
                          checkColor: whiteColor,
                          activeColor: textPrimaryColor,
                          focusColor: textPrimaryColor,
                          fillColor: const WidgetStatePropertyAll(textPrimaryColor),
                          side: const BorderSide(
                            color: textPrimaryColor,
                          ),

                          value: provider.term, onChanged: (v){
                            provider.toggleTerm();
                      });
                    }),
                    MyText(text: AppLocalizations.of(context)!.accepttermsandcondition,size: 15.sp,fontWeight: FontWeight.w500,)
                  ],
                ),
                15.height,
                RoundButton(
                    isLoad: true,
                    title:driverSignUpProvider.isUpdate==true? AppLocalizations.of(context)!.update: AppLocalizations.of(context)!.submit, onTap: (){

                  driverSignUpProvider.updateDriver( context);
                  // Navigator.pushNamed(context, RoutesNames.driverHomeView);
                }),
                15.height,
            
              ],
            ),
          ),
        ),
      ),
    );
  }
Widget testWidget({required String title}){
    return MyText(text: title,size:14.sp,fontWeight: FontWeight.w500);
}
}
