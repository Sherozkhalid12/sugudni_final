import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sugudeni/main.dart';
import 'package:sugudeni/utils/constants/colors.dart';

class AccountDeletionDialog extends StatelessWidget {
  const AccountDeletionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: transparentColor,
      height: 270.h,
      width: 347.w,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: 347.w,
              height: 225.h,
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(19.r)
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            child: Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                  color: redColor,
                  shape: BoxShape.circle
              ),
            ),
          ),
        ],
      ),
    );
  }
}
