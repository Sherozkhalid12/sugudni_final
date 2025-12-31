
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/global-functions.dart';

class ShimmerEffects{
  Shimmer shimmerForAccountant(){
    return Shimmer.fromColors(
      baseColor: primaryColor.withOpacity(0.2),
      enabled:true,
      direction: ShimmerDirection.ltr,
      highlightColor: primaryColor,
      child: Container(
        height: 40.h,
        width: double.infinity,
        color: primaryColor.withOpacity(0.6),
      ),
    );
  }
  Shimmer shimmerForProducts(){
    return Shimmer.fromColors(
      baseColor: primaryColor.withOpacity(0.2),
      enabled:true,
      direction: ShimmerDirection.ltr,
      highlightColor: primaryColor,
      child: Container(
        height: 130.h,
        width: 130.w,
        color: primaryColor.withOpacity(0.6),
      ),
    );
  }
  Shimmer shimmerForChats(){
    return Shimmer.fromColors(
      baseColor: primaryColor.withOpacity(0.1),
      enabled:true,
      direction: ShimmerDirection.ltr,
      highlightColor: primaryColor.withAlpha(getAlpha(0.5)),
      child: Container(
        height: 40.h,
        margin: EdgeInsets.only(bottom: 10.h),
        width: double.infinity,
        color: primaryColor.withOpacity(0.2),
      ),
    );
  }
  Shimmer shimmerForTables(){
    return Shimmer.fromColors(
      baseColor: primaryColor.withOpacity(0.1),
      enabled:true,
      direction: ShimmerDirection.ltr,
      highlightColor: primaryColor,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.4),
            borderRadius: BorderRadius.circular(10)
        ),
        height: 100.h,
        width: double.infinity,
      ),
    );
  }
}