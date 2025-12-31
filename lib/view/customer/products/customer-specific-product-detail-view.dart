import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/models/orders/CashOrderModel.dart';
import 'package:sugudeni/providers/customer/customer-addresses-provider.dart';
import 'package:sugudeni/repositories/orders/customer-order-repository.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/app-bar-title-widget.dart';
import 'package:sugudeni/utils/customWidgets/cached-network-image.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/round-button.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:sugudeni/view/currency/find-currency.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/orders/GetAllOrdersCutomerModel.dart';
import '../../../providers/carts/cart-provider.dart';
import '../../../utils/routes/routes-name.dart';


class CustomerOrderDetailView extends StatelessWidget {
  final Order orderSellerResponse;
  final bool? isOrderAgain;
  const CustomerOrderDetailView({super.key, required this.orderSellerResponse, this.isOrderAgain=false});

  @override
  Widget build(BuildContext context) {
    final cartProvider=Provider.of<CartProvider>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        toolbarHeight: 70.h,
        automaticallyImplyLeading: false,
        title: AppBarTitleWidget(title: AppLocalizations.of(context)!.orderdetail),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      isOrderAgain==false? SizedBox():  Consumer<CartProvider>(builder: (context,provider,child){
            return    provider.shippingId!=null?
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
                              MyText(text: capitalizeFirstLetter(context.read<CustomerAddressProvider>().customerData!.user!.addresses[provider.index!].firstname),size: 12.sp,fontWeight: FontWeight.w600),
                              10.width,
                              MyText(text: context.read<CustomerAddressProvider>().customerData!.user!.addresses[provider.index!].phone,size: 10.sp,fontWeight: FontWeight.w600,color: textSecondaryColor,),
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
                                  text: "${context.read<CustomerAddressProvider>().customerData!.user!.addresses[provider.index!].street} ${context.read<CustomerAddressProvider>().customerData!.user!.addresses[provider.index!].country}",size: 12.sp,fontWeight: FontWeight.w500,color: textSecondaryColor,),
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
                provider.setCheckout(true);
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

          Container(
            //  height: 162.h,
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 10.h),
            decoration: const BoxDecoration(
              color: whiteColor,
            ),
            child: Padding(
              padding: EdgeInsets.all(12.sp),
              child: Column(
                children: [
                  Row(
                    children: [
                      MyText(
                        text: "${AppLocalizations.of(context)!.ordernumber} :",
                        fontWeight: FontWeight.w500,
                        size: 12.sp,
                      ),
                      10.width,
                      MyText(
                        text: orderSellerResponse.id,
                        //text: orderSellerResponse.id,
                        fontWeight: FontWeight.w500,
                        color: textPrimaryColor.withOpacity(0.70),
                        size: 10.sp,
                      ),
                    ],
                  ),
                  5.height,
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: orderSellerResponse.cartItem.length,
                      itemBuilder: (context,index){
                        var cartItemData=orderSellerResponse.cartItem[index];
                        return  Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Material(
                            elevation: 2,
                            borderRadius: BorderRadius.circular(5.r),
                            child: Container(
                              // height: 65.h,
                              // width: 302.w,
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(5.r),
                                  color: const Color(0xffFBFBFB)),
                              child: Padding(
                                padding: EdgeInsets.all(8.sp),
                                child: Row(
                                  children: [
                                    MyCachedNetworkImage(
                                        height: 51.h,
                                        width: 51.w,
                                        imageUrl:cartItemData.productId.bulk==true?
                                            cartItemData.productId.imgCover
                                            :"${ApiEndpoints.productUrl}/${cartItemData.productId!.imgCover}"),
                                    // Container(
                                    //   height: 51.h,
                                    //   width: 51.w,
                                    //   decoration: BoxDecoration(
                                    //       borderRadius:
                                    //       BorderRadius.circular(6.r),
                                    //       image:  DecorationImage(
                                    //           image: NetworkImage("${ApiEndpoints.productUrl}/${orderData.product!.imgCover}"),
                                    //           fit: BoxFit.cover)),
                                    // ),
                                    10.width,
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          MyText(
                                            overflow: TextOverflow.clip,
                                            text:
                                            capitalizeFirstLetter(cartItemData.productId.title),
                                            fontWeight: FontWeight.w600,
                                            size: 12.sp,
                                          ),
                                          MyText(
                                            text: "QTY: ${cartItemData.quantity}",
                                            fontWeight: FontWeight.w600,
                                            size: 12.sp,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    cartItemData.totalProductDiscount==0?
                                        FindCurrency(usdAmount: cartItemData.price,
                                          size: 10.sp,
                                          fontWeight: FontWeight.w600,color: blackColor):
                                    FindCurrency(usdAmount: cartItemData.totalProductDiscount,
                                      size: 10.sp,
                                      fontWeight: FontWeight.w600,color: blackColor,)
                                    // MyText(
                                    //     size: 10.sp,
                                    //     fontWeight: FontWeight.w600,
                                    //     text: "\$ ${cartItemData.totalProductDiscount==0?cartItemData.price.toString()
                                    //         :cartItemData.totalProductDiscount.toString()}")
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                  5.height,
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [

                      MyText(
                        text: AppLocalizations.of(context)!.totalpurchase,
                        fontWeight: FontWeight.w500,
                        size: 12.sp,
                      ),
                      10.width,
                      FindCurrency(usdAmount: calculateTotalPrice(orderSellerResponse.cartItem),

                        fontWeight: FontWeight.w600,
                        color: const Color(0xffB70003),
                        size: 10.sp,
                      ),
                      // MyText(
                      //   text: "\$ ${calculateTotalPrice(orderSellerResponse.cartItem)}",
                      //   fontWeight: FontWeight.w600,
                      //   color: const Color(0xffB70003),
                      //   size: 10.sp,
                      // ),
                    ],
                  ),
                   5.height,
               isOrderAgain==true?   Row(
                    children: [
                      4.width,
                      Flexible(
                          flex: 1,
                          child: RoundButton(
                              height: 24.h,
                              btnTextSize: 10.sp,
                              borderColor: primaryColor,
                              bgColor: primaryColor,
                              textColor: whiteColor,
                              borderRadius:
                              BorderRadius.circular(5.r),
                              title: AppLocalizations.of(context)!.orderagain,
                              onTap: () async{
                                if(cartProvider.shippingId==null){
                                  showSnackbar(context, AppLocalizations.of(context)!.pleaseselectyourshippingaddress,color: redColor);
                                  return;
                                }
                                var model=CashOrderModel(
                                    shipping: cartProvider.shippingId!,
                                    deliverySlot: cartProvider.deliverySlotId!);
                                try{
                                  await CustomerOrderRepository.reorderProducts(model,orderSellerResponse.id,context).then((v){
                                    showSnackbar(context, AppLocalizations.of(context)!.orderplacedsuccessfully,color:greenColor);
                                    Navigator.pop(context);
                                  });
                                }catch(e){

                                }
                              })),

                    ],
                  ):const SizedBox()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
double calculateTotalPrice(List<CartItem> cartItems) {
  return cartItems.fold(0.0, (total, item) {
    double itemPrice = item.totalProductDiscount > 0 ? item.totalProductDiscount : item.price;
    return total + itemPrice;
  });
}
