
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/providers/notification-provider.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';
import 'package:sugudeni/view/customer/home/order-again.dart';
import 'package:sugudeni/view/customer/home/shop-now-grid-home-page.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/view/customer/home/ad-section.dart';
import 'package:sugudeni/view/customer/home/shop-by-category.dart';
import 'package:sugudeni/view/customer/products/scan/scanned-product-detail.dart';

import '../../../l10n/app_localizations.dart';
import '../products/customer-all-products-view.dart';

class CustomerHomeView extends StatefulWidget {
  const CustomerHomeView({super.key});

  @override
  State<CustomerHomeView> createState() => _CustomerHomeViewState();
}

class _CustomerHomeViewState extends State<CustomerHomeView> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Load notifications for badge count
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().loadNotifications(context);
    });
  }
  var _aspectTolerance = 0.00;
  var _numberOfCameras = 0;
  var _selectedCamera = -1;
  var _useAutoFocus = true;
  var _autoEnableFlash = false;
  ScanResult? scanResult;

  final _flashOnController = TextEditingController(text: 'Flash on');
  final _flashOffController = TextEditingController(text: 'Flash off');
  final _cancelController = TextEditingController(text: 'Cancel');
  Future<void> _scan() async {
    try {
      final result = await BarcodeScanner.scan(
        options: ScanOptions(
          strings: {
            'cancel': _cancelController.text,
            'flash_on': _flashOnController.text,
            'flash_off': _flashOffController.text,
          },
          useCamera: _selectedCamera,
          autoEnableFlash: _autoEnableFlash,
          android: AndroidOptions(
            aspectTolerance: _aspectTolerance,
            useAutoFocus: _useAutoFocus,
          ),
        ),
      );
      setState(() {
        scanResult = result;
        customPrint("Raw Result ===========================${scanResult!.rawContent}");
        if(scanResult!.rawContent.isNotEmpty){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>QRProductDetailsScreen(productId: scanResult!.rawContent,)));
        }
        customPrint("Result============================================================: ${scanResult!.rawContent}");
      });
    } on PlatformException catch (e) {
      setState(() {
        scanResult = ScanResult(
          rawContent: e.code == BarcodeScanner.cameraAccessDenied
              ? 'The user did not grant the camera permission!'
              : 'Unknown error: $e',
        );
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    final List<Map<String,dynamic>> categories=[
      {
        'pic':AppAssets.electronicsCategory,
        'title':'Electronics',
      },
      {
        'pic':AppAssets.clothCategory,
        'title':'Cloths',
      },  {
        'pic':AppAssets.cosmeticsCategory,
        'title':'Cosmetics',
      },
      {
        'pic':AppAssets.electronicsCategory,
        'title':'Electronics',
      },
    ];
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        forceMaterialTransparency: true,
        title: Row(
          children: [
            GestureDetector(
                onTap:(){
                  _scan();

                },
                child: Image.asset(AppAssets.scanIcon,scale: 3,color: greyColor)),
            10.width,
            // Notification Icon with Badge
            Consumer<NotificationProvider>(
              builder: (context, notificationProvider, child) {
                final unreadCount = notificationProvider.unreadCount;
                return Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, RoutesNames.notificationsView);
                      },
                      child: Container(
                        width: 35.w,
                        height: 35.h,
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.notifications_none_outlined,
                          color: primaryColor,
                          size: 20.sp,
                        ),
                      ),
                    ),
                    // Badge for unread notifications
                    if (unreadCount > 0)
                      Positioned(
                        top: 2.h,
                        right: 2.w,
                        child: Container(
                          width: 16.w,
                          height: 16.h,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            border: Border.all(color: whiteColor, width: 1),
                          ),
                          child: Center(
                            child: MyText(
                              text: unreadCount > 99 ? '99+' : unreadCount.toString(),
                              size: 8.sp,
                              fontWeight: FontWeight.w600,
                              color: whiteColor,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            10.width,
            Flexible(
              child: GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const CustomerAllProductsView(isComeFromSearch: true,)));
                },
                child: TextFormField(
                  enabled: false,
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const CustomerAllProductsView()));
                  },
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 10.sp,
                      color: const Color(0xff545454)
                  ),
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.searchinsugudeni,
                    suffixIcon: Container(
                      height: 32.h,
                      width: 80.w,
                      margin: EdgeInsets.all(4.sp),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(5.r)
                      ),
                      child: Center(
                        child: MyText(text: AppLocalizations.of(context)!.search,color: whiteColor,size: 13.sp,fontWeight: FontWeight.w500,),
                      ),
                    ),
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 10.sp,
                        color: const Color(0xff545454)
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: const BorderSide(
                        color: primaryColor,

                      ),
                    ),
                    enabledBorder:OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: const BorderSide(
                        color: primaryColor,

                      ),
                    ) ,
                    focusedBorder:OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: const BorderSide(
                        color: primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Trigger refresh by rebuilding the widgets
          setState(() {});
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(), // Enable pull-to-refresh even when content doesn't scroll
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              15.height,
              SymmetricPadding(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HomeAdSection(),
                    15.height,
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Column(
                  //       children: [
                  //         Container(
                  //           width: 108.w,
                  //           height: 38.h,
                  //           decoration: BoxDecoration(
                  //               color: transparentColor,
                  //               borderRadius: BorderRadius.circular(8.r),
                  //               border: Border.all(color: primaryColor)
                  //           ),
                  //           child: Row(
                  //             children: [
                  //               Image.asset(AppAssets.appLogo,scale: 12,),
                  //               MyText(text: "Earn\nCoins",
                  //                 size: 12.sp,
                  //                 fontWeight: FontWeight.w600,
                  //               )
                  //             ],
                  //           ),
                  //         ),
                  //         3.height,
                  //         Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             MyText(text: "Upto 20% OFF",
                  //               size: 10.sp,
                  //               color: const Color(0xffFFDB66),
                  //               fontWeight: FontWeight.w600,
                  //             ),
                  //             30.width,
                  //             Image.asset(AppAssets.arrowIcon,scale: 3,                        color: const Color(0xffFFDB66),
                  //             )
                  //           ],
                  //         )
                  //       ],
                  //     ),
                  //     6.width,
                  //     Flexible(
                  //       child: SizedBox(
                  //         height:60.h,
                  //         child: ListView.builder(
                  //             itemCount: categories.length,
                  //             scrollDirection: Axis.horizontal,
                  //
                  //             itemBuilder: (context,index){
                  //               final data=categories[index];
                  //               return   Column(
                  //                 children: [
                  //                   Container(
                  //                     width: 62.w,
                  //                     height: 38.h,
                  //                     margin: EdgeInsets.only(right: 3.w),
                  //
                  //                     decoration: BoxDecoration(
                  //                       color: transparentColor,
                  //                       image:  DecorationImage(image: AssetImage(data['pic']),fit: BoxFit.cover),
                  //                       borderRadius: BorderRadius.circular(8.r),
                  //                     ),
                  //                   ),
                  //                   3.height,
                  //                   MyText(text: data['title'],
                  //                     size: 9.sp,
                  //                     fontWeight: FontWeight.w500,
                  //                   )
                  //                 ],
                  //               );
                  //             }),
                  //       ),
                  //     )
                  //   ],
                  // ),
                  // 10.height,
                  // const VoucherAndDiscount()
                ],
              ),
            ),
            // 15.height,
            // const GrabDeal(),
            // const FlatSale(),
            const OrderAgainHome(),
            // 10.height,
            10.height,
            const ShopByCategory(),
            //const ShopNowProductGrid()
             const ShopNowStylishGrid()









          ],
        ),
      ),
      ));
  }
}
