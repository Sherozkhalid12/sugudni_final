// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:sugudeni/main.dart';
// import 'package:sugudeni/models/products/ProductStatusChangeModel.dart';
// import 'package:sugudeni/models/products/SellerProductListResponse.dart';
// import 'package:sugudeni/providers/products/products-provider.dart';
// import 'package:sugudeni/repositories/products/seller-product-repository.dart';
// import 'package:sugudeni/utils/constants/app-assets.dart';
// import 'package:sugudeni/utils/constants/colors.dart';
// import 'package:sugudeni/utils/customWidgets/cached-network-image.dart';
// import 'package:sugudeni/utils/customWidgets/my-text.dart';
// import 'package:sugudeni/utils/customWidgets/round-button.dart';
// import 'package:sugudeni/utils/extensions/dialog-extension.dart';
// import 'package:sugudeni/utils/extensions/sizebox.dart';
// import 'package:sugudeni/utils/global-functions.dart';
// import 'package:sugudeni/utils/product-status.dart';
//
// import '../../../../api/api-endpoints.dart';
//
// class ActiveTab extends StatefulWidget {
//   const ActiveTab({super.key});
//
//   @override
//   State<ActiveTab> createState() => _ActiveTabState();
// }
//
// class _ActiveTabState extends State<ActiveTab> {
//
//   bool isLoading=true;
//   SellerProductListResponse? sellerProductListResponse;
//   List<Product>? activeProduct;
//   void getData()async{
//    sellerProductListResponse= await SellerProductRepository.allSellerProducts(context);
//    List<Product> products=sellerProductListResponse!.getAllProducts;
//    List<Product> inActivesProducts=products.where((d){
//      return d.status==ProductStatus.active;
//    }).toList();
//    activeProduct=inActivesProducts!;
//    isLoading=false;
//    customPrint("Products after in sorting ==================================================$activeProduct");
//    setState(() {});
//   }
//   @override
//   void initState() {
//     // TODO: implement initState
//     customPrint("init ====================================================================================");
//     getData();
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     // final stockController=TextEditingController();
//     // final priceController=TextEditingController();
//     final productProvider=Provider.of<ProductsProvider>(context,listen: false);
//     return isLoading==true? const Center(
//       child: CircularProgressIndicator(),
//     ):Expanded(
//       child: ListView.builder(
//           itemCount: activeProduct!.length,
//           itemBuilder: (context,index){
//             var productData=activeProduct![index];
//             return Container(
//               // height: 124.h,
//                 margin: EdgeInsets.only(bottom: 10.h),
//                 color: whiteColor,
//                 child: Padding(
//                   padding:  EdgeInsets.all(12.sp),
//                   child: Column(
//                     children: [
//                       Row(
//                         children: [
//                           MyCachedNetworkImage(
//                               height:65.h ,
//                               width: 65.w,
//                               radius: 6.r,
//                               imageUrl: "${ApiEndpoints.productUrl}${productData.imgCover}"),
//                           // Container(
//                           //   height:65.h ,
//                           //   width: 65.w,
//                           //   decoration: BoxDecoration(
//                           //       borderRadius: BorderRadius.circular(6.r),
//                           //       image:  DecorationImage(image: NetworkImage(productData.imgCover),fit: BoxFit.contain)
//                           //   ),
//                           // ),
//                           10.width,
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               MyText(text: capitalizeFirstLetter(productData.title),size: 10.sp,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                               3.height,
//                               MyText(text: "Product ID : ${productData.id}",size: 8.sp,
//                                 color: textPrimaryColor.withOpacity(0.7),
//                                 fontWeight: FontWeight.w600,
//                               ),
//                               3.height,
//                               MyText(text: "\$ ${productData.price}",size: 10.sp,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                               3.height,
//                               MyText(text: "Stock : ${productData.quantity}",size: 10.sp,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//                       10.height,
//                       Row(
//                         children: [
//                           Flexible(flex: 3,
//                             child: RoundButton(
//                                 height: 21.h,
//                                 btnTextSize: 12.sp,
//                                 borderColor: primaryColor,
//                                 bgColor: transparentColor,
//                                 textColor: primaryColor,
//                                 borderRadius:
//                                 BorderRadius.circular(10.r),
//                                 title: "Edit Price",
//                                 onTap: () {
//                                   productProvider.priceController.text=productData.price.toString();
//
//                                   context.showTextFieldDialog(
//                                       confirmText: 'Update',
//                                       declineText: 'Cancel',
//                                       onNo: (){
//
//                                       },onYes: (){
//                                     productProvider.updateProductPrice(productData.id, context);
//
//                                   },title: 'Price',
//                                       controller:productProvider.priceController,
//                                       keyboardType: TextInputType.number
//
//                                   );
//                                 }),
//                           ),
//                           5.width,
//                           Flexible(
//                             flex: 3,
//                             child: RoundButton(
//                                 height: 21.h,
//                                 btnTextSize: 12.sp,
//                                 borderColor: primaryColor,
//                                 bgColor: transparentColor,
//                                 textColor: primaryColor,
//                                 borderRadius:
//                                 BorderRadius.circular(10.r),
//                                 title: "Edit Stock",
//                                 onTap: () {
//                                   productProvider.quantityController.text=productData.quantity.toString();
//                                   context.showTextFieldDialog(
//                                       confirmText: 'Update',
//                                       declineText: 'Cancel',
//                                       onNo: (){
//
//                                       },onYes: (){
//                                     productProvider.updateProductStock(productData.id, context);
//
//                                   },title: 'Stock',
//                                       controller:productProvider.quantityController,
//                                       keyboardType: TextInputType.number
//
//                                   );
//                                 }),
//                           ),
//                           5.width,
//
//                           Flexible(
//                             flex: 2,
//                             child: RoundButton(
//                                 height: 21.h,
//                                 btnTextSize: 10.sp,
//                                 borderColor: primaryColor,
//                                 bgColor: transparentColor,
//                                 textColor: primaryColor,
//                                 borderRadius:
//                                 BorderRadius.circular(10.r),
//                                 title: "Deactivate",
//                                 onTap: () async{
//                                   var model=ProductStatusChangeModel(productId: productData.id, status: ProductStatus.inactive);
//                                   await SellerProductRepository.updateProductStatus(model, context).then((v){
//                                     showSnackbar(context, "Product Deactivated",color: greenColor);
//                                   });
//                                 }),
//                           ),
//                           5.width,
//                           Image.asset(AppAssets.shareIcon,scale: 3,),
//
//                         ],
//                       )
//                     ],
//                   ),
//                 )
//             );
//           }),
//     );
//   }
// }
//

/// active
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
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
// import 'package:sugudeni/utils/global-functions.dart';
// import 'package:sugudeni/utils/product-status.dart';
//
// import '../../../../api/api-endpoints.dart';
//
// class ActiveTab extends StatelessWidget {
//   const ActiveTab({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // final stockController=TextEditingController();
//     // final priceController=TextEditingController();
//     final productProvider=Provider.of<ProductsProvider>(context,listen: false);
//     return FutureBuilder(
//         future: SellerProductRepository.allSellerProducts(context),
//         builder: (context,snapshot){
//           if(snapshot.connectionState==ConnectionState.waiting){
//             return SizedBox(
//               height: 500.h,
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
//           var activeProducts=data.where((d){
//             return d.status==ProductStatus.active;
//           }).toList();
//           if(activeProducts.isEmpty){
//             return SizedBox(
//               height: 500.h,
//               child: Center(
//                 child: MyText(text: "Empty",size: 12.sp,),
//               ),
//             );
//           }
//           return Expanded(
//             child: ListView.builder(
//                 itemCount: activeProducts.length,
//                 itemBuilder: (context,index){
//                   var productData=activeProducts[index];
//                   return Container(
//                     // height: 124.h,
//                       margin: EdgeInsets.only(bottom: 10.h),
//                       color: whiteColor,
//                       child: Padding(
//                         padding:  EdgeInsets.all(12.sp),
//                         child: Column(
//                           children: [
//                             Row(
//                               children: [
//                                 MyCachedNetworkImage(
//                                     height:65.h ,
//                                     width: 65.w,
//                                     radius: 6.r,
//                                     imageUrl: "${ApiEndpoints.productUrl}${productData.imgCover}"),
//                                 // Container(
//                                 //   height:65.h ,
//                                 //   width: 65.w,
//                                 //   decoration: BoxDecoration(
//                                 //       borderRadius: BorderRadius.circular(6.r),
//                                 //       image:  DecorationImage(image: NetworkImage(productData.imgCover),fit: BoxFit.contain)
//                                 //   ),
//                                 // ),
//                                 10.width,
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     MyText(text: capitalizeFirstLetter(productData.title),size: 10.sp,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                     3.height,
//                                     MyText(text: "Product ID : ${productData.id}",size: 8.sp,
//                                       color: textPrimaryColor.withOpacity(0.7),
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                     3.height,
//                                     MyText(text: "\$ ${productData.price}",size: 10.sp,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                     3.height,
//                                     MyText(text: "Stock : ${productData.quantity}",size: 10.sp,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ],
//                                 )
//                               ],
//                             ),
//                             10.height,
//                             Row(
//                               children: [
//                                 Flexible(flex: 3,
//                                   child: RoundButton(
//                                       height: 21.h,
//                                       btnTextSize: 12.sp,
//                                       borderColor: primaryColor,
//                                       bgColor: transparentColor,
//                                       textColor: primaryColor,
//                                       borderRadius:
//                                       BorderRadius.circular(10.r),
//                                       title: "Edit Price",
//                                       onTap: () {
//                                         productProvider.priceController.text=productData.price.toString();
//
//                                         context.showTextFieldDialog(
//                                             confirmText: 'Update',
//                                             declineText: 'Cancel',
//                                             onNo: (){
//
//                                             },onYes: (){
//                                           productProvider.updateProductPrice(productData.id, context);
//
//                                         },title: 'Price',
//                                             controller:productProvider.priceController,
//                                             keyboardType: TextInputType.number
//
//                                         );
//                                       }),
//                                 ),
//                                 5.width,
//                                 Flexible(
//                                   flex: 3,
//                                   child: RoundButton(
//                                       height: 21.h,
//                                       btnTextSize: 12.sp,
//                                       borderColor: primaryColor,
//                                       bgColor: transparentColor,
//                                       textColor: primaryColor,
//                                       borderRadius:
//                                       BorderRadius.circular(10.r),
//                                       title: "Edit Stock",
//                                       onTap: () {
//                                         productProvider.quantityController.text=productData.quantity.toString();
//                                         context.showTextFieldDialog(
//                                             confirmText: 'Update',
//                                             declineText: 'Cancel',
//                                             onNo: (){
//
//                                             },onYes: (){
//                                           productProvider.updateProductStock(productData.id, context);
//
//                                         },title: 'Stock',
//                                             controller:productProvider.quantityController,
//                                             keyboardType: TextInputType.number
//
//                                         );
//                                       }),
//                                 ),
//                                 5.width,
//
//                                 Flexible(
//                                   flex: 2,
//                                   child: RoundButton(
//                                       height: 21.h,
//                                       btnTextSize: 10.sp,
//                                       borderColor: primaryColor,
//                                       bgColor: transparentColor,
//                                       textColor: primaryColor,
//                                       borderRadius:
//                                       BorderRadius.circular(10.r),
//                                       title: "Deactivate",
//                                       onTap: () async{
//                                         var model=ProductStatusChangeModel(productId: productData.id, status: ProductStatus.inactive);
//                                         await SellerProductRepository.updateProductStatus(model, context).then((v){
//                                           showSnackbar(context, "Product Deactivated",color: greenColor);
//                                         });
//                                       }),
//                                 ),
//                                 5.width,
//                                 Image.asset(AppAssets.shareIcon,scale: 3,),
//
//                               ],
//                             )
//                           ],
//                         ),
//                       )
//                   );
//                 }),
//           );
//         });
//   }
// }
/// using pagination
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/main.dart';
import 'package:sugudeni/models/products/AddSaleToProductModel.dart';
import 'package:sugudeni/models/products/ProductStatusChangeModel.dart';
import 'package:sugudeni/models/products/SellerProductListResponse.dart';
import 'package:sugudeni/providers/products/products-provider.dart';
import 'package:sugudeni/providers/products/seller-products-tabs/seller-active-tab-products-provider.dart';
import 'package:sugudeni/providers/products/seller-products-tabs/seller-inactive-tab-products-provider.dart';
import 'package:sugudeni/repositories/products/product-repository.dart';
import 'package:sugudeni/repositories/products/seller-product-repository.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/cached-network-image.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/round-button.dart';
import 'package:sugudeni/utils/extensions/dialog-extension.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/utils/product-status.dart';
import 'package:sugudeni/utils/customWidgets/shimmer-widgets.dart';
import 'package:sugudeni/utils/customWidgets/empty-state-widget.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';

import '../../../../api/api-endpoints.dart';
import '../../../../l10n/app_localizations.dart';

class ActiveTab extends StatefulWidget {
  const ActiveTab({super.key});

  @override
  State<ActiveTab> createState() => _ActiveTabState();
}

class _ActiveTabState extends State<ActiveTab> {
  late SellerActiveTabProductProvider productProvider;
  final ScrollController _scrollController = ScrollController();

  final discountController=TextEditingController();
  @override
  void initState() {
    super.initState();
    productProvider = Provider.of<SellerActiveTabProductProvider>(context, listen: false);
    productProvider.fetchActiveProducts(context);
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
      productProvider.fetchActiveProducts(context);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sellerInActiveTab=Provider.of<SellerInActiveTabProductProvider>(context,listen: false);

    return Consumer<SellerActiveTabProductProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.productList.isEmpty) {
          return const ProductGridShimmer();
        }

        if (provider.errorText.isNotEmpty) {
          return SizedBox(
              height: 500.h,
              child: Center(
              child: Text(provider.errorText, style: const TextStyle(color: redColor))));
        }
        if (provider.filteredProductList.isEmpty) {
          return EmptyStateWidget(
            title: 'No Active Products',
            description: 'You don\'t have any active products yet. Add your first product to start selling.',
            icon: Icons.check_circle_outline,
            showButton: true,
            buttonText: 'Add Product',
            onButtonPressed: () {
              context.read<ProductsProvider>().clearResources();
              Navigator.pushNamed(context, RoutesNames.sellerAddProductView);
            },
          );
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
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: provider.filteredProductList.length + (provider.hasMoreData ? 1 : 0),
              controller: _scrollController,
              itemBuilder: (context, index) {
                if (index == provider.filteredProductList.length) {
                  return ProductGridShimmer();
                }

                var productData = provider.filteredProductList[index];

                return Container(
                  margin: EdgeInsets.only(bottom: 10.h),
                  color: whiteColor,
                  child: Padding(
                    padding: EdgeInsets.all(12.sp),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            MyCachedNetworkImage(
                              height: 65.h,
                              width: 65.w,
                              radius: 6.r,
                              imageUrl:productData.bulk==true?productData.imgCover :"${ApiEndpoints.productUrl}${productData.imgCover}",
                            ),
                            10.width,
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: MyText(
                                          overflow: TextOverflow.clip,
                                          text: capitalizeFirstLetter(productData.title),
                                          size: 10.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: (){
                                          context.showTextFieldDialog(
                                            confirmText: AppLocalizations.of(context)!.add,
                                            declineText: AppLocalizations.of(context)!.cancel,
                                            onNo: () {},
                                            onYes: () async{
                                              FocusManager.instance.primaryFocus!.unfocus();
                                              double discount=double.parse(discountController.text);
                                              if(discountController.text.isEmpty||discount>100){
                                                showSnackbar(context, "Incorrect value",color: redColor);
                                                return;
                                              }
                                              var model=AddSaleToProductModel(discount: discount);
                                             await SellerProductRepository.addSaleToProduct(model, productData.id, context).then((v)async{
                                             if(context.mounted){
                                               await provider.getSpecificProduct(productData.id, context);
                                             if(context.mounted){
                                               Navigator.pop(context);
                                             }

                                             }
                                             });
                                            },
                                            title: AppLocalizations.of(context)!.discount,
                                            controller: discountController,
                                            keyboardType: TextInputType.number,
                                          );
                                        },
                                        child: MyText(
                                          text: AppLocalizations.of(context)!.adddiscount,
                                          size: 10.sp,
                                          textDecoration: TextDecoration.underline,
                                          color: primaryColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  3.height,
                                  MyText(
                                    text: "${AppLocalizations.of(context)!.productid} : ${productData.id}",
                                    size: 8.sp,
                                    color: textPrimaryColor.withOpacity(0.7),
                                    fontWeight: FontWeight.w600,
                                  ),
                                  3.height,
                                  Row(
                                    children: [
                                      MyText(
                                        text: "\$ ${productData.saleDiscount==0? productData.price:productData.priceAfterDiscount}",
                                        size: 10.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      10.width,
                                  productData.saleDiscount==0?  const SizedBox() : MyText(
                                        text: "\$ ${productData.price}",
                                        size: 10.sp,
                                        textDecoration: TextDecoration.lineThrough,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                  3.height,
                                  MyText(
                                    text: "${AppLocalizations.of(context)!.stock} : ${productData.quantity}",
                                    size: 10.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        10.height,
                        Row(
                          children: [
                            Flexible(
                              flex: 3,
                              child: RoundButton(
                                height: 21.h,
                                btnTextSize: 12.sp,
                                borderColor: primaryColor,
                                bgColor: transparentColor,
                                textColor: primaryColor,
                                borderRadius: BorderRadius.circular(10.r),
                                title: AppLocalizations.of(context)!.editprice,
                                onTap: () {
                                  var productProvider = Provider.of<ProductsProvider>(context, listen: false);
                                  productProvider.priceController.text = productData.price.toString();

                                  context.showTextFieldDialog(
                                    confirmText: AppLocalizations.of(context)!.update,
                                    declineText: AppLocalizations.of(context)!.cancel,
                                    onNo: () {},
                                    onYes: () {
                                      productProvider.updateProductPrice(productData.id, context);
                                    },
                                    title: AppLocalizations.of(context)!.price,
                                    controller: productProvider.priceController,
                                    keyboardType: TextInputType.number,
                                  );
                                },
                              ),
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
                                borderRadius: BorderRadius.circular(10.r),
                                title: AppLocalizations.of(context)!.editstock,
                                onTap: () {
                                  var productProvider = Provider.of<ProductsProvider>(context, listen: false);
                                  productProvider.quantityController.text = productData.quantity.toString();

                                  context.showTextFieldDialog(
                                    confirmText: AppLocalizations.of(context)!.update,
                                    declineText: AppLocalizations.of(context)!.cancel,
                                    onNo: () {},
                                    onYes: () {
                                      productProvider.updateProductStock(productData.id, context);
                                    },
                                    title: AppLocalizations.of(context)!.stock,
                                    controller: productProvider.quantityController,
                                    keyboardType: TextInputType.number,
                                  );
                                },
                              ),
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
                                borderRadius: BorderRadius.circular(10.r),
                                title: AppLocalizations.of(context)!.deactivate,
                                onTap: () async {

                                  var model = ProductStatusChangeModel(
                                    productId: productData.id,
                                    status: ProductStatus.inactive,
                                  );
                                  await SellerProductRepository.updateProductStatus(model, context).then((v) {
                                    sellerInActiveTab.addProduct(productData);
                                    provider.removeProductById(productData.id);
                                    showSnackbar(context, AppLocalizations.of(context)!.productdeactivated, color: greenColor);
                                  });
                                },
                              ),
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
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}