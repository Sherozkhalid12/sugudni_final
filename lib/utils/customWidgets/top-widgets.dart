import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/colors.dart';
import 'my-text.dart';
class TopWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  const TopWidget({super.key, required this.title, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            height: 39.h,
            width: 39.w,
            decoration: BoxDecoration(
                border: Border.all(color: const Color(0xffD8DADC)),
                shape: BoxShape.circle
            ),
            child: Center(
              child: Icon(Icons.arrow_back_rounded,size: 18.sp,),
            ),
          ),
        ),
        const Spacer(),
        MyText(text: title,color: primaryColor,size: 16.sp,fontWeight: FontWeight.w600,),
        const Spacer()
      ],
    );
  }
}
