import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sugudeni/repositories/user-repository.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/shimmer-widgets.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';
import 'package:sugudeni/utils/sharePreference/is-user-registered.dart';
import 'package:sugudeni/utils/sharePreference/save-user-token.dart';
import 'package:sugudeni/view/customer/account/to-pay.dart';
import 'package:sugudeni/view/customer/appBar/account-app-bar.dart';

import '../../../l10n/app_localizations.dart';
import '../trackOrder/item-to-review-bottom-sheet.dart';

class CustomerAccountView extends StatelessWidget {
  const CustomerAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    // Removed dummy store list - all commented out code was using dummy data
    return FutureBuilder(
        future: getUserId(),
        builder: (context,token){
          var userId=token.data?? '';
          
          if(userId.isEmpty){
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamedAndRemoveUntil(context, RoutesNames.selectRoleView, (route) => false);
                        },
                        child: Center(
                          child: MyText(
                            text: AppLocalizations.of(context)!.signuplogintoyouraccount,
                            color: whiteColor,
                            size: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
      return  FutureBuilder(
          future: isUserRegistered(),
          builder: (context,value){
            bool isRegis=value.data??false;
            return Scaffold(
              appBar:  CustomerAccountAppBar(
                text: AppLocalizations.of(context)!.profile,
              ),
              body: SymmetricPadding(
                child: FutureBuilder(
                    future:UserRepository.getSellerData(context),
                    builder: (context,snapshot){
                      if(snapshot.connectionState==ConnectionState.waiting){
                        return const ListItemShimmer(height: 200);
                      }
                      if(snapshot.hasError){
                        return Center(
                          child: MyText(text: snapshot.error.toString()),
                        );
                      }
                      var data=snapshot.data;
                      return SingleChildScrollView(
                        child: Column(
                          spacing: 15.h,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(text: "${AppLocalizations.of(context)!.hello}, ${capitalizeFirstLetter(data!.user!.name)}!",size: 28.sp,fontWeight: FontWeight.w700),
                            // Container(
                            //   width: double.infinity,
                            //   decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(10.r),
                            //     color: const Color(0xffFFD8BD),
                            //   ),
                            //   child: Padding(
                            //     padding:  EdgeInsets.symmetric(horizontal: 12.w,vertical: 8.h),
                            //     child: Column(
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       children: [
                            //         MyText(text: "Announcement",size: 14.sp,fontWeight: FontWeight.w700),
                            //         Row(
                            //           children: [
                            //             Flexible(
                            //               child: MyText(
                            //                   overflow: TextOverflow.clip,
                            //                   text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas hendrerit luctus libero ac vulputate.",size: 10.sp,fontWeight: FontWeight.w400),
                            //             ),
                            //             Container(
                            //               height:30.h ,
                            //               width: 30.w,
                            //               decoration: const BoxDecoration(
                            //                   color: primaryColor,
                            //                   shape: BoxShape.circle
                            //               ),
                            //               child: const Center(
                            //                 child: Icon(Icons.arrow_forward,color: whiteColor,),
                            //               ),
                            //             )
                            //           ],
                            //         ),
                            //
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            // MyText(text: "Recently viewed",size: 21.sp,fontWeight: FontWeight.w700),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: List.generate(dummy.length, (index) =>   Container(
                            //     height:60.h ,
                            //     width: 60.w,
                            //     decoration: BoxDecoration(
                            //         border: Border.all(color: whiteColor,width: 5),
                            //         image: DecorationImage(image: AssetImage(dummy[index]),fit: BoxFit.cover),
                            //         shape: BoxShape.circle
                            //     ),
                            //   ),),
                            // ),
                            MyText(text: AppLocalizations.of(context)!.myorders,size: 21.sp,fontWeight: FontWeight.w700),
                            Row(
                              spacing: 10.w,
                              children: [
                                Flexible(
                                  child: GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomerToPayOrderView()));
                                    },
                                    child: Container(
                                      height: 35.h,

                                      decoration: BoxDecoration(
                                          color: const Color(0xffFFD8BD),
                                          borderRadius: BorderRadius.circular(18.r)
                                      ),
                                      child: Center(
                                        child: MyText(text: AppLocalizations.of(context)!.topay,size: 16.sp,fontWeight: FontWeight.w500,color: primaryColor,),
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: GestureDetector(
                                    onTap: (){
                                      Navigator.pushNamed(context, RoutesNames.customerToReceiveView);
                                    },
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: 35.h,
                                          decoration: BoxDecoration(
                                              color: const Color(0xffFFD8BD),
                                              borderRadius: BorderRadius.circular(18.r)
                                          ),
                                          child: Center(
                                            child: MyText(text: AppLocalizations.of(context)!.toreceive,size: 16.sp,fontWeight: FontWeight.w500,color: primaryColor,),
                                          ),
                                        ),
                                        // Container(
                                        //   height:14.h ,
                                        //   width: 14.w,
                                        //   decoration: BoxDecoration(
                                        //     color: primaryColor,
                                        //     shape: BoxShape.circle,
                                        //     border: Border.all(color: whiteColor,width: 3)
                                        //   ),
                                        // )
                                      ],
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: GestureDetector(
                                    onTap: (){
                                      showModalBottomSheet(
                                          isScrollControlled: true,
                                          backgroundColor: whiteColor,
                                          context: context, builder: (context){
                                        return Padding(
                                          padding:EdgeInsets.only(
                                              bottom: MediaQuery.of(context).viewInsets.bottom),
                                          child: const ItemToReviewBottomSheet(),
                                        );
                                      });
                                    },
                                    child: Container(
                                      height: 35.h,

                                      decoration: BoxDecoration(
                                          color: const Color(0xffFFD8BD),
                                          borderRadius: BorderRadius.circular(18.r)
                                      ),
                                      child: Center(
                                        child: MyText(text: AppLocalizations.of(context)!.toreview,size: 16.sp,fontWeight: FontWeight.w500,color: primaryColor,),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // MyText(text: "Stores",size: 21.sp,fontWeight: FontWeight.w700),
                            // SingleChildScrollView(
                            //   scrollDirection: Axis.horizontal,
                            //   child: Row(
                            //     spacing: 5.w,
                            //     children: List.generate(dummy.length, (index) =>
                            //         Container(
                            //           width: 104.w,
                            //           height: 175.h,
                            //           decoration: BoxDecoration(
                            //               color: Colors.red,
                            //               borderRadius: BorderRadius.circular(10.r),
                            //               image:  DecorationImage(image: AssetImage(dummy[index]),fit: BoxFit.cover)
                            //           ),
                            //           child: Center(
                            //             child: Image.asset(AppAssets.playIcon,scale: 2,),
                            //           ),
                            //         ),),
                            //   ),
                            // ),
                            120.height


                          ],
                        ),
                      );
                    }),
              ),

            );
          });
    });
  }
}
// isRegis==false?
// Scaffold(
// appBar: AppBar(),
// body: Center(
// child: Column(
// // mainAxisAlignment: MainAxisAlignment.center,
// children: [
// 100.height,
// Image.asset(AppAssets.appLogo),
// 120.height,
// GestureDetector(
// onTap: (){
// Navigator.pushNamed(context, RoutesNames.selectRoleView);
// },
// child: Container(
// decoration: BoxDecoration(
// color: primaryColor,
// borderRadius: BorderRadius.circular(10.r)
// ),
// child: Padding(
// padding: const EdgeInsets.all(15),
// child: MyText(text: "Create account",color: whiteColor,fontWeight: FontWeight.w600,size: 13.sp,),
// ),
// ),
// ),
// ],
// ),
// ),
// )
//
// :