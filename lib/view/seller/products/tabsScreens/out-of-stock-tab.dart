import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/providers/products/seller-products-tabs/seller-out-of-stock-provider.dart';
import 'package:sugudeni/repositories/products/seller-product-repository.dart';
import 'package:sugudeni/utils/customWidgets/cached-network-image.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/utils/product-status.dart';

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

class OutOfStockTab extends StatefulWidget {
  const OutOfStockTab({super.key});

  @override
  State<OutOfStockTab> createState() => _OutOfStockTabState();
}

class _OutOfStockTabState extends State<OutOfStockTab> {
  late SellerOutOfStockTabProductProvider productProvider;
  final ScrollController _scrollController = ScrollController();

  final discountController = TextEditingController();
  @override
  void initState() {
    super.initState();
    productProvider =
        Provider.of<SellerOutOfStockTabProductProvider>(context, listen: false);
    productProvider.fetchActiveProducts(context);
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
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
    return Consumer<SellerOutOfStockTabProductProvider>(
        builder: (context, provider, child) {
      if (provider.isLoading && provider.productList.isEmpty) {
        return ProductGridShimmer();
      }

      if (provider.errorText.isNotEmpty) {
        return SizedBox(
            height: 500.h,
            child: Center(
                child: Text(provider.errorText,
                    style: const TextStyle(color: redColor))));
      }
      if (provider.filteredProductList.isEmpty) {
        return SizedBox(
            height: 500.h,
            child: Center(
                child: MyText(
              text: AppLocalizations.of(context)!.empty,
              size: 12.sp,
            )));
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
              itemCount: provider.filteredProductList.length +
                  (provider.hasMoreData ? 1 : 0),
              controller: _scrollController,
              itemBuilder: (context, index) {
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
                      padding: EdgeInsets.all(12.sp),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyCachedNetworkImage(
                                  height: 65.h,
                                  width: 65.w,
                                  radius: 6.r,
                                  imageUrl:
                                      "${ApiEndpoints.productUrl}${productData.imgCover}"),
                              10.width,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MyText(
                                    text: capitalizeFirstLetter(
                                        productData.title),
                                    size: 10.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  3.height,
                                  MyText(
                                    text:
                                        "${AppLocalizations.of(context)!.productid} : ${productData.id}",
                                    size: 8.sp,
                                    color: textPrimaryColor.withOpacity(0.7),
                                    fontWeight: FontWeight.w600,
                                  ),
                                  3.height,
                                  MyText(
                                    text: "\$ ${productData.price}",
                                    size: 10.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  3.height,
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      MyText(
                                        text:
                                            "${AppLocalizations.of(context)!.stock} : ${productData.quantity}",
                                        size: 10.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      10.width,
                                      Column(
                                        children: [
                                          Container(
                                            width: 12.w,
                                            height: 12.h,
                                            decoration: BoxDecoration(
                                                color: primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(4.r)),
                                            child: Center(
                                              child: Icon(
                                                Icons.arrow_drop_up,
                                                color: whiteColor,
                                                size: 12.sp,
                                              ),
                                            ),
                                          ),
                                          5.height,
                                          Container(
                                            width: 12.w,
                                            height: 12.h,
                                            decoration: BoxDecoration(
                                                color: primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(4.r)),
                                            child: Center(
                                              child: Icon(
                                                Icons.arrow_drop_down_sharp,
                                                color: whiteColor,
                                                size: 12.sp,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      70.width,
                                      RoundButton(
                                          width: 114.w,
                                          height: 20.h,
                                          btnTextSize: 10.sp,
                                          title: AppLocalizations.of(context)!
                                              .publishproduct,
                                          onTap: () {})
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ));
              }),
        ),
      );
    });
  }
}

class ViolationDialog extends StatelessWidget {
  const ViolationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Spacer(),
              MyText(
                text: "See Violation Detail",
                size: 15.sp,
                fontWeight: FontWeight.w700,
              ),
              Spacer(),
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    AppAssets.cancelIcon,
                    scale: 3,
                  ))
            ],
          ),
          10.height,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 65.h,
                width: 65.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.r),
                    image: DecorationImage(
                        image: AssetImage(AppAssets.dummyChilliIcon),
                        fit: BoxFit.contain)),
              ),
              10.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  10.height,
                  MyText(
                    text: "Red Chili A Fiery Spice that Adds",
                    size: 10.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  3.height,
                  MyText(
                    text: "Product ID : 12155238985",
                    size: 8.sp,
                    color: textPrimaryColor.withOpacity(0.7),
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ],
          ),
          15.height,
          MyText(
            text: "Violation Detail",
            size: 11.sp,
            fontWeight: FontWeight.w600,
          ),
          10.height,
          ReadMoreText(
            style: TextStyle(
                color: textPrimaryColor.withOpacity(0.7),
                fontSize: 8.sp,
                fontWeight: FontWeight.w600),
            'Product  brand name is incorrect: Product pictures are not up to standards , check Copy Right Violations',
            trimMode: TrimMode.Line,
            trimLines: 1,
            colorClickableText: Colors.pink,
            trimCollapsedText: 'Show more',
            trimExpandedText: 'Show less',
            moreStyle: TextStyle(
                color: blackColor, fontSize: 8.sp, fontWeight: FontWeight.bold),
          ),
          10.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: RoundButton(
                    height: 34.h,
                    btnTextSize: 12.sp,
                    textColor: primaryColor,
                    bgColor: transparentColor,
                    borderColor: primaryColor,
                    textFontWeight: FontWeight.w700,
                    borderRadius: BorderRadius.circular(10.r),
                    title: "Delete",
                    onTap: () {
                      Navigator.pop(context);
                    }),
              ),
              10.width,
              Flexible(
                child: RoundButton(
                    height: 34.h,
                    textFontWeight: FontWeight.w700,
                    btnTextSize: 12.sp,
                    borderRadius: BorderRadius.circular(10.r),
                    title: "Edit Product",
                    onTap: () {
                      Navigator.pop(context);
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
