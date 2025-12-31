import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/repositories/orders/customer-order-repository.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/constants/enum.dart';
import 'package:sugudeni/utils/customWidgets/cached-network-image.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/shimmer-widgets.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/view/customer/account/rating-bottom-sheet.dart';
import 'package:sugudeni/view/customer/appBar/account-app-bar.dart';
import 'package:sugudeni/l10n/app_localizations.dart';

class CustomerToDeliveredView extends StatelessWidget {
  const CustomerToDeliveredView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomerAccountAppBar(text: "Delivered"),
      body: FutureBuilder(
        future: CustomerOrderRepository.allCustomersOrders(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.all(10.sp),
                child: const ListItemShimmer(height: 100),
              ),
            );
          }
          
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(20.sp),
                child: MyText(
                  text: snapshot.error.toString(),
                  color: textSecondaryColor,
                ),
              ),
            );
          }
          
          final data = snapshot.data;
          if (data == null || data.orders.isEmpty) {
            return Center(
              child: MyText(
                text: AppLocalizations.of(context)!.notfound,
                color: textSecondaryColor,
              ),
            );
          }
          
          // Filter only delivered orders
          final deliveredOrders = data.orders.where((order) {
            return order.cartItem.any((item) => 
              item.status == DeliveryStatus.delivered || item.isDelivered == true
            );
          }).toList();
          
          if (deliveredOrders.isEmpty) {
            return Center(
              child: MyText(
                text: AppLocalizations.of(context)!.notfound,
                color: textSecondaryColor,
              ),
            );
          }
          
          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            itemCount: deliveredOrders.length,
            itemBuilder: (context, index) {
              final order = deliveredOrders[index];
              final firstItem = order.cartItem.isNotEmpty ? order.cartItem[0] : null;
              
              if (firstItem == null) return const SizedBox.shrink();
              
              final deliveredDate = firstItem.deliveredAt ?? order.updatedAt;
              final dateFormat = DateFormat('MMMM, dd');
              
              return SymmetricPadding(
                child: Container(
                  margin: EdgeInsets.only(bottom: 10.h),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    boxShadow: [
                      BoxShadow(
                        color: blackColor.withAlpha(getAlpha(0.2)),
                        spreadRadius: 1,
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    child: Row(
                      spacing: 10.w,
                      children: [
                        MyCachedNetworkImage(
                          height: 89.h,
                          width: 89.w,
                          radius: 6.r,
                          imageUrl: firstItem.productId.bulk
                              ? firstItem.productId.imgCover
                              : "${ApiEndpoints.productUrl}/${firstItem.productId.imgCover}",
                        ),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyText(
                                text: firstItem.productId.title,
                                overflow: TextOverflow.clip,
                                size: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              MyText(
                                text: "${AppLocalizations.of(context)!.order} #${order.id.substring(order.id.length - 8)}",
                                overflow: TextOverflow.clip,
                                size: 14.sp,
                                fontWeight: FontWeight.w700,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xffE4E4E4),
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 2.h),
                                      child: MyText(
                                        text: dateFormat.format(deliveredDate),
                                        size: 13.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (context) => Padding(
                                          padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context).viewInsets.bottom,
                                          ),
                                          child: RatingBottomSheet(
                                            bulk: firstItem.productId.bulk,
                                            orderId: order.id,
                                            productId: firstItem.productId.id,
                                            title: firstItem.productId.title,
                                            img: firstItem.productId.imgCover,
                                            isForDelivery: true,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: primaryColor),
                                        borderRadius: BorderRadius.circular(9.r),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 2.h),
                                        child: MyText(
                                          text: AppLocalizations.of(context)!.review,
                                          size: 16.sp,
                                          fontWeight: FontWeight.w500,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
