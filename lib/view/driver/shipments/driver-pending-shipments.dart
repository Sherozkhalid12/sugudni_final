import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/models/shipment/GetAllAvailableShipmentModel.dart';
import 'package:sugudeni/providers/driver/driver-provider.dart';
import 'package:sugudeni/providers/shipping-provider/shipping-provider.dart';
import 'package:sugudeni/repositories/driver/driver-shipping-repository.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/constants/enum.dart';
import 'package:sugudeni/utils/constants/fonts.dart';
import 'package:sugudeni/utils/constants/screen-sizes.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/media-query.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/customWidgets/my-text.dart';
import '../home/driver-home-view.dart';
class DriverPendingShipmentView extends StatelessWidget {
  const DriverPendingShipmentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child:     SafeArea(
          child: SymmetricPadding(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
          
                MyText(text: AppLocalizations.of(context)!.pendingshipments,fontWeight: FontWeight.w700,size: 22.sp,),
                5.height,
                FutureBuilder(
                    future: DriverShippingRepository.getAllPendingShipment(context),
                    builder: (context,snapshot){
                      if(snapshot.connectionState==ConnectionState.waiting){
                        return SizedBox(
                          height: 500.h,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      if(snapshot.hasError){
                        return Center(
                          child: MyText(text: snapshot.error.toString()),
                        );
                      }
                      var data=snapshot.data!.shipments;
                      var filteredOrders = data!.where((order) => order.isDelivered==false&&order.trackingStatus==DeliveryStatus.shipping).toList();
                      if(filteredOrders.isEmpty){
                        return SizedBox(
                          height: 500.h,
                          child:  Center(
                            child: MyText(text: AppLocalizations.of(context)!.notfound),
                          ),
                        );
                      }
                      return  ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: filteredOrders.length,
                          itemBuilder: (context,index){
                            // var data=dummyOrderData[index];
                            var availableShippingData=filteredOrders[index];
                            return CompletedOrderWidget(
                                shipmentModel: availableShippingData,
                                img: availableShippingData.cartItems[0].product.imgCover,
                                title:  availableShippingData.cartItems[0].product.title,
                                discription:  availableShippingData.cartItems[0].product.description,
                                stars:  availableShippingData.cartItems[0].product.ratingAvg.toString(),
                                rupees:  availableShippingData.totalPriceAfterDiscount==0?availableShippingData.totalPriceAfterDiscount.toString():availableShippingData.totalPrice.toString()
                            );
                          });
                    })
          
              ],
            ),
          ),
        ),
      ),
    );
  }
}
