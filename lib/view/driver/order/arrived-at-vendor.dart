import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
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
import '../../../models/shipment/GetAllAvailableShipmentModel.dart';
import '../../../providers/loading-provider.dart';
import '../../../utils/customWidgets/my-text.dart';

class ArrivedAtVendor extends StatefulWidget {
  const ArrivedAtVendor({super.key});

  @override
  State<ArrivedAtVendor> createState() => _ArrivedAtVendorState();
}

class _ArrivedAtVendorState extends State<ArrivedAtVendor> {
  GoogleMapController? _mapController;
  LatLng? _initialLocation;
  Marker? _marker;
  ShipmentModel? _shipmentModel;
  bool _isMapReady = false;

  @override
  void initState() {
    super.initState();
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
        title: MyText(text: AppLocalizations.of(context)!.vendor,fontWeight: FontWeight.w700,size: 22.sp,),
        actions: [
          GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, RoutesNames.driverHelpCenterView);
              },
              child: MyText(text: AppLocalizations.of(context)!.help,fontWeight: FontWeight.w700,size: 22.sp,color: const Color(0xffFF0000),)),
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
                Center(
                  child: Material(
                    elevation: 4,  borderRadius: BorderRadius.circular(7.r),
                    child: Container(
                        decoration: BoxDecoration(
                          color: whiteColor,
                          border: Border.all(
                            color: primaryColor
                          ),
                          borderRadius: BorderRadius.circular(7.r)
                        ),
                        child: Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 10.w,vertical: 5.h),
                          child: MyText(text: "${AppLocalizations.of(context)!.arrivedat} ${formatDateTime(DateTime.now())}",size: 12.sp,fontWeight: FontWeight.w600),
                        )),
                  ),
                ),
                10.height,
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
                10.height,
                Center(
                  child: SizedBox(
                    width: 150.w,
                    child: const Divider(
                      color: textPrimaryColor,
                    ),
                  ),
                ),
                10.height,
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
                10.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    MyText(text: "${AppLocalizations.of(context)!.contactvendor}",size: 12.sp,fontWeight: FontWeight.w600),
                    Row(
                      children: [
                        Image.asset(AppAssets.callIcon,scale: 3,),
                        2.width,
                        MyText(text: shipmentModel.pickupAddress.phone,size: 12.sp,
                            textDecoration: TextDecoration.underline,
                            fontWeight: FontWeight.w600),

                      ],
                    )

                  ],
                ),
                20.height,
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
                    MyText(text: AppLocalizations.of(context)!.orderdetail,fontWeight: FontWeight.w600,size: 12.sp,),  10.width,
                    SizedBox(
                      width: 80.w,
                      child: const Divider(
                        color: textPrimaryColor,
                      ),
                    ),
                  ],
                ),
                10.height,

                Row(
                  children: [
                    MyText(text: AppLocalizations.of(context)!.to,size: 12.sp,fontWeight: FontWeight.w600),
                    12.width,
                    MyText(text: shipmentModel.shippingAddress!.firstname,size: 16.sp,fontWeight: FontWeight.w600),
                  ],
                ),
                10.height,
                MyText(text: "${AppLocalizations.of(context)!.totalitems} ${shipmentModel.cartItems.length}",size: 12.sp,fontWeight: FontWeight.w600),
                5.height,
                Row(
                  children: [
                    MyText(text: "${AppLocalizations.of(context)!.itemsvalue} ",size: 12.sp,fontWeight: FontWeight.w600),
                    10.width,
                    MyText(text: "\$ ${shipmentModel.totalPriceAfterDiscount==0? shipmentModel.totalPrice:shipmentModel.totalPriceAfterDiscount }",size: 22.sp,fontWeight: FontWeight.w600,color: primaryColor,),

                  ],
                ),
                5.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    MyText(text: AppLocalizations.of(context)!.contactcustomer,size: 12.sp,fontWeight: FontWeight.w600),
                    Row(
                      children: [
                        Image.asset(AppAssets.callIcon,scale: 3,),
                        2.width,
                        MyText(text: shipmentModel.shippingAddress!.phone,size: 12.sp,
                            textDecoration: TextDecoration.underline,
                            fontWeight: FontWeight.w600),

                      ],
                    )

                  ],
                ),
                15.height,
                Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(40.r),
                  child: RoundButton(
                    btnTextSize: 20.sp,
                      title: AppLocalizations.of(context)!.ordercheckedandpickedup, onTap: (){
                      showDialog(context: context, builder: (context){
                        return Dialog(
                          backgroundColor: whiteColor,
                          child: CustomDialog(text: AppLocalizations.of(context)!.doyouconfirmyoucheckedproperlyandpickedtheorder,
                            confirmPressed: ()async{
                            try{
                              await DriverShippingRepository.shipmentPicked(shipmentModel.id, context).then((v){
                                showSnackbar(context, AppLocalizations.of(context)!.shipmentpickedsuccessfully,color: greenColor);
                                Navigator.pushNamedAndRemoveUntil(context, RoutesNames.driverHomeView, (route) => false,);
                              });
                            }catch(e){

                            }
                         //    Navigator.pushNamed(context, RoutesNames.arrivedAtCustomer);

                          },),
                        );
                      });
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
class CustomDialog extends StatelessWidget {
  final String text;
  final VoidCallback confirmPressed;
  const CustomDialog({super.key, required this.text, required this.confirmPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: Image.asset(AppAssets.appLogo,width: 150.w,)),
        MyText(
          textAlignment: TextAlign.center,
          overflow: TextOverflow.clip,
            fontWeight: FontWeight.w600,
            size: 22.sp,
            text: text),
        10.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RoundButton(
              height: 34.h,
                width: 107.w,
                btnTextSize: 12.sp,
                textColor: primaryColor,
                bgColor: transparentColor,
                borderColor: primaryColor,
                borderRadius: BorderRadius.circular(10.r),
                title: AppLocalizations.of(context)!.cancel, onTap: (){
                Navigator.pop(context);
            }),

            10.width,
            RoundButton(
              height: 34.h,
                width: 107.w,
                btnTextSize: 12.sp,
                borderRadius: BorderRadius.circular(10.r),
                title: AppLocalizations.of(context)!.confirm, onTap: confirmPressed),
          ],
        ),
        10.height,

      ],
    );
  }
}

