import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/providers/products/seller-products-tabs/seller-pendingqc-tab-products-provider.dart';
import 'package:sugudeni/repositories/products/seller-product-repository.dart';
import 'package:sugudeni/utils/customWidgets/cached-network-image.dart';
import 'package:sugudeni/utils/extensions/dialog-extension.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/utils/product-status.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../repositories/products/product-repository.dart';
import '../../../../utils/customWidgets/my-text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sugudeni/main.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/round-button.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/customWidgets/shimmer-widgets.dart';

class PendingTab extends StatefulWidget {
  const PendingTab({super.key});

  @override
  State<PendingTab> createState() => _PendingTabState();
}

class _PendingTabState extends State<PendingTab> {
  late SellerPendingQCTabProductProvider productProvider;
  final ScrollController _scrollController = ScrollController();

  final discountController=TextEditingController();
  @override
  void initState() {
    super.initState();
    productProvider = Provider.of<SellerPendingQCTabProductProvider>(context, listen: false);
    productProvider.fetchPendingQCProducts(context);
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
      productProvider.fetchPendingQCProducts(context);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final sellerInActiveTab=Provider.of<SellerPendingQCTabProductProvider>(context,listen: false);

    return Consumer<SellerPendingQCTabProductProvider>(builder: (context,provider,child){
      if (provider.isLoading && provider.productList.isEmpty) {
        return ProductGridShimmer();
      }

      if (provider.errorText.isNotEmpty) {
        return SizedBox(
            height: 500.h,
            child: Center(
                child: Text(provider.errorText, style: const TextStyle(color: redColor))));
      }
      if (provider.filteredProductList.isEmpty) {
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
      return  Expanded(
        child: RefreshIndicator(
          onRefresh: () => provider.refreshProducts(context),
          child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),

              controller: _scrollController,
              itemCount: provider.filteredProductList.length + (provider.hasMoreData ? 1 : 0),
              itemBuilder: (context,index){
                if (index == provider.filteredProductList.length) {
                  return ProductGridShimmer();
                }

                var productData = provider.filteredProductList[index];


                return Container(
                  // height: 124.h,
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 10.h),
                    color: whiteColor,
                    child: Padding(
                      padding:  EdgeInsets.all(12.sp),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                    width: 150.w,
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
                              ),
                              Spacer(),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  MyText(text: AppLocalizations.of(context)!.pendingqc,color: primaryColor,
                                    size: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  30.height,
                                  RoundButton(
                                      width: 64.w,
                                      height: 20.h,
                                      btnTextSize: 10.sp,
                                      title: AppLocalizations.of(context)!.delete, onTap: (){
                                    context.showConfirmationDialog(title: AppLocalizations.of(context)!.doyouwanttodeleteproduct,
                                        onYes: ()async{
                                          await ProductRepository.deleteProduct(productData.id, context).then((v){
                                            showSnackbar(context, AppLocalizations.of(context)!.productdeletedsuccessfully,color: greenColor);
                                          });
                                          Navigator.pop(context);
                                        }, onNo: (){

                                        });
                                  })
                                ],
                              )

                            ],
                          ),

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
