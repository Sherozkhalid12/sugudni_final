import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/colors.dart';
import 'my-text.dart';
class SellerTabBarWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final bool selected;
  final String title;
  final double? width;
  const SellerTabBarWidget(
      {super.key,
        required this.onPressed,
        required this.selected,
        required this.title, this.width});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: EdgeInsets.only(right: 13.w),
        child: Column(
          children: [
            MyText(
              text: title,
              color: selected == true
                  ? primaryColor
                  : textPrimaryColor.withOpacity(0.7),
              fontWeight: FontWeight.w600,
              size: 12.sp,
            ),
            selected == true
                ? Container(
              width:width?? 38.w,
              height: 3,
              decoration: BoxDecoration(
                color: selected == true
                    ? primaryColor
                    : textPrimaryColor.withOpacity(0.7),
              ),
            )
                : SizedBox(
              width:width?? 38.w,
            ),
          ],
        ),
      ),
    );
  }
}
