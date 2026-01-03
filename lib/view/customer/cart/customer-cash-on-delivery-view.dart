import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/models/orders/CashOrderModel.dart';
import 'package:sugudeni/providers/carts/cart-provider.dart';
import 'package:sugudeni/providers/loading-provider.dart';
import 'package:sugudeni/repositories/carts/cart-repository.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/round-button.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';
import 'package:sugudeni/view/currency/find-currency.dart';
import 'package:sugudeni/view/customer/cart/webview-flutter.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/constants/fonts.dart';

class CustomerCashOnDeliveryView extends StatelessWidget {
  const CustomerCashOnDeliveryView({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider=Provider.of<CartProvider>(context,listen: false);
    final loadingProvider=Provider.of<LoadingProvider>(context,listen: false);

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
            IconButton(onPressed: (){                  Navigator.pop(context);
            }, icon: const Icon(Icons.arrow_back_ios)),
            MyText(text:cartProvider.selectedPaymentMethod==PaymentMethods.cashOnDelivery?AppLocalizations.of(context)!.cashondelivery:
            cartProvider.selectedPaymentMethod==PaymentMethods.stripe?'Stripe':'Orange Money',size:14.sp ,fontWeight: FontWeight.w600,),
          ],
        ),
      ),
      body: SymmetricPadding(
        child: Column(
          children: [
            20.height,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10.w,
              children: [
                Image.asset(AppAssets.paymentCashOnDeliveryIcon,scale: 3,),
                Flexible(
                  child: Column(
                    children: [
                      MyText(
                        overflow: TextOverflow.clip,
                        text:AppLocalizations.of(context)!.youmaypayincash,size: 11.sp,),
                      RichText(
                        textAlign: TextAlign.start,

                        text: TextSpan(
                          text: '${AppLocalizations.of(context)!.beforereceivingconfirthattheair}  ',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w400,
                            color: textPrimaryColor,
                            fontFamily: AppFonts.poppins,

                          ),
                          children: [

                            TextSpan(
                              text: 'SUGUDENI',
                              style: TextStyle(
                                color: textPrimaryColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 11.sp,
                                fontFamily: AppFonts.poppins,
                              ),
                              recognizer: TapGestureRecognizer()..onTap = () {
                                // Navigate to Terms & Conditions
                              },
                            ),

                          ],
                        ),
                      ),

                      MyText(
                        overflow: TextOverflow.clip,
                        text:'''

${AppLocalizations.of(context)!.beforeyoumakepayment}''',size: 11.sp,),

                    ],
                  ),
                )
              ],
            ),
            const Spacer(),
            Row(
              children: [
                MyText(text: AppLocalizations.of(context)!.subtotal,size: 12.sp,fontWeight: FontWeight.w600,),
                const Spacer(),
                FindCurrency(usdAmount: cartProvider.cartResponse!.cart.discount==0? cartProvider.cartResponse!.cart.totalPrice:cartProvider.cartResponse!.cart.totalPriceAfterDiscount,size: 12.sp,fontWeight: FontWeight.w600,color: blackColor,),
              ],
            ),
            5.height,
            Row(
              children: [
                MyText(text: AppLocalizations.of(context)!.cashpaymentfee,size: 12.sp,fontWeight: FontWeight.w600,),
                const Spacer(),
                FindCurrency(usdAmount: 0,size: 12.sp,fontWeight: FontWeight.w600,color: blackColor,),
              ],
            ),
           // text(title: AppLocalizations.of(context)!.subtotal, value: "\$. ${cartProvider.cartResponse!.cart.totalPrice}"),
            5.height,
           //text(title: AppLocalizations.of(context)!.cashpaymentfee, value: "\$. 0"),           5.height,
            Row(
              children: [
                MyText(text: AppLocalizations.of(context)!.totalamount,size: 12.sp,fontWeight: FontWeight.w600,),
                const Spacer(),
                FindCurrency(usdAmount: cartProvider.cartResponse!.cart.discount==0? cartProvider.cartResponse!.cart.totalPrice:cartProvider.cartResponse!.cart.totalPriceAfterDiscount,size: 12.sp,fontWeight: FontWeight.w600,color: blackColor,),
              ],
            ),
            //text(title: AppLocalizations.of(context)!.totalamount, value: "\$. ${cartProvider.cartResponse!.cart.totalPrice}"),
           20.height,
            RoundButton(
                borderRadius: BorderRadius.circular(8.r),
                title:  AppLocalizations.of(context)!.confirmpayment,
                isLoad: true,

                ///cash on delivery =======================================================================
                onTap:cartProvider.selectedPaymentMethod==PaymentMethods.cashOnDelivery?
                    ()async{
              loadingProvider.setLoading(true);
              var model=CashOrderModel(
                  shipping:context.read<CartProvider>().shippingId!,
                  deliverySlot:context.read<CartProvider>().deliverySlotId!,
              );
              await CartRepository.createCashOrder(
                  model,context.read<CartProvider>().cartResponse!.cart.id, context).then((v) async {
                loadingProvider.setLoading(false);
                if(context.mounted){
                  final cartProvider = context.read<CartProvider>();
                  // Store order details before removing items
                  cartProvider.storeOrderDetails();
                  showSnackbar(context, AppLocalizations.of(context)!.checkoutcreatedsuccessfully,color: greenColor);
                  // Remove only selected items from cart, not all items
                  await cartProvider.removeSelectedItemsFromCart(context);
                  Navigator.pushNamed(context, RoutesNames.customerPayAtYourAddressView);
                }
              }).onError((err,e){
                if(context.mounted){
                  showSnackbar(context, err.toString(),color: redColor);
                  loadingProvider.setLoading(false);
                }
              });
                      ///Payment with Stripe =======================================================================
                }:cartProvider.selectedPaymentMethod==PaymentMethods.stripe?
                    ()async{
                  loadingProvider.setLoading(true);
                  var model=CashOrderModel(
                    shipping:context.read<CartProvider>().shippingId!,
                    deliverySlot:context.read<CartProvider>().deliverySlotId!,
                  );
                  await CartRepository.createCheckoutOrderForStripe(
                      model,context.read<CartProvider>().cartResponse!.cart.id, context).then((v){
                    loadingProvider.setLoading(false);
                    if(context.mounted){
                     // showSnackbar(context, "Checkout created successfully",color: greenColor);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>WebViewScreen(url: v.sessions.url, paymentMethod: 'stripe')));
                     // showSnackbar(context, v.sessions.url,color: greenColor);
                     //  context.read<CartProvider>().clearResources();
                     //  Navigator.pushNamed(context, RoutesNames.customerPayAtYourAddressView);
                    }
                  }).onError((err,e){
                    if(context.mounted){
                      showSnackbar(context, err.toString(),color: redColor);
                      loadingProvider.setLoading(false);
                    }
                  });
                  //Navigator.pushNamed(context, RoutesNames.customerPayAtYourAddressView);
                }:
                ///Payment with Orange Money =======================================================================

                    ()async{
                  loadingProvider.setLoading(true);
                  var model=CashOrderModel(
                    shipping:context.read<CartProvider>().shippingId!,
                    deliverySlot:context.read<CartProvider>().deliverySlotId!,
                  );
                  await CartRepository.createCheckoutOrderForOrangeMoney(
                      model,context.read<CartProvider>().cartResponse!.cart.id, context).then((v){
                    loadingProvider.setLoading(false);
                    if(context.mounted){
                      // showSnackbar(context, "Checkout created successfully",color: greenColor);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>WebViewScreen(url: v.sessions.url, paymentMethod: 'orangemoney')));
                      // showSnackbar(context, v.sessions.url,color: greenColor);
                      //  context.read<CartProvider>().clearResources();
                      //  Navigator.pushNamed(context, RoutesNames.customerPayAtYourAddressView);
                    }
                  }).onError((err,e){
                    if(context.mounted){
                      showSnackbar(context, err.toString(),color: redColor);
                      loadingProvider.setLoading(false);
                    }
                  });
                  //Navigator.pushNamed(context, RoutesNames.customerPayAtYourAddressView);
                }),
            20.height,
          ],
        ),
      ),
    );
  }
  Widget text({required String title, required String value}){
    return  Row(
      children: [
        MyText(text: title,size: 12.sp,fontWeight: FontWeight.w600,),
        const Spacer(),
        MyText(text:value,size: 12.sp,fontWeight: FontWeight.w600,),


      ],
    );
  }
}
