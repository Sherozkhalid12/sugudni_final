import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/customWidgets/my-text.dart';
import '../../../utils/customWidgets/round-button.dart';

class SelectItemWeightBottomSheet extends StatefulWidget {
  const SelectItemWeightBottomSheet({super.key});

  @override
  State<SelectItemWeightBottomSheet> createState() => _SelectItemWeightBottomSheetState();
}

class _SelectItemWeightBottomSheetState extends State<SelectItemWeightBottomSheet> {
  int item=1;
  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: EdgeInsets.all(15.sp),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 90.h,
                  width: 90.w,
                  decoration: BoxDecoration(
                    image: const DecorationImage(image: AssetImage(AppAssets.dummyChilliIcon),fit: BoxFit.scaleDown),
                    borderRadius: BorderRadius.circular(6.r)
                  ),
                ),
               10.width,
               Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   MyText(text: "\$ 76.25",size: 16.sp,fontWeight: FontWeight.w600,color: primaryColor,),

                   Row(
                     children: [
                       MyText(text: "\$ 85.25",size: 10.sp,fontWeight: FontWeight.w500,color: greyColor,textDecoration: TextDecoration.lineThrough,),
                       20.width,
                       Container(
                         decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(6.r),
                             color: const Color(0xffFFB5B5)
                         ),
                         child: Padding(
                           padding:  EdgeInsets.symmetric(horizontal: 4.w,vertical: 2.h),
                           child: MyText(text: "-64%",color: const Color(0xffFF6A6A),size: 8.sp,fontWeight: FontWeight.w600,),
                         ),
                       )
                     ],
                   ),
                   10.height,
                   SizedBox(
                     width: 200.w,
                     child: MyText(
                       overflow: TextOverflow.clip,
                       text: "Red Chili A Fiery Spice that Adds Flavor and Heat to Every Dish.",
                       size: 12.sp,
                       fontWeight: FontWeight.w600,
                     ),
                   ),
                 ],
               ),
                const Spacer(),
                GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Image.asset(AppAssets.crossIcon,scale: 3,))
              ],
            ),
            5.height,
            const Divider(),
            5.height,
            MyText(text: "Select Weight",size:12.sp ,fontWeight: FontWeight.w500),
            5.height,
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ItemWeightWidget(weight: "100 gm"),
                ItemWeightWidget(weight: "200 gm",isSelected: true,),
                ItemWeightWidget(weight: "300 gm"),
                ItemWeightWidget(weight: "500 gm"),


              ],
            ),
            5.height,

            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ItemWeightWidget(weight: "1 kg"),
                ItemWeightWidget(weight: "2 kg",),
                ItemWeightWidget(weight: "3 kg"),
                ItemWeightWidget(weight: "5 kg"),


              ],
            ),
            5.height,
            const Divider(),
            5.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText(text: "Quantity",size:12.sp ,fontWeight: FontWeight.w500),
                const Spacer(),
                Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                        if(item==1){
                          return;
                        }
                        setState(() {
                          item--;
                        });
                      },
                      child: Container(
                        height: 16.h,
                        width: 16.w,
                        decoration: BoxDecoration(
                          color: appRedColor,
                          boxShadow: [
                            BoxShadow(
                              color: blackColor.withAlpha(getAlpha(0.3)),
                              spreadRadius: 2,
                              blurRadius: 7
                            )
                          ],
                          borderRadius: BorderRadius.circular(4.r)
                        ),
                        child: Center(
                          child: Icon(Icons.remove,color: whiteColor,size: 12.sp,),
                        ),
                      ),
                    ),
                    5.width,
                    MyText(text:item.toString(),size: 10.sp,fontWeight: FontWeight.w500,),
                    5.width,
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          item++;
                        });
                      },
                      child: Container(
                        height: 16.h,
                        width: 16.w,
                        decoration: BoxDecoration(
                          color: const Color(0xffFF8E8E),
                          borderRadius: BorderRadius.circular(4.r),   boxShadow: [
                          BoxShadow(
                              color: blackColor.withAlpha(getAlpha(0.3)),
                              spreadRadius: 2,
                              blurRadius: 7
                          )
                        ],
                        ),
                        child: Center(
                          child: Icon(Icons.add,color: whiteColor,size: 12.sp,),
                        ),
                      ),
                    ),
                  ],
                ),

              ],
            ),
            5.height,
            Row(
              children: [
                Flexible(
                  child: RoundButton(
                      height: 34.h,
                      borderRadius: BorderRadius.circular(5.r),
                      btnTextSize: 12.sp,
                      textFontWeight: FontWeight.w700,
                      bgColor: const Color(0xffFFB235),
                      title: "Buy Now", onTap: (){}),
                ),
                10.width,
                Flexible(
                  child: RoundButton(
                      height: 34.h,
                      borderRadius: BorderRadius.circular(5.r),
                      btnTextSize: 12.sp,
                      textFontWeight: FontWeight.w700,
                      bgColor:primaryColor,
                      title: "Add to Cart", onTap: (){}),
                ),
              ],
            )

          ],
        ),
      ),
    );
  }
}
class ItemWeightWidget extends StatelessWidget {
  final String weight;
  final bool? isSelected;
  const ItemWeightWidget({super.key, required this.weight, this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88.h,
      width: 65.w,
      decoration: BoxDecoration(
          color: whiteColor,
          border: Border.all(
              color: isSelected==true? primaryColor:transparentColor
          ),
          borderRadius: BorderRadius.circular(6.r)
      ),
      child: Column(
        children: [
          Container(
            height: 65.h,
            width: 65.w,
            decoration: BoxDecoration(

                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6.r),
                  topRight: Radius.circular(6.r),
                ),
                image: const DecorationImage(image: AssetImage(AppAssets.dummyChilliIcon),fit: BoxFit.cover)
            ),
          ),
          3.height,
          MyText(text: weight,color: textPrimaryColor.withOpacity(0.8),size: 10.sp,fontWeight: FontWeight.w500)
        ],
      ),
    );
  }
}
