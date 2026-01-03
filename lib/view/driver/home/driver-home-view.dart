import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/models/shipment/GetAllAvailableShipmentModel.dart';
import 'package:sugudeni/providers/driver/driver-provider.dart';
import 'package:sugudeni/providers/shipping-provider/shipping-provider.dart';
import 'package:sugudeni/repositories/driver/driver-shipping-repository.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/constants/enum.dart';
import 'package:sugudeni/utils/constants/fonts.dart';
import 'package:sugudeni/utils/constants/screen-sizes.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/media-query.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';
import 'package:sugudeni/view/driver/home/driver-status-widget.dart';
import 'package:sugudeni/view/driver/sidebar/driver-side-drawer.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/customWidgets/my-text.dart';
import '../../../utils/customWidgets/cached-network-image.dart';

class DriverHomeView extends StatefulWidget {
  const DriverHomeView({super.key});

  @override
  State<DriverHomeView> createState() => _DriverHomeViewState();
}

class _DriverHomeViewState extends State<DriverHomeView> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Clear cache and force refresh on app start to show latest orders
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final provider = context.read<ShippingProvider>();
        // Force refresh to get latest orders instantly
        provider.getAllAvailableShipments(context, forceRefresh: true);
        provider.getAllCompletedShipments(context, forceRefresh: true);
        context.read<DriverProvider>().loadApprovalStatus(context);
      }
    });
  }


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    // Removed dummyOrderData - using real API data from DriverShippingRepository
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      drawer: const DriverDrawer(),
      appBar: AppBar(
        forceMaterialTransparency: true,
        toolbarHeight: 80.h,
        centerTitle: true,
        leadingWidth: 60.w,
        leading: GestureDetector(
          onTap: (){
          scaffoldKey.currentState!.openDrawer();
          },
          child: Container(
            height: 50.h,
            width: 50.w,
            margin: EdgeInsets.only(left: 15.w),
            decoration:  BoxDecoration(
              color: whiteColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: blackColor.withAlpha(getAlpha(0.1)),
                  spreadRadius: 1,
                  blurRadius: 8
                )
              ]
            ),

            child: const Center(
              child: Icon(Icons.menu,color: primaryColor,),
            ),
          ),
        ),
        actions: [
          Consumer<DriverProvider>(builder: (context,provider,child){
            // Check if driver status is underreview - don't show online status
            String? driverStatus = provider.driverStatus;
            if (driverStatus == 'underreview') {
              return const SizedBox.shrink(); // Hide online status when under review
            }
            
            // Use cached online status from provider for instant updates
            bool isOnline = provider.isOnline ?? false;
            return Container(
              width: 67.w,
              height: 20.h,
              margin: EdgeInsets.only(right: 10.w),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.r),
                  color: isOnline==true? const Color(0xff6DFF87):redColor
              ),
              child: Center(
                child: MyText(
                  text:isOnline==true? AppLocalizations.of(context)!.working:AppLocalizations.of(context)!.offline,
                  size: 8.sp,
                  fontWeight: FontWeight.w600,color:isOnline==true? const Color(0xff005613):whiteColor,),
              ),
            );
          })
        ],
        title: MyText(text: AppLocalizations.of(context)!.currentshift,fontWeight: FontWeight.w700,size: 20.sp,),

      ),
      body: Consumer<DriverProvider>(builder: (context, provider, child) {
        // Check if driver status is underreview - show beautiful waiting message
        String? driverStatus = provider.driverStatus;
        if (driverStatus == 'underreview') {
          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 50.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated icon container with gradient
                    Container(
                      width: 120.w,
                      height: 120.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            primaryColor.withOpacity(0.2),
                            primaryColor.withOpacity(0.1),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: 100.w,
                          height: 100.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primaryColor.withOpacity(0.1),
                          ),
                          child: Icon(
                            Icons.hourglass_empty_rounded,
                            size: 60.sp,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                    30.height,
                    // Main title
                    MyText(
                      text: 'Waiting for Approval',
                      size: 28.sp,
                      fontWeight: FontWeight.w700,
                      color: textPrimaryColor,
                    ),
                    15.height,
                    // Subtitle with gradient text effect
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: primaryColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: MyText(
                        text: 'Your driver account is under review',
                        size: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                        textAlignment: TextAlign.center,
                      ),
                    ),
                    25.height,
                    // Description
                    MyText(
                      text: 'Our team is reviewing your application. You\'ll be notified once your account is approved.',
                      size: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: textPrimaryColor.withOpacity(0.7),
                      textAlignment: TextAlign.center,
                    ),
                    40.height,
                    // Decorative dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                          width: 8.w,
                          height: 8.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primaryColor.withOpacity(0.3 + (index * 0.2)),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        
        // Normal content when not under review
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DriverStatusWidget(),
              10.height,
              Consumer<DriverProvider>(builder: (context,provider,child){
                // Use cached online status from provider for instant updates
                bool isOnline = provider.isOnline ?? false;
                // Use driverStatus from API if available, otherwise fallback to isPendingApproval
                String? driverStatus = provider.driverStatus;
                bool isPendingApproval = driverStatus != null 
                    ? driverStatus != 'approved' 
                    : provider.isPendingApproval;
                
                // Determine message based on driverStatus
                String statusMessage = 'Your driver account is pending approval';
                if (driverStatus == 'rejected') {
                  statusMessage = 'Your driver account has been rejected';
                } else if (driverStatus == 'pending') {
                  statusMessage = 'Your driver account is pending approval';
                } else if (driverStatus != 'approved') {
                  statusMessage = 'Your driver account is pending approval';
                }
                
                if(isOnline==false){
                  if(isPendingApproval){
                    return  Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            driverStatus == 'rejected' ? Icons.cancel : Icons.pending_actions, 
                            size: 48.sp, 
                            color: redColor
                          ),
                          10.height,
                          MyText(
                            text: statusMessage,
                            size: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: redColor,
                          ),
                          5.height,
                          MyText(
                            text: driverStatus == 'rejected' 
                                ? 'Please contact admin for more information'
                                : 'Please wait for admin approval before going online',
                            size: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    );
                  }
                  return  Center(
                    child: MyText(text: AppLocalizations.of(context)!.youareoffline),
                  );
                }
                return SymmetricPadding(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tab Bar
                      TabBar(
                        controller: _tabController,
                        labelColor: primaryColor,
                        unselectedLabelColor: textSecondaryColor,
                        indicatorColor: primaryColor,
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        labelPadding: EdgeInsets.symmetric(horizontal: 16.w),
                        tabs: [
                          Tab(
                            child: Text(
                              AppLocalizations.of(context)!.availableshipments,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                              ),
                              overflow: TextOverflow.clip,
                            ),
                          ),
                          Tab(
                            child: Text(
                              'Orders Completed',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                              ),
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ],
                      ),
                      10.height,
                      // Tab Bar View
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: TabBarView(
                          controller: _tabController,
                          physics: const BouncingScrollPhysics(),
                          children: [
                            // Available Shipments Tab - Using cached provider data
                            Consumer<ShippingProvider>(
                              builder: (context, provider, child) {
                                if (provider.isLoading && provider.shipmentModel == null) {
                                  return const Center(child: CircularProgressIndicator());
                                }
                                if (provider.errorText != null && provider.shipmentModel == null) {
                                  return Center(child: MyText(text: provider.errorText!));
                                }
                                final data = provider.shipmentModel
                                    ?.where((shipment) => shipment.shippingAddress != null)
                                    .toList() ?? [];
                                if (data.isEmpty) {
                                  return SizedBox(
                                    height: 250.h,
                                    child: Center(
                                      child: MyText(text: AppLocalizations.of(context)!.notfound),
                                    ),
                                  );
                                }
                                return ListView.builder(
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  cacheExtent: 500,
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    final availableShippingData = data[index];
                                    return CompletedOrderWidget(
                                      key: ValueKey('available_${availableShippingData.id}'),
                                      shipmentModel: availableShippingData,
                                      img: availableShippingData.cartItems[0].product.imgCover,
                                      title: availableShippingData.cartItems[0].product.title,
                                      discription: availableShippingData.cartItems[0].product.description,
                                      stars: availableShippingData.cartItems[0].product.ratingAvg.toString(),
                                      rupees: availableShippingData.cartItems[0].product.price.toString());
                                  },
                                );
                              },
                            ),
                            // Completed Shipments Tab - Using cached provider data
                            Consumer<ShippingProvider>(
                              builder: (context, provider, child) {
                                if (provider.isLoadingCompleted && provider.completedShipments == null) {
                                  return const Center(child: CircularProgressIndicator());
                                }
                                if (provider.errorText != null && provider.completedShipments == null) {
                                  return Center(child: MyText(text: provider.errorText!));
                                }
                                final completedData = provider.completedShipments ?? [];
                                if (completedData.isEmpty) {
                                  return SizedBox(
                                    height: 250.h,
                                    child: Center(
                                      child: MyText(text: AppLocalizations.of(context)!.notfound),
                                    ),
                                  );
                                }
                                return ListView.builder(
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  cacheExtent: 500,
                                  itemCount: completedData.length,
                                  itemBuilder: (context, index) {
                                    final completedShippingData = completedData[index];
                                    return CompletedOrderWidget(
                                      key: ValueKey('completed_${completedShippingData.id}'),
                                      shipmentModel: completedShippingData,
                                      img: completedShippingData.cartItems[0].product.imgCover,
                                      title: completedShippingData.cartItems[0].product.title,
                                      discription: completedShippingData.cartItems[0].product.description,
                                      stars: completedShippingData.cartItems[0].product.ratingAvg.toString(),
                                      rupees: completedShippingData.totalPriceAfterDiscount == 0
                                          ? completedShippingData.totalPriceAfterDiscount.toString()
                                          : completedShippingData.totalPrice.toString());
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      }),
    );
  }
}

class CompletedOrderWidget extends StatelessWidget {
  final ShipmentModel shipmentModel;
  final String img;
  final String title;
  final String discription;
  final String stars;
  final String rupees;
  final bool? isBulk;

  const CompletedOrderWidget({
    super.key, 
    required this.img, 
    required this.title, 
    required this.stars, 
    required this.rupees,
    this.isBulk=false, 
    required this.discription, 
    required this.shipmentModel
  });

  @override
  Widget build(BuildContext context) {
    bool isCompleted = shipmentModel.isDelivered == true;
    return   GestureDetector(
      onTap: () {
        // Only handle card tap for non-completed shipments - instant navigation
        if(!isCompleted){
          if(shipmentModel.trackingStatus==DeliveryStatus.readytoship){
            Navigator.pushNamed(context, RoutesNames.driverNewOrderView,arguments: shipmentModel);
          } else if(shipmentModel.trackingStatus==DeliveryStatus.shipping){
            if(shipmentModel.driverPicked==false){
              Navigator.pushNamed(context, RoutesNames.arrivedAtVendor,arguments: shipmentModel);
            } else if(shipmentModel.driverPicked==true){
              Navigator.pushNamed(context, RoutesNames.arrivedAtCustomer,arguments: shipmentModel);
            }
          }
        }
      },
      child: Container(
        //height: 97.h,
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 10.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: primaryColor
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
          child: Row(
            children: [
              MyCachedNetworkImage(
                height: 70.h,
                width: 70.w,
                radius: 0,
                fit: BoxFit.cover,
                imageUrl: isBulk == true ? img : "${ApiEndpoints.productUrl}/$img",
              ),
              10.width,
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyText(text: title,color: whiteColor,size:16.sp ,fontWeight: FontWeight.w600,
                          fontFamily: AppFonts.jost,
                        ),
                        const Spacer(),

                        const Icon(Icons.star,color: Colors.yellow,),
                        MyText(text: stars,color: whiteColor,size:14.sp ,fontWeight: FontWeight.w600,
                          fontFamily: AppFonts.jost,
                        ),                              ],
                    ),
                    MyText(
                      maxLine: 2,
                      overflow: TextOverflow.clip,
                      text: discription,color: whiteColor,size:10.sp ,fontWeight: FontWeight.w500,
                      fontFamily: AppFonts.poppins,
                    ),
                    Row(
                      children: [
                        MyText(text: AppLocalizations.of(context)!.value,
                          color: whiteColor,size:12.sp ,fontWeight: FontWeight.w600,
                          fontFamily: AppFonts.poppins,
                        ),
                        10.width,
                        MyText(text: rupees,
                          color: whiteColor,size:16.sp ,fontWeight: FontWeight.w600,
                          fontFamily: AppFonts.jost,
                        ),
                        MyText(text: "\$ ",
                          color: whiteColor,size:13.sp ,fontWeight: FontWeight.w300,
                          fontFamily: AppFonts.jost,
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            // Instant navigation - no delay
                            if(isCompleted){
                              Navigator.pushNamed(
                                context, 
                                RoutesNames.driverCompletedShipmentDetailView, 
                                arguments: shipmentModel
                              );
                            } else {
                              if(shipmentModel.trackingStatus==DeliveryStatus.readytoship){
                                Navigator.pushNamed(
                                  context, 
                                  RoutesNames.driverNewOrderView,
                                  arguments: shipmentModel
                                );
                              } else if(shipmentModel.trackingStatus==DeliveryStatus.shipping){
                                if(shipmentModel.driverPicked==false){
                                  Navigator.pushNamed(
                                    context, 
                                    RoutesNames.arrivedAtVendor,
                                    arguments: shipmentModel
                                  );
                                } else if(shipmentModel.driverPicked==true){
                                  Navigator.pushNamed(
                                    context, 
                                    RoutesNames.arrivedAtCustomer,
                                    arguments: shipmentModel
                                  );
                                }
                              }
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color:const Color(0xffDDDDDD),
                                border: Border.all(color: whiteColor),
                                borderRadius: BorderRadius.circular(8.r)
                            ),
                            child: Center(
                              child:   Padding(
                                padding:  EdgeInsets.symmetric(horizontal: 10.w,vertical: 4.h),
                                child: MyText(text: AppLocalizations.of(context)!.view,
                                  color: blackColor,size:13.sp ,fontWeight: FontWeight.w600,
                                  fontFamily: AppFonts.jost,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
