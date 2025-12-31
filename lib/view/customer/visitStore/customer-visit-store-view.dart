import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/models/products/ProductListResponse.dart';
import 'package:sugudeni/repositories/products/product-repository.dart';
import 'package:sugudeni/repositories/products/seller-product-repository.dart';
import 'package:sugudeni/repositories/user-repository.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/constants/fonts.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/shimmer-widgets.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/media-query.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/utils/product-status.dart';
import 'package:sugudeni/utils/sharePreference/save-user-token.dart';
import 'package:sugudeni/view/customer/visitStore/visit-store-appBar.dart';
import 'package:sugudeni/view/seller/messages/seller-message-detailed-screen.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/routes/routes-name.dart';
import '../../currency/find-currency.dart';
import '../home/shop-now-product-grid.dart';

class CustomerVisitStoreView extends StatelessWidget {
  const CustomerVisitStoreView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth=context.screenWidth;
    final screenHeight=context.screenHeight;
    String sellerId=ModalRoute.of(context)!.settings.arguments as String;
    return FutureBuilder(
        future: UserRepository.getSellerDataForCustomer(sellerId,context),
        builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return const ProductGridShimmer(
              crossAxisCount: 2,
              aspectRatio: 0.8,
            );
          }
          if(snapshot.hasError){
            return Center(
              child: MyText(text: snapshot.error.toString()),
            );
          }
          var data=snapshot.data;
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          forceMaterialTransparency: true,
          toolbarHeight: 180.h,
          flexibleSpace: Container(
            height: 200.h,
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color(0xffFC3B3B),
                  Color(0xff792396),
                ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter
                )
            ),
          ),
          title: VisitStoreAppBar(storeName: capitalizeFirstLetter(data!.user!.name),) ,
        ),
        body: Stack(
          children: [

            SingleChildScrollView(
              child: Column(
                spacing: 7.h,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SymmetricPadding(
                  //   child: Column(
                  //     spacing: 7.h,
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       MyText(text: "GET UPTO 60% OFF",size: 16.sp,fontWeight: FontWeight.w600),
                  //       Container(
                  //         height: 90.h,
                  //         width: double.infinity,
                  //         decoration: const BoxDecoration(
                  //             image: DecorationImage(image: AssetImage(AppAssets.visitStoreImg),fit: BoxFit.cover)
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Container(
                    color: whiteColor,
                    child: Padding(
                      padding:  EdgeInsets.symmetric(vertical: 10.h,horizontal: 15.w),
                      child: Column(
                        spacing: 7.h,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(text: AppLocalizations.of(context)!.latestaddiotions,size: 16.sp,fontWeight: FontWeight.w600),

                          FutureBuilder(
                              future: SellerProductRepository.allSellerProductsForCustomer(sellerId,context),
                              builder: (context,productSnapshot){
                                if(productSnapshot.connectionState==ConnectionState.waiting){
                                  return const ProductGridShimmer(
                                    crossAxisCount: 2,
                                    aspectRatio: 0.8,
                                  );
                                }
                                if(productSnapshot.hasError){
                                  return Center(
                                    child: MyText(text: productSnapshot.error.toString(),overflow: TextOverflow.clip,),
                                  );
                                }
                                var productData=productSnapshot.data;
                                var activeProducts=productData!.getAllProducts.where((d){
                                  return d.status==ProductStatus.active;
                                }).toList();
                                if(activeProducts.isEmpty){
                                  return const SizedBox();
                                }
                                var firstProductData=activeProducts!.first;
                                String firstDiscount=calculateDiscountPercentage(firstProductData.price.toDouble(), firstProductData.priceAfterDiscount.toDouble());

                                return Row(
                              spacing: 5.w,
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    Navigator.pushNamed(context, RoutesNames.customerProductDetailView,arguments: firstProductData);
                                  },
                                  child: Container(
                                    // height: 204.h,
                                    margin: EdgeInsets.symmetric(horizontal: 3.w,vertical: 2),
                                    width: 166.w,
                                    decoration: BoxDecoration(
                                        color: whiteColor,
                                        borderRadius: BorderRadius.circular(4.r),
                                        boxShadow: [
                                          BoxShadow(
                                              spreadRadius: 1,
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                              color: blackColor.withAlpha(getAlpha(0.3))
                                          )
                                        ]
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 140.h,
                                          width: 166.w,
                                          decoration:  BoxDecoration(
                                              image: DecorationImage(image:
                                              NetworkImage(
                                                  firstProductData.bulk==true? firstProductData.imgCover:
                                                  "${ApiEndpoints.productUrl}/${firstProductData.imgCover}"),fit: BoxFit.contain)
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                            firstProductData.saleDiscount==0? const SizedBox():     Container(
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
                                                      child: MyText(text: firstDiscount,color: whiteColor,fontWeight: FontWeight.w600,size: 10.sp),
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
                                              MyText(text: capitalizeFirstLetter(firstProductData.title),size:10.sp,fontWeight: FontWeight.w600,),
                                              MyText(text: firstProductData.size,size:9.sp,fontWeight: FontWeight.w600,color: textPrimaryColor.withOpacity(0.7),),
                                              
                                              Row(
                                                children: [
                                                  firstProductData.saleDiscount==0?FindCurrency(usdAmount: firstProductData.price??1.0):FindCurrency(usdAmount: firstProductData.priceAfterDiscount??1.0),

                                                  //  MyText(text:firstProductData.saleDiscount==0? "\$ ${firstProductData.price}":"\$ ${firstProductData.priceAfterDiscount}",size:10.sp,fontWeight: FontWeight.w600,color: appPinkColor,),
                                                  5.width,
                                                  firstProductData.saleDiscount==0? const SizedBox():
                                                  FindCurrency(usdAmount: firstProductData.price??85.25,color: greyColor,textDecoration: TextDecoration.lineThrough),

                                                 // MyText(text: "\$ ${firstProductData.price}",size:10.sp,fontWeight: FontWeight.w600,color: greyColor,textDecoration: TextDecoration.lineThrough,),
                                                  // 15.width,
                                                  // Container(
                                                  //   decoration: BoxDecoration(
                                                  //       borderRadius: BorderRadius.circular(6.r),
                                                  //       color: const Color(0xffFFB5B5)
                                                  //   ),
                                                  //   child: Padding(
                                                  //     padding:  EdgeInsets.symmetric(horizontal: 4.w,vertical: 2.h),
                                                  //     child: MyText(text: "-64%",color: const Color(0xffFF6A6A),size: 8.sp,fontWeight: FontWeight.w600,),
                                                  //   ),
                                                  // )
                                                ],
                                              ),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Image.asset(AppAssets.starIcon,scale: 4,),
                                                  1.width,
                                                  MyText(text: "${firstProductData.ratingAvg}",size:10.sp,fontWeight: FontWeight.w600,color: greyColor,),
                                                  MyText(text: "(${firstProductData.ratingCount})",size:8.sp,fontWeight: FontWeight.w600,color: greyColor,),
                                                  MyText(text: " | ${firstProductData.sold} ${AppLocalizations.of(context)!.sold}",size:8.sp,fontWeight: FontWeight.w600,color: greyColor,),

                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Column(
                                  spacing: 5.h,
                                  children: List.generate(
                                    activeProducts.length>3?3:activeProducts.length, (index) {
                                      var pData=activeProducts[index];

                                      return  LatestAuditionWidget(
                                        bulk: pData.bulk,
                                      salesDiscount: pData.saleDiscount,
                                      title:pData.title.isEmpty? "N/A":capitalizeFirstLetter(pData.title),
                                      price: pData.price,
                                      priceAfterDiscount: pData.priceAfterDiscount,
                                      imgUrl: pData.imgCover,
                                    );
                                  },),
                                )

                              ],
                            );
                          })
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(AppAssets.halfHeartLeft,scale: 3,),
                      5.width,
                      MyText(text: AppLocalizations.of(context)!.justforyou,size: 12.sp,fontWeight: FontWeight.w600),
                      5.width,

                      Image.asset(AppAssets.halfHeartRight,scale: 3,),
                    ],
                  ),
                   ShopNowProductGridTow(sellerId: sellerId),
                  10.height
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FutureBuilder(
                      future: UserRepository.getUserNameAndId(sellerId, context),
                      builder: (context,s){
                        if(s.connectionState==ConnectionState.waiting){
                          return  const SizedBox();
                        }
                        // if(snapshot.data!.message=='success'){
                        //   return  ShimmerEffects().shimmerForChats();
                        // }
                        var receiverData=s.data;
                        return    GestureDetector(
                          onTap: ()async{
                            String userId=await getUserId();
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                SellerMessageDetailView(receiverId: sellerId, receiverName: receiverData!.user.name, senderId: userId,)));
                            // Navigator.pushNamed(context, RoutesNames.customerChatWithOwnerView);
                          },
                          child: Container(
                            height: 32.h,
                            width: 81.w,
                            decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(18.r)
                                )
                            ),
                            child: Row(
                              spacing: 5.w,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 26.h,
                                  width: 26.w,
                                  decoration: BoxDecoration(
                                      image: const DecorationImage(image: AssetImage(AppAssets.floatingChatIcon),scale: 3),
                                      border: Border.all(
                                          color: whiteColor
                                      ),
                                      borderRadius: BorderRadius.circular(6.r)
                                  ),
                                ),

                                MyText(text: AppLocalizations.of(context)!.chat,color: whiteColor,size: 12.sp,fontWeight: FontWeight.w600,)
                              ],
                            ),
                          ),
                        );
                      }),


                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamedAndRemoveUntil(context, RoutesNames.customerBottomNav, (route) => false);
                    },
                    child: Container(
                        height: 32.h,
                        width: 81.w,
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(18.r)
                            )
                        ),
                        child: Center(child: MyText(text: AppLocalizations.of(context)!.home,color: whiteColor,size: 12.sp,fontWeight: FontWeight.w600,))
                    ),
                  ),

                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
