import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/models/shipment/GetAllAvailableShipmentModel.dart';
import 'package:sugudeni/providers/loading-provider.dart';
import 'package:sugudeni/repositories/driver/driver-shipping-repository.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/constants/fonts.dart';
import 'package:sugudeni/utils/customWidgets/round-button.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/customWidgets/my-text.dart';

class DriverNewOrderView extends StatefulWidget {
  const DriverNewOrderView({super.key});

  @override
  State<DriverNewOrderView> createState() => _DriverNewOrderViewState();
}

class _DriverNewOrderViewState extends State<DriverNewOrderView> {
  GoogleMapController? _mapController;
  LatLng? _initialLocation;
  Marker? _marker;
  ShipmentModel? _shipmentModel;
  bool _isMapReady = false;

  @override
  void initState() {
    super.initState();
    // Get arguments immediately without blocking
    Future.microtask(() {
      if (mounted) {
        final args = ModalRoute.of(context)?.settings.arguments as ShipmentModel?;
        if (args != null) {
          setState(() {
            _shipmentModel = args;
          });
          if (args.pickupAddress != null) {
            _loadMapAsync(args);
          }
        }
      }
    });
  }

  void _loadMapAsync(ShipmentModel args) {
    Future.microtask(() {
      if (mounted && args.pickupAddress != null) {
        final longitude = args.pickupAddress.longitude;
        final latitude = args.pickupAddress.latitude;
        setState(() {
          _initialLocation = LatLng(latitude, longitude);
          _marker = Marker(
            markerId: const MarkerId("selected-location"),
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
    double longitude=shipmentModel.pickupAddress.longitude;
    double latitude=shipmentModel.pickupAddress.latitude;
    final loadingProvider=Provider.of<LoadingProvider>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        leadingWidth: 50.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 15.w),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 5.w,
              height: 35.h,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: textFieldColor,
                image: DecorationImage(image: AssetImage(AppAssets.backArrow), scale: 3)
              ),
            ),
          ),
        ),
        toolbarHeight: 70.h,
        title: MyText(text: AppLocalizations.of(context)!.neworder,fontWeight: FontWeight.w700,size: 22.sp,),
        actions: [
          MyText(text: AppLocalizations.of(context)!.decline,fontWeight: FontWeight.w700,size: 22.sp,color: const Color(0xffFF0000),),
          10.width
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            5.height,
            _isMapReady && _initialLocation != null
                ? SizedBox(
                    height: 250.h,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _initialLocation!,
                        zoom: 14,
                      ),
                      onMapCreated: (controller) => _mapController = controller,
                      mapType: MapType.normal,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      markers: _marker != null ? {_marker!} : {},
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
            SymmetricPadding(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                10.height,
                MyText(text: "1st Oct 2025 14 : 45",size: 12.sp,fontWeight: FontWeight.w600),
                20.height,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height:14.h ,
                      width: 14.w,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xffFF4800)
                      ),
                    ),
                    10.width,
                    Flexible(
                      child: MyText(
                          overflow: TextOverflow.clip,
                      
                          text: "${AppLocalizations.of(context)!.from} :${shipmentModel.pickupAddress.street}, ${shipmentModel.pickupAddress.city}, ${shipmentModel.pickupAddress.country}",
                          size: 13.sp,fontWeight: FontWeight.w500
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height:14.h ,
                      width: 14.w,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xff6EFF00)
                      ),
                    ),
                    10.width,
                    Flexible(
                      child: MyText(
                        overflow: TextOverflow.clip,
                          text: "${AppLocalizations.of(context)!.destination}:${shipmentModel.shippingAddress!.street}, ${shipmentModel.shippingAddress!.city}, ${shipmentModel.shippingAddress!.country}",
                          size: 13.sp,fontWeight: FontWeight.w500),
                    ),

                  ],
                ),
                40.height,
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
                    MyText(text: "${AppLocalizations.of(context)!.orderprice}",fontWeight: FontWeight.w600,size: 12.sp,),  10.width,
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
                  child: MyText(text: "\$ ${shipmentModel.totalPriceAfterDiscount}",size: 22.sp,
                      color: const Color(0xff005613),
                      fontWeight: FontWeight.w600),
                ),  20.height,
                Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(40.r),
                  child: RoundButton(
                      isLoad: true,
                      height:66.h ,
                      title: AppLocalizations.of(context)!.accept,
                      onTap: ()async{
                        try{
                          loadingProvider.setLoading(true);
                          await DriverShippingRepository.acceptDeliveryToShip(shipmentModel.id, context).then((v){
                            loadingProvider.setLoading(false);
                            showSnackbar(context, AppLocalizations.of(context)!.orderacceptedforshipping,color: greenColor);
                            Navigator.pop(context);
                          });
                        }catch(e){
                          loadingProvider.setLoading(false);

                        }
                        // Navigator.pushNamed(context, RoutesNames.arrivedAtVendor);
                  }),
                ),
                20.height,
              ],
            ))
          ],
        ),
      ),
    );
  }
}
