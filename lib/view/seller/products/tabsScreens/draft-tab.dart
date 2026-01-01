import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/providers/products/products-provider.dart';
import 'package:sugudeni/providers/products/seller-products-tabs/seller-draft-tab-products-provider.dart';
import 'package:sugudeni/repositories/products/seller-product-repository.dart';
import 'package:sugudeni/utils/customWidgets/cached-network-image.dart';
import 'package:sugudeni/utils/customWidgets/loading-dialog.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/utils/product-status.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';

import '../../../../l10n/app_localizations.dart';
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
import 'package:sugudeni/utils/customWidgets/empty-state-widget.dart';

class DraftTab extends StatefulWidget {
  const DraftTab({super.key});

  @override
  State<DraftTab> createState() => _DraftTabState();
}

class _DraftTabState extends State<DraftTab> {
  late SellerDraftTabProductProvider productProvider;
  final ScrollController _scrollController = ScrollController();

  final discountController=TextEditingController();
  @override
  void initState() {
    super.initState();
    productProvider = Provider.of<SellerDraftTabProductProvider>(context, listen: false);
    productProvider.fetchDraftProducts(context);
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
      productProvider.fetchDraftProducts(context);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  Future<void> refresh() async {
    setState(() {}); // Trigger rebuild
    await Future.delayed(const Duration(milliseconds: 500)); // Optional delay to prevent flickering
  }
  @override
  Widget build(BuildContext context) {

    return Consumer<SellerDraftTabProductProvider>(builder: (context,provider,child){
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
        return EmptyStateWidget(
          title: 'No Draft Products',
          description: 'You don\'t have any draft products. Start creating your first product draft.',
          icon: Icons.edit_outlined,
          showButton: true,
          buttonText: 'Create Draft',
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
              itemBuilder: (context,index){
                if (index == provider.filteredProductList.length) {
                  return ProductGridShimmer();
                }
                var productData = provider.filteredProductList[index];

                return Container(
                  // height: 124.h,
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
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MyText(
                                      overflow: TextOverflow.clip,
                                      text: capitalizeFirstLetter(productData.title),size: 10.sp,
                                      fontWeight: FontWeight.w600,
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
                                    10.height,
                                    RoundButton(
                                        height: 21.h,
                                        width: 214.w,
                                        btnTextSize: 12.sp,
                                        borderColor: primaryColor,
                                        bgColor: transparentColor,
                                        textColor: primaryColor,
                                        borderRadius:
                                        BorderRadius.circular(10.r),
                                        title: AppLocalizations.of(context)!.completelistingandpublish,
                                        onTap: () async{
                                          showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (context){
                                                return const LoadingDialog();
                                              });
                                          context.read<ProductsProvider>().clearResources();
                                          context.read<ProductsProvider>(). setDraftToPublish();
                                          context.read<ProductsProvider>(). setProductId(productData.id);
                                          await context.read<ProductsProvider>().addFiles(productData.images);
                                          if(context.mounted){
                                            context.read<ProductsProvider>().setValues(productData);
                                            Navigator.pop(context);
                                            Navigator.pushNamed(context, RoutesNames.sellerAddProductView);
                                          }
                                        })
                                  ],
                                ),
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
