import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/providers/review/seller-review-provider.dart';
import 'package:sugudeni/providers/seller-product-review-provider.dart';
import 'package:sugudeni/providers/seller-return-order-provider.dart';
import 'package:sugudeni/utils/customWidgets/app-bar-title-widget.dart';
import 'package:sugudeni/utils/customWidgets/cached-network-image.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/search-product-textfield.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/utils/customWidgets/shimmer-widgets.dart';

import '../../../utils/constants/app-assets.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/customWidgets/tab-bar-widget.dart';
import '../../../utils/routes/routes-name.dart';
import '../products/seller-my-products-view.dart';
import '../../../l10n/app_localizations.dart';

class SellerManageReviewView extends StatefulWidget {
  const SellerManageReviewView({super.key});

  @override
  State<SellerManageReviewView> createState() => _SellerManageReviewViewState();
}

class _SellerManageReviewViewState extends State<SellerManageReviewView> {
  late SellerReviewProvider productProvider;
  final ScrollController _scrollController = ScrollController();

  final discountController=TextEditingController();
  @override
  void initState() {
    super.initState();
    productProvider = Provider.of<SellerReviewProvider>(context, listen: false);
    productProvider.fetchSellerReviews(context);
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
      productProvider.fetchSellerReviews(context);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final productsImages=[
      AppAssets.dummyChilliIcon,
      AppAssets.dummyProductTwo,
      AppAssets.dummyProductThree,
      AppAssets.dummyProductFour,
      AppAssets.dummyProductTwo,

    ];
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        context.read<SellerReviewProvider>().clearResources();

      },
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 80.h,
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RoundIconButton(onPressed: (){
              Navigator.pop(context);
            },iconUrl: AppAssets.arrowBack),
            const Spacer(),
             AppBarTitleWidget(title: AppLocalizations.of(context)!.prodcutreview),
            20.width,
            const Spacer()
          ],
        ),
      ),
      body: Column(
        children: [
          SymmetricPadding(child: SearchProductTextField(
            hintText: AppLocalizations.of(context)!.searchreview,
            onChange: (v){
              context.read<SellerReviewProvider>().changeQuery(v!);
            },
          )),
          15.height,
          Consumer<SellerReviewProvider>(builder: (context,provider,child){
            if (provider.isLoading && provider.reviewList.isEmpty) {
              return Expanded(
                child: Column(
                  children: List.generate(3, (index) => const ReviewItemShimmer()),
                ),
              );
            }

            if (provider.errorText.isNotEmpty) {
              return Expanded(
                child: SizedBox(
                  height: 500.h,
                  child: Center(
                    child: Text(provider.errorText, style: const TextStyle(color: redColor))
                  )
                ),
              );
            }
            
            // If reviewList has data but filteredReviewList is empty, it means search filtered everything out
            if (provider.filteredReviewList.isEmpty && provider.reviewList.isNotEmpty) {
              return Expanded(
                child: SizedBox(
                  height: 500.h,
                  child: Center(
                    child: MyText(text: 'No reviews match your search',size: 12.sp,)
                  )
                ),
              );
            }
            
            // If both are empty and not loading, show empty state
            if (provider.filteredReviewList.isEmpty && !provider.isLoading) {
              return Expanded(
                child: SizedBox(
                  height: 500.h,
                  child: Center(
                    child: MyText(text: AppLocalizations.of(context)!.empty,size: 12.sp,)
                  )
                ),
              );
            }
            WidgetsBinding.instance.addPostFrameCallback((_) {
              double screenHeight = MediaQuery.of(context).size.height;
              double itemHeight = 120; // Approximate height of a single list item
              provider.autoLoadMoreIfNeeded(context, screenHeight, itemHeight);
            });
            return  Expanded(
              child: RefreshIndicator(
                onRefresh: () => provider.refreshReviews(context),

                child: ListView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: provider.filteredReviewList.length,
                    itemBuilder: (context,index){
                      var reviewData=provider.filteredReviewList[index];
                      return Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 16.h),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16.r),
                            onTap: () {
                              // Optional: Add tap action if needed
                            },
                            child: Padding(
                              padding: EdgeInsets.all(16.sp),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Review ID Badge
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                    decoration: BoxDecoration(
                                      color: appRedColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8.r),
                                      border: Border.all(
                                        color: appRedColor.withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.receipt_long,
                                          size: 14.sp,
                                          color: appRedColor,
                                        ),
                                        6.width,
                                        MyText(
                                          text: reviewData.id,
                                          size: 10.sp,
                                          fontWeight: FontWeight.w700,
                                          color: appRedColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                  16.height,
                                  // Product Info Section
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Product Image with shadow
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12.r),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.08),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12.r),
                                          child: MyCachedNetworkImage(
                                            height: 85.h,
                                            width: 85.w,
                                            radius: 12.r,
                                            imageUrl: "${ApiEndpoints.productUrl}/${reviewData.productId.imgCover}",
                                          ),
                                        ),
                                      ),
                                      16.width,
                                      // Product Details
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            MyText(
                                              text: capitalizeFirstLetter(reviewData.productId.title),
                                              size: 14.sp,
                                              fontWeight: FontWeight.w700,
                                              color: blackColor,
                                              maxLine: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            8.height,
                                            Flexible(
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                                                decoration: BoxDecoration(
                                                  color: primaryColor.withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(6.r),
                                                  border: Border.all(
                                                    color: primaryColor.withOpacity(0.3),
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons.inventory_2_outlined,
                                                      size: 12.sp,
                                                      color: primaryColor,
                                                    ),
                                                    6.width,
                                                    Flexible(
                                                      child: MyText(
                                                        text: "${AppLocalizations.of(context)!.productid}: ${reviewData.productId.id}",
                                                        size: 10.sp,
                                                        color: primaryColor,
                                                        fontWeight: FontWeight.w600,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  16.height,
                                  // Rating Section
                                  Container(
                                    padding: EdgeInsets.all(12.sp),
                                    decoration: BoxDecoration(
                                      color: bgColor,
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: Row(
                                      children: [
                                        // Star Rating
                                        Row(
                                          children: List.generate(5, (index) {
                                            return Padding(
                                              padding: EdgeInsets.only(right: 3.w),
                                              child: Icon(
                                                index < reviewData.rate 
                                                    ? Icons.star 
                                                    : Icons.star_border,
                                                color: index < reviewData.rate 
                                                    ? Colors.amber 
                                                    : Colors.grey[300],
                                                size: 20.sp,
                                              ),
                                            );
                                          }),
                                        ),
                                        12.width,
                                        Container(
                                          width: 1,
                                          height: 20.h,
                                          color: textPrimaryColor.withOpacity(0.2),
                                        ),
                                        12.width,
                                        MyText(
                                          text: "${reviewData.rate}/5",
                                          size: 13.sp,
                                          fontWeight: FontWeight.w700,
                                          color: textPrimaryColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                  16.height,
                                  // Review Text
                                  Container(
                                    padding: EdgeInsets.all(14.sp),
                                    decoration: BoxDecoration(
                                      color: whiteColor,
                                      borderRadius: BorderRadius.circular(10.r),
                                      border: Border.all(
                                        color: textPrimaryColor.withOpacity(0.1),
                                        width: 1,
                                      ),
                                    ),
                                    child: MyText(
                                      overflow: TextOverflow.visible,
                                      text: capitalizeFirstLetter(reviewData.text),
                                      size: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: textPrimaryColor,
                                      maxLine: null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            );
          }),
        ],
      ),
    ));
  }
}
// Row(
//   mainAxisAlignment: MainAxisAlignment.center,
//   children: [
//     Consumer<SellerProductReviewProvider>(
//         builder: (context, provider, child) {
//           return SellerTabBarWidget(
//               onPressed: () {
//                 provider.changeProductReviewTab(SellerProductReviewTabs.products);
//               },
//               width: 70.w,
//               selected:
//               provider.selectProductReviewTab == SellerProductReviewTabs.products,
//               title: SellerProductReviewTabs.products);
//         }),
//     40.width,
//     Consumer<SellerProductReviewProvider>(
//         builder: (context, provider, child) {
//           return SellerTabBarWidget(
//               onPressed: () {
//                 provider.changeProductReviewTab(SellerProductReviewTabs.delivery);
//               },
//               width: 70.w,
//               selected:
//               provider.selectProductReviewTab == SellerProductReviewTabs.delivery,
//               title: SellerProductReviewTabs.delivery);
//         }),
//
//   ],
// ),
// 10.height,