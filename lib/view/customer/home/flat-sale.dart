import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/constants/screen-sizes.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/media-query.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/view/customer/home/ad-section.dart';
import 'package:sugudeni/view/customer/home/grab-deal.dart';
import 'package:sugudeni/view/customer/home/voucher-discount.dart';

class FlatSale extends StatelessWidget {
  const FlatSale({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 150.h,
      color: whiteColor,
      child: SymmetricPadding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            10.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(AppAssets.flashIcon,scale: 3,width: 88.w,height: 25.h,),
                const Spacer(),
                MyText(text: "Shop More",size: 14.sp,fontWeight: FontWeight.w500),3.width,
                Image.asset(AppAssets.arrowIcon,scale: 4,color: textPrimaryColor,)
              ],
            ),
            10.height,
           const Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               FlatSaleWidget(img: AppAssets.flashSalePicOne,),
               FlatSaleWidget(img: AppAssets.flashSalePicTwo,),
               FlatSaleWidget(img: AppAssets.flashSalePicThree,),
             ],
           )
          ],
        ),
      ),
    );
  }
}
class FlatSaleWidget extends StatelessWidget {
  final String img;
  const FlatSaleWidget({super.key, required this.img});

  @override
  Widget build(BuildContext context) {
    final screenWidth=context.screenWidth;
    final screenHeight=context.screenHeight;
    return  Container(
      height:screenWidth<ScreenSizes.width420? 123.h:113.h,
      width: 100.w,
      decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(8.r)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 80.h,
            width: 112.w,
            decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(8.r),
                image:  DecorationImage(image: AssetImage(img),fit: BoxFit.cover)
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 16.h,
                  width: 54.w,
                  decoration: BoxDecoration(
                      color: appPinkColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4.r),
                        bottomRight: Radius.circular(4.r),
                      )
                  ),
                  child: Center(
                    child: MyText(text: "76% OFF",color: whiteColor,fontWeight: FontWeight.w600,size: 10.sp),
                  ),
                )
              ],
            ),
          ),
          MyText(text: "\$ 76.25",
            color: appPinkColor,size: 10.sp,
            fontWeight: FontWeight.w600,
          ),
          MyText(
            textDecoration: TextDecoration.lineThrough,
            text: "\$ 85.25",
            color: borderColor,
            size: 8.sp,
            fontWeight: FontWeight.w500,
          ),
          2.height,
          Container(
            height: 5.h,
            width: double.infinity,
            decoration: BoxDecoration(
                color: appPinkColor,
                borderRadius: BorderRadius.circular(8.r)

            ),
          )
        ],
      ),
    );
  }
}
