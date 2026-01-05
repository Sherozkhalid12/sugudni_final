import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/models/cart/AddToCartModel.dart';
import 'package:sugudeni/providers/carts/cart-provider.dart';
import 'package:sugudeni/providers/wishlist-provider.dart';
import 'package:sugudeni/repositories/carts/cart-repository.dart';
import 'package:sugudeni/repositories/review/review-repositoy.dart';
import 'package:sugudeni/repositories/user-repository.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/utils/customWidgets/cached-network-image.dart';
import 'package:sugudeni/utils/customWidgets/round-button.dart';
import 'package:sugudeni/utils/customWidgets/shimmer-widgets.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';
import 'package:sugudeni/utils/sharePreference/save-user-token.dart';
import 'package:sugudeni/view/currency/find-currency.dart';
import 'package:sugudeni/view/customer/cart/customer-cart-view.dart';
import 'package:sugudeni/view/customer/home/product-grid-for-product-detail.dart';
import 'package:sugudeni/view/customer/wishlist/customer-all-wishlist-view.dart';
import 'package:sugudeni/view/seller/messages/seller-message-detailed-screen.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/products/SimpleProductModel.dart';
import '../../../utils/constants/app-assets.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/customWidgets/my-text.dart';
import 'customer-all-products-view.dart';

class CustomerProductDetailPage extends StatefulWidget {
  const CustomerProductDetailPage({super.key});

  @override
  State<CustomerProductDetailPage> createState() => _CustomerProductDetailPageState();
}

