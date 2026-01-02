import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sugudeni/providers/bottom_navigation_provider.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/view/customer/cart/customer-cart-view.dart';

import '../../../utils/constants/app-assets.dart';
import '../products/customer-all-products-view.dart';

class CustomerUsedAppBar extends StatelessWidget {
  const CustomerUsedAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Only show back button if we can pop (not in bottom nav root pages)
    final bool canPop = Navigator.canPop(context);
    
    return Row(
      children: [
        if (canPop)
          IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: const Icon(Icons.arrow_back_ios)),
        Flexible(
          child: GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const CustomerAllProductsView(isComeFromSearch: true,)));
            },
            child: TextFormField(
              enabled: false,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 10.sp,
                  color: const Color(0xff545454)
              ),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search,color: Color(0xff545454),),
                hintText: "Search in SUGUDENI",
                hintStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 10.sp,
                    color: const Color(0xff545454)
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(
                    color: primaryColor,

                  ),
                ),
                enabledBorder:OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(
                    color: primaryColor,

                  ),
                ) ,
                focusedBorder:OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(
                    color: primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ),
        4.width,
        GestureDetector(
          onTap: () {
            Share.share('Check out SUGUDENI - Your favorite shopping app! Download now');
          },
          child: Image.asset(AppAssets.shareIcon,scale: 2,width: 20.w,height: 20.h,),
        ),
        4.width,
        Stack(
          children: [
            GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomerCartView()));
                },
                child: Image.asset(AppAssets.cartBottomIcon,scale: 1,color: primaryColor,width: 30.w,height: 30.h,)),
            // Positioned(
            //   right: 0,
            //   child: Container(
            //     height: 13.h,
            //     width: 13.w,
            //     decoration: const BoxDecoration(
            //         color: appRedColor,
            //         shape: BoxShape.circle
            //     ),
            //     child: Center(
            //       child: MyText(text: '10',color: whiteColor,size: 7.sp,fontFamily: AppFonts.jost,),
            //     ),
            //   ),
            // )
          ],
        ),
        4.width,
        GestureDetector(
          onTap: () {
            context.read<BottomNavigationProvider>().navigateToProfile();
          },
          child: Image.asset(AppAssets.gridIcon,scale: 2,width: 20.w,height: 20.h,),
        ),
      ],
    );
  }
}
