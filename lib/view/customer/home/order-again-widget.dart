
import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/models/products/ProductListResponse.dart';

import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/media-query.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';
import 'package:sugudeni/view/currency/find-currency.dart';

import '../../../models/products/SimpleProductModel.dart';
import '../../../utils/constants/screen-sizes.dart';
import '../../../utils/global-functions.dart';


class OrderAgain extends StatelessWidget {
  final bool? isShowTitle;
  final bool? isBulk;
  final String? title;
  final String? size;
  final double? price;
  final double? priceAfterDiscount;
  final String? image;
  final String? ratingCount;
  final String? ratingAvg;
  final String? sold;
  final Product product;
  final VoidCallback? onPressed;
  const OrderAgain({super.key, this.isShowTitle=true, this.title, this.size, this.price, this.priceAfterDiscount, this.image, this.ratingCount, this.ratingAvg, this.sold, required this.product, this.onPressed, this.isBulk=false});

  @override
  Widget build(BuildContext context) {
    String discount=calculateDiscountPercentage(price!.toDouble(), priceAfterDiscount!.toDouble());

    final screenWidth=context.screenWidth;
    final screenHeight=context.screenHeight;
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Column(
        children: [
        isShowTitle==true?
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyText(text: "Order Again",size: 14.sp,fontWeight: FontWeight.w700),
              Container(
                height: 16.h,
                width: 16.w,
                decoration: BoxDecoration(
                    color: whiteColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          spreadRadius: 2,
                          blurRadius: 6,
                          color: blackColor.withOpacity(0.2)
                      )
                    ]
                ),
                child: Center(
                  child:Icon(Icons.arrow_forward_ios_outlined,size: 12.sp,),
                ),
              )
            ],
          ):const SizedBox(),
          10.height,
          GestureDetector(
            onTap:onPressed?? (){
              Navigator.pushNamed(context, RoutesNames.customerProductDetailView,arguments: product);
            },
            child: Container(
              // height: 204.h,
              margin: EdgeInsets.symmetric(horizontal: 3.w,vertical: 2),
              width: 108.w,
              decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(4.r),
                  boxShadow: [
                    // BoxShadow(
                    //     spreadRadius: 2,
                    //     blurRadius: 6,
                    //     offset: const Offset(0, 4),
                    //     color: blackColor.withOpacity(0.2)
                    // )
                  ]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 130.h,
                    width: 108.w,
                    decoration:  BoxDecoration(
                        image: DecorationImage(image: NetworkImage(

                           isBulk==true? image!: "${ApiEndpoints.productUrl}/$image"),fit: BoxFit.contain)

                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                  product.saleDiscount==0? const SizedBox():          Container(
                              height: 16.h,
                              width: 54.w,
                              decoration: BoxDecoration(
                                  gradient: const LinearGradient(colors: [
                                    Color(0xffFF9C59),
                                    Color(0xffFF6600)
                                  ]),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4.r),
                                    bottomRight: Radius.circular(4.r),
                                  )
                              ),
                              child: Center(
                                child: MyText(text: discount,color: whiteColor,fontWeight: FontWeight.w600,size: 10.sp),
                              ),
                            )
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: 25.h,
                              width: 25.w,
                              decoration: BoxDecoration(
                                  color: appRedColor,
                                  borderRadius: BorderRadius.circular(4.sp)
                              ),
                              child: Center(
                                child: Image.asset(AppAssets.addIconT,scale: 3,),
                              ),
                            ),
                            2.width,
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 5.w,vertical: 5.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(text:title?? "Shampoo",size:10.sp,fontWeight: FontWeight.w600,),
                        MyText(text:size?? "250ml",size:9.sp,fontWeight: FontWeight.w600,color: textPrimaryColor.withOpacity(0.7),),
                        Row(
                          children: [
                            product.saleDiscount==0?FindCurrency(usdAmount: price??1.0):FindCurrency(usdAmount: priceAfterDiscount??1.0),
                           // MyText(text:  "\$ ${product.saleDiscount==0?price:priceAfterDiscount??76.25}",size:10.sp,fontWeight: FontWeight.w600,color: appPinkColor,),
                            5.width,
                            product.saleDiscount==0? const SizedBox():
                            FindCurrency(usdAmount: price??85.25,color: greyColor,textDecoration: TextDecoration.lineThrough),
                            //MyText(text: "\$ ${price??85.25}",size:10.sp,fontWeight: FontWeight.w600,color: greyColor,textDecoration: TextDecoration.lineThrough,),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(AppAssets.starIcon,scale: 4,),
                            1.width,
                            MyText(text: "${ratingAvg?? 100}",size:10.sp,fontWeight: FontWeight.w600,color: greyColor,),
                            MyText(text: "(${ratingCount?? 256})",size:8.sp,fontWeight: FontWeight.w600,color: greyColor,),
                            MyText(text: " | ${sold??1.2} sold",size:8.sp,fontWeight: FontWeight.w600,color: greyColor,),

                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
