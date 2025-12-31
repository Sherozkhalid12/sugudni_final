import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/providers/auth/driver-sign-up-provider.dart';
import 'package:sugudeni/repositories/user-repository.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/constants/fonts.dart';
import 'package:sugudeni/utils/customWidgets/cached-network-image.dart';
import 'package:sugudeni/utils/customWidgets/loading-dialog.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/round-button.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/customWidgets/text-field.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';
import '../../../utils/customWidgets/custom-phone-number-field.dart';
import '../../l10n/app_localizations.dart';

class DriverProfileView extends StatelessWidget {
  const DriverProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final driverSignUpProvider=Provider.of<DriverSignUpProvider>(context,listen: false);

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        driverSignUpProvider.clearResources();
      },
      child: Scaffold(
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
                width: 5.w,
                height: 35.h,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: textFieldColor,
                    image: DecorationImage(image: AssetImage(AppAssets.backArrow),scale: 3)
                ),
              ),
            ),
          ),
          title: MyText(text: AppLocalizations.of(context)!.driverprofile,fontWeight: FontWeight.w700,size: 26.sp,),
        ),
        body: SafeArea(
          child: SymmetricPadding(
            child: FutureBuilder(
                future: UserRepository.getDriverData(context),
                builder: (context,snapshot){
                  if(snapshot.connectionState==ConnectionState.waiting){
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if(snapshot.hasError){
                    return Center(
                      child: MyText(text: snapshot.error.toString()),
                    );
                  }
                  var data=snapshot.data!.user;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    20.height,
                    testWidget(title: AppLocalizations.of(context)!.name),
                    5.height,
                    Container(

                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: textFieldColor,
                          borderRadius: BorderRadius.circular(13.r)
                      ),
                      child: Padding(
                        padding:  EdgeInsets.symmetric(vertical: 12.h,horizontal: 10.w),
                        child: MyText(text: "${capitalizeFirstLetter(data.firstname)} ${data.lastname}",color: textPrimaryColor,size: 12.sp,fontWeight: FontWeight.w500,fontFamily: AppFonts.poppins,),
                      ),
                    ),

                    15.height,
                    testWidget(title: AppLocalizations.of(context)!.email),
                    5.height,
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: textFieldColor,
                          borderRadius: BorderRadius.circular(13.r)
                      ),
                      child: Padding(
                        padding:  EdgeInsets.symmetric(vertical: 12.h,horizontal: 10.w),
                        child: MyText(text: data.email,color: textPrimaryColor,size: 12.sp,fontWeight: FontWeight.w500,fontFamily: AppFonts.poppins,),
                      ),
                    ),
                    15.height,
                    testWidget(title: AppLocalizations.of(context)!.phonenumber),
                    5.height,
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: textFieldColor,
                          borderRadius: BorderRadius.circular(13.r)
                      ),
                      child: Padding(
                        padding:  EdgeInsets.symmetric(vertical: 12.h,horizontal: 10.w),
                        child: MyText(text: data.phone,color: textPrimaryColor,size: 12.sp,fontWeight: FontWeight.w500,fontFamily: AppFonts.poppins,),
                      ),
                    ),
                    15.height,
                    testWidget(title: AppLocalizations.of(context)!.drivinglicensedetail),
                    5.height,
                    Row(
                      children: [
                        Flexible(
                          child: Container(

                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: textFieldColor,
                                borderRadius: BorderRadius.circular(13.r)
                            ),
                            child: Padding(
                              padding:  EdgeInsets.symmetric(vertical: 12.h,horizontal: 10.w),
                              child: Center(child: MyText(text: data.licenseNumber,color: textPrimaryColor,size: 12.sp,fontWeight: FontWeight.w500,fontFamily: AppFonts.poppins,)),
                            ),
                          ),
                        ),                    10.width,

                        Flexible(
                          child: Container(

                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: textFieldColor,
                                borderRadius: BorderRadius.circular(13.r)
                            ),
                            child: Padding(
                              padding:  EdgeInsets.symmetric(vertical: 12.h,horizontal: 10.w),
                              child: Center(child: MyText(text: data.bikeRegistrationNumber,color: textPrimaryColor,size: 12.sp,fontWeight: FontWeight.w500,fontFamily: AppFonts.poppins,)),
                            ),
                          ),
                        ),

                      ],
                    ),
                    15.height,
                    MyText(text:  AppLocalizations.of(context)!.driverlicenseimage,fontWeight: FontWeight.w600,size: 19.sp,),
                    10.height,

                    MyCachedNetworkImage(
                        height: 200.h,
                        width: double.infinity,
                        fit: BoxFit.contain,
                        imageUrl: "${ApiEndpoints.productUrl}/${data.licenseFront}"),
                    10.height,
                    MyCachedNetworkImage(
                        height: 200.h,
                        width: double.infinity,
                        fit: BoxFit.contain,
                        imageUrl: "${ApiEndpoints.productUrl}/${data.licenseBack}"),

                    15.height,
                    Row(
                      children: [
                        Flexible(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            testWidget(title:  AppLocalizations.of(context)!.drivingsince),
                            5.height,
                            Container(
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
                                  MyText(text:data.drivingSince==null? 'date':dateFormat(data.drivingSince!),size: 12.sp,)
                                ],
                              ),
                            ),
                          ],
                        )),
                        10.width,
                        Flexible(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            testWidget(title:  AppLocalizations.of(context)!.birthdate),
                            5.height,
                            Container(
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
                                  MyText(text:data.dob==null? '':dateFormat(data.dob!),size: 12.sp,)
                                ],
                              ),
                            ),
                          ],
                        )),

                      ],
                    ),
                    15.height,
                    RoundButton(title: AppLocalizations.of(context)!.editprofile, onTap: ()async{
                      showDialog(context: context, builder: (context){
                        return  LoadingDialog(text: AppLocalizations.of(context)!.pleasewait,);
                      });
                   await driverSignUpProvider.setValues(data);
                   if(context.mounted){
                     Navigator.pop(context);
                     Navigator.pushNamed(context, RoutesNames.driverSignUpView);
                   }
                    }),
                    15.height,

                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
  Widget testWidget({required String title}){
    return MyText(text: title,size:14.sp,fontWeight: FontWeight.w500);
  }
}
