import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/models/orders/GetAllOrdersCutomerModel.dart';
import 'package:sugudeni/repositories/orders/customer-order-repository.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/constants/enum.dart';
import 'package:sugudeni/utils/customWidgets/cached-network-image.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/shimmer-widgets.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';
import 'package:sugudeni/view/customer/account/rating-bottom-sheet.dart';
import 'package:sugudeni/view/customer/appBar/account-app-bar.dart';
import 'package:sugudeni/view/customer/products/customer-specific-product-detail-view.dart';

import '../../../l10n/app_localizations.dart';

class CustomerToReceiveOrderView extends StatelessWidget {
  const CustomerToReceiveOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: const CustomerAccountAppBar(),
     body:  FutureBuilder(
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
           
           // Filter orders that are not yet delivered (to receive)
           // Include paid orders that are not delivered
           final toReceiveOrders = data!.orders.where((order) {
             return order.cartItem.isNotEmpty && 
                    order.cartItem.any((item) => 
                      item.status != DeliveryStatus.delivered && 
                      item.isDelivered != true
                    );
           }).toList();
           
           if (toReceiveOrders.isEmpty) {
             return Center(
               child: Padding(
                 padding: EdgeInsets.all(40.sp),
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Icon(Icons.local_shipping_outlined, size: 64.sp, color: textSecondaryColor),
                     20.height,
                     MyText(
                       text: "No Orders to Receive",
                       size: 18.sp,
                       fontWeight: FontWeight.w600,
                       color: textSecondaryColor,
                     ),
                     10.height,
                     MyText(
                       text: "You don't have any orders to receive at the moment.",
                       size: 14.sp,
                       color: textSecondaryColor.withOpacity(0.7),
                       textAlignment: TextAlign.center,
                     ),
                   ],
                 ),
               ),
             );
           }
           
       return   ListView.builder(
         itemCount: toReceiveOrders.length,
           itemBuilder: (context,index){
           var orderData=toReceiveOrders[index];
                return   SymmetricPadding(
                    child: OrderStatusWidget(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomerOrderDetailView(orderSellerResponse: orderData)));
                      },
                      bulk:orderData.cartItem[0].productId.bulk,
                      order: orderData,
                      img: orderData.cartItem[0].productId.imgCover,
                      status: orderData.cartItem[0].status,
                      quantity: orderData.cartItem[0].quantity.toString(),
                      orderId: orderData.id,
                    ));
              });
     }),
    );
  }
}
class OrderStatusWidget extends StatelessWidget {
  final String status;
  final String? img;
  final String? quantity;
  final String? orderId;
  final VoidCallback? onPressed;
  final Order order;
  final bool? bulk;
  //final bool isDriverPicked;
  const OrderStatusWidget({super.key, required this.status, this.orderId, this.img, this.quantity, this.onPressed, required this.order, this.bulk=false,});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        //  height: 101.h,
        width:double.infinity,
        margin: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            MyCachedNetworkImage(
                height: 75.h,
                width: 75.w,
                radius: 9.r,
                imageUrl:bulk==true? img!:"${ApiEndpoints.productUrl}/$img"),
            // Container(
            //   height: 75.h,
            //   width: 75.w,
            //   decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(9.r),
            //       image:  DecorationImage(image: NetworkImage("${ApiEndpoints.productUrl}/$img"),fit: BoxFit.cover)
            //   ),
            // ),
            5.width,
            Flexible(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    overflow: TextOverflow.clip,
                    text: "${AppLocalizations.of(context)!.order} #${orderId?? 92287157}",size: 11.sp,fontWeight: FontWeight.w700,),
                  MyText(text: AppLocalizations.of(context)!.standarddelivery,size: 11.sp,fontWeight: FontWeight.w500,),
                  5.height,
                 status==DeliveryStatus.toShip? MyText(text: AppLocalizations.of(context)!.pending,size: 14.sp,fontWeight: FontWeight.w700,):
                 status==DeliveryStatus.readytoship? MyText(text: AppLocalizations.of(context)!.readyforshipping,size: 14.sp,fontWeight: FontWeight.w700,):
                 status==DeliveryStatus.shipping ? MyText(text: AppLocalizations.of(context)!.shipping,size: 14.sp,fontWeight: FontWeight.w700,):
                 status==DeliveryStatus.failed? MyText(text: AppLocalizations.of(context)!.failed,size: 14.sp,fontWeight: FontWeight.w700,):
                     Row(
                       spacing: 5.w,
                       children: [
                     MyText(text: AppLocalizations.of(context)!.delivered,size: 14.sp,fontWeight: FontWeight.w700,),
                          Container(
                           height: 22.h,
                           width: 22.w,
                           decoration: BoxDecoration(
                             color: primaryColor,
                             border: Border.all(color: whiteColor,width: 2),
                             shape: BoxShape.circle,
                             image: const DecorationImage(image: AssetImage(AppAssets.checkIcon),scale: 3)
                           ),
                         ),

                       ],
                     )
                  ,

                ],
              ),
            ),
            const Spacer(),
            Column(
              spacing: 20.h,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: const Color(0xffE4E4E4),
                      borderRadius: BorderRadius.circular(4.r)
                  ),
                  child: Center(
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 5.w,vertical: 2.h),
                      child: MyText(text: "$quantity ${AppLocalizations.of(context)!.items}",size: 10.sp,fontWeight: FontWeight.w500,),
                    ),
                  ),
                ),
             status==DeliveryStatus.delivered?
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
                       bulk: order.cartItem[0].productId.bulk,
                       orderId: order.id,
                       productId: orderId,
                       title: order.cartItem[0].productId.title,
                       img: order.cartItem[0].productId.imgCover,
                       isForDelivery: true,),
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
                     padding:  EdgeInsets.symmetric(
                         horizontal: 10.w,vertical: 2.h),
                     child: MyText(text: AppLocalizations.of(context)!.ratedelivery,size: 12.sp,
                       fontWeight: FontWeight.w500,color: primaryColor,),
                   ),
                 ),
               ),
             ):
             GestureDetector(
               onTap: (){
                 if(status==DeliveryStatus.toShip){
                   Navigator.pushNamed(context, RoutesNames.customerOrderTrackingStepOneViewView,arguments: order);
                 }
                 if(status==DeliveryStatus.readytoship){
                   Navigator.pushNamed(context, RoutesNames.customerOrderTrackingStepOneViewView,arguments: order);
                 }
                 if(status==DeliveryStatus.shipping){
                   Navigator.pushNamed(context, RoutesNames.customerOrderTrackingStepTwoViewView,arguments: order);
                 }
                 if(status==DeliveryStatus.failed){
                   Navigator.pushNamed(context, RoutesNames.customerOrderTrackingStepThreeViewView,arguments: order);
                 }
                 if(status==DeliveryStatus.delivered){
                   Navigator.pushNamed(context, RoutesNames.customerOrderTrackingStepThreeViewView,arguments: order);
                 }
               },
               child: Container(
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(9.r)
                    ),
                    child: Center(
                      child: Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 15.w,vertical: 2.h),
                        child: MyText(text: AppLocalizations.of(context)!.track,size: 12.sp,fontWeight: FontWeight.w500,color: whiteColor,),
                      ),
                    ),
                  ),
             ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class OrderStatus{
  static const String packed='Packed';
  static const String shipped='Shipped';
  static const String delivered='Delivered';

}
