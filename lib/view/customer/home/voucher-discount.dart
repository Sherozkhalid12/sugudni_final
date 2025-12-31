import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sugudeni/utils/constants/screen-sizes.dart';
import 'package:sugudeni/utils/extensions/media-query.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/customWidgets/my-text.dart';

class VoucherAndDiscount extends StatelessWidget {
  const VoucherAndDiscount({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth=context.screenWidth;
    final screenHeight=context.screenHeight;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(text: "Voucher & Discount",
          size: 14.sp,
          fontWeight: FontWeight.w600,
        ),
        10.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 40.h,
              //  width: 133.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: const Color(0xffEDEDED),
                  boxShadow: [
                    BoxShadow(
                        color: blackColor.withOpacity(0.3),
                        spreadRadius: 0,
                        blurRadius: 10
                    )
                  ]
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyText(text: "25% OFF",size: 9.sp,fontWeight: FontWeight.w600,color: const Color(0xff00A2F9),),
                        MyText(text: "SUGUDENI Voucher",size: 9.sp,fontWeight: FontWeight.w600,color: const Color(0xff00A2F9),),
                      ],
                    ),
                    20.width,
                    DottedDashedLine(
                        height: 26.h,
                        width: 1.w,
                        dashWidth: 2.w,
                        dashColor: borderColor,
                        axis: Axis.vertical)

                  ],
                ),
              ),
            ),
            Flexible(
              child: Container(
                height: 40.h,
                //  width: 133.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: const Color(0xffEDEDED),
                    boxShadow: [
                      BoxShadow(
                          color: blackColor.withOpacity(0.3),
                          spreadRadius: 0,
                          blurRadius: 10
                      )
                    ]
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MyText(text: "\$.10",size: 9.sp,fontWeight: FontWeight.w600,color: const Color(0xff00E5E9),),
                          MyText(text: "Free Shipping",size: 9.sp,fontWeight: FontWeight.w600,color: const Color(0xff00E5E9),),
                        ],
                      ),
                      screenWidth<ScreenSizes.width420? 0.width:20.width,
                      DottedDashedLine(
                          height: 26.h,
                          width: 2.w,
                          dashWidth: 10.w,
                          dashColor: borderColor,
                          axis: Axis.vertical)

                    ],
                  ),
                ),
              ),
            ),
            Flexible(
              child: Container(
                height: 40.h,
                //  width: 133.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: const Color(0xffEDEDED),
                    boxShadow: [
                      BoxShadow(
                          color: blackColor.withOpacity(0.3),
                          spreadRadius: 0,
                          blurRadius: 10
                      )
                    ]
                ),
                child: Container(
                  width: 103.w,
                  height: 30.h,
                  margin: EdgeInsets.all(4.sp),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      gradient: const LinearGradient(colors: [
                        Color(0xffFF6600),
                        Color(0xffFF099D),
                      ])
                  ),
                  child: Center(
                    child: MyText(text: "Collect All",
                      color: whiteColor,size: 9.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
