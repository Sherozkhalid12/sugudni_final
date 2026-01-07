import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/repositories/products/product-repository.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/cached-network-image.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/shimmer-widgets.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/product-status.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';
import 'package:sugudeni/view/customer/products/customer-all-products-view.dart';
import 'package:sugudeni/providers/products/customer/all-customer-products.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/global-functions.dart';

import '../../currency/find-currency.dart';

class ShopNowStylishGrid extends StatelessWidget {
  const ShopNowStylishGrid({super.key});

  @override
  Widget build(BuildContext context) {
    // Removed dummy list - using real API data from ProductRepository
    return SymmetricPadding(
      child: FutureBuilder(
          future: ProductRepository.allProductsForCustomer(context),
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return const ProductGridShimmer(crossAxisCount: 2, aspectRatio: 0.75);
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
            var data=snapshot.data;
            var allProducts=data!.getAllProducts;

            final activeProducts=allProducts.where((p){
              return p.status==ProductStatus.active;
            }).toList();

        return MasonryGridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns
          ),
          mainAxisSpacing: 6.0, // Vertical spacing
          crossAxisSpacing: 3.0, // Horizontal spacing
          itemCount: activeProducts.length, // Number of items
          itemBuilder: (BuildContext context, int index) {
            final d=activeProducts[index];
            bool isBulk=d.bulk;
            String discount=calculateDiscountPercentage(d.price.toDouble(), d.priceAfterDiscount.toDouble());

            if (index == 1) {
              // Special container for index 1
              return Container(
                height: 102.h,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [
                    Color(0xffC400FF),
                    Color(0xffB400C4),
                    Color(0xffC400FF),
                  ]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child:  Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: (){
                          // Clear search before navigating
                          final productProvider = Provider.of<CustomerFetchProductProvider>(context, listen: false);
                          productProvider.clearValues();
                          productProvider.clearResources();
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const CustomerAllProductsView()));
                        },
                        child: Container(
                          height: 21.h,
                          width: 123.w,
                          margin: EdgeInsets.only(bottom: 10.h),
                          decoration: BoxDecoration(
                              border: Border.all(color: primaryColor),
                              borderRadius: BorderRadius.circular(10.r),
                              color: const Color(0xffD9D9D9)
                          ),
                          child: Center(
                            child: MyText(text: AppLocalizations.of(context)!.shopnow,color: primaryColor,size: 9.sp,fontWeight: FontWeight.w600),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
            else {
              // Default containers for other indices
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
                      Center(
                        child: Stack(
                          children: [
                            Center(
                              child: MyCachedNetworkImage(
                                  height: 130.h,
                                  width: 108.w,
                                  imageUrl:isBulk? d.imgCover:"${ApiEndpoints.productUrl}/${d.imgCover}"),
                            ),
                            SizedBox(
                              height: 130.h,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                 d.saleDiscount==0? const SizedBox():
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
                          ],
                        ),
                      ),
                      // Container(
                      //   height: 130.h,
                      //   // width: 108.w,
                      //   decoration:  BoxDecoration(
                      //       image: DecorationImage(image: NetworkImage("${ApiEndpoints.productUrl}/${d.imgCover}"),fit: BoxFit.contain)
                      //   ),
                      //   child: Column(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Row(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           Container(
                      //             height: 16.h,
                      //             width: 54.w,
                      //             decoration: BoxDecoration(
                      //                 gradient: const LinearGradient(colors: [
                      //                   Color(0xffFF9C59),
                      //                   Color(0xffFF6600)
                      //                 ]),
                      //                 borderRadius: BorderRadius.only(
                      //                   topLeft: Radius.circular(4.r),
                      //                   bottomRight: Radius.circular(4.r),
                      //                 )
                      //             ),
                      //             child: Center(
                      //               child: MyText(text: "15% OFF",color: whiteColor,fontWeight: FontWeight.w600,size: 10.sp),
                      //             ),
                      //           )
                      //         ],
                      //       ),
                      //       Row(
                      //         crossAxisAlignment: CrossAxisAlignment.end,
                      //         mainAxisAlignment: MainAxisAlignment.end,
                      //         children: [
                      //           Container(
                      //             height: 25.h,
                      //             width: 25.w,
                      //             decoration: BoxDecoration(
                      //                 color: appRedColor,
                      //                 borderRadius: BorderRadius.circular(4.sp)
                      //             ),
                      //             child: Center(
                      //               child: Image.asset(AppAssets.addIconT,scale: 3,),
                      //             ),
                      //           ),
                      //           2.width,
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // ),
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

                                //MyText(text:d.saleDiscount==0? "\$ ${d.price}":"\$ ${d.priceAfterDiscount}",size:10.sp,fontWeight: FontWeight.w600,color: appPinkColor,),
                                5.width,

                                d.saleDiscount==0? const SizedBox():
                                FindCurrency(usdAmount: d.price??85.25,color: greyColor,textDecoration: TextDecoration.lineThrough),

                                // MyText(text: "\$ ${d.price}",size:10.sp,fontWeight: FontWeight.w600,color: greyColor,textDecoration: TextDecoration.lineThrough,),
                              ],
                            ),
                            3.height,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(AppAssets.starIcon,scale: 4,),
                                1.width,
                                MyText(text: d.ratingAvg.toString(),size:10.sp,fontWeight: FontWeight.w600,color: greyColor,),
                                MyText(text: "(${d.ratingCount})",size:8.sp,fontWeight: FontWeight.w600,color: greyColor,),
                                MyText(text: " | ${d.sold} ${AppLocalizations.of(context)!.sold}",size:8.sp,fontWeight: FontWeight.w600,color: greyColor,),

                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
          },
        );
      }),
    );
  }
}