import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sugudeni/main.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/view/customer/help/select-issue-bottom-sheet.dart';

import '../trackOrder/order-unsuccessful-bottom-sheet.dart';

class CustomerHelpCenterOneView extends StatefulWidget {
  const CustomerHelpCenterOneView({super.key});

  @override
  State<CustomerHelpCenterOneView> createState() => _CustomerHelpCenterOneViewState();
}

class _CustomerHelpCenterOneViewState extends State<CustomerHelpCenterOneView> {
  @override
  void initState() {
    // TODO: implement initState
    selectIssueBottomSheet();
    super.initState();
  }
  void selectIssueBottomSheet(){
    Future.delayed(const Duration(milliseconds: 1000),() =>
        showModalBottomSheet(context: context,
            isDismissible: false
            ,
            builder: (context){
          return const SelectMainIssueBottomSheet();
        }),);
  }
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 70.h,
        backgroundColor: whiteColor,
        leading: Padding(
          padding: EdgeInsets.only(left: 10.w),
          child: IconButton(onPressed: (){
            Navigator.pop(context);
          },
              icon: Icon(Icons.arrow_back_ios,size: 24.sp,)),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyText(text: "Chat Bot",size: 16.sp,fontWeight: FontWeight.w600),
            MyText(text: "Customer Care Service",size: 12.sp,fontWeight: FontWeight.w500),
          ],
        ),
        actions: [
          Material(
            elevation: 2,

            shape: const CircleBorder(),
            child: Container(
              height: 44.h,
              width: 44.w,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor.withOpacity(0.4),
                  border: Border.all(color: whiteColor,width: 5),
                  image: const DecorationImage(image: AssetImage(AppAssets.cartIcon),scale: 3)
              ),

            ),
          ),
          10.width
        ],

      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          10.height,
          SymmetricPadding(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 221.w,
                  decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(9.r)
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(11.sp),
                    child: MyText(
                        size: 12.sp,
                        overflow: TextOverflow.clip,
                        fontWeight: FontWeight.w500,
                        text:
                        "Hello, Amanda! Welcome to Customer Care Service. We will be happy to help you. Please, provide us more details about your issue before we can start."),
                  ),
                ),
                20.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          //width: 221.w,
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(9.r)
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(11.sp),
                            child: Row(
                              children: [
                                Container(
                                  height: 22.h,
                                  width: 22.w,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: primaryColor,
                                      border: Border.all(color: whiteColor,width: 2)
                                  ),
                                  child: Center(
                                    child: Icon(Icons.check,size: 12.sp,color: whiteColor,),
                                  ),
                                ),
                                5.width,
                                MyText(
                                    size: 12.sp,
                                    color: whiteColor,
                                    overflow: TextOverflow.clip,
                                    fontWeight: FontWeight.w500,
                                    text:
                                    "Order Issues"),
                              ],
                            ),
                          ),
                        ),
                        7.height,
                        Container(
                          //width: 221.w,
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(9.r)
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(11.sp),
                            child: Row(
                              children: [
                                Container(
                                  height: 22.h,
                                  width: 22.w,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: primaryColor,
                                      border: Border.all(color: whiteColor,width: 2)
                                  ),
                                  child: Center(
                                    child: Icon(Icons.check,size: 12.sp,color: whiteColor,),
                                  ),
                                ),
                                5.width,
                                MyText(
                                    size: 12.sp,
                                    color: whiteColor,
                                    overflow: TextOverflow.clip,
                                    fontWeight: FontWeight.w500,
                                    text:
                                    "I didn't receive my parcel"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    5.width,
                    Material(
                      elevation: 2,

                      shape: const CircleBorder(),
                      child: Container(
                        height: 44.h,
                        width: 44.w,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primaryColor.withOpacity(0.4),
                            border: Border.all(color: whiteColor,width: 5),
                            image: const DecorationImage(image: AssetImage(AppAssets.dummyUserFour))
                        ),

                      ),
                    ),

                  ],
                ),
                7.height,
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    //  height: 101.h,
                    width: 305.w,
                    decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(9.r),
                        border: Border.all(color: primaryColor)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
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
                              MyText(text: "Shipped",size: 18.sp,fontWeight: FontWeight.w700,),

                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          const Spacer(),
          Container(
            height: 75.h,
            width: double.infinity,
            color: whiteColor,
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 42.h,
                    width: 58.w,
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(10.r),
                        image: const DecorationImage(image: AssetImage(AppAssets.addIcon),scale: 3)
                    ),
                  ),
                  7.width,
                  Flexible(
                      child: TextFormField(
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 10.sp,
                            color: const Color(0xff545454)
                        ),
                        decoration: InputDecoration(
                          hintText: "Type your message",
                          suffixIcon: Image.asset(AppAssets.emojiIcon,scale: 2,),
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 10.sp,
                              color: const Color(0xff545454)
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: const BorderSide(
                              color: primaryColor,

                            ),
                          ),
                          enabledBorder:OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: const BorderSide(
                              color: primaryColor,

                            ),
                          ) ,
                          focusedBorder:OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: const BorderSide(
                              color: primaryColor,
                            ),
                          ),
                        ),
                      )),
                  7.width,
                  Container(
                    height: 42.h,
                    width: 58.w,
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(10.r),
                        image: const DecorationImage(image: AssetImage(AppAssets.sendIcon),scale: 3)
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