class _CustomerProductDetailPageState extends State<CustomerProductDetailPage> {
  int initialPage=1;
  final PageController pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    // Load wishlist data when the view initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final wishlistProvider = Provider.of<WishlistProvider>(context, listen: false);
      wishlistProvider.getWishlistProducts(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    Product product=ModalRoute.of(context)!.settings.arguments as Product;
    customPrint("Product: $product");
    String discountPrice= calculateDiscountPercentage(product.price.toDouble(), product.priceAfterDiscount.toDouble());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        forceMaterialTransparency: true,
        flexibleSpace: Container(
          color: whiteColor,
        ),
        title: Row(
          children: [
            IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: const Icon(Icons.arrow_back_ios)),
            Flexible(
              child: GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const CustomerAllProductsView(isComeFromSearch: true,)));
                },
                child: TextFormField(
                  enabled: false,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 10.sp,
                      color: const Color(0xff545454)
                  ),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search,color: Color(0xff545454),),
                    hintText: AppLocalizations.of(context)!.searchinsugudeni,
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 10.sp,
                        color: const Color(0xff545454)
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: const BorderSide(
                        color: primaryColor,

                      ),
                    ),
                    enabledBorder:OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: const BorderSide(
                        color: primaryColor,

                      ),
                    ) ,
                    focusedBorder:OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: const BorderSide(
                        color: primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
           // 8.width,
            //Image.asset(AppAssets.shareIcon,scale: 2,width: 20.w,height: 20.h,),
            8.width,
            Consumer<CartProvider>(
              builder: (context, cartProvider, child) {
                final itemCount = cartProvider.getTotalCartItemsCount();
                return Stack(
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomerCartView()));
                        },
                        child: Image.asset(AppAssets.cartBottomIcon, scale: 1, color: primaryColor, width: 30.w, height: 30.h)),
                    if (itemCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          height: 16.h,
                          width: 16.w,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: MyText(
                              text: itemCount > 99 ? '99+' : itemCount.toString(),
                              color: whiteColor,
                              size: 8.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            8.width,
           GestureDetector(
               onTap: ()async{
                 String userId=await getUserId();
                 if(userId.isEmpty){
                   showSnackbar(context, AppLocalizations.of(context)!.pleaselogintouseacount,color: redColor);
                   return;
                 }
                 Navigator.push(context, MaterialPageRoute(builder: (context)=>const CustomerAllWishListView()));
               },
               child: const Icon(Icons.favorite,color: primaryColor,)),
            // Image.asset(AppAssets.gridIcon,scale: 2,width: 20.w,height: 20.h,),
          ],
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                5.height,
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      height: 319.h,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          color: primaryColor,
                      ),
                      child: PageView.builder(
                        onPageChanged: (i){
                          setState(() {
                            initialPage=i+1;
                          });
                        },
                        controller: pageController,
                        itemCount:product.images.length,
                        itemBuilder: (context, index) {
                          return MyCachedNetworkImage(
                              imageUrl:product.bulk? product.images[index]:"${ApiEndpoints.productUrl}/${product.images[index]}",fit: BoxFit.contain,);
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xff515151),
                          borderRadius: BorderRadius.circular(8.r)
                        ),
                        child: Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 10.w,vertical: 2.h),
                          child: MyText(text: "$initialPage/${product.images.length}",color: whiteColor,size: 8.sp,fontWeight: FontWeight.w500),
                        ),
                      ),
                    )




                  ],
                ),
                // Container(
                //   height: 37.h,
                //     width: double.infinity,
                //     decoration: const BoxDecoration(
                //       image: DecorationImage(image: AssetImage(AppAssets.flashSaleOrageBg),fit: BoxFit.cover)
                //     ),
                //     child: Padding(
                //       padding:  EdgeInsets.symmetric(horizontal: 10.w),
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         crossAxisAlignment: CrossAxisAlignment.center,
                //         children: [
                //           Image.asset(AppAssets.flashIcon,color: whiteColor,scale: 2.3,),
                //           Column(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             crossAxisAlignment: CrossAxisAlignment.end,
                //             children: [
                //               MyText(text: "End In 01 : 04:39",size: 8.sp,color: whiteColor,fontWeight: FontWeight.w600),
                //               MyText(text: "28 sold",size: 8.sp,color: whiteColor,fontWeight: FontWeight.w600),
                //             ],
                //           )
                //         ],
                //       ),
                //     )),
                10.height,
               Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   SymmetricPadding(
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Row(
                           children: [
                             product.saleDiscount==0?
                                 FindCurrency(
                                     usdAmount: product.price,size: 16.sp,fontWeight: FontWeight.w600,color: primaryColor)
                                 :FindCurrency(usdAmount: product.priceAfterDiscount,size: 16.sp,fontWeight: FontWeight.w600,color: primaryColor),
                             //MyText(text: "\$ ${ product.saleDiscount==0?product.price:product.priceAfterDiscount}",size: 16.sp,fontWeight: FontWeight.w600,color: primaryColor,),
                             10.width,
                          product.saleDiscount!=0?
                              FindCurrency(usdAmount: product.price,size: 10.sp,fontWeight: FontWeight.w500,color: greyColor,textDecoration: TextDecoration.lineThrough,)
                          //MyText(text: "\$ ${product.price}",size: 10.sp,fontWeight: FontWeight.w500,color: greyColor,textDecoration: TextDecoration.lineThrough,)
                              :const SizedBox(),
                             10.width,
                             product.saleDiscount!=0?     Container(
                               decoration: BoxDecoration(
                                   color: const Color(0xffFFB5B5),
                                   borderRadius: BorderRadius.circular(2.r)
                               ),
                               child: Center(
                                 child: Padding(
                                   padding:  EdgeInsets.symmetric(horizontal: 5.w,vertical: 3.h),
                                   child: MyText(text:discountPrice,color: primaryColor,size: 8.sp,fontWeight: FontWeight.w500),
                                 ),
                               ),
                             ):const SizedBox()
                           ],
                         ),
                         10.height,
                         MyText(
                           overflow: TextOverflow.clip,
                           text: capitalizeFirstLetter(product.title),
                           size: 12.sp,
                           fontWeight: FontWeight.w600,
                         ),
                         3.height,
                         // Row(
                         //   children: [
                         //     MyText(
                         //       overflow: TextOverflow.clip,
                         //       text: "250gm",
                         //       color: textPrimaryColor.withOpacity(0.7),
                         //       size: 12.sp,
                         //       fontWeight: FontWeight.w600,
                         //     ),
                         //     20.width,
                         //     GestureDetector(
                         //         onTap: (){
                         //           showModalBottomSheet(context: context, builder: (context){
                         //             return const SelectItemWeightBottomSheet();
                         //           });
                         //         },
                         //         child: Icon(Icons.keyboard_arrow_down_outlined,color: textPrimaryColor.withOpacity(0.7),))
                         //   ],
                         // ),
                         // 3.height,
                         Row(
                           crossAxisAlignment: CrossAxisAlignment.center,
                           mainAxisAlignment: MainAxisAlignment.start,
                           children: [
                             Image.asset(AppAssets.starIcon,scale: 2,),
                             1.width,
                             MyText(text: product.ratingAvg.toString(),size:12.sp,fontWeight: FontWeight.w600,color: greyColor,),
                             MyText(text: " (${product.ratingCount})",size:10.sp,fontWeight: FontWeight.w600,color: greyColor,),
                             MyText(text: " | ${product.sold} ${AppLocalizations.of(context)!.sold}",size:10.sp,fontWeight: FontWeight.w600,color: greyColor,),
                             const Spacer(),


                             Consumer<WishlistProvider>(
                               builder: (context, wishlistProvider, child) {
                                 bool isInWishlist = wishlistProvider.isProductInWishlist(product.id);
                                 return GestureDetector(
                                   onTap: () async {
                                     String userId = await getUserId();
                                     if (userId.isEmpty) {
                                       showSnackbar(context, AppLocalizations.of(context)!.pleaselogintouseacount, color: redColor);
                                       return;
                                     }

                                     bool success = await wishlistProvider.toggleWishlist(product.id, context);
                                     if (success) {
                                       String message = isInWishlist
                                           ? "Product removed from wishlist"
                                           : AppLocalizations.of(context)!.producthasbeenaddedtowishlish;
                                       showSnackbar(context, message, color: greenColor);
                                     }
                                   },
                                   child: Icon(
                                     isInWishlist ? Icons.favorite : Icons.favorite_border,
                                     color: isInWishlist ? Colors.red : primaryColor,
                                     size: 24.sp,
                                   ),
                                 );
                               },
                             ),
                             10.width,
                            // Image.asset(AppAssets.productShareIcon,scale: 3),


                           ],
                         ),
                       ],
                     ),
                   ),
                   // 10.height,
                   // Container(
                   //   color: whiteColor,
                   //   child: Padding(
                   //     padding:  EdgeInsets.symmetric(horizontal: 15.w,vertical: 8.h),
                   //     child: Row(
                   //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   //       children: [
                   //         Column(
                   //           crossAxisAlignment: CrossAxisAlignment.start,
                   //           children: [
                   //             Row(
                   //               children: [
                   //                 Image.asset(AppAssets.warrantyIcon,scale: 2.5,),
                   //                 10.width,
                   //                 MyText(text: "14 days easy return policy",size: 10.sp,)
                   //               ],
                   //             ),
                   //             10.height,
                   //             Row(
                   //               children: [
                   //                 Image.asset(AppAssets.productDeliveryIcon,scale: 2.5,),
                   //                 10.width,
                   //                 MyText(text: "Product delivery 31 Dec - 4 Jan",size: 10.sp,)
                   //               ],
                   //             ),
                   //             10.height,
                   //             Row(
                   //               children: [
                   //                 Image.asset(AppAssets.productGridIcon,scale: 2.5,),
                   //                 10.width,
                   //                 Row(
                   //                   children: List.generate(5, (index) =>
                   //                       Container(
                   //                     height: 17.h,
                   //                     width: 21.w,
                   //                     margin: EdgeInsets.only(right: 5.w),
                   //                     decoration: BoxDecoration(
                   //                         borderRadius: BorderRadius.circular(2.r),
                   //                         image: const DecorationImage(image: AssetImage(AppAssets.dummyChilliIcon),fit: BoxFit.cover)
                   //                     ),
                   //                   ),),
                   //                 )
                   //               ],
                   //             ),
                   //
                   //           ],
                   //         ),
                   //         Column(
                   //           children: [
                   //             MyText(text: "\$ 15.00",size: 10.sp,fontWeight: FontWeight.w600),
                   //             MyText(text: "To new Shalimar",size: 8.sp),
                   //             MyText(text: "250gm",size: 11.sp,fontWeight: FontWeight.w600,color: textPrimaryColor.withOpacity(0.7),),
                   //           ],
                   //         )
                   //       ],
                   //     ),
                   //   ),
                   // ),
                   10.height,
                   SymmetricPadding(
                     child: GestureDetector(
                       onTap: (){
                        // Navigator.pushNamed(context, RoutesNames.customerProductReviewView);
                       },
                       child: Row(
                         children: [
                           MyText(text: AppLocalizations.of(context)!.ratingsandreviews,size: 12.sp,
                           fontWeight: FontWeight.w600,),
                           MyText(text: " (${product.ratingCount})",size: 10.sp,
                           fontWeight: FontWeight.w600,
                           color: textPrimaryColor.withOpacity(0.7),
                           ),
                           const Spacer(),
                           MyText(text: "${product.ratingAvg}",size: 12.sp,
                             fontWeight: FontWeight.w600,),
                           5.width,
                           Row(
                             children: List.generate(5, (index) => Image.asset(AppAssets.starIcon,scale: 3,),),
                           )
                         ],
                       ),
                     ),
                   ),
                   10.height,
                   FutureBuilder(
                       future: ReviewRepository.getReviewOfSingleProduct(product.id, context),
                       builder: (context,ratingSnapshot){
                         if(ratingSnapshot.connectionState==ConnectionState.waiting){
                           return Column(
                             children: List.generate(3, (index) => const ReviewItemShimmer()),
                           );
                         }
                         if(ratingSnapshot.hasError){
                           return Center(
                             child: Padding(
                               padding: EdgeInsets.all(20.sp),
                               child: MyText(
                                 text: ratingSnapshot.error.toString()=='Token is empty'?'':ratingSnapshot.error.toString(),
                                 color: textSecondaryColor,
                               ),
                             ),
                           );
                         }
                         var data=ratingSnapshot.data;
                         if (data == null || data.getAllReviews.isEmpty) {
                           return Padding(
                             padding: EdgeInsets.all(20.sp),
                             child: Center(
                               child: MyText(
                                 text: "No reviews yet",
                                 color: textSecondaryColor,
                                 size: 12.sp,
                               ),
                             ),
                           );
                         }
                     return ListView.builder(
                       physics: const NeverScrollableScrollPhysics(),
                         shrinkWrap: true,
                         itemCount: data!.getAllReviews.length,
                         itemBuilder: (context,index){
                         var ratingData=data.getAllReviews[index];
                       return Container(
                         color: whiteColor,
                         margin: EdgeInsets.only(bottom: 10.h),
                         child: Padding(
                           padding:  EdgeInsets.symmetric(horizontal: 15.w,vertical: 5.h),
                           child: Row(
                             children: [
                               Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   SizedBox(
                                     width: 230.w,
                                     child: MyText(
                                         overflow: TextOverflow.clip,
                                         size: 8.sp,
                                         text: ratingData.text),
                                   ),
                                   10.height,
                                   Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       Row(
                                         children: List.generate(ratingData.rate, (index) => Image.asset(AppAssets.starIcon,scale: 3,),),
                                       ),
                                       10.width,
                                       MyText(text: capitalizeFirstLetter(ratingData.userId.name),size: 8.sp)
                                     ],
                                   )
                                 ],
                               ),
                               // SizedBox(
                               //   height: 65.h,
                               //   width: 100.w,
                               //   child: ListView.builder(
                               //       shrinkWrap: true,
                               //       itemCount: 3,
                               //       scrollDirection: Axis.horizontal,
                               //       itemBuilder: (context,index){
                               //         return Container(
                               //           height: 65.h,
                               //           width: 65.w,
                               //           margin: EdgeInsets.only(right: 5.w),
                               //           decoration: BoxDecoration(
                               //               image: const DecorationImage(image: AssetImage(AppAssets.dummyChilliIcon),fit: BoxFit.cover),
                               //               borderRadius: BorderRadius.circular(6.r)
                               //           ),
                               //         );
                               //       }),
                               // )
                             ],
                           ),
                         ),
                       );
                     });
                   }),
                   10.height,
                   // Container(
                   //   color: whiteColor,
                   //   child: Padding(
                   //     padding:  EdgeInsets.symmetric(horizontal: 15.w,vertical: 5.h),
                   //     child: Column(
                   //       children: [
                   //         Row(
                   //           children: [
                   //             MyText(text: "Questions about this product",size: 12.sp,
                   //               fontWeight: FontWeight.w600,),
                   //             MyText(text: " (1259)",size: 10.sp,
                   //               fontWeight: FontWeight.w600,
                   //               color: textPrimaryColor.withOpacity(0.7),
                   //             ),
                   //             const Spacer(),
                   //             GestureDetector(
                   //               onTap: (){
                   //                 Navigator.pushNamed(context, RoutesNames.customerProductQuestionView);
                   //               },
                   //               child: MyText(text: " View all",size: 10.sp,
                   //                 fontWeight: FontWeight.w600,
                   //                 color: textPrimaryColor.withOpacity(0.7),
                   //               ),
                   //             ),
                   //             3.width,
                   //             Icon(Icons.arrow_forward_ios_outlined,size: 12.sp, color: textPrimaryColor.withOpacity(0.7))
                   //           ],
                   //         ),
                   //         8.height,
                   //         Row(
                   //           crossAxisAlignment: CrossAxisAlignment.start,
                   //           children: [
                   //             Container(
                   //               height: 12.h,
                   //               width: 12.w,
                   //               decoration: const BoxDecoration(
                   //                 color: primaryColor,
                   //                 shape: BoxShape.circle
                   //               ),
                   //               child: Center(
                   //                 child: Icon(Icons.question_mark,color: whiteColor,size: 10.sp,),
                   //               ),
                   //             ),
                   //             5.width,
                   //             MyText(text: "When i will get my order ? and please do\nlet me know about its expiry?",size: 8.sp)
                   //           ],
                   //         ),
                   //         10.height,
                   //         GestureDetector(
                   //           onTap: (){
                   //             Navigator.pushNamed(context, RoutesNames.customerProductQuestionView);
                   //           },
                   //           child: Row(
                   //             mainAxisAlignment: MainAxisAlignment.center,
                   //             children: [
                   //               Image.asset(AppAssets.askQuestionIcon,scale: 3),
                   //               5.width,
                   //               MyText(text: "Ask Questions",size: 8.sp),
                   //               5.width,
                   //               Icon(Icons.arrow_forward_ios_outlined,size: 12.sp, color: textPrimaryColor.withOpacity(0.7))
                   //
                   //
                   //             ],
                   //           ),
                   //         )
                   //       ],
                   //     ),
                   //   ),
                   // ),
                   // 10.height,
                   // Container(
                   //   color: whiteColor,
                   //   child: Padding(
                   //     padding:  EdgeInsets.symmetric(horizontal: 15.w,vertical: 5.h),
                   //     child: Column(
                   //       children: [
                   //         Row(
                   //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   //           children: [
                   //             Container(
                   //               height: 26.h,
                   //               width: 26.w,
                   //               decoration: BoxDecoration(
                   //                   borderRadius: BorderRadius.circular(6.r),
                   //                   image: const DecorationImage(image: AssetImage(AppAssets.shopHomePageIcon),scale: 3),
                   //                   border: Border.all(color: primaryColor)
                   //               ),
                   //             ),
                   //             15.width,
                   //             MyText(text: "AMY Online Shopping Store",size: 10.sp,fontWeight: FontWeight.w600,),
                   //             const Spacer(),
                   //             GestureDetector(
                   //               onTap: (){
                   //                 Navigator.pushNamed(context, RoutesNames.customerVisitStoreView);
                   //               },
                   //               child: Container(
                   //                 decoration: BoxDecoration(
                   //                   color: primaryColor,
                   //                   borderRadius: BorderRadius.circular(5.r)
                   //                 ),
                   //                 child: Padding(
                   //                   padding:  EdgeInsets.symmetric(horizontal: 10.w,vertical: 5.h),
                   //                   child: Center(
                   //                     child: MyText(text: "Visit Store",color: whiteColor,size: 10.sp,fontWeight: FontWeight.w500),
                   //                   ),
                   //                 ),
                   //               ),
                   //             )
                   //           ],
                   //         ),
                   //         10.height,
                   //         Container(
                   //           decoration: BoxDecoration(
                   //             color: bgColor,
                   //             borderRadius: BorderRadius.circular(6.r)
                   //           ),
                   //           child: Padding(
                   //             padding:  EdgeInsets.symmetric(horizontal: 15.w,vertical: 5.h),
                   //             child: Row(
                   //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   //               children: [
                   //                 Column(
                   //                   crossAxisAlignment: CrossAxisAlignment.start,
                   //                   children: [
                   //                     Row(
                   //                       children: [
                   //                         MyText(text: "83%",size: 10.sp,color: textPrimaryColor.withOpacity(0.8)),
                   //                         3.width,
                   //                         MyText(text: "Medium",size: 8.sp,color: textPrimaryColor.withOpacity(0.8)),
                   //
                   //                       ],
                   //                     ),
                   //                     MyText(text: "Positive Seller",size: 10.sp,color: textPrimaryColor.withOpacity(0.8)),
                   //
                   //                   ],
                   //                 ),
                   //                 Container(
                   //                   height: 25.h,
                   //                   width: 2.w,
                   //                   color: const Color(0xffCBCBCB),
                   //                 ),
                   //                 Column(
                   //                   crossAxisAlignment: CrossAxisAlignment.start,
                   //                   children: [
                   //                     Row(
                   //                       children: [
                   //                         MyText(text: "90%",size: 10.sp,color: textPrimaryColor.withOpacity(0.8)),
                   //                         3.width,
                   //                         MyText(text: "High",size: 8.sp,color: const Color(0xff89D800)),
                   //
                   //                       ],
                   //                     ),
                   //                     MyText(text: "Ship on Time",size: 10.sp,color: textPrimaryColor.withOpacity(0.8)),
                   //
                   //                   ],
                   //                 ),
                   //                 Container(
                   //                   height: 25.h,
                   //                   width: 2.w,
                   //                   color: const Color(0xffCBCBCB),
                   //                 ),
                   //                 Column(
                   //                   crossAxisAlignment: CrossAxisAlignment.start,
                   //                   children: [
                   //                     Row(
                   //                       children: [
                   //                         MyText(text: "83%",size: 10.sp,color: textPrimaryColor.withOpacity(0.8)),
                   //                         3.width,
                   //                         MyText(text: "High",size: 8.sp,color: const Color(0xff89D800)),
                   //
                   //                       ],
                   //                     ),
                   //                     MyText(text: "Chat Response",size: 10.sp,color: textPrimaryColor.withOpacity(0.8)),
                   //
                   //                   ],
                   //                 ),
                   //
                   //               ],
                   //             ),
                   //           ),
                   //         )
                   //       ],
                   //     ),
                   //   ),
                   // ),
                   // 10.height,
                   // SymmetricPadding(child: MyText(text: "More from Store",size:12.sp,fontWeight: FontWeight.w500,)),
                   //  FutureBuilder
                   //    (future: ProductRepository.allProductsForCustomer(context), builder: (context,snapshot){
                   //      if(snapshot.connectionState==ConnectionState.waiting){
                   //        return const Center(
                   //          child: CircularProgressIndicator(),
                   //        );
                   //      }
                   //
                   //      var data=snapshot.data!.getAllProducts;
                   //      var sellerProducts=data.where((d){
                   //        return d.sellerId==product.sellerId && d.status==ProductStatus.active;
                   //      }).toList();
                   //    return SizedBox(
                   //      height: 220.h,
                   //      child: ListView.builder(
                   //          scrollDirection: Axis.horizontal,
                   //          itemCount: sellerProducts.length,
                   //          itemBuilder: (context,index){
                   //            var sellerProductsData=sellerProducts[index];
                   //            bool isBulk=sellerProductsData.bulk;
                   //        return OrderAgain(
                   //          isShowTitle: false,
                   //          isBulk: isBulk,
                   //          image: sellerProductsData.imgCover,
                   //          title: sellerProductsData.title,
                   //          size: sellerProductsData.size,
                   //          price: sellerProductsData.price,
                   //          priceAfterDiscount: sellerProductsData.priceAfterDiscount,
                   //          ratingAvg: sellerProductsData.ratingAvg.toString(),
                   //          ratingCount: sellerProductsData.ratingCount.toString(),
                   //          sold: sellerProductsData.sold.toString(),
                   //          product: sellerProductsData,
                   //        );
                   //      }),
                   //    );
                   //  }),
                   10.height,
                   SymmetricPadding(child: MyText(text: AppLocalizations.of(context)!.discription,size:10.sp,fontWeight: FontWeight.w500,)),
                   10.height,
                   // Container(
                   //   height: 174.h,
                   //   decoration: BoxDecoration(
                   //     image: const DecorationImage(image: AssetImage(AppAssets.productDescription)),
                   //     borderRadius: BorderRadius.circular(8.r)
                   //   ),
                   // ),
                   // 10.height,
                   SymmetricPadding(
                     child: MyText(
                       overflow: TextOverflow.clip,
                         size: 9.sp,
                       text: capitalizeFirstLetter(product.description),
                     )
                   ),
                   10.height,
                   // Row(
                   //   mainAxisAlignment: MainAxisAlignment.center,
                   //   children: [
                   //     MyText(text: "See More",size: 10.sp,fontWeight: FontWeight.w600),
                   //     5.width,
                   //
                   //     const Icon(Icons.keyboard_arrow_down_sharp,),
                   //   ],
                   // ),
                   10.height,
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
                   10.height,
                   const ShopNowStylishGridForProductDetail(),
                    // ShopNowProductGrid(
                    //  crossAccess: 3,
                    //  ratio:screenWidth<ScreenSizes.width420? 0.52:0.55,),
                   80.height,







                 ],
               )
              ],
            ),
          ),

          Column(
            children: [
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: ()async{
                      String userId=await getUserId();
                      if(userId.isEmpty){
                        showSnackbar(context, AppLocalizations.of(context)!.pleaselogintouseacount,color: redColor);
                        return;
                      }
                      Navigator.pushNamed(context, RoutesNames.customerVisitStoreView,arguments: product.sellerId!.id);
                    },
                    child: Container(
                      height: 32.h,
                      // width: 120.w,
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12.r),
                            bottomLeft: Radius.circular(12.r),
                          )
                      ),
                      child: Row(
                        spacing: 5.w,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          5.width,
                          Image.asset(AppAssets.shopHomePageIcon,color: whiteColor,scale: 2,),

                          MyText(text: AppLocalizations.of(context)!.visitstore,color: whiteColor,size: 12.sp,fontWeight: FontWeight.w600,),
                          5.width,

                        ],
                      ),
                    ),
                  ),

                ],
              ),
              const Spacer(),
              Container(
                color: whiteColor,
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 15.w,vertical: 5.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: ()async{
                          String userId=await getUserId();
                          if(userId.isEmpty){
                            showSnackbar(context, AppLocalizations.of(context)!.pleaselogintouseacount,color: redColor);
                            return;
                          }
                          Navigator.pushNamed(context, RoutesNames.customerVisitStoreView,arguments: product.sellerId!.id);
                        },
                        child: Container(
                          height: 26.h,
                          width: 26.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.r),
                              image: const DecorationImage(image: AssetImage(AppAssets.shopHomePageIcon),scale: 3),
                              border: Border.all(color: primaryColor)
                          ),
                        ),
                      ),
                      FutureBuilder(
                          future: UserRepository.getUserNameAndId(product.sellerId!.id, context),
                          builder: (context,s){
                            if(s.connectionState==ConnectionState.waiting){
                              return const UserNameShimmer();
                            }
                            // if(snapshot.data!.message=='success'){
                            //   return  ShimmerEffects().shimmerForChats();
                            // }
                            var receiverData=s.data;
                            return   GestureDetector(
                              onTap: ()async{

                                String userId=await getUserId();
                                if(userId.isEmpty){
                                  showSnackbar(context, AppLocalizations.of(context)!.pleaselogintouseacount,color: redColor);
                                  return;
                                }
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                    SellerMessageDetailView(receiverId: product.sellerId!.id, receiverName: receiverData!.user.name, senderId: userId,)));
                                // Navigator.pushNamed(context, RoutesNames.customerChatWithOwnerView);

                              },
                              child: Container(
                                height: 26.h,
                                width: 26.w,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6.r),
                                    image: const DecorationImage(image: AssetImage(AppAssets.productChatIconT),scale: 3),
                                    border: Border.all(color: primaryColor)
                                ),
                              ),
                            );
                          }),
                      RoundButton(
                          width: 118.w,
                          height: 34.h,
                          borderRadius: BorderRadius.circular(5.r),
                          btnTextSize: 10.sp,
                          textFontWeight: FontWeight.w700,
                          bgColor: const Color(0xffFFB235),
                          title: AppLocalizations.of(context)!.buynow,
                          onTap: ()async{
                            String userId=await getUserId();
                            if(userId.isEmpty){
                              showSnackbar(context, AppLocalizations.of(context)!.pleaselogintouseacount,color: redColor);
                              return;
                            }

                            // Check if product is already in cart
                            final cartProvider = Provider.of<CartProvider>(context, listen: false);
                            bool isAlreadyInCart = false;

                            if (cartProvider.cartResponse != null) {
                              isAlreadyInCart = cartProvider.cartResponse!.cart.cartItem
                                  .any((cartItem) => cartItem.productId.id == product.id);
                            }

                            if (isAlreadyInCart) {
                              // Product already in cart, just navigate to cart
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>const CustomerCartView()));
                            } else {
                              // Add product to cart first, then navigate
                              var model=AddToCartModel(
                                  sellerId: product.sellerId!.id,
                                  productId: product.id,
                                  quantity: 1,
                                  price: product.price.toDouble(),
                                  totalProductDiscount: product.priceAfterDiscount.toDouble());

                              // Show professional loading overlay
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    child: Container(
                                      padding: EdgeInsets.all(20.sp),
                                      decoration: BoxDecoration(
                                        color: whiteColor,
                                        borderRadius: BorderRadius.circular(12.r),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            width: 20.sp,
                                            height: 20.sp,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                                            ),
                                          ),
                                          12.width,
                                          MyText(
                                            text: AppLocalizations.of(context)!.pleasewait,
                                            size: 12.sp,
                                            color: textPrimaryColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );

                              await CartRepository.addProductToCart(model, context).then((v){
                                Navigator.pop(context);
                                // Refresh cart data to update badge count
                                final cartProvider = Provider.of<CartProvider>(context, listen: false);
                                cartProvider.getCartData(context);
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>const CustomerCartView()));
                              }).onError((err,e){
                                Navigator.pop(context);
                              });
                            }
                          }                      ),
                      RoundButton(
                          width: 108.w,
                          height: 34.h,
                          borderRadius: BorderRadius.circular(5.r),
                          btnTextSize: 10.sp,
                          textFontWeight: FontWeight.w700,
                          bgColor:primaryColor,
                          title: AppLocalizations.of(context)!.addtocart,
                          onTap: ()async{
                            String userId=await getUserId();
                            if(userId.isEmpty){
                              showSnackbar(context, AppLocalizations.of(context)!.pleaselogintouseacount,color: redColor);
                              return;
                            }
                            var model=AddToCartModel(
                                sellerId: product.sellerId!.id,
                                productId: product.id,
                                quantity: 1,
                                price: product.price.toDouble(),
                                totalProductDiscount: product.priceAfterDiscount.toDouble());
                            // Show professional loading overlay
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return Dialog(
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(20.sp),
                                    decoration: BoxDecoration(
                                      color: whiteColor,
                                      borderRadius: BorderRadius.circular(12.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: 20.sp,
                                          height: 20.sp,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                                          ),
                                        ),
                                        12.width,
                                        MyText(
                                          text: AppLocalizations.of(context)!.addingtocart,
                                          size: 12.sp,
                                          color: textPrimaryColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                            await CartRepository.addProductToCart(model, context).then((v){
                              Navigator.pop(context);
                              // Refresh cart data to update badge count
                              final cartProvider = Provider.of<CartProvider>(context, listen: false);
                              cartProvider.getCartData(context);
                              showSnackbar(context, AppLocalizations.of(context)!.producthasaddedtocartsuccessfully,color: greenColor);
                            }).onError((err,e){
                              Navigator.pop(context);
                            });

                          }),
                    ],
                  ),
                ),
              ),
              10.height,
            ],
          )
        ],
      ),
    );
  }
}
