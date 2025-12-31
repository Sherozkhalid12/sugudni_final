import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/constants/fonts.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/view/customer/cart/customer-cart-view.dart';

import '../../../l10n/app_localizations.dart';
import '../products/customer-all-products-view.dart';

class VisitStoreAppBar extends StatelessWidget {
  final String? storeName;
  const VisitStoreAppBar({super.key, this.storeName});

  @override
  Widget build(BuildContext context) {
    final border=OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: const BorderSide(
        color: whiteColor,

      ),
    );
    return Column(
      children: [
        Row(
          children: [
            IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: const Icon(Icons.arrow_back_ios,color: whiteColor,)),
            Flexible(
              child: GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const CustomerAllProductsView(isComeFromSearch: true,)));
                },
                child: TextFormField(
                  enabled: false,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 10.sp,
                      color:  whiteColor
                  ),
                  decoration: InputDecoration(
                      prefixIcon:  Icon(Icons.search,color: whiteColor.withOpacity(0.7),),
                      hintText: AppLocalizations.of(context)!.searchinsugudeni,
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 10.sp,
                          color: whiteColor
                      ),
                      border: border,
                      enabledBorder:border ,
                      focusedBorder:border
                  ),
                ),
              ),
            ),
            15.width,
            Stack(
              children: [
                GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const CustomerCartView()));
                    },
                    child: Image.asset(AppAssets.cartBottomIcon,scale: 1,color: whiteColor,width: 30.w,height: 30.h,)),
                // Positioned(
                //   right: 0,
                //   child: Container(
                //     height: 13.h,
                //     width: 13.w,
                //     decoration: const BoxDecoration(
                //         color: appRedColor,
                //         shape: BoxShape.circle
                //     ),
                //     child: Center(
                //       child: MyText(text: '0',color: whiteColor,size: 7.sp,fontFamily: AppFonts.jost,),
                //     ),
                //   ),
                // )
              ],
            ),
            15.width,
           // Image.asset(AppAssets.gridIcon,scale: 2,width: 20.w,height: 20.h,color: whiteColor,),
          ],
        ),
        10.height,
        Container(
          // height: 72.h,
          // width: 340.w,
          decoration: BoxDecoration(
            //  color: Color(0xffD9D9D9).withAlpha(137),
              color: const Color(0xffD9D9D9).withAlpha(getAlpha(0.54)),
              // color: Color(0xffD9D9D9).withOpacity(0.5),
              borderRadius: BorderRadius.circular(10.r)
          ),
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 10.w,vertical: 5.h),
            child: Column(
              spacing: 3.h,
              children: [
                Row(
                  children: [
                    Container(
                      height: 40.h,
                      width: 40.w,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: roundProfileColor
                      ),
                      child: Center(
                        child: MyText(text:firstTwoLetters(storeName!??"AMY") ,color: whiteColor,size: 12.sp,fontWeight: FontWeight.w600),
                      ),
                    ),
                    5.width,
                    MyText(text:storeName?? "AMY Online Shopping\nStore",color: whiteColor,size: 12.sp,fontWeight: FontWeight.w600),
                    const Spacer(),
                    SizedBox()
                    // Container(
                    //   decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(8.r),
                    //       boxShadow: [
                    //         BoxShadow(
                    //             color: blackColor.withAlpha(getAlpha(0.3)),
                    //             spreadRadius: 1,
                    //             blurRadius: 9,
                    //             offset: const Offset(-2, 4)
                    //         )
                    //       ],
                    //       gradient: const LinearGradient(colors: [
                    //         Color(0xffFF099D),
                    //         Color(0xffFF6600),
                    //       ])
                    //   ),
                    //   child: Padding(
                    //     padding:  EdgeInsets.symmetric(horizontal:15.w,vertical: 5.h),
                    //     child: Center(
                    //       child: MyText(text: "Follow",color: whiteColor,size: 12.sp,fontWeight: FontWeight.w700),
                    //
                    //     ),
                    //   ),
                    // )
                  ],
                ),
                // Row(
                //   children: [
                //     MyText(text: "84%",color: whiteColor,size: 12.sp,fontWeight: FontWeight.w600),
                //     MyText(text: "  Positive seller ratings",color: whiteColor,size: 10.sp,fontWeight: FontWeight.w600),
                //     const Spacer(),
                //     MyText(text: "548",color: whiteColor,size: 12.sp,fontWeight: FontWeight.w600),
                //     MyText(text: "  Followers",color: whiteColor,size: 10.sp,fontWeight: FontWeight.w600),
                //   ],
                // )

              ],
            ),
          ),
        )
      ],
    );
  }
}
