import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/global-functions.dart';

class UserNameProfileWidget extends StatelessWidget {
  final String name;
  const UserNameProfileWidget({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      width: 40.w,
      decoration:  const BoxDecoration(
          color: redColor,
          shape: BoxShape.circle,
      ),
      child: Center(
        child: MyText(text: firstTwoLetters(name),color: whiteColor,size: 12.sp,fontWeight: FontWeight.w700,),
      ),
    );
  }
}
