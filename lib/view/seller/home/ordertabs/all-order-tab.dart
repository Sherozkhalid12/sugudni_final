import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/providers/image-pickers-provider.dart';
import 'package:sugudeni/providers/seller-scroll-tab-provider.dart';
import 'package:sugudeni/providers/shipping-provider/shipping-provider.dart';
import 'package:sugudeni/repositories/orders/seller-order-repository.dart';
import 'package:sugudeni/repositories/user-repository.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/cached-network-image.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/round-button.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/utils/sharePreference/save-user-token.dart';
import 'package:sugudeni/utils/shimmer/shimmer-effects.dart';
import 'package:sugudeni/utils/customWidgets/shimmer-widgets.dart';
import 'package:sugudeni/utils/customWidgets/empty-state-widget.dart';
import 'package:sugudeni/view/seller/messages/seller-message-detailed-screen.dart';
import 'package:sugudeni/view/seller/orders/seller-specific-order-detail-view.dart';

import '../../../../l10n/app_localizations.dart';


class SellerAllOrderTab extends StatelessWidget {
  const SellerAllOrderTab({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SellerOrderRepository.allSellerOrders(context),
        builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return Column(
              children: List.generate(3, (index) => const ListItemShimmer(height: 100)),
            );
          }
          if(snapshot.hasError){
            customPrint("============================${snapshot.error.toString()}");
            return Center(
              child: MyText(
                  overflow: TextOverflow.clip,
                  text: snapshot.error.toString()),
            );
          }
          var data=snapshot.data;
          if (data == null || data.orders == null) {
            return EmptyStateWidget(
              title: AppLocalizations.of(context)!.noordersfound,
              description: 'You don\'t have any orders yet. Orders will appear here once customers start purchasing your products.',
              icon: Icons.shopping_bag_outlined,
            );
          }
          var filteredOrders = data.orders!.where((order) => order.cartItem.isNotEmpty).toList();

          if (filteredOrders.isEmpty) {
            return EmptyStateWidget(
              title: AppLocalizations.of(context)!.noordersfound,
              description: 'You don\'t have any orders yet. Orders will appear here once customers start purchasing your products.',
              icon: Icons.shopping_bag_outlined,
            );
          }

          return Expanded(
              child: ListView.builder(
                  itemCount: filteredOrders!.length,
                  itemBuilder: (context, index) {
                    var orderData=filteredOrders![index];
                    return Container(
                      //  height: 162.h,
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 10.h),
                      decoration: const BoxDecoration(
                        color: whiteColor,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12.sp),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                MyText(
                                  text: "${AppLocalizations.of(context)!.ordernumber} :",
                                  fontWeight: FontWeight.w500,
                                  size: 12.sp,
                                ),
                                10.width,
                                MyText(
                                  text: orderData.id!,
                                  fontWeight: FontWeight.w500,
                                  color: textPrimaryColor.withOpacity(0.70),
                                  size: 10.sp,
                                ),
                              ],
                            ),
                            5.height,
                            ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: orderData.cartItem.length,
                                itemBuilder: (context,index){
                                  var cartData=orderData.cartItem[index];
                                  return  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Material(
                                      elevation: 2,
                                      borderRadius: BorderRadius.circular(5.r),
                                      child: Container(
                                        // height: 65.h,
                                        // width: 302.w,

                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(5.r),
                                            color: const Color(0xffFBFBFB)),
                                        child: Padding(
                                          padding: EdgeInsets.all(8.sp),
                                          child: Row(
                                            children: [
                                              MyCachedNetworkImage(
                                                  height: 51.h,
                                                  width: 51.w,
                                                  imageUrl:cartData.product!.bulk==true?cartData.product!.imgCover :"${ApiEndpoints.productUrl}/${cartData.product!.imgCover}"),
                                              // Container(
                                              //   height: 51.h,
                                              //   width: 51.w,
                                              //   decoration: BoxDecoration(
                                              //       borderRadius:
                                              //       BorderRadius.circular(6.r),
                                              //       image:  DecorationImage(
                                              //           image: NetworkImage("${ApiEndpoints.productUrl}/${orderData.product!.imgCover}"),
                                              //           fit: BoxFit.cover)),
                                              // ),
                                              10.width,
                                              Flexible(
                                                flex: 6,
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    MyText(
                                                      overflow: TextOverflow.clip,
                                                      text:
                                                      capitalizeFirstLetter(cartData.product!.title!),
                                                      fontWeight: FontWeight.w600,
                                                      size: 12.sp,
                                                    ),
                                                    MyText(
                                                      text: "QTY: ${cartData.quantity}",
                                                      fontWeight: FontWeight.w600,
                                                      size: 12.sp,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Spacer(),
                                              MyText(
                                                  size: 10.sp,
                                                  fontWeight: FontWeight.w600,
                                                  // text: "\$ ${cartData.totalProductDiscount==0?cartData.price.toString()
                                                  //     :cartData.totalProductDiscount.toString()}",
                                                  text: "\$ ${cartData.priceAfterDiscount}"
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                            5.height,
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                MyText(
                                  text: AppLocalizations.of(context)!.totalpurchase,
                                  fontWeight: FontWeight.w500,
                                  size: 12.sp,
                                ),
                                10.width,
                                MyText(
                                  text: "\$ ${orderData.totalPriceAfterDiscount}",
                                  // text: "\$ ${calculateTotalPrice(orderData.cartItem)}",
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xffB70003),
                                  size: 10.sp,
                                ),
                              ],
                            ),
                            5.height,
                            Row(
                              children: [
                                Flexible(
                                    flex: 2,
                                    child: RoundButton(
                                        height: 24.h,
                                        btnTextSize: 10.sp,
                                        borderColor: primaryColor,
                                        bgColor: transparentColor,
                                        textColor: primaryColor,
                                        borderRadius:
                                        BorderRadius.circular(5.r),
                                        title: AppLocalizations.of(context)!.contachbuyer,
                                        onTap: ()async {
                                          String userId=await getUserId();
                                          var data=await UserRepository.getUserNameAndId(orderData.userId!.id, context);
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                              SellerMessageDetailView(receiverId: orderData.userId!.id, receiverName: data.user.name, senderId: userId,)));
                                        })),
                                4.width,
                                // Flexible(
                                //     flex: 1,
                                //     child: RoundButton(
                                //         height: 24.h,
                                //         btnTextSize: 10.sp,
                                //         borderColor: textPrimaryColor,
                                //         bgColor: transparentColor,
                                //         textColor: textPrimaryColor,
                                //         borderRadius:
                                //         BorderRadius.circular(5.r),
                                //         title: "Cancel Order",
                                //         onTap: () {})),
                                4.width,
                                Flexible(
                                    flex: 1,
                                    child: RoundButton(
                                        height: 24.h,
                                        btnTextSize: 10.sp,
                                        borderRadius:
                                        BorderRadius.circular(5.r),
                                        title: AppLocalizations.of(context)!.view,
                                        onTap: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>SellerOrderDetailView(orderSellerResponse: filteredOrders[index])));
                                        })),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }));
        });
  }
}
