import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/providers/customer/customer-addresses-provider.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/shimmer-widgets.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/customWidgets/round-button.dart';
import '../../../utils/customWidgets/text-field.dart';

class CustomerAddAddressView extends StatefulWidget {
  const CustomerAddAddressView({super.key});

  @override
  State<CustomerAddAddressView> createState() => _CustomerAddAddressViewState();
}

class _CustomerAddAddressViewState extends State<CustomerAddAddressView> {
  // GoogleMapController? _mapController;
  // LatLng? _selectedLocation;
  // String _selectedAddress = "Fetching current location...";
  // bool _isDragging = false;
  // Marker? _marker;
  //
  // String? lat;
  // String? lng;
  @override
  void initState() {
    super.initState();
    Provider.of<CustomerAddressProvider>(context,listen: false).isUpdate==false?
    Provider.of<CustomerAddressProvider>(context,listen: false).getUserLocation(context):null;  }

  // /// Get user's current location
  // Future<void> _getUserLocation() async {
  //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     return _showErrorDialog("Location services are disabled.");
  //   }
  //
  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return _showErrorDialog("Location permission is denied.");
  //     }
  //   }
  //
  //   if (permission == LocationPermission.deniedForever) {
  //     return _showErrorDialog(
  //         "Location permission is permanently denied. Enable it from settings.");
  //   }
  //
  //   // Get current location
  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //
  //   LatLng currentLatLng = LatLng(position.latitude, position.longitude);
  //   setState(() {
  //     _selectedLocation = currentLatLng;
  //     _marker = Marker(
  //       markerId: const MarkerId("selected-location"),
  //       position: currentLatLng,
  //     );
  //   });
  //
  //   _mapController?.animateCamera(CameraUpdate.newLatLngZoom(currentLatLng, 14));
  //   _getAddressFromLatLng(currentLatLng);
  // }
  //
  // /// Get address from LatLng
  // Future<void> _getAddressFromLatLng(LatLng position) async {
  //   try {
  //     List<Placemark> placemarks =
  //     await placemarkFromCoordinates(position.latitude, position.longitude);
  //     if (placemarks.isNotEmpty) {
  //       Placemark place = placemarks.first;
  //       setState(() {
  //         _selectedAddress =
  //         "${place.street}, ${place.locality}, ${place.country}";
  //       });
  //     }
  //   } catch (e) {
  //     print("Error getting address: $e");
  //   }
  // }
  //
  // /// When user scrolls the map
  // void _onCameraMove(CameraPosition position) {
  //   setState(() {
  //     _isDragging = true;
  //     _selectedLocation = position.target;
  //   });
  // }
  //
  // /// When user stops scrolling, update marker and address
  // void _onCameraIdle() {
  //   if (_selectedLocation != null) {
  //     _updateLocation(_selectedLocation!);
  //   }
  // }
  //
  // /// When user taps on map
  // void _onMapTapped(LatLng position) {
  //   _updateLocation(position);
  // }
  //
  // /// Update marker position and address
  // void _updateLocation(LatLng position) {
  //   setState(() {
  //     _selectedLocation = position;
  //     _marker = Marker(
  //       markerId: const MarkerId("selected-location"),
  //       position: position,
  //     );
  //   });
  //   _getAddressFromLatLng(position);
  // }
  //
  // /// Show error dialog
  // void _showErrorDialog(String message) {
  //   showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         title: const Text("Error"),
  //         content: Text(message),
  //         actions: [
  //           TextButton(
  //               onPressed: () => Navigator.pop(context),
  //               child: const Text("OK"))
  //         ],
  //       ));
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        automaticallyImplyLeading: false,
        forceMaterialTransparency: true,
        toolbarHeight: 50.h,
        flexibleSpace: Container(
          color: whiteColor,
        ),
        title: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                }, icon: const Icon(Icons.arrow_back_ios)),
            MyText(
              text: AppLocalizations.of(context)!.addshippingaddress,
              size: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
      body: Consumer<CustomerAddressProvider>(
          builder: (context,provider,child){
        return Column(
          children: [
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SymmetricPadding(
                      child: Column(
                        spacing: 10.h,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          0.height,
                          text(title: AppLocalizations.of(context)!.receipientname),
                          CustomTextFiled(
                            controller: provider.recipientNameController,
                            borderRadius: 10.r,
                            isBorder: true,
                            isShowPrefixIcon: false,
                            isFilled: true,
                            hintText: AppLocalizations.of(context)!.inputtherealname,
                            hintColor: textPrimaryColor.withAlpha(getAlpha(0.70)),
                          ),
                          text(title: AppLocalizations.of(context)!.phonenumber),
                          CustomTextFiled(
                            controller: provider.phoneController,
                            keyboardType: TextInputType.phone,
                            borderRadius: 10.r,
                            isBorder: true,
                            isShowPrefixIcon: false,
                            isFilled: true,
                            hintText: AppLocalizations.of(context)!.pleaseinputphonenumber,
                            hintColor: textPrimaryColor.withAlpha(getAlpha(0.70)),
                          ),
                          text(title: AppLocalizations.of(context)!.regioncitydistrict),
                          CustomTextFiled(
                            controller: provider.cityController,

                            borderRadius: 10.r,
                            isBorder: true,
                            isShowPrefixIcon: false,
                            isFilled: true,
                            hintText: AppLocalizations.of(context)!.pleaseinputregioncitydistrict,
                            hintColor: textPrimaryColor.withAlpha(getAlpha(0.70)),
                          ),  text(title: AppLocalizations.of(context)!.country),
                          CustomTextFiled(
                            controller: provider.countryController,

                            borderRadius: 10.r,
                            isBorder: true,
                            isShowPrefixIcon: false,
                            isFilled: true,
                            hintText: AppLocalizations.of(context)!.pleaseinputregioncitydistrict,
                            hintColor: textPrimaryColor.withAlpha(getAlpha(0.70)),
                          ),
                          text(title: AppLocalizations.of(context)!.address),
                          CustomTextFiled(
                            controller: provider.addressController,

                            borderRadius: 10.r,
                            isBorder: true,
                            isShowPrefixIcon: false,
                            isFilled: true,
                            hintText: AppLocalizations.of(context)!.housenobuildingstreetarea,
                            hintColor: textPrimaryColor.withAlpha(getAlpha(0.70)),
                          ),
                          MyText(
                            text: AppLocalizations.of(context)!.landmark,
                            size: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          CustomTextFiled(
                            controller: provider.landMarkController,

                            borderRadius: 10.r,
                            isBorder: true,
                            isShowPrefixIcon: false,
                            isFilled: true,
                            hintColor: textPrimaryColor.withAlpha(getAlpha(0.70)),
                            hintText: AppLocalizations.of(context)!.addadditionalinfo,
                          ),
                          // Column(
                          //   children: [
                          //     Row(
                          //       children: [
                          //         MyText(
                          //             text: "Address Category",
                          //             size: 14.sp,
                          //             fontWeight: FontWeight.w500),
                          //         const Spacer(),
                          //         checkboxWidget(title: "Home", value: true),
                          //         checkboxWidget(title: "Office", value: false),
                          //       ],
                          //     ),
                          //     Row(
                          //       children: [
                          //         MyText(
                          //             text: "Address Category",
                          //             size: 14.sp,
                          //             fontWeight: FontWeight.w500),
                          //         const Spacer(),
                          //         checkboxWidget(title: "ON", value: true),
                          //         checkboxWidget(title: "Off", value: false),
                          //       ],
                          //     ),
                          //   ],
                          // ),


                        ],
                      ),
                    ),


                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  SymmetricPadding(
                    child: Row(
                      spacing: 5.w,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.location_pin,color: appRedColor,size: 12.sp,),
                        MyText(
                            text: AppLocalizations.of(context)!.selectlocationonmap,
                            size: 14.sp,
                            fontWeight: FontWeight.w500),
                      ],
                    ),
                  ),
                  10.height,
                  provider.selectedLocation==null
                      ? const MapShimmer()
                      : SizedBox(
                          width: double.infinity,
                          height: 183.h,
                          child: GoogleMap(
                            onMapCreated: (controller) {
                              provider.mapController = controller;
                            },
                            initialCameraPosition: CameraPosition(
                              target:  provider.selectedLocation!,
                              zoom: 14.0,
                            ),
                            markers: {
                              Marker(
                                markerId: const MarkerId("selected-location"),
                                position:  provider.selectedLocation!,
                              ),
                            },
                            onTap:  provider.onMapTapped,

                            onCameraMove:  provider.onCameraMove, // Listen for map movement
                            onCameraIdle:provider.onCameraIdle, // Called when user stops moving map/ Detect user tap on map
                          ),
                        ),
                  provider.selectedLocation==null?
                  const SizedBox():   Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("${AppLocalizations.of(context)!.address}: ${ provider.selectedAddress}"),
                  ),

                  // Container(
                  //   height: 143.h,
                  //   width: double.infinity,
                  //   decoration: const BoxDecoration(
                  //     image: DecorationImage(image: AssetImage(AppAssets.dummyMap),fit: BoxFit.cover)
                  //   ),
                  // ),
                  10.height,
                  SymmetricPadding(
                    child: RoundButton(
                        isLoad: true,
                        title:provider.isUpdate==true?AppLocalizations.of(context)!.update: AppLocalizations.of(context)!.save, onTap: (){

                      provider.isUpdate==true?  provider.updateAddress(context): provider.addAddress(context);

                    }),
                  ),
                  10.height,
                ],
              ),
            )
          ],
        );
      }),
    );
  }

  Widget text({required String title}) {
    return Row(
      children: [
        MyText(
          text: title,
          size: 14.sp,
          fontWeight: FontWeight.w600,
        ),
        MyText(
          text: "*",
          size: 12.sp,
          fontWeight: FontWeight.w500,
          color: appRedColor,
        ),
      ],
    );
  }

  Widget checkboxWidget({required String title, required bool value}) {
    return Row(
      children: [
        Checkbox(
            shape: const CircleBorder(),
            activeColor: appBlueColor,
            value: value,
            onChanged: (v) {}),
        MyText(text: title, size: 12.sp, fontWeight: FontWeight.w500),
      ],
    );
  }
}
