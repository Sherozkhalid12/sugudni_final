import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';
import 'package:sugudeni/view/customer/help/select-issue-bottom-sheet.dart';
import 'package:sugudeni/view/customer/trackOrder/customer-order-tracking-step-one.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/orders/GetAllOrdersCutomerModel.dart';
import '../appBar/account-app-bar.dart';
import 'order-unsuccessful-bottom-sheet.dart';

class CustomerOrderTrackingStepTwo extends StatelessWidget {
  const CustomerOrderTrackingStepTwo({super.key});

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
              Image.asset(AppAssets.progressStepTwo),
              GestureDetector(
                onTap: (){
                 // Navigator.pushNamed(context, RoutesNames.customerOrderTrackingStepThreeViewView);
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
              // TrackingTextWidget(title: "Out for Delivery", subtitle: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore."),
              // GestureDetector(
              //   onTap: (){
              //     showModalBottomSheet(context: context, builder: (context){
              //       return const OrderNotSuccessFullBottomSheet();
              //     });
              //   },
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           MyText(text: "Attempt to deliver your parcel\nwas not successful",size: 14.sp,fontWeight: FontWeight.w700,color: appBlueColor,),
              //           Container(
              //             decoration: BoxDecoration(
              //                 color: appRedColor,
              //                 borderRadius: BorderRadius.circular(4.r)
              //             ),
              //             child: Center(
              //               child: Padding(
              //                 padding:  EdgeInsets.symmetric(horizontal: 5.w,vertical: 2.h),
              //                 child: MyText(text: "April,19 12:31",size: 13.sp,fontWeight: FontWeight.w500,color: whiteColor,),
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //       5.height,
              //       MyText(
              //         overflow: TextOverflow.clip,
              //         text: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore.",size: 12.sp,fontWeight: FontWeight.w400,),
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      ),

    );
  }
}
