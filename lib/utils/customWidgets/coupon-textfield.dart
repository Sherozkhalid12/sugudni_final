import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/models/cart/ApplyCouponModel.dart';
import 'package:sugudeni/models/coupon/ApplyCouponModel.dart';
import 'package:sugudeni/providers/carts/cart-provider.dart';
import 'package:sugudeni/providers/loading-provider.dart';
import 'package:sugudeni/repositories/products/product-repository.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/round-button.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/global-functions.dart';
import '../../l10n/app_localizations.dart';

class CouponTextField extends StatelessWidget {
  final TextEditingController controller;
  const CouponTextField({super.key,required this.controller});

  @override
  Widget build(BuildContext context) {
    final couponCode=TextEditingController();
    final loadingProvider=Provider.of<LoadingProvider>(context,listen: false);
    return  SymmetricPadding(
      child: TextFormField(
        controller: couponCode,
        style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 10.sp,
            color: const Color(0xff545454)
        ),
        onChanged: (v){
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(15),
          hintText: AppLocalizations.of(context)!.couponcode,
          hintStyle: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 10.sp,
              color: const Color(0xff545454)
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.all(3.0),
            child: RoundButton(
                height: 1.h,
                width: 120.w,
                isLoad: true,
                borderRadius:BorderRadius.circular(20.r) ,
                btnTextSize: 10.sp,
                title: AppLocalizations.of(context)!.applycoupon,
                onTap: ()async{
                  if(couponCode.text.isEmpty){
                    showSnackbar(context, AppLocalizations.of(context)!.entercouponcode,color: redColor);
                    return;
                  }
                  var model=Coupon(code: couponCode.text.trim().toString());
                  try{
                    loadingProvider.setLoading(true);
                    await ProductRepository.applyCoupon(model, context).then((v) async {
                      loadingProvider.setLoading(false);
                     if(context.mounted){
                       showSnackbar(context, AppLocalizations.of(context)!.couponcodeapplied,color: greenColor);
                       await context.read<CartProvider>().getCartData(context);

                       couponCode.clear();
                     }
                    });
                  }catch(e){
                    loadingProvider.setLoading(false);
                  }
            }),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.r),
            borderSide: const BorderSide(
              color: blackColor,

            ),
          ),
          enabledBorder:OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.r),
            borderSide: const BorderSide(
              color: blackColor,

            ),
          ) ,
          focusedBorder:OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.r),
            borderSide: const BorderSide(
              color: blackColor,
            ),
          ),
        ),
      ),
    );
  }
}
