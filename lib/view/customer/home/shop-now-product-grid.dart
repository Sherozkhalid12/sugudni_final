import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sugudeni/api/api-endpoints.dart';

import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/shimmer-widgets.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/utils/product-status.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';

import '../../../repositories/products/seller-product-repository.dart';
import '../../currency/find-currency.dart';
class ShopNowProductGrid extends StatelessWidget {
  final int? crossAccess;
  final double? ratio;
  const ShopNowProductGrid({super.key, this.crossAccess, this.ratio});

  @override
  Widget build(BuildContext context) {
    // NOTE: This widget uses dummy data and needs API integration
    // TODO: Replace with API call to fetch products
    // For now, returning empty to avoid showing dummy data
    return const SizedBox.shrink();
    
    /* REMOVED DUMMY DATA - Needs API integration
    final List<Map<String,dynamic>> list=[...];
    return SymmetricPadding(
      child: GridView.builder(
        shrinkWrap: true,

        physics: const NeverScrollableScrollPhysics(),
        gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:crossAccess?? 2, // Number of columns
          crossAxisSpacing: 2, // Space between columns
          mainAxisSpacing: 8, // Space between rows
          childAspectRatio:ratio?? 0.8, // Adjusts the size ratio of grid items
        ),
        itemCount: list.length, // Number of items
        itemBuilder: (context, index) {
          final d=list[index];
          return Container(
            // height: 204.h,
            margin: EdgeInsets.symmetric(horizontal: 3.w,vertical: 2),
            width: 108.w,
            decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(4.r),
                boxShadow: [
                  BoxShadow(
                      spreadRadius: 2,
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                      color: blackColor.withOpacity(0.2)
                  )
                ]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 130.h,
                  // width: 108.w,
                  decoration:  BoxDecoration(
                      image: DecorationImage(image: AssetImage(d['pic']),fit: BoxFit.contain)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
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
                              child: MyText(text: "15% OFF",color: whiteColor,fontWeight: FontWeight.w600,size: 10.sp),
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
                      MyText(text: d['title'],size:10.sp,fontWeight: FontWeight.w600,),
                      MyText(text: "250ml",size:9.sp,fontWeight: FontWeight.w600,color: textPrimaryColor.withOpacity(0.7),),
                      Row(
                        children: [
                          MyText(text: "\$ 76.25",size:10.sp,fontWeight: FontWeight.w600,color: appPinkColor,),
                          5.width,
                          MyText(text: "\$ 85.25",size:10.sp,fontWeight: FontWeight.w600,color: greyColor,textDecoration: TextDecoration.lineThrough,),
                        ],
                      ),
                      3.height,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(AppAssets.starIcon,scale: 4,),
                          1.width,
                          MyText(text: "4.7",size:10.sp,fontWeight: FontWeight.w600,color: greyColor,),
                          MyText(text: "(256)",size:8.sp,fontWeight: FontWeight.w600,color: greyColor,),
                          MyText(text: " | 1.2k sold",size:8.sp,fontWeight: FontWeight.w600,color: greyColor,),

                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
    */
  }
}
class ShopNowProductGridTow extends StatelessWidget {
  final int? crossAccess;
  final double? ratio;
  final String sellerId;
  const ShopNowProductGridTow({super.key, this.crossAccess, this.ratio,required this.sellerId});

  @override
  Widget build(BuildContext context) {
    // Removed dummy list - using real API data from SellerProductRepository
    return SymmetricPadding(
      child: FutureBuilder(
          future: SellerProductRepository.allSellerProductsForCustomer(sellerId!,context),
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return const ProductGridShimmer(crossAxisCount: 2, aspectRatio: 0.8);
            }
            if(snapshot.hasError){
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(20.sp),
                  child: MyText(
                    text: snapshot.error.toString(),
                    overflow: TextOverflow.clip,
                    color: textSecondaryColor,
                  ),
                ),
              );
            }
            var productData=snapshot.data;
            var activeProducts=productData!.getAllProducts.where((d){
              return d.status==ProductStatus.active;
            }).toList();
            if(activeProducts.isEmpty){
              return const SizedBox();
            }
            return GridView.builder(
              shrinkWrap: true,

              physics: const NeverScrollableScrollPhysics(),
              gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:crossAccess?? 2, // Number of columns
                crossAxisSpacing: 2, // Space between columns
                mainAxisSpacing: 8, // Space between rows
                childAspectRatio:ratio?? 0.8, // Adjusts the size ratio of grid items
              ),
              itemCount: activeProducts.length, // Number of items
              itemBuilder: (context, index) {
                final d=activeProducts[index];
                String discount=calculateDiscountPercentage(d.price.toDouble(), d.priceAfterDiscount.toDouble());

                return GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(context, RoutesNames.customerProductDetailView,arguments: d);
                  },
                  child: Container(
                    // height: 204.h,
                    margin: EdgeInsets.symmetric(horizontal: 3.w,vertical: 2),
                    width: 108.w,
                    decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(4.r),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 6,
                              offset: const Offset(0, 4),
                              color: blackColor.withOpacity(0.2)
                          )
                        ]
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 130.h,
                          // width: 108.w,
                          decoration:  BoxDecoration(
                              image: DecorationImage(image: NetworkImage(
                             d.bulk==true? d.imgCover:    "${ApiEndpoints.productUrl}/${d.imgCover}"
                              ),fit: BoxFit.contain)
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                           d.saleDiscount==0? const SizedBox():       Container(
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
                              MyText(text: capitalizeFirstLetter(d.title),size:10.sp,fontWeight: FontWeight.w600,),
                              MyText(text: d.size,size:9.sp,fontWeight: FontWeight.w600,color: textPrimaryColor.withOpacity(0.7),),
                              Row(
                                children: [
                                  d.saleDiscount==0? FindCurrency(usdAmount: d.price??1.0):FindCurrency(usdAmount: d.priceAfterDiscount??1.0),

                                 // MyText(text:d.saleDiscount==0? "\$ ${d.price}":"\$ ${d.priceAfterDiscount}",size:10.sp,fontWeight: FontWeight.w600,color: appPinkColor,),
                                  5.width,
                                  d.saleDiscount==0? const SizedBox():
                                  FindCurrency(usdAmount: d.price??85.25,color: greyColor,textDecoration: TextDecoration.lineThrough),

                                //  MyText(text: "\$ ${d.price}",size:10.sp,fontWeight: FontWeight.w600,color: greyColor,textDecoration: TextDecoration.lineThrough,),
                                ],
                              ),
                              3.height,
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(AppAssets.starIcon,scale: 4,),
                                  1.width,
                                  MyText(text: " ${d.ratingAvg}",size:10.sp,fontWeight: FontWeight.w600,color: greyColor,),
                                  MyText(text: "( ${d.ratingCount})",size:8.sp,fontWeight: FontWeight.w600,color: greyColor,),
                                  MyText(text: " | ${d.sold} sold",size:8.sp,fontWeight: FontWeight.w600,color: greyColor,),

                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
