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
              return Column(
                children: List.generate(3, (index) => const ReviewItemShimmer()),
              );
            }

            if (provider.errorText.isNotEmpty) {
              return SizedBox(
                  height: 500.h,
                  child: Center(
                      child: Text(provider.errorText, style: const TextStyle(color: redColor))));
            }
            if (provider.filteredReviewList.isEmpty) {
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
                onRefresh: () => provider.refreshReviews(context),

                child: ListView.builder(
                    itemCount: provider.filteredReviewList.length,
                    itemBuilder: (context,index){
                      var reviewData=provider.filteredReviewList[index];
                      return   Container(
                          width: double.infinity,
                          // height: 144.h,
                          color: whiteColor,
                          margin: EdgeInsets.only(bottom: 10.h),
                          child: Padding(
                            padding:  EdgeInsets.all(12.sp),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyText(text: reviewData.id,size: 12.sp,fontWeight: FontWeight.w500,

                                  color: appRedColor.withOpacity(0.7),
                                ),
                                5.height,
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    MyCachedNetworkImage(
                                        height:65.h ,
                                        width: 65.w,
                                        radius: 6.r,
                                        imageUrl: "${ApiEndpoints.productUrl}/${reviewData.productId.imgCover}"),
                                    // Container(
                                    //   height:65.h ,
                                    //   width: 65.w,
                                    //   decoration: BoxDecoration(
                                    //       borderRadius: BorderRadius.circular(6.r),
                                    //       image:   DecorationImage(image: AssetImage(productsImages[index]),fit: BoxFit.contain)
                                    //   ),
                                    // ),
                                    10.width,
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                        MyText(text: capitalizeFirstLetter(reviewData.productId.title),size: 10.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        3.height,
                                        MyText(text: "${AppLocalizations.of(context)!.productid} : ${reviewData.productId.id}",size: 8.sp,
                                          color: textPrimaryColor.withOpacity(0.7),
                                          fontWeight: FontWeight.w600,
                                        ),

                                      ],
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                                5.height,
                                Row(
                                  children: List.generate(reviewData.rate, (index) => Image.asset(AppAssets.starIcon,scale: 3,),),
                                ),
                                5.height,
                                MyText(
                                  overflow: TextOverflow.clip,
                                  text: capitalizeFirstLetter(reviewData.text),
                                  size: 8.sp,fontWeight: FontWeight.w600,
                                  color: textPrimaryColor.withOpacity(0.7),
                                ),

                                // 5.height,
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     GestureDetector(
                                //       onTap: (){
                                //         Navigator.pushNamed(context, RoutesNames.driverHelpCenterView);
                                //       },
                                //       child: Row(
                                //         children: [
                                //           Image.asset(AppAssets.productChatIcon,scale: 3,),
                                //           2.width,
                                //           MyText(text: "Chat",color: primaryColor,size: 10.sp,fontWeight: FontWeight.w500,),
                                //         ],
                                //       ),
                                //     ),
                                //     Spacer(),
                                //     Container(
                                //       height: 20.h,
                                //       width: 96.w,
                                //       decoration: BoxDecoration(
                                //           color: primaryColor,
                                //           borderRadius: BorderRadius.circular(18.r)
                                //       ),
                                //       child: Column(
                                //         mainAxisAlignment: MainAxisAlignment.center,
                                //         children: [
                                //           MyText(text: "Report Abuse",color: whiteColor,size: 8.sp,fontWeight: FontWeight.w500,),
                                //         ],
                                //       ),
                                //     )
                                //   ],
                                // )

                              ],
                            ),
                          )
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