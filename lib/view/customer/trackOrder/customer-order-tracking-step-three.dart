import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/constants/enum.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';
import 'package:sugudeni/view/customer/trackOrder/customer-order-tracking-step-one.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/orders/GetAllOrdersCutomerModel.dart';
import '../appBar/account-app-bar.dart';

class CustomerOrderTrackingStepThree extends StatelessWidget {
  const CustomerOrderTrackingStepThree({super.key});

  @override
  Widget build(BuildContext context) {
    final order=ModalRoute.of(context)!.settings.arguments as Order;

    return Scaffold(
      appBar: const CustomerAccountAppBar(),
      body: SymmetricPadding(
        child: SingleChildScrollView(
          child: Column(
            spacing: 20.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(AppAssets.progressStepThree),
              GestureDetector(
                onTap: (){
                 // Navigator.pushNamed(context, RoutesNames.customerToDeliverViewView);
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: const Color(0xffFFD8BD)
                  ),
                  child: Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(text: AppLocalizations.of(context)!.trackingnumber,size: 14.sp,fontWeight: FontWeight.w700,),
                            MyText(text: order.cartItem[0].trackingId.isEmpty?'N/A':order.cartItem[0].trackingId,size: 12.sp,fontWeight: FontWeight.w400,),
                          ],
                        ),
                        Image.asset(AppAssets.trackingIcon,scale: 3,)
                      ],
                    ),
                  ),
                ),
              ),
              TrackingTextWidget(title: AppLocalizations.of(context)!.packed, subtitle: AppLocalizations.of(context)!.yourparcelispackedandwillbehandedovertoourdelivery),
              TrackingTextWidget(title: AppLocalizations.of(context)!.waitingforpickingdriver, subtitle: AppLocalizations.of(context)!.yourparcelisreadytohandover),
              TrackingTextWidget(title: AppLocalizations.of(context)!.orderassigned, subtitle: AppLocalizations.of(context)!.yourorderhasbeenassignedtodriver),
              // const TrackingTextWidget(title: "Shipped", subtitle: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore."),
              // const TrackingTextWidget(title: "Out for Delivery", subtitle: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore."),
             order.cartItem[0].status==DeliveryStatus.failed?
              TrackingTextWidget(title: AppLocalizations.of(context)!.failed, subtitle: "${AppLocalizations.of(context)!.reason}: ${order.cartItem[0].failureReason}"):  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        spacing: 10.w,
                        children: [
                          MyText(text: AppLocalizations.of(context)!.delivered,size: 14.sp,fontWeight: FontWeight.w700,color: appBlueColor,),
                          Container(
                            height: 22.h,
                            width: 22.w,
                            decoration: BoxDecoration(
                                color: appBlueColor,
                                border: Border.all(color: whiteColor,width: 2),
                                shape: BoxShape.circle,
                                image: const DecorationImage(image: AssetImage(AppAssets.checkIcon),scale: 3)
                            ),
                          ),
                        ],
                      ),
            order.cartItem[0].deliveredAt==null ?  const SizedBox():Container(
                        decoration: BoxDecoration(
                            color: const Color(0xffE4E4E4),
                            borderRadius: BorderRadius.circular(4.r)
                        ),
                        child: Center(
                          child: Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 5.w,vertical: 2.h),
                            child: MyText(text: dateFormat(order.cartItem[0].deliveredAt!),size: 13.sp,fontWeight: FontWeight.w500,),
                          ),
                        ),
                      ),
                    ],
                  ),
                  5.height,
                  MyText(
                    overflow: TextOverflow.clip,
                    text: AppLocalizations.of(context)!.yourorderhasbeendeliveredsuccessfully,size: 12.sp,fontWeight: FontWeight.w400,),
                ],
              )
            ],
          ),
        ),
      ),

    );
  }
}
