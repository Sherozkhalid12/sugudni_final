
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/providers/customer-help-provider.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/round-button.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';
import 'package:sugudeni/view/customer/account/customer-to-receive-order-view.dart';
import 'package:sugudeni/view/customer/help/select-order-issue-bottom-sheet.dart';

import '../account/rating-bottom-sheet.dart';

class SelectOrderBottomSheet extends StatelessWidget {
  const SelectOrderBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SymmetricPadding(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 10.h,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          0.height,
          Row(
            children: [
              MyText(text: "Select one of your orders",size: 22.sp,fontWeight: FontWeight.w700,),
              const Spacer(),
              GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Image.asset(AppAssets.cancelIcon,scale: 2,))
            ],
          ),
          const OrderStatusWidget(status: OrderStatus.packed,),
          const OrderStatusWidget(status: OrderStatus.delivered,isSelected: true,),


          Row(
            spacing: 5.w,
            children: [
              Flexible(
                child: RoundButton(
                    borderRadius: BorderRadius.circular(10.r),
                    title: "Next", onTap: (){
                  Navigator.pop(context);

                }),
              ),
              Container(
                height: 26.w,
                width: 26.w,
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(7.r)
                ),
                child: Center(
                  child: Image.asset(AppAssets.cancelIcon,color: whiteColor,scale: 3),
                ),
              )
            ],
          ),
          10.height
        ],
      ),
    );
  }
}
class OrderStatusWidget extends StatelessWidget {
  final String status;
  final bool? isSelected;
  const OrderStatusWidget({super.key, required this.status, this.isSelected=false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //  height: 101.h,
      width:double.infinity,
      child: Row(
        children: [
          Container(
            height: 89.h,
            width: 89.w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9.r),
                image: const DecorationImage(image: AssetImage(AppAssets.shippedDummy),fit: BoxFit.cover)
            ),
          ),
          5.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(text: "Order #92287157",size: 14.sp,fontWeight: FontWeight.w700,),
              MyText(text: "Standard Delivery",size: 14.sp,fontWeight: FontWeight.w500,),
              5.height,
              status==OrderStatus.shipped? MyText(text: "Shipped",size: 18.sp,fontWeight: FontWeight.w700,):
              status==OrderStatus.packed? MyText(text: "Packed",size: 18.sp,fontWeight: FontWeight.w700,):
              Row(
                children: [
                  MyText(text: "Delivered",size: 18.sp,fontWeight: FontWeight.w700,),
                  Container(
                    height: 22.h,
                    width: 22.w,
                    decoration: BoxDecoration(
                        color: primaryColor,
                        border: Border.all(color: whiteColor,width: 2),
                        shape: BoxShape.circle,
                        image: const DecorationImage(image: AssetImage(AppAssets.checkIcon),scale: 3)
                    ),
                  ),

                ],
              )
              ,

            ],
          ),
          const Spacer(),
          Column(
            spacing: 20.h,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: const Color(0xffE4E4E4),
                    borderRadius: BorderRadius.circular(4.r)
                ),
                child: Center(
                  child: Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 5.w,vertical: 2.h),
                    child: MyText(text: "3 items",size: 13.sp,fontWeight: FontWeight.w500,),
                  ),
                ),
              ),
              GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                    color:  isSelected==true?primaryColor:transparentColor,
                      border: Border.all(color: primaryColor),
                      borderRadius: BorderRadius.circular(9.r)
                  ),
                  child: Center(
                    child: Padding(
                      padding:  EdgeInsets.symmetric(
                          horizontal: 15.w,vertical: 2.h),
                      child: MyText(text:
                     isSelected==true?"Selected": "Select",size: 16.sp,
                        fontWeight: FontWeight.w500,color: isSelected==true?whiteColor: primaryColor,),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
