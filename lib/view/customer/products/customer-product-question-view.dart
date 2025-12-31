import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/constants/fonts.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';

import '../../../utils/constants/app-assets.dart';
import '../appBar/customer-used-appbar.dart';
class CustomerProductQuestionView extends StatefulWidget {
  const CustomerProductQuestionView({super.key});

  @override
  State<CustomerProductQuestionView> createState() => _CustomerProductQuestionViewState();
}

class _CustomerProductQuestionViewState extends State<CustomerProductQuestionView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        automaticallyImplyLeading: false,
        forceMaterialTransparency: true,
        toolbarHeight: 70.h,
        flexibleSpace: Container(
          color: whiteColor,
        ),
        title:const CustomerUsedAppBar(),
      ),
      body: Stack(
        children: [
          SymmetricPadding(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(text: "Q & A",size: 22.sp,fontWeight: FontWeight.w700),
                10.height,
                MyText(text: "Questions about this product (387)",size: 10.sp,fontWeight: FontWeight.w500,color: textSecondaryColor),
                10.height,
                Expanded(
                  child: ListView.builder(
                      itemCount: 8,

                      itemBuilder: (context,index){
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(AppAssets.questionIcon,scale: 3,),
                            10.width,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyText(text: "What are the main uses of red chili ?",fontWeight: FontWeight.w500,size: 10.sp,),
                                5.height,
                                MyText(text: "Olivia Grace. - 2 days ago",fontWeight: FontWeight.w500,size: 8.sp,color: textSecondaryColor),
                              ],
                            )
                          ],
                        ),
                        15.height,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(AppAssets.answerIcon,scale: 3,),
                            10.width,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyText(text: "To add heat and flavor to dishes in\ncooking.",fontWeight: FontWeight.w500,size: 10.sp,),
                                5.height,
                                MyText(text: "AMY Online Shopping Store -Answered within 2 hours ",fontWeight: FontWeight.w500,size: 8.sp,color: textSecondaryColor),
                              ],
                            )
                          ],
                        ),
                        15.height,
                        const Divider()
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 60.h,
              width: double.infinity,
              color: whiteColor,
              margin: EdgeInsets.only(bottom: 30.h),
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 12.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Flexible(
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          style: TextStyle(

                              fontWeight: FontWeight.w500,
                              fontSize: 10.sp,
                              color: const Color(0xff545454)
                          ),
                          decoration: InputDecoration(
                            hintText: "Enter your Question(s) here ",

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
            ),
          )
        ],
      )
    );
  }
}
