import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/models/shipment/GetAllAvailableShipmentModel.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/constants/fonts.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/customWidgets/my-text.dart';
import '../../../utils/customWidgets/cached-network-image.dart';

class DriverCompletedShipmentDetailView extends StatefulWidget {
  const DriverCompletedShipmentDetailView({super.key});

  @override
  State<DriverCompletedShipmentDetailView> createState() => _DriverCompletedShipmentDetailViewState();
}

class _DriverCompletedShipmentDetailViewState extends State<DriverCompletedShipmentDetailView> {
  LatLng? _initialLocation;
  Marker? _marker;
  GoogleMapController? _mapController;
  ShipmentModel? _shipmentModel;
  bool _isMapReady = false;

  @override
  void initState() {
    super.initState();
    // Get arguments immediately - use microtask for instant execution
    Future.microtask(() {
      if (mounted) {
        final args = ModalRoute.of(context)?.settings.arguments as ShipmentModel?;
        if (args != null) {
          setState(() {
            _shipmentModel = args;
          });
          // Load map asynchronously without blocking UI
          if (args.shippingAddress != null) {
            _loadMapAsync(args);
          }
        }
      }
    });
  }

  void _loadMapAsync(ShipmentModel args) {
    Future.microtask(() {
      if (mounted && args.shippingAddress != null) {
        final longitude = args.shippingAddress!.longitude;
        final latitude = args.shippingAddress!.latitude;
        setState(() {
          _initialLocation = LatLng(latitude, longitude);
          _marker = Marker(
            markerId: const MarkerId("delivery-location"),
            position: _initialLocation!,
          );
          _isMapReady = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final shipmentModel = _shipmentModel ?? ModalRoute.of(context)?.settings.arguments as ShipmentModel;
    
    if (shipmentModel == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: blackColor),
          onPressed: () => Navigator.pop(context),
        ),
        forceMaterialTransparency: true,
        toolbarHeight: 70.h,
        title: MyText(
          text: AppLocalizations.of(context)!.completedshipments,
          fontWeight: FontWeight.w700,
          size: 22.sp,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            5.height,
            // Show map placeholder immediately, load map async
            _isMapReady && _initialLocation != null
                ? SizedBox(
                    height: 250.h,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _initialLocation!,
                        zoom: 14,
                      ),
                      onMapCreated: (controller) {
                        _mapController = controller;
                      },
                      markers: _marker != null ? {_marker!} : {},
                      mapType: MapType.normal,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                    ),
                  )
                : Container(
                    height: 250.h,
                    color: textFieldColor,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(),
                          10.height,
                          MyText(
                            text: 'Loading map...',
                            size: 12.sp,
                            color: textSecondaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
            SymmetricPadding(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  20.height,
                  // Product Information
                  if (shipmentModel.cartItems.isNotEmpty) ...[
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: blackColor.withAlpha(25),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          MyCachedNetworkImage(
                            height: 70.h,
                            width: 70.w,
                            radius: 8.r,
                            fit: BoxFit.cover,
                            imageUrl: "${ApiEndpoints.productUrl}/${shipmentModel.cartItems[0].product.imgCover}",
                          ),
                          10.width,
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyText(
                                  text: shipmentModel.cartItems[0].product.title,
                                  size: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: AppFonts.jost,
                                ),
                                5.height,
                                MyText(
                                  text: shipmentModel.cartItems[0].product.description,
                                  size: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: AppFonts.poppins,
                                  maxLine: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                5.height,
                                Row(
                                  children: [
                                    const Icon(Icons.star, color: Colors.yellow, size: 16),
                                    5.width,
                                    MyText(
                                      text: shipmentModel.cartItems[0].product.ratingAvg.toString(),
                                      size: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: AppFonts.jost,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    20.height,
                  ],
                  // Pickup Address
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 14.h,
                        width: 14.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffFF4800),
                        ),
                      ),
                      10.width,
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(
                              text: "${AppLocalizations.of(context)!.from}:",
                              size: 13.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            5.height,
                            MyText(
                              overflow: TextOverflow.clip,
                              text: "${shipmentModel.pickupAddress.street}, ${shipmentModel.pickupAddress.city}, ${shipmentModel.pickupAddress.country}",
                              size: 13.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  20.height,
                  Center(
                    child: SizedBox(
                      width: 150.w,
                      child: const Divider(
                        color: textPrimaryColor,
                      ),
                    ),
                  ),
                  20.height,
                  // Delivery Address
                  if (shipmentModel.shippingAddress != null)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 14.h,
                          width: 14.w,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xff6EFF00),
                          ),
                        ),
                        10.width,
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyText(
                                text: "${AppLocalizations.of(context)!.destination}:",
                                size: 13.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              5.height,
                              MyText(
                                overflow: TextOverflow.clip,
                                text: "${shipmentModel.shippingAddress!.street}, ${shipmentModel.shippingAddress!.city}, ${shipmentModel.shippingAddress!.country}",
                                size: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  40.height,
                  // Order Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 80.w,
                        child: const Divider(
                          color: textPrimaryColor,
                        ),
                      ),
                      10.width,
                      MyText(
                        text: AppLocalizations.of(context)!.orderprice,
                        fontWeight: FontWeight.w600,
                        size: 12.sp,
                      ),
                      10.width,
                      SizedBox(
                        width: 80.w,
                        child: const Divider(
                          color: textPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                  10.height,
                  Center(
                    child: MyText(
                      text: "\$ ${shipmentModel.totalPriceAfterDiscount == 0 ? shipmentModel.totalPriceAfterDiscount.toString() : shipmentModel.totalPrice.toString()}",
                      size: 22.sp,
                      color: const Color(0xff005613),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  20.height,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

