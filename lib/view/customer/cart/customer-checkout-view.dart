import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/providers/carts/cart-provider.dart';
import 'package:sugudeni/providers/customer/customer-addresses-provider.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/checout-widget.dart';
import 'package:sugudeni/utils/customWidgets/coupon-textfield.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/global-functions.dart';

import '../../currency/find-currency.dart';

class CustomerCheckOutView extends StatefulWidget {
  const CustomerCheckOutView({super.key});

  @override
  State<CustomerCheckOutView> createState() => _CustomerCheckOutViewState();
}

class _CustomerCheckOutViewState extends State<CustomerCheckOutView> {
  bool isActivate=true;
  
  
  @override
  Widget build(BuildContext context) {
    final cartProvider=Provider.of<CartProvider>(context,listen: false);

    return Scaffold(
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
            IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: const Icon(Icons.arrow_back_ios)),
            MyText(text: AppLocalizations.of(context)!.checkout,size:14.sp ,fontWeight: FontWeight.w600,),
          ],
        ),
      ),
      body: Column(
        spacing: 10.h,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          0.height,
       Consumer<CartProvider>(builder: (context,provider,child){
         return    cartProvider.shippingId!=null?
         Container(
           color: whiteColor,
           margin: const EdgeInsets.only(bottom: 10),
           child: Padding(
             padding:  EdgeInsets.symmetric(horizontal: 12.w,vertical: 5.h),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Container(
                   height:50.h ,
                   width: 50.w,

                   decoration: BoxDecoration(
                       image: const DecorationImage(image: AssetImage(AppAssets.dummyMap),fit: BoxFit.cover),
                       borderRadius: BorderRadius.circular(10.r)
                   ),
                 ),
                 5.width,
                 Flexible(
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Row(
                         children: [
                           MyText(text: capitalizeFirstLetter(context.read<CustomerAddressProvider>().customerData!.user!.addresses[cartProvider.index!].firstname),size: 12.sp,fontWeight: FontWeight.w600),
                           10.width,
                           MyText(text: context.read<CustomerAddressProvider>().customerData!.user!.addresses[cartProvider.index!].phone,size: 10.sp,fontWeight: FontWeight.w600,color: textSecondaryColor,),
                           const Spacer(),
                           GestureDetector(
                               onTap: (){
                                 // provider.setDataForUpdate(index);
                                 Navigator.pushNamed(context, RoutesNames.customerAddressView);

                               },
                               child: MyText(text: AppLocalizations.of(context)!.change,color: primaryColor,size: 12.sp,fontWeight: FontWeight.w600))
                         ],
                       ),
                       Row(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Icon(Icons.location_pin,color: const Color(0xff009EE7),size: 12.sp,),
                           5.width,
                           SizedBox(
                             width: 200.w,
                             child: MyText(
                               overflow: TextOverflow.clip,
                               text: "${context.read<CustomerAddressProvider>().customerData!.user!.addresses[cartProvider.index!].street} ${context.read<CustomerAddressProvider>().customerData!.user!.addresses[cartProvider.index!].country}",size: 12.sp,fontWeight: FontWeight.w500,color: textSecondaryColor,),
                             //  text: "456 Red Pepper Drive, Spicetown Heights, San Diego, CA 92103, USA.",size: 12.sp,fontWeight: FontWeight.w500,color: textSecondaryColor,),
                           ),

                         ],
                       ),
                     ],
                   ),
                 )
               ],
             ),
           ),
         ):
         GestureDetector(
           onTap: (){
             context.read<CustomerAddressProvider>().clearResources();
             cartProvider.setCheckout(true);
             Navigator.pushNamed(context, RoutesNames.customerAddressView);
           },
           child: Container(
             decoration: BoxDecoration(
                 border: Border.all(color: const Color(0xff00FFF2)),
                 borderRadius: BorderRadius.circular(20.r)
             ),
             margin: EdgeInsets.symmetric(horizontal: 15.w),
             child: Padding(
               padding:  EdgeInsets.symmetric(vertical: 15.h),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 spacing: 10.w,
                 children: [
                   Image.asset(AppAssets.addIcon,color: const Color(0xff00FFF2),scale: 3,),
                   MyText(text: AppLocalizations.of(context)!.selectaddress,color: const Color(0xff00FFF2),size: 12.sp,fontWeight: FontWeight.w600)
                 ],
               ),
             ),
           ),
         );
       }),
          Consumer<CartProvider>(builder: (context,provider,child){
            if (provider.cartResponse == null) {
              return const Expanded(
                flex: 21,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (provider.cartResponse!.cart.cartItem.isEmpty) {
              return const Expanded(
                flex: 21,
                child: Center(
                  child: Text('Your cart is empty'),
                ),
              );
            }

            // Filter to only show selected items
            final selectedCartItems = provider.cartResponse!.cart.cartItem
                .where((item) => provider.selectedIndex.contains(item.id))
                .toList();
            
            if (selectedCartItems.isEmpty) {
              return const Expanded(
                flex: 21,
                child: Center(
                  child: Text('No items selected for checkout'),
                ),
              );
            }
            
            return Expanded(
              flex: 21,
              child: ListView.builder(
                  itemCount: selectedCartItems.length,
                  itemBuilder: (context,index){
                    var cartData = selectedCartItems[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: CheckOutWidget(
                        img: cartData.productId.imgCover,
                        productId: cartData.productId.id,
                        bulk: cartData.productId.bulk,
                        title: cartData.productId.title,
                        quantity: cartData.quantity.toString(),
                        price: cartData.price,
                        priceAfterDiscount: cartData.priceAfterDiscount,
                        incrementPressed: (){
                          provider.incrementQuantity(cartData.id,context);
                        },
                        decrementPressed: (){
                          provider.decrementQuantity(cartData.id,context);
                        },
                        onChange: (v){
                          provider.toggleItem(cartData.id); // Use cart item ID, not product ID
                        },
                        isSelected: provider.selectedIndex.contains(cartData.id), // Use cart item ID
                        deliverySlot: provider.deliverySlot != null
                            ? "${provider.deliverySlot!.startTime}-${provider.deliverySlot!.endTime} ${capitalizeFirstLetter(provider.deliverySlot!.title)}"
                            : "Select delivery slot",
                      ),
                    );
                  }),
            );
          }),

          CouponTextField(controller: TextEditingController(),),
          Container(
            width: double.infinity,
            color: whiteColor,
            child: Padding(
              padding:  EdgeInsets.all(12.sp),
              child: Column(
                spacing: 5.h,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer<CartProvider>(
                    builder: (context, provider, child) {
                      // Calculate subtotal for selected items only
                      final selectedItemsCount = provider.getSelectedItemsCount();
                      final selectedItemsSubtotal = provider.getSelectedItemsSubtotal();
                      
                      return Row(
                        children: [
                          MyText(text: AppLocalizations.of(context)!.merchandisesubtotal,size: 12.sp,fontWeight: FontWeight.w600,),
                          MyText(text: " ($selectedItemsCount ${selectedItemsCount == 1 ? AppLocalizations.of(context)!.item : AppLocalizations.of(context)!.items})",size: 10.sp,fontWeight: FontWeight.w600,color: textSecondaryColor,),
                          const Spacer(),
                          FindCurrency(
                            usdAmount: selectedItemsSubtotal,
                            size: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: blackColor,
                          ),
                        ],
                      );
                    },
                  ),
                  Consumer<CartProvider>(
                    builder: (context, provider, child) {
                      // Show shipping fee (currently 0, can be updated later)
                      final shippingFee = 0.0;
                      
                      return Row(
                        children: [
                          MyText(text: "${AppLocalizations.of(context)!.shippingfee} : ",size: 12.sp,fontWeight: FontWeight.w600,),
                          const Spacer(),
                          FindCurrency(
                            usdAmount: shippingFee,
                            size: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: blackColor,
                          ),
                        ],
                      );
                    },
                  ),
                  // Row(
                  //   children: [ Image.asset(AppAssets.voucherIcon,scale: 3,),
                  //     3.width,
                  //     MyText(text: "Voucher",size: 12.sp,fontWeight: FontWeight.w600,),
                  //     const Spacer(),
                  //     MyText(text: "\$. 0",size: 12.sp,fontWeight: FontWeight.w600,),
                  //
                  //
                  //   ],
                  // ),
                  // Row(
                  //   children: [ Image.asset(AppAssets.shippingVoucherIcon,scale: 3,),
                  //     3.width,
                  //     MyText(text: "Shipping Fee Voucher",size: 12.sp,fontWeight: FontWeight.w600,),
                  //     const Spacer(),
                  //     MyText(text: "\$. 0",size: 12.sp,fontWeight: FontWeight.w600,),
                  //
                  //
                  //   ],
                  // ),
                  // Row(
                  //   children: [
                  //     Image.asset(AppAssets.sugudeniCoinIcon,scale: 3,),
                  //     3.width,
                  //     MyText(text: "SUGUDENI Coins",size: 12.sp,fontWeight: FontWeight.w600,),
                  //     const Spacer(),
                  //     MyText(text: " Redeem \$. 2.00",size: 10.sp,fontWeight: FontWeight.w600,color: textSecondaryColor,),
                  //
                  //     SizedBox(
                  //       width: 30,
                  //       child: FittedBox(
                  //         child: Switch(
                  //             thumbColor: WidgetStatePropertyAll(whiteColor.withAlpha(getAlpha(0.5))),
                  //             activeColor: primaryColor,
                  //             value: isActivate, onChanged: (v){
                  //           setState(() {
                  //             isActivate=!isActivate;
                  //           });
                  //         }),
                  //       ),
                  //     )
                  //
                  //
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Divider(
            color: greyColor.shade300,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Text(
              textAlign: TextAlign.center,
              AppLocalizations.of(context)!.thanksforshoppingwith,
            style: GoogleFonts.shrikhand(
              color: primaryColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,

            ),
            ),
          ),

          Container(
            color: whiteColor,
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: 12.w,vertical: 10.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Consumer<CartProvider>(
                        builder: (context, provider, child) {
                          // Calculate total for selected items only (subtotal + shipping)
                          final selectedItemsSubtotal = provider.getSelectedItemsSubtotal();
                          final shippingFee = 0.0; // Shipping fee (can be updated later if needed)
                          final totalAmount = selectedItemsSubtotal + shippingFee;
                          
                          return Row(
                            children: [
                              MyText(text: "${AppLocalizations.of(context)!.total} : ",size: 12.sp,fontWeight: FontWeight.w600),
                              FindCurrency(
                                usdAmount: totalAmount,
                                size: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: primaryColor,
                              ),
                            ],
                          );
                        },
                      ),
                      Row(
                        children: [
                          MyText(text: AppLocalizations.of(context)!.vatincluded,size: 9.sp,fontWeight: FontWeight.w600),
                        ],
                      ),


                    ],
                  ),
                  10.width,
                  GestureDetector(
                    onTap: (){
                      if(cartProvider.shippingId==null){
                        showSnackbar(context, AppLocalizations.of(context)!.pleaseselectyourdeliveryaddress,color: redColor);
                        return;
                      }
                      if(cartProvider.deliverySlotId==null){
                        showSnackbar(context, "Please select a delivery slot",color: redColor);
                        return;
                      }
                      Navigator.pushNamed(context, RoutesNames.customerSelectPaymentMethodView);
                    },
                    child: Container(
                    //  width: 117.w,
                      height: 34.h,
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(5.r)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Center(
                          child: MyText(text: AppLocalizations.of(context)!.placeorder,color: whiteColor,size: 12.sp,fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                  10.width,
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
// Checkbox(value: false, onChanged: (v){},
//   shape:  ContinuousRectangleBorder(
//       side: BorderSide(
//           color: textPrimaryColor.withAlpha(getAlpha(0.7)),
//           width: 1
//       ),
//
//       borderRadius: BorderRadius.circular(8.r)
//   ),
//   side: BorderSide(
//       width: 1
//   ),
// ),