

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../providers/loading-provider.dart';
import '../constants/colors.dart';
import '../constants/fonts.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool loading;
  final double?width;
  final double?height;
  final Color?textColor;
  final Color? bgColor;
  final Color? borderColor;
  final Color? loadingColor;
  final double? btnTextSize;
  final String? textFontFamily;
  final bool? isLoad;
  final bool? isShowIcon;
  final FontWeight? textFontWeight;
  final BorderRadius? borderRadius;
  const RoundButton({
    super.key,
    this.borderRadius,
    required this.title,
    required this.onTap,
    this.loading=false,
    this.isLoad=false,
    this.isShowIcon=false,
    this.width,
    this.height,
    this.textColor,
    this.bgColor,
    this.btnTextSize,
    this.borderColor, this.textFontFamily, this.textFontWeight, this.loadingColor
  });
  @override
  Widget build(BuildContext context) {
    return Consumer<LoadingProvider>(builder: (context,statusProvider,child){
      return InkWell(
        onTap: statusProvider.isLoading?null: onTap,
        child: Container(
          height:height?? 45.h,
          width:width?? double.infinity,
          decoration: BoxDecoration(
              color:bgColor?? primaryColor,
              gradient:bgColor==null? const LinearGradient(
                  colors: [
                gradientColorThree,
                    gradientColorTwo,
                    gradientColorOne,

                  ]):null,
              borderRadius: borderRadius ?? BorderRadius.circular(40.r),
              border: Border.all(
                  color: borderColor??transparentColor
              )
          ),
          child: Center(
            child: statusProvider.isLoading &&isLoad==true? SpinKitDoubleBounce(color:loadingColor?? Colors.white,size: 20,)
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                                  title,
                                  style: TextStyle(
                      color: textColor?? whiteColor,
                      fontFamily:textFontFamily?? AppFonts.poppins,
                      fontSize:btnTextSize?? 19.sp,
                      fontWeight: textFontWeight??FontWeight.w500),
                                ),
                    isShowIcon==true?   SizedBox(width: 5.w,):const SizedBox(),

                    isShowIcon==true?  Icon(Icons.arrow_right_alt,color: whiteColor,size: 20.sp,):const SizedBox(),

                  ],
                ),
          ),
        ),

      );
    });
  }
}