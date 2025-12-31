import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/providers/carts/cart-provider.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/round-button.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';
import 'package:sugudeni/view/currency/find-currency.dart';
import 'package:sugudeni/view/customer/home/shop-now-product-grid.dart';

import '../../../l10n/app_localizations.dart';

class CustomerPayAtYourAddress extends StatefulWidget {
  const CustomerPayAtYourAddress({super.key});

  @override
  State<CustomerPayAtYourAddress> createState() => _CustomerPayAtYourAddressState();
}

class _CustomerPayAtYourAddressState extends State<CustomerPayAtYourAddress> {
  @override
  void initState() {
    super.initState();
    // Clear stored order details after page is shown (one-time use)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CartProvider>().clearOrderDetails();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider=Provider.of<CartProvider>(context,listen: false);
    
    // Get order details from cart or stored values
    final cart = cartProvider.cartResponse?.cart;
    final totalAmount = cart != null 
        ? (cart.discount == 0 ? cart.totalPrice : cart.totalPriceAfterDiscount)
        : cartProvider.lastOrderTotal ?? 0.0;
    final sellerId = cart != null && cart.cartItem.isNotEmpty
        ? cart.cartItem.first.productId.sellerId.id
        : cartProvider.lastOrderSellerId ?? '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        automaticallyImplyLeading: false,
        forceMaterialTransparency: true,
        toolbarHeight: 50.h,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, RoutesNames.customerBottomNav, (route) => false,);
                }, icon: const Icon(Icons.arrow_back_ios)),
            MyText(
              text: AppLocalizations.of(context)!.payatyouraddress,
              size: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          SizedBox()
          // Image.asset(AppAssets.clockIcon,scale: 3,)
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10.h,
          children: [
            0.height,
            SymmetricPadding(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyText(text: AppLocalizations.of(context)!.totalamount,size:10.sp ,fontWeight: FontWeight.w500),
                 FindCurrency(usdAmount: totalAmount,size:10.sp ,fontWeight: FontWeight.w500,color: blackColor,),
                //  MyText(text: "\$. ${cartProvider.cartResponse!.cart.totalPrice}",size:10.sp ,fontWeight: FontWeight.w500),
                ],
              ),
            ),
            10.height,
            SymmetricPadding(
              child: Row(
                spacing: 10.w,
                children: [
                Flexible(child: RoundButton(
                  bgColor: transparentColor,
                    height: 34.h,
                    borderColor: const Color(0xffFFB235),
                    textColor: const Color(0xffFFB235),
                    btnTextSize: 12.sp,
                    textFontWeight: FontWeight.w700,
                    borderRadius: BorderRadius.circular(5.r),
                    title: AppLocalizations.of(context)!.home, onTap: (){
                    Navigator.pushNamedAndRemoveUntil(context, RoutesNames.customerBottomNav, (route) => false,);
                })),
                // Flexible(child: RoundButton(
                //   bgColor: transparentColor,
                //     height: 34.h,
                //     borderColor: primaryColor,
                //     textColor: primaryColor,
                //     btnTextSize: 12.sp,
                //     textFontWeight: FontWeight.w700,
                //     borderRadius: BorderRadius.circular(5.r),
                //     title: "View Order", onTap: (){
                //
                // })),
                ],
              ),
            ),
            Container(
              color: whiteColor,
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 15.w,vertical:5.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(AppAssets.paymentCashOnDeliveryIcon,scale: 3,),
                    5.width,
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(text: AppLocalizations.of(context)!.cashondelivery,size:14.sp ,fontWeight: FontWeight.w600,),
                          MyText(text: AppLocalizations.of(context)!.pleasehavethisamount,size:10.sp ,
                            overflow: TextOverflow.clip,
                            fontWeight: FontWeight.w500,
                          color: textPrimaryColor.withAlpha(getAlpha(0.7)),
                          ),
                        ],
                      ),
                    ),
                    FindCurrency(usdAmount: totalAmount,size:14.sp ,fontWeight: FontWeight.w600,color: blackColor,),

                  //  MyText(text: "\$ ${cartProvider.cartResponse!.cart.totalPrice}",size:14.sp ,fontWeight: FontWeight.w600,),
                  ],
                ),
              ),
            ),
            // SymmetricPadding(child: MyText(text: "Surprise! You’ve earned some rewards!",size:10.sp ,fontWeight: FontWeight.w500)),
            // Container(
            //   color: whiteColor,
            //   child: Padding(
            //     padding:  EdgeInsets.symmetric(horizontal: 15.w,vertical:5.h),
            //     child: Row(
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       children: [
            //         Image.asset(AppAssets.sugudeniCoinIcon,scale: 2,),
            //         15.width,
            //         Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             RichText(
            //               textAlign: TextAlign.start,
            //
            //               text: TextSpan(
            //                 text: 'Congrats ! you’ve won  ',
            //                 style: TextStyle(
            //                   fontSize: 10.sp,
            //                   fontWeight: FontWeight.w500,
            //                   color: textPrimaryColor,
            //                   fontFamily: AppFonts.poppins,
            //
            //                 ),
            //                 children: [
            //
            //                   TextSpan(
            //                     text: '596\n',
            //                     style: TextStyle(
            //                       color: appPinkColor,
            //                       fontWeight: FontWeight.w500,
            //                       fontSize: 10.sp,
            //                       fontFamily: AppFonts.poppins,
            //                     ),
            //                     recognizer: TapGestureRecognizer()..onTap = () {
            //                       // Navigate to Terms & Conditions
            //                     },
            //                   ),
            //                   TextSpan(
            //                     text: 'Coins',
            //                     style: TextStyle(
            //                       color: textPrimaryColor,
            //                       fontWeight: FontWeight.w500,
            //                       fontSize: 10.sp,
            //                       fontFamily: AppFonts.poppins,
            //                     ),
            //                     recognizer: TapGestureRecognizer()..onTap = () {
            //                       // Navigate to Terms & Conditions
            //                     },
            //                   ),
            //
            //                 ],
            //               ),
            //             ),
            //           ],
            //         ),
            //         const Spacer(),
            //         Container(
            //           width: 103.w,
            //           height: 30.h,
            //           margin: EdgeInsets.all(4.sp),
            //           decoration: BoxDecoration(
            //               borderRadius: BorderRadius.circular(8.r),
            //               gradient: const LinearGradient(colors: [
            //                 Color(0xffFF6600),
            //                 Color(0xffFF099D),
            //               ])
            //           ),
            //           child: Center(
            //             child: MyText(text: "Collect All",
            //               color: whiteColor,size: 9.sp,
            //               fontWeight: FontWeight.w600,
            //             ),
            //           ),
            //         ),
            //
            //       ],
            //     ),
            //   ),
            // ),
             if (sellerId.isNotEmpty)
               ShopNowProductGridTow(crossAccess: 3,ratio: 0.52, sellerId: sellerId),



          ],
        ),
      ),
    );
  }
}
