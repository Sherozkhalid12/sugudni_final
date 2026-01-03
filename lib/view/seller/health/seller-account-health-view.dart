import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/providers/products/seller-products-tabs/seller-violation-tab-products-provider.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/constants/screen-sizes.dart';
import 'package:sugudeni/utils/customWidgets/cached-network-image.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/customWidgets/tab-bar-widget.dart';
import 'package:sugudeni/utils/extensions/media-query.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/utils/safe-google-fonts.dart';
import 'package:sugudeni/utils/sharePreference/save-user-token.dart';
import 'package:sugudeni/utils/customWidgets/shimmer-widgets.dart';
import 'package:sugudeni/repositories/user-repository.dart';
import 'package:sugudeni/view/seller/messages/seller-message-detailed-screen.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/customWidgets/app-bar-title-widget.dart';

class SellerAccountHealthView extends StatefulWidget {
  const SellerAccountHealthView({super.key});

  @override
  State<SellerAccountHealthView> createState() => _SellerAccountHealthViewState();
}

class _SellerAccountHealthViewState extends State<SellerAccountHealthView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SellerViolationTabProductProvider>().fetchViolationProducts(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth=context.screenWidth;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.h,
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Material(
                elevation: 2,
                shape: const CircleBorder(),
                child: Container(
                  height: 44.h,
                  width: 44.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primaryColor.withOpacity(0.15),
                    border: Border.all(color: whiteColor, width: 5),
                    image: DecorationImage(
                      image: AssetImage(AppAssets.arrowBack),
                      scale: 3,
                    )
                  ),
                  child: Center(
                    child: Image.asset(AppAssets.arrowBack, scale: 3, color: primaryColor,),
                  ),
                ),
              ),
            ),
            20.width,
             AppBarTitleWidget(title: AppLocalizations.of(context)!.accounthealth),

          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height:screenWidth<ScreenSizes.width420? 220.h: 200.h,
              width: double.infinity,
              child: Stack(
                children: [
                  Container(
                    height:screenWidth<ScreenSizes.width420? 140.h
                        : 128.h,
                    width: double.infinity,
                    color:const Color(0xff00C347),
                    child: Column(
                      children: [
                        3.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(AppAssets.smileIcon,scale: 3,),
                            2.width,
                            MyText(text: AppLocalizations.of(context)!.excellent,color: whiteColor,size: 18.sp,fontWeight: FontWeight.w700,),
                          ],
                        ),
                        SymmetricPadding(
                          child: MyText(
                            overflow: TextOverflow.clip,
                            text: AppLocalizations.of(context)!.yourstoreisdoingwell,
                            color: whiteColor,size: 12.sp,fontWeight: FontWeight.w500,),
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height:screenWidth<ScreenSizes.width420? 120.h
                          : 100.h,
                      width:333.w,
                      margin: EdgeInsets.only(top: 60.h),
                      decoration: BoxDecoration(
                        color:whiteColor ,
                        boxShadow: const[
                          BoxShadow(
                            spreadRadius: 1,
                            blurRadius: 2,
                            color: greyColor
                          )
                        ],
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                            Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              MyText(
                                overflow: TextOverflow.clip,
                                text: '0',
                                color: const Color(0xff006D28),
                                size: 18.sp,fontWeight: FontWeight.w700,),
                              2.width,
                              MyText(
                                overflow: TextOverflow.clip,
                                text: AppLocalizations.of(context)!.points,
                                color: blackColor,
                                size: 13.sp,fontWeight: FontWeight.w300,),
                            ],
                          ),
                          6.height,
                          SizedBox(
                              width: 300.w,
                              child: Stack(
                                children: [
                                  const Divider(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            height: 13.h,
                                            width: 5.w,
                                            decoration: const BoxDecoration(
                                                color: Color(0xff006D28),
                                                shape: BoxShape.circle
                                            ),
                                          ),
                                          MyText(text: "0",size: 10.sp,fontWeight: FontWeight.w500,)
                                        ],
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            height: 13.h,
                                            width: 5.w,
                                            decoration: const BoxDecoration(
                                                color: Color(0xffD9D9D9),
                                                shape: BoxShape.circle
                                            ),
                                          ),
                                          MyText(text: "12",size: 10.sp,fontWeight: FontWeight.w500,)
                                        ],
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            height: 13.h,
                                            width: 5.w,
                                            decoration: const BoxDecoration(
                                                color: Color(0xffD9D9D9),
                                                shape: BoxShape.circle
                                            ),
                                          ),
                                          MyText(text: "24",size: 10.sp,fontWeight: FontWeight.w500,)
                                        ],
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            height: 13.h,
                                            width: 5.w,
                                            decoration: const BoxDecoration(
                                                color: Color(0xffD9D9D9),
                                                shape: BoxShape.circle
                                            ),
                                          ),
                                          MyText(text: "36",size: 10.sp,fontWeight: FontWeight.w500,)
                                        ],
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            height: 13.h,
                                            width: 5.w,
                                            decoration: const BoxDecoration(
                                                color: Color(0xffD9D9D9),
                                                shape: BoxShape.circle
                                            ),
                                          ),
                                          MyText(text: "48",size: 10.sp,fontWeight: FontWeight.w500,)
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          4.height,
                          MyText(
                            overflow: TextOverflow.clip,
                            text: 'Range of Points',
                            color: blackColor,
                            size: 11.sp,fontWeight: FontWeight.w500,),
                          2.height,
                          MyText(
                            overflow: TextOverflow.clip,
                            text: "0-48",
                            color: const Color(0xff006D28),
                            size: 12.sp,fontWeight: FontWeight.w700,
                          ),
                          4.height,
                          Container(
                            width: 308.w,
                            decoration: BoxDecoration(
                              color: const Color(0xffFF5050),
                              borderRadius: BorderRadius.circular(7.r)
                            ),
                            child: Padding(
                              padding:  EdgeInsets.symmetric(horizontal: 5.w,vertical: 3.h),
                              child: MyText(
                                overflow: TextOverflow.clip,
                                text: AppLocalizations.of(context)!.whenyoureach12points,
                                color: whiteColor,
                                size: 8.sp,fontWeight: FontWeight.w500,),
                            ),
                          ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SymmetricPadding(
                  child: Consumer<SellerViolationTabProductProvider>(
                    builder: (context, provider, child) {
                      final violationCount = provider.filteredProductList.length;
                      return SellerTabBarWidget(
                        onPressed: (){},
                        selected: true,
                        title: "${AppLocalizations.of(context)!.yourviolations} ($violationCount)",
                        width: 100.w,
                      );
                    },
                  ),
                ),
                10.height,
                Consumer<SellerViolationTabProductProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading && provider.productList.isEmpty) {
                      return Column(
                        children: List.generate(3, (index) => const ListItemShimmer(height: 150)),
                      );
                    }

                    if (provider.errorText.isNotEmpty) {
                      return Center(
                        child: MyText(
                          text: provider.errorText,
                          color: redColor,
                        ),
                      );
                    }

                    if (provider.filteredProductList.isEmpty) {
                      return SizedBox(
                        height: 300.h,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle_outline, size: 64.sp, color: const Color(0xff00C347)),
                              10.height,
                              MyText(
                                text: "No Violations",
                                size: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              5.height,
                              MyText(
                                text: "Your account is in good standing with no violations.",
                                size: 12.sp,
                                color: textSecondaryColor,
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: provider.filteredProductList.length,
                      itemBuilder: (context, index) {
                        final product = provider.filteredProductList[index];
                        final violation = product.violation;
                        
                        return Container(
                          width: double.infinity,
                          color: whiteColor,
                          margin: EdgeInsets.only(bottom: 10.h),
                          child: Padding(
                            padding: EdgeInsets.all(12.sp),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    MyText(
                                      text: "${AppLocalizations.of(context)!.violationid} : ${violation?.id ?? product.id}",
                                      size: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: textPrimaryColor.withOpacity(0.7),
                                    ),
                                    MyText(
                                      text: "0 Point(s)",
                                      size: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: textPrimaryColor.withOpacity(0.7),
                                    ),
                                  ],
                                ),
                                5.height,
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    MyCachedNetworkImage(
                                      height: 65.h,
                                      width: 65.w,
                                      imageUrl: product.bulk == true
                                          ? product.imgCover
                                          : "${ApiEndpoints.productUrl}/${product.imgCover}",
                                    ),
                                    10.width,
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          MyText(
                                            text: capitalizeFirstLetter(product.title.isNotEmpty ? product.title : ''),
                                            size: 10.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          3.height,
                                          MyText(
                                            text: "${AppLocalizations.of(context)!.productid} : ${product.id}",
                                            size: 8.sp,
                                            color: textPrimaryColor.withOpacity(0.7),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        5.height,
                                        GestureDetector(
                                          onTap: () async {
                                            String userId = await getUserId();
                                            await UserRepository.getUserNameAndId('SUGUDENI', context);
                                            if (mounted) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => SellerMessageDetailView(
                                                    receiverId: 'SUGUDENI',
                                                    receiverName: 'SUGUDENI',
                                                    senderId: userId,
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                          child: Container(
                                            height: 32.h,
                                            width: 82.w,
                                            decoration: BoxDecoration(
                                              color: primaryColor,
                                              borderRadius: BorderRadius.circular(18.r)
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                MyText(
                                                  text: AppLocalizations.of(context)!.chat,
                                                  color: whiteColor,
                                                  size: 8.sp,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                Text(
                                                  "SUGUDENI",
                                                  style: SafeGoogleFonts.blinker(
                                                    color: whiteColor,
                                                    fontSize: 10.sp,
                                                    fontWeight: FontWeight.w700
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                if (violation != null) ...[
                                  5.height,
                                  MyText(
                                    overflow: TextOverflow.clip,
                                    text: violation.description.isNotEmpty
                                        ? violation.description
                                        : AppLocalizations.of(context)!.theparcelhasbeenreturnedbythecustomer,
                                    size: 8.sp,
                                    fontWeight: FontWeight.w600,
                                    color: textPrimaryColor.withOpacity(0.7),
                                  ),
                                ],
                              ],
                            ),
                          )
                        );
                      },
                    );
                  },
                )
              ],
            )
          ],
        ),
      ),

    );
  }
}
