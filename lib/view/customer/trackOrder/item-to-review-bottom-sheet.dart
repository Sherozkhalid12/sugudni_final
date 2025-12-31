import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/cached-network-image.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/shimmer-widgets.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/view/customer/account/rating-bottom-sheet.dart';

import '../../../api/api-endpoints.dart';
import '../../../l10n/app_localizations.dart';
import '../../../repositories/orders/customer-order-repository.dart';
import '../../../utils/constants/enum.dart';

class ItemToReviewBottomSheet extends StatelessWidget {
  const ItemToReviewBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    // Removed dummy list - using real API data from CustomerOrderRepository
    return FutureBuilder(
        future: CustomerOrderRepository.allCustomersOrders(context),
        builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return Column(
              children: List.generate(3, (index) => const ListItemShimmer(height: 100)),
            );
          }
          if(snapshot.hasError){
            return Center(
              child: MyText(text: snapshot.error.toString()),
            );
          }
          var data=snapshot.data;
          
          // Filter orders that can be reviewed (delivered orders)
          final reviewableOrders = data?.orders.where((order) {
            return order.cartItem.any((item) => 
              item.status == DeliveryStatus.delivered || item.isDelivered == true
            );
          }).toList() ?? [];
          
          return SafeArea(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: SymmetricPadding(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 10.h,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with close button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Center(
                        child: MyText(
                          text: AppLocalizations.of(context)!.whichitemyouwanttoreview,
                          size: 18.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      color: textSecondaryColor,
                    ),
                  ],
                ),
                // Empty state or list
                if (reviewableOrders.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.h),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.rate_review_outlined, size: 64.sp, color: textSecondaryColor),
                          20.height,
                          MyText(
                            text: AppLocalizations.of(context)!.noordersfound,
                            size: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: textSecondaryColor,
                          ),
                          10.height,
                          MyText(
                            text: "You don't have any orders to review yet.",
                            size: 12.sp,
                            color: textSecondaryColor.withOpacity(0.7),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: reviewableOrders.length,
                      itemBuilder: (context,index){
                        var orderData=reviewableOrders[index];
                        return  Container(
                   decoration: const BoxDecoration(
                     color: whiteColor,

                   ),
                   child: Padding(
                     padding:  EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
                     child: Row(
                       spacing: 10.w,
                       children: [

                         MyCachedNetworkImage(
                             height: 75.h,
                             width: 75.w,
                             radius: 9.r,
                             imageUrl:orderData.cartItem[0].productId.bulk==true?
                             orderData.cartItem[0].productId.imgCover:"${ApiEndpoints.productUrl}/${orderData.cartItem[0].productId.imgCover}"),
                         // Container(
                         //   height: 100.h,
                         //   width: 123.w,
                         //   decoration: BoxDecoration(
                         //       boxShadow: [
                         //         BoxShadow(
                         //             color: blackColor.withAlpha(getAlpha(0.1)),
                         //             spreadRadius: 1,
                         //             blurRadius: 8
                         //         )
                         //       ],
                         //       image:  DecorationImage(image: AssetImage(dummy[0]),fit: BoxFit.cover),
                         //       borderRadius: BorderRadius.circular(6.r)
                         //   ),
                         // ),
                         Flexible(
                           child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               MyText(text: capitalizeFirstLetter(orderData.cartItem[0].productId.title),
                                   overflow: TextOverflow.clip,
                                   size: 11.sp,fontWeight: FontWeight.w500),
                               MyText(text: "${AppLocalizations.of(context)!.order} #${orderData.id}.",
                                   overflow: TextOverflow.clip,
                                   size: 11.sp,fontWeight: FontWeight.w700),
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   // Container(
                                   //   decoration: BoxDecoration(
                                   //       color: const Color(0xffE4E4E4),
                                   //       borderRadius: BorderRadius.circular(4.r)
                                   //   ),
                                   //   child: Center(
                                   //     child: Padding(
                                   //       padding:  EdgeInsets.symmetric(horizontal: 15.w,vertical: 5.h),
                                   //       child: MyText(text: "April,19",size: 13.sp,fontWeight: FontWeight.w500,),
                                   //     ),
                                   //   ),
                                   // ),
                                   GestureDetector(
                                     onTap: (){
                                       showModalBottomSheet(
                                           backgroundColor: whiteColor,
                                           isScrollControlled: true,
                                           context: context, builder: (context){
                                         return Padding(
                                           padding:EdgeInsets.only(
                                               bottom: MediaQuery.of(context).viewInsets.bottom),
                                           child:  RatingBottomSheet(
                                             bulk: orderData.cartItem[0].productId.bulk,
                                             img: orderData.cartItem[0].productId.imgCover,
                                             productId: orderData.cartItem[0].productId.id,
                                             title: orderData.cartItem[0].productId.title,
                                           ),
                                         );
                                       });
                                     },
                                     child: Container(
                                       decoration: BoxDecoration(
                                           border: Border.all(color: primaryColor),
                                           borderRadius: BorderRadius.circular(9.r)
                                       ),
                                       child: Center(
                                         child: Padding(
                                           padding:  EdgeInsets.symmetric(horizontal: 10.w,vertical: 3.h),
                                           child: MyText(text: AppLocalizations.of(context)!.review,size: 12.sp,fontWeight: FontWeight.w500,color: primaryColor,),
                                         ),
                                       ),
                                     ),
                                   ),
                                 ],
                               )
                             ],
                           ),
                         )
                       ],
                     ),
                   ),
                 );
                    }),
                  ),
                10.height
              ],
            ),
          ),
        ),
      );
    });
  }
}
