import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/models/shipment/ShipmentFailedModel.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/round-button.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/dialog-extension.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';
import 'package:sugudeni/view/driver/order/arrived-at-vendor.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/shipment/GetAllAvailableShipmentModel.dart';
import '../../../providers/loading-provider.dart';
import '../../../repositories/driver/driver-shipping-repository.dart';
import '../../../utils/customWidgets/my-text.dart';
import '../../../utils/global-functions.dart';

class ArrivedAtCustomer extends StatefulWidget {
  const ArrivedAtCustomer({super.key});

  @override
  State<ArrivedAtCustomer> createState() => _ArrivedAtCustomerState();
}

class _ArrivedAtCustomerState extends State<ArrivedAtCustomer> {
  GoogleMapController? _mapController;
  LatLng? _initialLocation;
  Marker? _marker;
  final failedController=TextEditingController();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as ShipmentModel?;
    double longitude=args!.pickupAddress.longitude;
    double latitude=args.pickupAddress.latitude;
    if (args != null && _initialLocation == null) {
      setState(() {
        _initialLocation = LatLng(latitude, longitude);
        _marker = Marker(
          markerId: const MarkerId("selected-location"),
          position: _initialLocation!,
        );
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    ShipmentModel shipmentModel=ModalRoute.of(context)!.settings.arguments as ShipmentModel;
    double longitude=shipmentModel.pickupAddress.longitude;
    double latitude=shipmentModel.pickupAddress.latitude;
    final loadingProvider=Provider.of<LoadingProvider>(context,listen: false);

    return Scaffold(
      appBar:  AppBar(
        automaticallyImplyLeading: false,
        forceMaterialTransparency: true,
        toolbarHeight: 70.h,
        title: MyText(text: AppLocalizations.of(context)!.vendor,fontWeight: FontWeight.w700,size: 22.sp,),
        actions: [
          GestureDetector(
              onTap: (){
                context.showTextFieldDialog(
                  controller: failedController,
                  keyboardType: TextInputType.text,
                  onYes: ()async{
                    if(failedController.text.isEmpty){
                       showSnackbar(context, AppLocalizations.of(context)!.pleaseenterfailurereason,color: redColor);
                       return;
                    }
                    try{

                      var model=FailedDeliveryModel(failureReason: failedController.text.trim());
                      await DriverShippingRepository.deliveryFailed(model, shipmentModel.id, context).then((v){
                        showSnackbar(context, AppLocalizations.of(context)!.orderhasbeenfailedtodeliver,color: greenColor);
                        Navigator.pushNamedAndRemoveUntil(context, RoutesNames.driverHomeView, (route) => false,);
                      });
                    }catch(e){

                    }
                  },
                  onNo: (){},
                  title: AppLocalizations.of(context)!.failurereason
                );
                //Navigator.pushNamed(context, RoutesNames.driverHelpCenterView);
              },
              child: MyText(text: AppLocalizations.of(context)!.cancel,fontWeight: FontWeight.w700,size: 22.sp,color: const Color(0xffFF0000),)),
          10.width
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            5.height,
            _initialLocation == null
                ? const Center(child: CircularProgressIndicator()) // Show loader if null
                : SizedBox(
              height: 250.h,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _initialLocation!,
                  zoom: 14,
                ),
                onMapCreated: (controller) => _mapController = controller,
                markers: _marker != null ? {_marker!} : {},
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
                          child: MyText(text: "${AppLocalizations.of(context)!.arrivedat}  ${formatDateTime(DateTime.now())}",size: 12.sp,fontWeight: FontWeight.w600),
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

                    MyText(text: AppLocalizations.of(context)!.contactvendor,size: 12.sp,fontWeight: FontWeight.w600),
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
                    MyText(text: AppLocalizations.of(context)!.itemsvalue,size: 12.sp,fontWeight: FontWeight.w600),
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
                      title: AppLocalizations.of(context)!.orderdelivered, onTap: (){
                       showDialog(context: context, builder: (context){
                         return Dialog(
                           backgroundColor: whiteColor,
                           child:  CustomDialog(text: AppLocalizations.of(context)!.doyouconfirmyoudeliveredtheorder,
                               confirmPressed: ()async{
                                 try{
                                   await DriverShippingRepository.deliveredShipment(shipmentModel.id, context).then((v){
                                     showSnackbar(context, AppLocalizations.of(context)!.shipmentdeliveredsuccessfully,color: greenColor);
                                     Navigator.pushNamedAndRemoveUntil(context, RoutesNames.driverHomeView, (route) => false,);
                                   });
                                 }catch(e){

                                 }

                           })
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
