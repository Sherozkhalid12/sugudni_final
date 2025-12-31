import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';

class OrderNotSuccessFullBottomSheet extends StatelessWidget {
  const OrderNotSuccessFullBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SymmetricPadding(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 10.h,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          0.height,
          Center(child: MyText(text: "Delivery was not successful",size: 22.sp,fontWeight: FontWeight.w700,)),
          MyText(text: "What should I do?",size: 18.sp,fontWeight: FontWeight.w700,),
          MyText(
            overflow: TextOverflow.clip,
            text: '''Don't worry, we will shortly contact you to arrange
more suitable time for the delivery. You can also contact
us by using this number +00 000 000 000 or chat with our customer care service''',size: 13.sp,fontWeight: FontWeight.w600,),
          GestureDetector(
            onTap: (){
              Navigator.pushNamed(context, RoutesNames.customerHelpCenterView);
            },
            child: Container(
              width: 144.w,
              decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(9.r)
              ),
              child: Center(
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 15.w,vertical: 10.h),
                  child: MyText(text: "Chat Now",size: 16.sp,fontWeight: FontWeight.w500,color: whiteColor,),
                ),
              ),
            ),
          ),
          10.height
        ],
      ),
    );
  }
}