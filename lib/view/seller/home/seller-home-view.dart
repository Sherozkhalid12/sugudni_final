import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/providers/image-pickers-provider.dart';
import 'package:sugudeni/providers/seller-scroll-tab-provider.dart';
import 'package:sugudeni/providers/shipping-provider/shipping-provider.dart';
import 'package:sugudeni/repositories/orders/seller-order-repository.dart';
import 'package:sugudeni/repositories/user-repository.dart';
import 'package:sugudeni/utils/customWidgets/cached-network-image.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/round-button.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';
import 'package:sugudeni/utils/sharePreference/save-user-token.dart';
import 'package:sugudeni/utils/shimmer/shimmer-effects.dart';
import 'package:sugudeni/utils/customWidgets/shimmer-widgets.dart';
import 'package:sugudeni/utils/customWidgets/spinkit-loader.dart';
import 'package:sugudeni/view/seller/orders/seller-specific-order-detail-view.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/constants/app-assets.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/customWidgets/app-bar-title-widget.dart';
import '../../../utils/customWidgets/tab-bar-widget.dart';
import '../messages/seller-message-detailed-screen.dart';
import '../products/seller-my-products-view.dart';
import '../../../models/orders/GetAllOrderSellerResponseModel.dart';

class SellerHomeView extends StatefulWidget {
  const SellerHomeView({super.key});

  @override
  State<SellerHomeView> createState() => _SellerHomeViewState();
}

class _SellerHomeViewState extends State<SellerHomeView> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        toolbarHeight: 70.h,
        automaticallyImplyLeading: false,
        title: AppBarTitleWidget(title: AppLocalizations.of(context)!.sellercenter),
        actions: [
          RoundIconButton(
            iconUrl: AppAssets.bellIcon,
            onPressed: () {
              Navigator.pushNamed(context, RoutesNames.notificationsView);
            },
          ),
          15.width,
        ],
      ),
      body: SafeArea(
        child: SymmetricPadding(
          child: Column(
            children: [
              const SellerInfoWidget(isForProfile: true),
              20.height,
             Consumer<ShippingProvider>(
                 builder: (context,provider,child){
               return  Container(
                 //  height: 71.h,
                 width: double.infinity,
                 color: whiteColor,
                 child: Padding(
                   padding: EdgeInsets.all(12.sp),
                   child: Column(
                     children: [
                       GestureDetector(
                         onTap: ()async{
                           var date=await showDatePicker(
                               context: context,
                               initialDate: DateTime.now(),
                               firstDate: DateTime(2000), lastDate: DateTime(2050));
                           if(date!=null){
                             provider.changeDate(date);
                           }
                         },
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             MyText(
                               text: AppLocalizations.of(context)!.orders,
                               fontWeight: FontWeight.w600,
                               size: 12.sp,
                             ),
                             10.width,
                             MyText(
                               text: provider.selectDate,
                               fontWeight: FontWeight.w400,
                               color: textPrimaryColor.withOpacity(0.70),
                               size: 12.sp,
                             ),
                             const Spacer(),
                             // Icon(
                             //   Icons.keyboard_arrow_down_rounded,
                             //   color: textPrimaryColor.withOpacity(0.7),
                             // )
                           ],
                         ),
                       ),
                       10.height,
                       FutureBuilder(
                           future: SellerOrderRepository.getSellerStats(provider.selectDate, context),
                           builder: (context,snapshot){
                             if(snapshot.connectionState==ConnectionState.waiting){
                               return const ListItemShimmer(height: 50);
                             }
                             var data=snapshot.data;
                         return  Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Column(
                               children: [
                                 MyText(
                                   text: data!.orderStats.first.count.toString(),
                                   fontWeight: FontWeight.w500,
                                   size: 10.sp,
                                   color: const Color(0xffFF0000),
                                 ),
                                 5.height,
                                 MyText(
                                   text: AppLocalizations.of(context)!.toprocess,
                                   fontWeight: FontWeight.w500,
                                   size: 10.sp,
                                 ),
                               ],
                             ),
                             Column(
                               children: [
                                 MyText(
                                   text: data.orderStats[2].count.toString(),
                                   fontWeight: FontWeight.w500,
                                   size: 10.sp,
                                 ),
                                 5.height,
                                 MyText(
                                   text: AppLocalizations.of(context)!.shipping,
                                   fontWeight: FontWeight.w500,
                                   size: 10.sp,
                                 ),
                               ],
                             ),
                             Column(
                               children: [
                                 MyText(
                                   text: data.reviewStats.reviewsCount.toString(),
                                   fontWeight: FontWeight.w500,
                                   size: 10.sp,
                                 ),
                                 5.height,
                                 MyText(
                                   text: AppLocalizations.of(context)!.review,
                                   fontWeight: FontWeight.w500,
                                   size: 10.sp,
                                 ),
                               ],
                             ),
                           ],
                         );
                       })
                     ],
                   ),
                 ),
               );
             }),
              10.height,
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Consumer<SellerScrollTabProvider>(
                        builder: (context, provider, child) {
                      return SellerTabBarWidget(
                          onPressed: () {
                            provider.changeHomeTab(SellerHomeTabs.all);
                          },
                          selected:
                              provider.selectedHomeTab == SellerHomeTabs.all,
                          title: AppLocalizations.of(context)!.all);
                    }),
                    Consumer<SellerScrollTabProvider>(
                        builder: (context, provider, child) {
                      return SellerTabBarWidget(
                          onPressed: () {
                            provider.changeHomeTab(SellerHomeTabs.unPaid);
                          },
                          selected:
                              provider.selectedHomeTab == SellerHomeTabs.unPaid,
                          title: AppLocalizations.of(context)!.unpaid);
                    }),
                    Consumer<SellerScrollTabProvider>(
                        builder: (context, provider, child) {
                      return SellerTabBarWidget(
                          onPressed: () {
                            provider.changeHomeTab(SellerHomeTabs.toShip);
                          },
                          selected:
                              provider.selectedHomeTab == SellerHomeTabs.toShip,
                          title: AppLocalizations.of(context)!.toship);
                    }),
                    Consumer<SellerScrollTabProvider>(
                        builder: (context, provider, child) {
                      return SellerTabBarWidget(
                          onPressed: () {
                            provider.changeHomeTab(SellerHomeTabs.delivered);
                          },
                          selected: provider.selectedHomeTab ==
                              SellerHomeTabs.delivered,
                          title: AppLocalizations.of(context)!.delivered);
                    }),
                    Consumer<SellerScrollTabProvider>(
                        builder: (context, provider, child) {
                      return SellerTabBarWidget(
                          onPressed: () {
                            provider.changeHomeTab(SellerHomeTabs.shipping);
                          },
                          selected: provider.selectedHomeTab ==
                              SellerHomeTabs.shipping,
                          title: AppLocalizations.of(context)!.shipping);
                    }),
                    Consumer<SellerScrollTabProvider>(
                        builder: (context, provider, child) {
                      return SellerTabBarWidget(
                          onPressed: () {
                            provider.changeHomeTab(SellerHomeTabs.failure);
                          },
                          selected: provider.selectedHomeTab ==
                              SellerHomeTabs.failure,
                          title: AppLocalizations.of(context)!.failure);
                    }),
                  ],
                ),
              ),
              10.height,
              Consumer<SellerScrollTabProvider>(builder: (context,provider,child){
                return provider.getTab();
              })

            ],
          ),
        ),
      ),
    );
  }
}

