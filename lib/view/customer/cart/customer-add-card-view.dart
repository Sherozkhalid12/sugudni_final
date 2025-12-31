import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/providers/carts/cart-provider.dart';
import 'package:sugudeni/providers/loading-provider.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/round-button.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/customWidgets/text-field.dart';
import 'package:sugudeni/utils/extensions/media-query.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/orders/CashOrderModel.dart';
import '../../../repositories/carts/cart-repository.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/global-functions.dart';

class CustomerAddCardView extends StatelessWidget {
  const CustomerAddCardView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight=context.screenHeight;
    final loadingProvider=Provider.of<LoadingProvider>(context,listen: false);
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            // height: 77.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xffF8FAFF),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(9.r),
                topLeft: Radius.circular(9.r),
              )
            ),
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: 12.w,vertical: 20.h),
              child: MyText(text: AppLocalizations.of(context)!.addcard,size:22.sp ,fontWeight: FontWeight.w700),
            ),
          ),
          30.height,
          SymmetricPadding(
            child: Column(
              mainAxisSize: MainAxisSize.min,

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                text(title: AppLocalizations.of(context)!.cardholder),
                5.height,
                CustomTextFiled(
                  borderRadius: 15.r,
                  isBorder: true,
                  isShowPrefixIcon: false,
                  isFilled: true,
                  hintText: AppLocalizations.of(context)!.required,

                ),
                20.height,
                text(title: AppLocalizations.of(context)!.cardnumber),
                5.height,
                CustomTextFiled(
                  keyboardType: TextInputType.number,

                  borderRadius: 15.r,
                  isBorder: true,
                  isShowPrefixIcon: false,
                  isFilled: true,
                  hintText: AppLocalizations.of(context)!.required,

                ),
                20.height,
                Row(
                  spacing: 5.w,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          text(title: AppLocalizations.of(context)!.valid),
                          5.height,
                          CustomTextFiled(
                            keyboardType: TextInputType.number,

                            borderRadius: 15.r,
                            isBorder: true,
                            isShowPrefixIcon: false,
                            isFilled: true,
                            hintText: AppLocalizations.of(context)!.required,

                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          text(title: AppLocalizations.of(context)!.cvv),
                          5.height,
                          CustomTextFiled(
                            keyboardType: TextInputType.number,
                            borderRadius: 15.r,
                            isBorder: true,
                            isShowPrefixIcon: false,
                            isFilled: true,
                            hintText: AppLocalizations.of(context)!.required,

                          ),
                        ],
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
        20.height,
        //  const Spacer(),
          SymmetricPadding(
            child: RoundButton(
                borderRadius: BorderRadius.circular(9.r),
                title: AppLocalizations.of(context)!.paynow,
                isLoad: true,
                onTap: ()async{
                  loadingProvider.setLoading(true);
              var model=CashOrderModel(
                shipping:context.read<CartProvider>().shippingId!,
                deliverySlot:context.read<CartProvider>().deliverySlotId!,

              );
              await CartRepository.createCashOrder(model,context.read<CartProvider>().cartResponse!.cart.id, context).then((v){
                loadingProvider.setLoading(false);
               if(context.mounted){
                 showSnackbar(context, AppLocalizations.of(context)!.checkoutcreatedsuccessfully,color: greenColor);
                 Navigator.pushNamedAndRemoveUntil(context, RoutesNames.customerBottomNav, (route) => false,);
               }
              }).onError((err,e){
                if(context.mounted){
                  showSnackbar(context, err.toString(),color: redColor);
                  loadingProvider.setLoading(false);
                }
              });

            }),
          ),
          20.height,
        ],
      ),
    );
  }
  Widget text({required String title}){
    return              MyText(text: title,size: 13.sp,fontWeight: FontWeight.w600,);

  }
}
