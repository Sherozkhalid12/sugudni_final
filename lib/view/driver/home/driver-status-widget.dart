import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/providers/driver/driver-provider.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/customWidgets/my-text.dart';

class DriverStatusWidget extends StatelessWidget {
  const DriverStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      //height: 93.h,
      width: double.infinity,
      color: whiteColor,
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 15.w,vertical: 15.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(10.r),
              child: Container(
                width: 35.w,
                height: 60.h,
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MyText(text: getMonthAbbreviation(DateTime.now()),color: const Color(0xffFF2929),size: 12.sp,fontWeight: FontWeight.w600,),
                    MyText(text: getFormattedDate(DateTime.now()),size: 12.sp,fontWeight: FontWeight.w600,),
                    MyText(text: getDayAbbreviation(DateTime.now()),size: 12.sp,fontWeight: FontWeight.w600,),
                  ],
                ),
              ),
            ),
            10.width,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                5.height,
                MyText(text: getFormattedTime(DateTime.now()),size: 12.sp,fontWeight: FontWeight.w600,),
                15.height,
                Row(
                  children: [
                    Container(
                      height: 15.w,
                      width: 15.w,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xff55FF00)
                      ),
                      child: Center(
                        child: Icon(Icons.check,color: whiteColor,size: 12.sp,),
                      ),
                    ),
                    3.width,
                    MyText(text: AppLocalizations.of(context)!.ongoing,size: 12.sp,fontWeight: FontWeight.w600,),
                  ],
                ),

              ],
            ),
            const Spacer(),
            Column(
              children: [
               Consumer<DriverProvider>(builder: (context,provider,child){
                 // Use driverStatus from API if available, otherwise fallback to isPendingApproval
                 bool isPendingApproval = provider.driverStatus != null 
                     ? provider.driverStatus != 'approved' 
                     : provider.isPendingApproval;
                 
                 // Use cached online status from provider for instant updates
                 bool inOnline = provider.isOnline ?? false;
                 
                 return Row(
                   children: [
                     MyText(text: AppLocalizations.of(context)!.online,size: 12.sp,fontWeight: FontWeight.w600,),
                     10.width,
                     SizedBox(
                       width: 40,
                       child: FittedBox(
                         child: Switch(
                             activeColor: const Color(0xff00C000),
                             value: inOnline,
                             onChanged: (provider.isToggling || isPendingApproval) ? null : (v) {
                               // Toggle immediately - provider handles optimistic update
                               provider.toggleDriver(context);
                             }),
                       ),
                     )
                   ],
                 );
               }),
                Row(
                  children: [
                    MyText(
                      textAlignment: TextAlign.start,
                      text: AppLocalizations.of(context)!.waitingfordeliveries,size: 12.sp,fontWeight: FontWeight.w600,),
                    5.width,
                    // SpinKitCircle(
                    //   color: primaryColor,
                    //   size: 30.sp,
                    // ),
                    5.width


                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