class SellerInfoWidget extends StatefulWidget {
  final bool? isShowLastIcon;
  final bool? isForProfile;

  const SellerInfoWidget({super.key, this.isShowLastIcon=false, this.isForProfile=false});

  @override
  State<SellerInfoWidget> createState() => _SellerInfoWidgetState();
}

class _SellerInfoWidgetState extends State<SellerInfoWidget> {
  @override
  Widget build(BuildContext context) {
    final provider=Provider.of<ImagePickerProviders>(context,listen: false);

    return FutureBuilder(
        future: UserRepository.getSellerData(context),
        builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return ShimmerEffects().shimmerForChats();
          }
          var sellerData=snapshot.data;
          customPrint("data=====================$sellerData");
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Consumer<ImagePickerProviders>(builder: (context,provider,child){
                // Priority: Local file > API profile pic > Initials
                final hasLocalPic = provider.sellerProfilePic != null;
                final hasApiPic = sellerData!.user!.profilePic.isNotEmpty;
                
                return Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    image: hasLocalPic
                        ? DecorationImage(image: FileImage(File(provider.sellerProfilePic!.path)), fit: BoxFit.cover)
                        : hasApiPic
                            ? DecorationImage(image: NetworkImage("${ApiEndpoints.productUrl}${sellerData.user!.profilePic}"), fit: BoxFit.cover)
                            : null,
                    shape: BoxShape.circle,
                    color: const Color(0xffBD3C3C),
                  ),
                  child: !hasLocalPic && !hasApiPic
                      ? Center(
                          child: MyText(
                            text: firstTwoLetters(sellerData.user!.name),
                            color: whiteColor,
                            fontWeight: FontWeight.w600,
                            size: 12.sp,
                          ),
                        )
                      : null,
                );
              }),
              Positioned(
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: () async {
                    // Pick image and wait for completion
                    final picked = await provider.pickSellerImage(ImageSource.gallery);
                    // If image was picked, upload it
                    if (picked && context.mounted) {
                      await provider.uploadSellerProfilePicture(context);
                      // Force widget rebuild to show API image after upload
                      if (mounted) {
                        setState(() {});
                      }
                    }
                  },
                  child: Container(
                    width: 20.w,
                    height: 20.h,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(AppAssets.pencilIcon),
                            scale: 2),
                        shape: BoxShape.circle,
                        color: primaryColor),
                  ),
                ),
              ),
            ],
          ),
          15.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                text: capitalizeFirstLetter(sellerData!.user!.name),
                size: 16.sp,
                fontWeight: FontWeight.w600,
              ),
              widget.isForProfile==false?   const SizedBox():
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: primaryColor.withOpacity(0.3), width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.badge_outlined, size: 14.sp, color: primaryColor),
                    5.width,
                    MyText(
                      text: "ID: ",
                      size: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                    MyText(
                      text: sellerData.user!.id,
                      size: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: textPrimaryColor.withOpacity(0.7),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          widget.isShowLastIcon==true? GestureDetector(
            onTap: (){
              Navigator.pushNamed(context, RoutesNames.sellerAccountSettingView);
            },
            child: Container(
              width: 20.w,
              height: 20.h,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(AppAssets.pencilIcon), scale: 2),
                  shape: BoxShape.circle,
                  color: primaryColor),
            ),
          ):const SizedBox()

        ],
      );
    });
  }
}

double calculateTotalPrice(List<CartItem> cartItems) {
  return cartItems.fold(0.0, (total, item) {
    double itemPrice = item.totalProductDiscount > 0 ? item.totalProductDiscount : item.price;
    return total + itemPrice;
  });
}
