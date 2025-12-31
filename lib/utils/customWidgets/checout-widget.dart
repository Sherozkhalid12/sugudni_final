import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/providers/carts/cart-provider.dart';
import 'package:sugudeni/providers/loading-provider.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/cached-network-image.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/extensions/dialog-extension.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/view/currency/find-currency.dart';
import '../../l10n/app_localizations.dart';

import '../../models/coupon/ApplyCouponModel.dart';
import '../../repositories/products/product-repository.dart';
import '../global-functions.dart';

class CheckOutWidget extends StatelessWidget {
  final String?title;
  final String?productId;
  final String?deliverySlot;
  final String?img;
  final double? price;
  final double?priceAfterDiscount;
  final String?quantity;
  final VoidCallback? incrementPressed;
  final VoidCallback? decrementPressed;
  final ValueChanged<bool?> onChange;
  final bool? isSelected;
  final bool? bulk;
  const CheckOutWidget({super.key, this.title, this.img, required this.price, this.priceAfterDiscount, this.quantity, this.incrementPressed, this.decrementPressed, required this.onChange, this.isSelected, this.deliverySlot, this.bulk=false, this.productId});

  @override
  Widget build(BuildContext context) {
    final controller=TextEditingController();
    final loadingProvider=Provider.of<LoadingProvider>(context,listen: false);

    return  Container(
      margin: EdgeInsets.symmetric(horizontal:15.w,vertical: 5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              MyCachedNetworkImage(
                  height:65.h ,
                  width: 65.w,
                  radius: 6.r,
                  imageUrl: bulk==true? img!:"${ApiEndpoints.productUrl}/$img"),
              // Container(
              //   height:65.h ,
              //   width: 65.w,
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(6.r),
              //       image:   DecorationImage(image: NetworkImage(
              //           "${ApiEndpoints.productUrl}/$img"),fit: BoxFit.contain)
              //   ),
              // ),
              10.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 100.w,
                    child: MyText(
                      overflow: TextOverflow.clip,
                      text:title?? "Red Chili A Fiery Spice that Adds",size: 10.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  // 3.height,
                  // MyText(text: "AMY Online Shopping Store",size: 8.sp,
                  //   color: textPrimaryColor.withOpacity(0.7),
                  //   fontWeight: FontWeight.w600,
                  // ),
                  3.height,
                  priceAfterDiscount==0? FindCurrency(usdAmount: price??1.0,size: 10.sp, fontWeight: FontWeight.w500,color: appRedColor,):FindCurrency(usdAmount: priceAfterDiscount??1.0,size: 10.sp, fontWeight: FontWeight.w500,color: appRedColor,),

                  //MyText(text: "\$  ${priceAfterDiscount==0?price:priceAfterDiscount}",size: 10.sp, fontWeight: FontWeight.w500,color: appRedColor,),




                ],
              ),
              const Spacer(),
              Column(
                children: [
                  GestureDetector(
                      onTap: (){
                        context.showTextFieldDialog(
                          keyboardType: TextInputType.text,
                            controller:controller,
                            title: AppLocalizations.of(context)!.applycoupon,
                            confirmText: AppLocalizations.of(context)!.apply,
                            onNo: (){},onYes: ()async{
                          if(controller.text.isEmpty){
                            showSnackbar(context, AppLocalizations.of(context)!.entercouponcode,color: redColor);
                            return;
                          }
                          var model=Coupon(
                              code: controller.text.trim().toString(),
                              productId: productId
                          );
                          try{
                            //loadingProvider.setLoading(true);
                            await ProductRepository.applyCoupon(model, context).then((v) async {
                            //  loadingProvider.setLoading(false);

                              if(context.mounted){
                                Navigator.pop(context);
                                showSnackbar(context, AppLocalizations.of(context)!.couponcodeapplied,color: greenColor);
                                await context.read<CartProvider>().getCartData(context);

                                controller.clear();
                              }
                            });
                          }catch(e){
                          //  loadingProvider.setLoading(false);
                          }
                        });
                      },
                      child: Image.asset(AppAssets.coupon,scale: 2,color: primaryColor,)),
                  MyText(text: "Qty: $quantity",size: 10.sp, fontWeight: FontWeight.w500,color: textSecondaryColor),
                ],
              ),

            ],
          ),
          10.height,
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.r),
                border: Border.all(color: primaryColor)
            ),
            //     margin: EdgeInsets.symmetric(horizontal:15.w,vertical: 5.h),
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal:15.w,vertical: 5.h),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyText(text: AppLocalizations.of(context)!.standarddelivery,size:10.sp ,fontWeight: FontWeight.w600),
                      // MyText(text: "\$. 15.00",size:10.sp ,fontWeight: FontWeight.w600),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(AppAssets.deliveryVehicleIcon,scale: 3,),
                      3.width,
                      MyText(text:deliverySlot?? "Expected Delivery Time by 3-6 jan",size:8.sp ,fontWeight: FontWeight.w500,color: textSecondaryColor,),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
