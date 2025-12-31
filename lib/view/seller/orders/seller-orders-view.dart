import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/providers/seller-return-order-provider.dart';
import 'package:sugudeni/providers/seller-scroll-tab-provider.dart';
import 'package:sugudeni/utils/customWidgets/app-bar-title-widget.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/search-product-textfield.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/constants/app-assets.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/customWidgets/tab-bar-widget.dart';
import '../../../utils/routes/routes-name.dart';
import '../products/seller-my-products-view.dart';

class SellerOrderView extends StatelessWidget {
  const SellerOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.h,
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RoundIconButton(onPressed: (){
              Navigator.pop(context);
            },iconUrl: AppAssets.arrowBack),
            const Spacer(),
             AppBarTitleWidget(title: AppLocalizations.of(context)!.orders),
            20.width,
            const Spacer()
          ],
        ),
      ),
      body:  Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Consumer<SellerScrollTabProvider>(
                    builder: (context, provider, child) {
                      return SellerTabBarWidget(
                          onPressed: () {
                            provider.changeHomeTab(SellerHomeTabs.all);
                          },
                          selected:
                          provider.selectedHomeTab == SellerHomeTabs.all,
                          title: AppLocalizations.of(context)!.all);
                    }),
                Consumer<SellerScrollTabProvider>(
                    builder: (context, provider, child) {
                      return SellerTabBarWidget(
                          onPressed: () {
                            provider.changeHomeTab(SellerHomeTabs.unPaid);
                          },
                          selected:
                          provider.selectedHomeTab == SellerHomeTabs.unPaid,
                          title: AppLocalizations.of(context)!.unpaid);
                    }),
                Consumer<SellerScrollTabProvider>(
                    builder: (context, provider, child) {
                      return SellerTabBarWidget(
                          onPressed: () {
                            provider.changeHomeTab(SellerHomeTabs.toShip);
                          },
                          selected:
                          provider.selectedHomeTab == SellerHomeTabs.toShip,
                          title: AppLocalizations.of(context)!.toship);
                    }),
                Consumer<SellerScrollTabProvider>(
                    builder: (context, provider, child) {
                      return SellerTabBarWidget(
                          onPressed: () {
                            provider.changeHomeTab(SellerHomeTabs.delivered);
                          },
                          selected: provider.selectedHomeTab ==
                              SellerHomeTabs.delivered,
                          title: AppLocalizations.of(context)!.delivered);
                    }),
                Consumer<SellerScrollTabProvider>(
                    builder: (context, provider, child) {
                      return SellerTabBarWidget(
                          onPressed: () {
                            provider.changeHomeTab(SellerHomeTabs.shipping);
                          },
                          selected: provider.selectedHomeTab ==
                              SellerHomeTabs.shipping,
                          title: AppLocalizations.of(context)!.shipping);
                    }),
                Consumer<SellerScrollTabProvider>(
                    builder: (context, provider, child) {
                      return SellerTabBarWidget(
                          onPressed: () {
                            provider.changeHomeTab(SellerHomeTabs.failure);
                          },
                          selected: provider.selectedHomeTab ==
                              SellerHomeTabs.failure,
                          title: AppLocalizations.of(context)!.failure);
                    }),
              ],
            ),
          ),
          10.height,
          Consumer<SellerScrollTabProvider>(builder: (context,provider,child){
            return provider.getTab();
          })
          // const SymmetricPadding(child: SearchProductTextField()),
          // 15.height,
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Consumer<SellerReturnOrderProvider>(
          //         builder: (context, provider, child) {
          //           return SellerTabBarWidget(
          //               onPressed: () {
          //                 provider.changeOrderTab(SellerOrderTabs.completed);
          //               },
          //               width: 70.w,
          //               selected:
          //               provider.selectOrderTab == SellerOrderTabs.completed,
          //               title: SellerOrderTabs.completed);
          //         }),
          //     40.width,
          //     Consumer<SellerReturnOrderProvider>(
          //         builder: (context, provider, child) {
          //           return SellerTabBarWidget(
          //               onPressed: () {
          //                 provider.changeOrderTab(SellerOrderTabs.pending);
          //               },
          //               width: 100.w,
          //               selected:
          //               provider.selectOrderTab == SellerOrderTabs.pending,
          //               title: SellerOrderTabs.pending);
          //         }),
          //
          //   ],
          // ),
          // 10.height,
          // Expanded(
          //   child: ListView.builder(
          //       itemCount: productsImages.length,
          //       itemBuilder: (context,index){
          //
          //         return   Container(
          //             width: double.infinity,
          //             // height: 144.h,
          //             color: whiteColor,
          //             margin: EdgeInsets.only(bottom: 10.h),
          //             child: Padding(
          //               padding:  EdgeInsets.all(12.sp),
          //               child: Column(
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: [
          //                   MyText(text: "Order ID : 12155238985",size: 16.sp,fontWeight: FontWeight.w600,
          //                     color: textPrimaryColor.withOpacity(0.7),
          //                   ),
          //                   5.height,
          //                   Row(
          //                     crossAxisAlignment: CrossAxisAlignment.start,
          //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                     children: [
          //                       Container(
          //                         height:65.h ,
          //                         width: 65.w,
          //                         decoration: BoxDecoration(
          //                             borderRadius: BorderRadius.circular(6.r),
          //                             image:   DecorationImage(image: AssetImage(productsImages[index]),fit: BoxFit.contain)
          //                         ),
          //                       ),
          //                       10.width,
          //                       Column(
          //                         crossAxisAlignment: CrossAxisAlignment.start,
          //                         children: [
          //                           MyText(text: "Total Items 2",size: 8.sp,
          //                             color: textPrimaryColor.withOpacity(0.7),
          //                             fontWeight: FontWeight.w600,
          //                           ),
          //                           MyText(text: "Requested at    24-06-2023  16:26",size: 8.sp,
          //                             color: textPrimaryColor.withOpacity(0.7),
          //                             fontWeight: FontWeight.w600,
          //                           ),
          //                           MyText(text: "Product ID : 12155238985",size: 8.sp,
          //                             color: textPrimaryColor.withOpacity(0.7),
          //                             fontWeight: FontWeight.w600,
          //                           ),
          //
          //                           3.height,
          //                           MyText(text: "Red Chili A Fiery Spice that Adds",size: 10.sp,
          //                             fontWeight: FontWeight.w600,
          //                           ),
          //                           3.height,
          //
          //                         ],
          //                       ),
          //                       const Spacer(),
          //                       Column(
          //                         mainAxisAlignment: MainAxisAlignment.center,
          //                         children: [
          //                           MyText(text: "Order ID : 156652156",size: 8.sp,
          //                             color: textPrimaryColor.withOpacity(0.7),
          //                             fontWeight: FontWeight.w600,
          //                           ),
          //                           5.height,
          //                           GestureDetector(
          //                             onTap: (){
          //                               Navigator.pushNamed(context, RoutesNames.driverHelpCenterView);
          //                             },
          //                             child: Container(
          //                               height: 32.h,
          //                               width: 82.w,
          //                               decoration: BoxDecoration(
          //                                   color: primaryColor,
          //                                   borderRadius: BorderRadius.circular(18.r)
          //                               ),
          //                               child: Column(
          //                                 mainAxisAlignment: MainAxisAlignment.center,
          //                                 children: [
          //                                   MyText(text: "Chat",color: whiteColor,size: 8.sp,fontWeight: FontWeight.w500,),
          //                                   Text("SUGUDENI",style: GoogleFonts.blinker(
          //                                       color: whiteColor,
          //                                       fontSize: 10.sp,
          //                                       fontWeight: FontWeight.w700
          //                                   ),)
          //                                 ],
          //                               ),
          //                             ),
          //                           )
          //                         ],
          //                       )
          //                     ],
          //                   ),
          //
          //                 ],
          //               ),
          //             )
          //         );
          //       }),
          // )
        ],
      ),
    );
  }
}