class LatestAuditionWidget extends StatelessWidget {
  final String? imgUrl;
  final String? title;
  final double? price;
  final double? priceAfterDiscount;
  final double? salesDiscount;
  final bool? bulk;
  const LatestAuditionWidget({super.key, this.title, this.price, this.priceAfterDiscount, this.imgUrl,this.bulk=false, this.salesDiscount});

  @override
  Widget build(BuildContext context) {
    String discount=calculateDiscountPercentage(price!.toDouble(), priceAfterDiscount!.toDouble());

    return  Row(
      spacing: 5.w,
      children: [
        Container(
          height: 65.h,
          width: 65.w,
          decoration: BoxDecoration(
              image:  DecorationImage(image: NetworkImage(
                bulk==true? imgUrl!:
                  "${ApiEndpoints.productUrl}/$imgUrl"),fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(6.r)
          ),
        ),
        Column(
          spacing: 2.h,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                width: 80.w,
                child: MyText(
                  overflow: TextOverflow.ellipsis,
                  maxLine: 2,
                  text:title?? "Red Chili A Fiery Spice that Adds ",
                  size: 10.sp,fontWeight: FontWeight.w600,)),
            salesDiscount==0? FindCurrency(usdAmount: price??1.0):FindCurrency(usdAmount: priceAfterDiscount??1.0),

           // MyText(text: "\$ ${salesDiscount==0? price:priceAfterDiscount??76.25}",size:10.sp,fontWeight: FontWeight.w600,color: appPinkColor,),
            5.width,
            Row(
              spacing: 10.w,
              children: [
           salesDiscount==0? const SizedBox():
           FindCurrency(usdAmount: price??85.25,color: greyColor,textDecoration: TextDecoration.lineThrough),

               // MyText(text: "\$ ${price??85.25}",size:10.sp,fontWeight: FontWeight.w600,color: greyColor,textDecoration: TextDecoration.lineThrough,),

                salesDiscount==0? const SizedBox():    Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.r),
                      color: const Color(0xffFFB5B5)
                  ),
                  child: Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 4.w,vertical: 2.h),
                    child: MyText(text: discount,color: const Color(0xffFF6A6A),size: 8.sp,fontWeight: FontWeight.w600,),
                  ),
                )
              ],
            ),
            15.width,

          ],
        )
      ],
    );
  }
}
