import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sugudeni/models/orders/GetAllOrdersCutomerModel.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';

import '../../../l10n/app_localizations.dart';
import '../appBar/account-app-bar.dart';

class CustomerOrderTrackingStepOne extends StatelessWidget {
  const CustomerOrderTrackingStepOne({super.key});

  @override
  Widget build(BuildContext context) {
    final order=ModalRoute.of(context)!.settings.arguments as Order;
    return Scaffold(
      appBar: const CustomerAccountAppBar(),
      body: SymmetricPadding(
        child: Column(
          spacing: 20.h,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(AppAssets.progressStepOne),
            GestureDetector(
              onTap: (){
              //  Navigator.pushNamed(context, RoutesNames.customerOrderTrackingStepTwoViewView);
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
             TrackingTextWidget(title: AppLocalizations.of(context)!.packed, subtitle:AppLocalizations.of(context)!.yourparcelispackedandwillbehandedovertoourdelivery),
             TrackingTextWidget(title: AppLocalizations.of(context)!.waitingforpickingdriver, subtitle: AppLocalizations.of(context)!.yourparcelisreadytohandover),
            //const TrackingTextWidget(title: "Arrived at Logistic Facility", subtitle: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore."),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         MyText(text: "Shipped",size: 14.sp,fontWeight: FontWeight.w700,color: const Color(0xff9C9C9C),),
            //         Container(
            //           decoration: BoxDecoration(
            //               color: const Color(0xffFFD8BD),
            //               borderRadius: BorderRadius.circular(4.r)
            //           ),
            //           child: Center(
            //             child: Padding(
            //               padding:  EdgeInsets.symmetric(horizontal: 5.w,vertical: 2.h),
            //               child: MyText(text: "Expected on April,20",size: 13.sp,fontWeight: FontWeight.w500,),
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //     5.height,
            //     MyText(
            //       overflow: TextOverflow.clip,
            //         color: const Color(0xff9C9C9C),
            //       text: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore.",
            //       size: 12.sp,fontWeight: FontWeight.w400,),
            //   ],
            // )
          ],
        ),
      ),

    );
  }
}
class TrackingTextWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  const TrackingTextWidget({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(text: title,size: 14.sp,fontWeight: FontWeight.w700,),
            // Container(
            //   decoration: BoxDecoration(
            //       color: const Color(0xffE4E4E4),
            //       borderRadius: BorderRadius.circular(4.r)
            //   ),
            //   child: Center(
            //     child: Padding(
            //       padding:  EdgeInsets.symmetric(horizontal: 5.w,vertical: 2.h),
            //       child: MyText(text: "April,19 12:31",size: 13.sp,fontWeight: FontWeight.w500,),
            //     ),
            //   ),
            // ),
          ],
        ),
        5.height,
        MyText(
          overflow: TextOverflow.clip,
          text: subtitle,size: 12.sp,fontWeight: FontWeight.w400,),
      ],
    );
  }
}
