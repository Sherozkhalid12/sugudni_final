import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/providers/sellerProfile/seller-address-provider.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/shimmer-widgets.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/customWidgets/round-button.dart';
import '../../../utils/customWidgets/text-field.dart';

class SellerAddAddressView extends StatefulWidget {
  const SellerAddAddressView({super.key});

  @override
  State<SellerAddAddressView> createState() => _SellerAddAddressViewState();
}

class _SellerAddAddressViewState extends State<SellerAddAddressView> {
  @override
  void initState() {
    super.initState();
    Provider.of<SellerAddressProvider>(context,listen: false).isUpdate==false?
    Provider.of<SellerAddressProvider>(context,listen: false).getUserLocation(context):null;
  }
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
              text: AppLocalizations.of(context)!.addpckupaddress,
              size: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
      body: Consumer<SellerAddressProvider>(builder: (context,provider,child){
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SymmetricPadding(
                      child: Column(
                        spacing: 10.h,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          0.height,
                          text(title: AppLocalizations.of(context)!.name),
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
                  provider.selectedLocation==null? SizedBox():  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("${AppLocalizations.of(context)!.address}: ${ provider.selectedAddress}"),
                  ),
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
