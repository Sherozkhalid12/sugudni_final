import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/models/orders/AddReadyToShipModel.dart';
import 'package:sugudeni/providers/shipping-provider/shipping-provider.dart';
import 'package:sugudeni/repositories/orders/seller-order-repository.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/constants/enum.dart';
import 'package:sugudeni/utils/customWidgets/app-bar-title-widget.dart';
import 'package:sugudeni/utils/customWidgets/cached-network-image.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/round-button.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:sugudeni/view/customer/account/customer-to-receive-order-view.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/orders/GetAllOrderSellerResponseModel.dart';
import '../../../providers/customer/customer-addresses-provider.dart';
import '../../../utils/constants/app-assets.dart';
import '../../../utils/routes/routes-name.dart';

class SellerOrderDetailView extends StatelessWidget {
  final Order orderSellerResponse;
  const SellerOrderDetailView({super.key, required this.orderSellerResponse});

  @override
  Widget build(BuildContext context) {
    final shippingProvider=Provider.of<ShippingProvider>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        toolbarHeight: 70.h,
        automaticallyImplyLeading: false,
        title:const AppBarTitleWidget(title: "Order Detail"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        //  MyText(text: "${orderSellerResponse.trackingStatus}"),
     orderSellerResponse.trackingStatus==DeliveryStatus.toShip?    Consumer<ShippingProvider>(
             builder: (context,provider,child){
           return provider.pickupAddressId==null?  GestureDetector(
             onTap: (){
               shippingProvider.clearResources();
               shippingProvider.setComeFromOder();
               //cartProvider.setCheckout(true);
               Navigator.pushNamed(context, RoutesNames.sellerAddressView);
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
                     MyText(text: AppLocalizations.of(context)!.selectpickupaddress,color: const Color(0xff00FFF2),size: 12.sp,fontWeight: FontWeight.w600)
                   ],
                 ),
               ),
             ),
           )
           :   Container(
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
                             MyText(text: capitalizeFirstLetter(provider.addressesModel!.firstname),size: 12.sp,fontWeight: FontWeight.w600),
                             10.width,
                             MyText(text: provider.addressesModel!.phone,size: 10.sp,fontWeight: FontWeight.w600,color: textSecondaryColor,),
                             const Spacer(),
                             GestureDetector(
                                 onTap: (){
                                   // provider.setDataForUpdate(index);
                                   Navigator.pushNamed(context, RoutesNames.sellerAddressView);

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
                                 text: "${provider.addressesModel!.street} ${provider.addressesModel!.country}",size: 12.sp,fontWeight: FontWeight.w500,color: textSecondaryColor,),
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
           );
         }):SizedBox(),
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
                                   imageUrl:cartItemData.product!.bulk==true?cartItemData.product!.imgCover :"${ApiEndpoints.productUrl}/${cartItemData.product!.imgCover}"),
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
                                 flex: 5,
                                 child: Column(
                                   crossAxisAlignment:
                                   CrossAxisAlignment.start,
                                   children: [
                                     MyText(
                                       overflow: TextOverflow.clip,
                                       text:
                                       capitalizeFirstLetter(cartItemData.product!.title!),
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
                               MyText(
                                 size: 10.sp,
                                   fontWeight: FontWeight.w600,
                                   // text: "\$ ${cartItemData.totalProductDiscount==0?cartItemData.price.toString()
                                   //     :cartItemData.totalProductDiscount.toString()}",
                                   text: "\$ ${cartItemData.priceAfterDiscount}"

                               )
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
                      MyText(
                        text: "\$ ${orderSellerResponse.totalPriceAfterDiscount}",
                      //  text: "\$ ${calculateTotalPrice(orderSellerResponse.cartItem)}",
                        fontWeight: FontWeight.w600,
                        color: const Color(0xffB70003),
                        size: 10.sp,
                      ),
                    ],
                  ),
                  5.height,
             orderSellerResponse.trackingStatus== DeliveryStatus.readytoship?
             RoundButton(
                 height: 24.h,
                 btnTextSize: 10.sp,
                 borderColor: textPrimaryColor,
                 bgColor: transparentColor,
                 textColor: textPrimaryColor,
                 borderRadius:
                 BorderRadius.circular(5.r),
                 title: AppLocalizations.of(context)!.waitingfordrivertopickedup,
                 onTap: () async{

                 }):  orderSellerResponse.trackingStatus== DeliveryStatus.delivered?
             RoundButton(
                 height: 24.h,
                 btnTextSize: 10.sp,
                 borderColor: textPrimaryColor,
                 bgColor: transparentColor,
                 textColor: textPrimaryColor,
                 borderRadius:
                 BorderRadius.circular(5.r),
                 title: AppLocalizations.of(context)!.orderdelivered,
                 onTap: () async{

                 }):
             orderSellerResponse.trackingStatus== DeliveryStatus.shipping?
             RoundButton(
                 height: 24.h,
                 btnTextSize: 10.sp,
                 borderColor: textPrimaryColor,
                 bgColor: transparentColor,
                 textColor: textPrimaryColor,
                 borderRadius:
                 BorderRadius.circular(5.r),
                 title:orderSellerResponse.driverPicked== true? AppLocalizations.of(context)!.driverpickedtheorder:AppLocalizations.of(context)!.driverhasacceptedtheordetandreadytopicked,
                 onTap: () async{

                 }):
             orderSellerResponse.trackingStatus== DeliveryStatus.failed?
             RoundButton(
                 height: 24.h,
                 btnTextSize: 10.sp,
                 borderColor: textPrimaryColor,
                 bgColor: transparentColor,
                 textColor: textPrimaryColor,
                 borderRadius:
                 BorderRadius.circular(5.r),
                 title:AppLocalizations.of(context)!.failedtodeliver,
                 onTap: () async{

                 }):
             Row(
                    children: [
                      4.width,
                      Flexible(
                          flex: 1,
                          child: RoundButton(
                              height: 24.h,
                              btnTextSize: 10.sp,
                              borderColor: textPrimaryColor,
                              bgColor: transparentColor,
                              textColor: textPrimaryColor,
                              borderRadius:
                              BorderRadius.circular(5.r),
                              title: AppLocalizations.of(context)!.readytoship,
                              onTap: () async{
                                if(shippingProvider.pickupAddressId==null){
                                  showSnackbar(context, AppLocalizations.of(context)!.pleaseselectpickupaddress,color: redColor);
                                  return;
                                }
                                try{
                                  var model=ReadyToShipModel(pickupAddress: shippingProvider.pickupAddressId!);
                                  await SellerOrderRepository.addReadyToShipOrder(model,orderSellerResponse.orderId, context).then((v){
                                    showSnackbar(context, AppLocalizations.of(context)!.orderhasveebsetforshipsuccessfully,color: greenColor);
                                    Navigator.pop(context);
                                  });
                                }catch(e){

                                }
                              })),
                      4.width,
                      Flexible(
                          flex: 1,
                          child: RoundButton(
                              height: 24.h,
                              btnTextSize: 10.sp,
                              borderRadius:
                              BorderRadius.circular(5.r),
                              title: AppLocalizations.of(context)!.printinvoice,
                              onTap: () {
                                printInvoice(orderSellerResponse);
                              })),
                    ],
                  )
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
void printInvoice(Order order) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("SUGUDENI", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Text("Order Number: #${order.id}", style: pw.TextStyle(fontSize: 16)),
            pw.SizedBox(height: 20),
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  decoration: pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(8.0), child: pw.Text("Item Name")),
                    pw.Padding(padding: const pw.EdgeInsets.all(8.0), child: pw.Text("Quantity")),
                    pw.Padding(padding: const pw.EdgeInsets.all(8.0), child: pw.Text("Price")),
                    pw.Padding(padding: const pw.EdgeInsets.all(8.0), child: pw.Text("Total")),
                  ],
                ),
                ...order.cartItem.map(
                      (item) => pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(item.product?.title ?? "Unknown"),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(item.quantity.toString()),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text("\$${item.totalProductDiscount==0?item.price:item.totalProductDiscount}"),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text("\$${item.quantity * (item.totalProductDiscount==0?item.price:item.totalProductDiscount)}"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text("Grand Total: \$100", style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            ),
          ],
        );
      },
    ),
  );

  await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
}