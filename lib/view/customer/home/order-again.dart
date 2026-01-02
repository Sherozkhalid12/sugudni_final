import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/repositories/orders/customer-order-repository.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/view/customer/home/order-again-widget.dart';

import '../../../l10n/app_localizations.dart';
import '../../../providers/carts/cart-provider.dart';
import '../../../repositories/devlivery/develivery-repository.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/customWidgets/shimmer-widgets.dart';
import '../products/customer-specific-product-detail-view.dart';

class OrderAgainHome extends StatelessWidget {
  const OrderAgainHome({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: CustomerOrderRepository.allCustomersOrders(context),
        builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Center(
              child: SizedBox(),
            );
          }
          if(snapshot.hasError){
            return Center(
              child: MyText(text: snapshot.error.toString()=='Token is empty'?'':snapshot.error.toString()),
            );
          }
          var data=snapshot.data;
          if(data == null || data.orders.isEmpty){
            return const SizedBox();
          }
          return   Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.height,
              SymmetricPadding(child: MyText(text: AppLocalizations.of(context)!.orderagain,size: 14.sp,fontWeight: FontWeight.w700)),
              SizedBox(
                height: 220.h,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: data.orders.length,
                    itemBuilder: (context,index){
                      var orderData=data.orders[index];
                      return   OrderAgain(
                        isShowTitle: false,
                        isBulk: orderData.cartItem.first.productId.bulk,
                        onPressed: (){
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                            ),
                            builder: (context) {
                              List<String> slots = _generateTimeSlots();

                              return Consumer<CartProvider>(
                                  builder: (context,provider,child){
                                    return Container(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                           Text(
                                             AppLocalizations.of(context)!.selectdeliveryslots,
                                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 16),
                                          FutureBuilder(
                                              future: DeliveryRepository.getAllDeliverySlot(context),
                                              builder: (context,snapshot){
                                                if(snapshot.connectionState==ConnectionState.waiting){
                                                  return SizedBox(
                                                    height: 220.h,
                                                    child: ListView.builder(
                                                      scrollDirection: Axis.horizontal,
                                                      itemCount: 3,
                                                      itemBuilder: (context, index) => const ListItemShimmer(height: 220, width: 150),
                                                    ),
                                                  );
                                                }
                                                var data=snapshot.data;
                                                return  GridView.builder(
                                                  shrinkWrap: true,
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  itemCount: data!.deliverySlots.length,
                                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 2, // Two slots per row
                                                    crossAxisSpacing: 10,
                                                    mainAxisSpacing: 10,
                                                    childAspectRatio: 3.5, // Adjust slot size
                                                  ),
                                                  itemBuilder: (context, index) {
                                                    String slot = slots[index];
                                                    bool isSelected = slot == provider.selectedSlot;
                                                    var slotsData=data.deliverySlots[index];
                                                    return GestureDetector(
                                                      onTap: () {
                                                        provider.setDeliveryId(slotsData.id, slotsData);
                                                        Navigator.of(context).pop(); // Close the bottom sheet
                                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomerOrderDetailView(orderSellerResponse: orderData,isOrderAgain: true,)));

                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          color: isSelected ? primaryColor : Colors.grey[200],
                                                          borderRadius: BorderRadius.circular(10),
                                                          border: Border.all(
                                                            color: isSelected ? primaryColor : whiteColor,
                                                            width: 2,
                                                          ),
                                                        ),
                                                        alignment: Alignment.center,
                                                        padding: const EdgeInsets.symmetric(vertical: 5),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Text("${slotsData.startTime}-${slotsData.endTime}",
                                                              style: TextStyle(
                                                                fontSize: 11,
                                                                fontWeight: FontWeight.bold,
                                                                color: isSelected ? whiteColor : blackColor,
                                                              ),
                                                            ),
                                                            Text(slotsData.title,
                                                              style: TextStyle(
                                                                fontSize: 11,
                                                                fontWeight: FontWeight.bold,
                                                                color: isSelected ? whiteColor : blackColor,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              }),


                                        ],
                                      ),
                                    );
                                  });
                            },
                          );

                        },
                        product: orderData.cartItem.first.productId,
                        price: orderData.cartItem.first.price,
                        priceAfterDiscount: orderData.cartItem.first.totalProductDiscount,
                        title: orderData.cartItem.first.productId.title,
                        size: orderData.cartItem.first.productId.size,
                        sold: orderData.cartItem.first.productId.sold.toString(),
                        ratingAvg: orderData.cartItem.first.productId.ratingAvg.toString(),
                        ratingCount: orderData.cartItem.first.productId.ratingCount.toString(),
                        image: orderData.cartItem.first.productId.imgCover,
                      );
                    }),
              ),
            ],
          );
        });
  }
}
List<String> _generateTimeSlots() {
  List<String> slots = [];
  for (int hour = 0; hour < 24; hour += 2) {
    String start = _formatTime(hour);
    String end = _formatTime(hour + 2);
    slots.add("$start - $end");
  }
  return slots;
}

String _formatTime(int hour) {
  return hour.toString().padLeft(2, '0') + ":00";
}