import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/providers/seller-return-order-provider.dart';
import 'package:sugudeni/utils/customWidgets/app-bar-title-widget.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/search-product-textfield.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';

import '../../../utils/constants/app-assets.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/customWidgets/tab-bar-widget.dart';
import '../../../utils/routes/routes-name.dart';
import '../products/seller-my-products-view.dart';

class SellerReturnOrderView extends StatelessWidget {
  const SellerReturnOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    final productsImages=[
      AppAssets.dummyChilliIcon,
      AppAssets.dummyProductTwo,
      AppAssets.dummyProductThree,
      AppAssets.dummyProductFour,
      AppAssets.dummyProductTwo,

    ];
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
            const AppBarTitleWidget(title: "Return List"),
            20.width,
            const Spacer()
          ],
        ),
      ),
      body:  Column(
        children: [
          const SymmetricPadding(child: SearchProductTextField()),
          15.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Consumer<SellerReturnOrderProvider>(
                  builder: (context, provider, child) {
                    return SellerTabBarWidget(
                        onPressed: () {
                          provider.changeReturnOrderTab(SellerReturnOrderTabs.inProcess);
                        },
                        width: 70.w,
                        selected:
                        provider.selectReturnOrderTab == SellerReturnOrderTabs.inProcess,
                        title: SellerReturnOrderTabs.inProcess);
                  }),
              40.width,
              Consumer<SellerReturnOrderProvider>(
                  builder: (context, provider, child) {
                    return SellerTabBarWidget(
                        onPressed: () {
                          provider.changeReturnOrderTab(SellerReturnOrderTabs.received);
                        },
                        width: 70.w,
                        selected:
                        provider.selectReturnOrderTab == SellerReturnOrderTabs.received,
                        title: SellerReturnOrderTabs.received);
                  }),

            ],
          ),
          10.height,
          Expanded(
            child: ListView.builder(
                itemCount: productsImages.length,
                itemBuilder: (context,index){

              return   Container(
                  width: double.infinity,
                  // height: 144.h,
                  color: whiteColor,
                  margin: EdgeInsets.only(bottom: 10.h),
                  child: Padding(
                    padding:  EdgeInsets.all(12.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(text: "Return ID : 12155238985",size: 16.sp,fontWeight: FontWeight.w600,
                          color: textPrimaryColor.withOpacity(0.7),
                        ),
                        5.height,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height:65.h ,
                              width: 65.w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6.r),
                                  image:   DecorationImage(image: AssetImage(productsImages[index]),fit: BoxFit.contain)
                              ),
                            ),
                            10.width,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyText(text: "Total Items 2",size: 8.sp,
                                  color: textPrimaryColor.withOpacity(0.7),
                                  fontWeight: FontWeight.w600,
                                ),
                                MyText(text: "Requested at    24-06-2023  16:26",size: 8.sp,
                                  color: textPrimaryColor.withOpacity(0.7),
                                  fontWeight: FontWeight.w600,
                                ),
                                MyText(text: "Product ID : 12155238985",size: 8.sp,
                                  color: textPrimaryColor.withOpacity(0.7),
                                  fontWeight: FontWeight.w600,
                                ),

                                3.height,
                                MyText(text: "Red Chili A Fiery Spice that Adds",size: 10.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                3.height,

                              ],
                            ),
                            const Spacer(),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MyText(text: "Order ID : 156652156",size: 8.sp,
                                  color: textPrimaryColor.withOpacity(0.7),
                                  fontWeight: FontWeight.w600,
                                ),
                                5.height,
                                GestureDetector(
                                  onTap: (){
                                    Navigator.pushNamed(context, RoutesNames.driverHelpCenterView);
                                  },
                                  child: Container(
                                    height: 32.h,
                                    width: 82.w,
                                    decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.circular(18.r)
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        MyText(text: "Chat",color: whiteColor,size: 8.sp,fontWeight: FontWeight.w500,),
                                        Text("SUGUDENI",style: GoogleFonts.blinker(
                                            color: whiteColor,
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w700
                                        ),)
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MyText(text: "View Reasons",size: 10.sp,fontWeight: FontWeight.w600,
                              color: primaryColor,
                            ),
                            IconButton(onPressed: (){}, icon: Icon(Icons.keyboard_arrow_down_outlined,size: 20.sp,
                              color: primaryColor,
                            ))
                          ],
                        ),
                        MyText(
                          overflow: TextOverflow.clip,
                          text: "The parcel has been returned by the customer due to dissatisfaction with the product. They mentioned it did not meet their expectations or requirements.",
                          size: 8.sp,fontWeight: FontWeight.w600,
                          color: textPrimaryColor.withOpacity(0.7),
                        ),

                      ],
                    ),
                  )
              );
            }),
          )
        ],
      ),
    );
  }
}
