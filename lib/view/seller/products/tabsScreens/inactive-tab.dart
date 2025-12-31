// import 'package:flutter/cupertino.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:sugudeni/api/api-endpoints.dart';
// import 'package:sugudeni/main.dart';
// import 'package:sugudeni/models/products/ProductStatusChangeModel.dart';
// import 'package:sugudeni/providers/products/products-provider.dart';
// import 'package:sugudeni/repositories/products/seller-product-repository.dart';
// import 'package:sugudeni/utils/constants/app-assets.dart';
// import 'package:sugudeni/utils/constants/colors.dart';
// import 'package:sugudeni/utils/customWidgets/cached-network-image.dart';
// import 'package:sugudeni/utils/customWidgets/my-text.dart';
// import 'package:sugudeni/utils/customWidgets/round-button.dart';
// import 'package:sugudeni/utils/extensions/dialog-extension.dart';
// import 'package:sugudeni/utils/extensions/sizebox.dart';
// import 'package:sugudeni/utils/product-status.dart';
//
// import '../../../../utils/customWidgets/my-text.dart';
// import '../../../../utils/global-functions.dart';
//
// class InActiveTab extends StatelessWidget {
//   const InActiveTab({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final productProvider=Provider.of<ProductsProvider>(context,listen: false);
//
//     return FutureBuilder(
//         future: SellerProductRepository.allSellerProducts(context),
//         builder: (context,snapshot){
//           if(snapshot.connectionState==ConnectionState.waiting){
//             return SizedBox(              height: 500.h,
//
//               child: const Center(
//                 child: CircularProgressIndicator(),
//               ),
//             );
//           }
//           if(snapshot.hasError){
//             return SizedBox(
//               height: 500.h,
//               child: Center(
//                 child: MyText(text: snapshot.error.toString(),size: 12.sp,),
//               ),
//             );
//           }
//
//           var data=snapshot.data!.getAllProducts;
//           var inActiveProducts=data.where((d){
//             return d.status==ProductStatus.inactive;
//           }).toList();
//           if(inActiveProducts.isEmpty){
//             return SizedBox(
//               height: 500.h,
//               child: Center(
//                 child: MyText(text: "Empty",size: 12.sp,),
//               ),
//             );
//           }
//       return Expanded(
//         child: ListView.builder(
//             itemCount: inActiveProducts.length,
//             itemBuilder: (context,index){
//               var productData=inActiveProducts[index];
//
//               return Container(
//                 // height: 124.h,
//                   margin: EdgeInsets.only(bottom: 10.h),
//                   color: whiteColor,
//                   child: Padding(
//                     padding:  EdgeInsets.all(12.sp),
//                     child: Column(
//                       children: [
//                         Row(
//                           children: [
//                             MyCachedNetworkImage(
//                                 height:65.h ,
//                                 width: 65.w,
//                                 radius: 6.r,
//                                 imageUrl: "${ApiEndpoints.productUrl}${productData.imgCover}"),
//                             10.width,
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 MyText(text: capitalizeFirstLetter(productData.title),size: 10.sp,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                                 3.height,
//                                 MyText(text: "Product ID : ${productData.id}",size: 8.sp,
//                                   color: textPrimaryColor.withOpacity(0.7),
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                                 3.height,
//                                 MyText(text: "\$ ${productData.price}",size: 10.sp,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                                 3.height,
//                                 MyText(text: "Stock : ${productData.quantity}",size: 10.sp,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ],
//                             )
//                           ],
//                         ),
//                         10.height,
//                         Row(
//                           children: [
//                             Flexible(flex: 3,
//                               child: RoundButton(
//                                   height: 21.h,
//                                   btnTextSize: 12.sp,
//                                   borderColor: primaryColor,
//                                   bgColor: transparentColor,
//                                   textColor: primaryColor,
//                                   borderRadius:
//                                   BorderRadius.circular(10.r),
//                                   title: "Edit Price",
//                                   onTap: () {
//                                     productProvider.priceController.text=productData.price.toString();
//
//                                     context.showTextFieldDialog(
//                                         confirmText: 'Update',
//                                         declineText: 'Cancel',
//                                         onNo: (){
//
//                                         },onYes: (){
//                                       productProvider.updateProductPrice(productData.id, context);
//
//                                     },title: 'Price',
//                                         controller:productProvider.priceController,
//                                         keyboardType: TextInputType.number
//
//                                     );
//                                   }),
//                             ),
//                             5.width,
//                             Flexible(
//                               flex: 3,
//                               child: RoundButton(
//                                   height: 21.h,
//                                   btnTextSize: 12.sp,
//                                   borderColor: primaryColor,
//                                   bgColor: transparentColor,
//                                   textColor: primaryColor,
//                                   borderRadius:
//                                   BorderRadius.circular(10.r),
//                                   title: "Edit Stock",
//                                   onTap: () {
//                                     productProvider.quantityController.text=productData.quantity.toString();
//                                     context.showTextFieldDialog(
//                                         confirmText: 'Update',
//                                         declineText: 'Cancel',
//                                         onNo: (){
//
//                                         },onYes: (){
//                                       productProvider.updateProductStock(productData.id, context);
//
//                                     },title: 'Stock',
//                                         controller:productProvider.quantityController,
//                                         keyboardType: TextInputType.number
//
//                                     );
//                                   }),
//                             ),
//                             5.width,
//
//                             Flexible(
//                               flex: 2,
//                               child: RoundButton(
//                                   height: 21.h,
//                                   btnTextSize: 10.sp,
//                                   borderColor: primaryColor,
//                                   bgColor: transparentColor,
//                                   textColor: primaryColor,
//                                   borderRadius:
//                                   BorderRadius.circular(10.r),
//                                   title: "Activate",
//                                   onTap: ()async {
//                                     var model=ProductStatusChangeModel(productId: productData.id, status: ProductStatus.active);
//                                     await SellerProductRepository.updateProductStatus(model, context).then((v){
//                                       showSnackbar(context, "Product Activated",color: greenColor);
//                                     });
//                                   }),
//                             ),
//                             5.width,
//                             Image.asset(AppAssets.shareIcon,scale: 3,),
//
//                           ],
//                         )
//                       ],
//                     ),
//                   )
//               );
//             }),
//       );
//     });
// }
// }
/// using pagination


import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/main.dart';
import 'package:sugudeni/models/products/ProductStatusChangeModel.dart';
import 'package:sugudeni/providers/products/products-provider.dart';
import 'package:sugudeni/providers/products/seller-products-tabs/seller-active-tab-products-provider.dart';
import 'package:sugudeni/providers/products/seller-products-tabs/seller-inactive-tab-products-provider.dart';
import 'package:sugudeni/repositories/products/seller-product-repository.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/cached-network-image.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/round-button.dart';
import 'package:sugudeni/utils/extensions/dialog-extension.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/product-status.dart';
import 'package:sugudeni/utils/customWidgets/shimmer-widgets.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../repositories/products/product-repository.dart';
import '../../../../utils/customWidgets/my-text.dart';
import '../../../../utils/global-functions.dart';

class InActiveTab extends StatefulWidget {
  const InActiveTab({super.key});

  @override
  State<InActiveTab> createState() => _InActiveTabState();
}

class _InActiveTabState extends State<InActiveTab> {
  late SellerInActiveTabProductProvider productProvider;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    productProvider = Provider.of<SellerInActiveTabProductProvider>(context, listen: false);
    productProvider.fetchInActiveProducts(context);
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
      productProvider.fetchInActiveProducts(context);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final productProvider=Provider.of<ProductsProvider>(context,listen: false);
    final sellerActiveTab=Provider.of<SellerActiveTabProductProvider>(context,listen: false);

    return Consumer<SellerInActiveTabProductProvider>(builder: (context,provider,child){
      if (provider.isLoading && provider.productList.isEmpty) {
        return ProductGridShimmer();
      }

      if (provider.errorText.isNotEmpty) {
        return SizedBox(
            height: 500.h,
            child: Center(
                child: Text(provider.errorText, style: const TextStyle(color: redColor))));
      }
      if (provider.productList.isEmpty) {
        return SizedBox(
            height: 500.h,
            child: Center(
                child: MyText(text: AppLocalizations.of(context)!.empty,size: 12.sp,)));
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        double screenHeight = MediaQuery.of(context).size.height;
        double itemHeight = 120; // Approximate height of a single list item
        provider.autoLoadMoreIfNeeded(context, screenHeight, itemHeight);
      });
      return Expanded(
        child: RefreshIndicator(
          onRefresh: () => provider.refreshProducts(context),

          child: ListView.builder(
              itemCount: provider.productList.length + (provider.hasMoreData ? 1 : 0),
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),

              itemBuilder: (context,index){
                if (index == provider.productList.length) {
                  return ProductGridShimmer();
                }

                var productData = provider.productList[index];


                return Container(
                  // height: 124.h,
                    margin: EdgeInsets.only(bottom: 10.h),
                    color: whiteColor,
                    child: Padding(
                      padding:  EdgeInsets.all(12.sp),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              MyCachedNetworkImage(
                                  height:65.h ,
                                  width: 65.w,
                                  radius: 6.r,
                                imageUrl:productData.bulk==true?productData.imgCover :"${ApiEndpoints.productUrl}${productData.imgCover}",
                              ),
                              10.width,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 170.w,
                                    child: MyText(
                                      overflow: TextOverflow.clip,
                                      text: capitalizeFirstLetter(productData.title),size: 10.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  3.height,
                                  MyText(text: "${AppLocalizations.of(context)!.productid} : ${productData.id}",size: 8.sp,
                                    color: textPrimaryColor.withOpacity(0.7),
                                    fontWeight: FontWeight.w600,
                                  ),
                                  3.height,
                                  MyText(text: "\$ ${productData.price}",size: 10.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  3.height,
                                  MyText(text: "${AppLocalizations.of(context)!.stock} : ${productData.quantity}",size: 10.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              )
                            ],
                          ),
                          10.height,
                          Row(
                            children: [
                              Flexible(flex: 3,
                                child: RoundButton(
                                    height: 21.h,
                                    btnTextSize: 12.sp,
                                    borderColor: primaryColor,
                                    bgColor: transparentColor,
                                    textColor: primaryColor,
                                    borderRadius:
                                    BorderRadius.circular(10.r),
                                    title: AppLocalizations.of(context)!.editprice,
                                    onTap: () {
                                      productProvider.priceController.text=productData.price.toString();

                                      context.showTextFieldDialog(
                                          confirmText: AppLocalizations.of(context)!.update,
                                          declineText: AppLocalizations.of(context)!.cancel,
                                          onNo: (){

                                          },onYes: (){
                                        productProvider.updateProductPrice(productData.id, context);

                                      },title: AppLocalizations.of(context)!.price,
                                          controller:productProvider.priceController,
                                          keyboardType: TextInputType.number

                                      );
                                    }),
                              ),
                              5.width,
                              Flexible(
                                flex: 3,
                                child: RoundButton(
                                    height: 21.h,
                                    btnTextSize: 12.sp,
                                    borderColor: primaryColor,
                                    bgColor: transparentColor,
                                    textColor: primaryColor,
                                    borderRadius:
                                    BorderRadius.circular(10.r),
                                    title: AppLocalizations.of(context)!.editstock,
                                    onTap: () {
                                      productProvider.quantityController.text=productData.quantity.toString();
                                      context.showTextFieldDialog(
                                          confirmText: AppLocalizations.of(context)!.update,
                                          declineText: AppLocalizations.of(context)!.cancel,
                                          onNo: (){

                                          },onYes: (){
                                        productProvider.updateProductStock(productData.id, context);

                                      },title: AppLocalizations.of(context)!.stock,
                                          controller:productProvider.quantityController,
                                          keyboardType: TextInputType.number

                                      );
                                    }),
                              ),
                              5.width,

                              Flexible(
                                flex: 2,
                                child: RoundButton(
                                    height: 21.h,
                                    btnTextSize: 10.sp,
                                    borderColor: primaryColor,
                                    bgColor: transparentColor,
                                    textColor: primaryColor,
                                    borderRadius:
                                    BorderRadius.circular(10.r),
                                    title: AppLocalizations.of(context)!.activate,
                                    onTap: ()async {
                                      var model=ProductStatusChangeModel(productId: productData.id, status: ProductStatus.active);
                                      await SellerProductRepository.updateProductStatus(model, context).then((v){
                                        sellerActiveTab.addProduct(productData);
                                        provider.removeProductById(productData.id);

                                        showSnackbar(context, AppLocalizations.of(context)!.productactivated,color: greenColor);
                                      });
                                    }),
                              ),
                              5.width,
                              GestureDetector(
                                  onTap: (){
                                    context.showConfirmationDialog(title: AppLocalizations.of(context)!.doyouwanttodeleteproduct,
                                        onYes: ()async{
                                          await ProductRepository.deleteProduct(productData.id, context).then((v){
                                            provider.removeProductById(productData.id);
                                            showSnackbar(context, AppLocalizations.of(context)!.productdeletedsuccessfully,color: greenColor);
                                          });
                                          Navigator.pop(context);
                                        }, onNo: (){

                                        });
                                  },
                                  child: Image.asset(AppAssets.deleteIcon, scale: 3)),

                            ],
                          )
                        ],
                      ),
                    )
                );
              }),
        ),
      );
    });
  }
}
