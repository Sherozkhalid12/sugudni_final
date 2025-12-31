import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/providers/carts/cart-provider.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';
import 'package:sugudeni/view/customer/cart/customer-add-card-view.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/constants/colors.dart';

class CustomerSelectPaymentMethodView extends StatelessWidget {
  const CustomerSelectPaymentMethodView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: whiteColor,
        automaticallyImplyLeading: false,
        forceMaterialTransparency: true,
        toolbarHeight: 50.h,
        flexibleSpace: Container(
          color: whiteColor,
        ),
        title: Row(
          children: [
            IconButton(onPressed: (){                  Navigator.pop(context);
            }, icon: const Icon(Icons.arrow_back_ios)),
            MyText(text: AppLocalizations.of(context)!.selectpaymentmethod,size:14.sp ,fontWeight: FontWeight.w600,),
          ],
        ),
      ),
      body: Column(
        children: [
          const Spacer(),
          Container(
            color: whiteColor,
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: 12.w,vertical: 15.h),
              child: Column(
                spacing: 15.h,
                children: [
                  GestureDetector(
                    onTap: (){
                      context.read<CartProvider>().changePaymentMethod(PaymentMethods.cashOnDelivery);

                      Navigator.pushNamed(context, RoutesNames.customerCashOnDeliveryView);
                    },
                    child: Row(
                      children: [
                        Image.asset(AppAssets.paymentCashOnDeliveryIcon,scale: 3,),
                        15.width,
                        MyText(text: AppLocalizations.of(context)!.cashondelivery,size:14.sp ,fontWeight: FontWeight.w600,),
                        const Spacer(),
                        const Icon(Icons.arrow_forward_ios_outlined)
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      context.read<CartProvider>().changePaymentMethod(PaymentMethods.stripe);
                      Navigator.pushNamed(context, RoutesNames.customerCashOnDeliveryView);
                    },
                    child: Row(
                      children: [
                        Image.asset(AppAssets.stripe,scale:8,),
                        15.width,
                        MyText(text: "Stripe",size:14.sp ,fontWeight: FontWeight.w600,),
                        const Spacer(),
                        const Icon(Icons.arrow_forward_ios_outlined)
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      context.read<CartProvider>().changePaymentMethod(PaymentMethods.orangeMoney);
                      Navigator.pushNamed(context, RoutesNames.customerCashOnDeliveryView);
                    },
                    child: Row(
                      children: [
                        Image.asset(AppAssets.orangeMoneyIcon,scale:18,),
                        15.width,
                        MyText(text: "Orange Money",size:14.sp ,fontWeight: FontWeight.w600,),
                        const Spacer(),
                        const Icon(Icons.arrow_forward_ios_outlined)
                      ],
                    ),
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Container(
                  //       height: 155.h,
                  //       width: 269.w,
                  //       decoration: BoxDecoration(
                  //           color: const Color(0xffF1F4FE),
                  //           borderRadius: BorderRadius.circular(11.r)
                  //       ),
                  //       child: Column(
                  //         children: [
                  //           Row(
                  //             mainAxisAlignment: MainAxisAlignment.end,
                  //             children: [
                  //               Icon(Icons.check_circle,color: Colors.blue,size: 15.sp,),
                  //             ],
                  //           ),
                  //           Padding(
                  //             padding:  EdgeInsets.symmetric(horizontal: 12.sp),
                  //             child: Column(
                  //               children: [
                  //                 10.height,
                  //                 Row(
                  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //                   children: [
                  //                     Image.asset(AppAssets.masterCardIcon,scale: 3,),
                  //                     Container(
                  //                       height: 35.h,
                  //                       width:35.w ,
                  //                       decoration: const BoxDecoration(
                  //                           shape: BoxShape.circle,
                  //                           color: Color(0xffE5EBFC)
                  //                       ),
                  //                       child: Center(
                  //                         child: Image.asset(AppAssets.settingIcon,scale: 3,),
                  //                       ),
                  //                     )
                  //                   ],
                  //                 ),
                  //                 30.height,
                  //                 const Row(
                  //                   crossAxisAlignment: CrossAxisAlignment.center,
                  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //                   children: [
                  //                     MyText(text: "* * * *     * * * * "),
                  //                     MyText(text: "157 "),
                  //                   ],
                  //                 ),
                  //                 15.height,
                  //                 Row(
                  //                   crossAxisAlignment: CrossAxisAlignment.center,
                  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //                   children: [
                  //                     Text('AMANDA',style: GoogleFonts.nunitoSans(
                  //                         fontSize: 10.sp,
                  //                         fontWeight: FontWeight.w600
                  //                     ),),
                  //                     Text('12/02',style: GoogleFonts.nunitoSans(
                  //                         fontSize: 10.sp,
                  //                         fontWeight: FontWeight.w600
                  //                     ),),
                  //
                  //                   ],
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //     GestureDetector(
                  //       onTap: (){
                  //         showModalBottomSheet(
                  //             isScrollControlled: true,
                  //             context: context, builder: (context){
                  //
                  //           return Padding(
                  //             padding:EdgeInsets.only(
                  //                 bottom: MediaQuery.of(context).viewInsets.bottom),
                  //             child: const CustomerAddCardView(),
                  //           );
                  //         });
                  //       //  Navigator.pushNamed(context, RoutesNames.customerAddCardView);
                  //       },
                  //       child: Container(
                  //         height: 155.h,
                  //         width: 43.w,
                  //         decoration: BoxDecoration(
                  //             color: primaryColor,
                  //             borderRadius: BorderRadius.circular(11.r)
                  //         ),
                  //         child: Center(
                  //           child: Image.asset(AppAssets.addIcon,scale: 3),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
