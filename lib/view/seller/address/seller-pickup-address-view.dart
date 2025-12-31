import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/providers/carts/cart-provider.dart';
import 'package:sugudeni/providers/customer/customer-addresses-provider.dart';
import 'package:sugudeni/providers/sellerProfile/seller-address-provider.dart';
import 'package:sugudeni/providers/shipping-provider/shipping-provider.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/utils/customWidgets/shimmer-widgets.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';

import '../../../utils/constants/colors.dart';
import '../../../l10n/app_localizations.dart';

class SellerAddressView extends StatefulWidget {
  const SellerAddressView({super.key});

  @override
  State<SellerAddressView> createState() => _SellerAddressViewState();
}

class _SellerAddressViewState extends State<SellerAddressView> {
  @override
  void initState() {
    // TODO: implement initState
    Provider.of<SellerAddressProvider>(context,listen: false).fetchUserData(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final provider=   Provider.of<SellerAddressProvider>(context,listen: false);
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
            IconButton(onPressed: (){  Navigator.pop(context);
            }, icon: const Icon(Icons.arrow_back_ios)),
            MyText(text: AppLocalizations.of(context)!.mypickupaddress,size:14.sp ,fontWeight: FontWeight.w600,),
          ],
        ),
      ),
      body: Consumer<SellerAddressProvider>(
          builder: (context,provider,child){
            if(provider.isLoading){
              return Column(
                children: List.generate(3, (index) => const ListItemShimmer(height: 100)),
              );
            }
            if(provider.errorText.isNotEmpty){
              return Center(
                child: MyText(text: provider.errorText),
              );
            }
            return RefreshIndicator(
              onRefresh: () async{
                provider.fetchUserData(context);
              },
              child: Column(spacing: 10.h,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  0.height,
                  GestureDetector(
                    onTap: (){
                      provider.clearResources();
                      Navigator.pushNamed(context, RoutesNames.sellerAddAddressView);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xff00FFF2)),
                          borderRadius: BorderRadius.circular(20.r)
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Padding(
                        padding:  EdgeInsets.symmetric(vertical: 30.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 10.w,
                          children: [
                            Image.asset(AppAssets.addIcon,color: const Color(0xff00FFF2),scale: 3,),
                            MyText(text: AppLocalizations.of(context)!.addaddress,color: const Color(0xff00FFF2),size: 12.sp,fontWeight: FontWeight.w600)
                          ],
                        ),
                      ),
                    ),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: provider.sellerData!.user!.pickups.length,
                      itemBuilder: (context,index){

                        if(provider.sellerData!.user!.pickups.isEmpty){
                          return const SizedBox();
                        }
                        var addressData=provider.sellerData!.user!.pickups[index];
                        return  GestureDetector(
                          onTap: context.read<ShippingProvider>().isComeFromOrder==true? (){
                            context.read<ShippingProvider>().setData(addressData.id, addressData);
                            Navigator.pop(context);
                          }:null,
                          child: Container(
                            color: whiteColor,
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Padding(
                              padding:  EdgeInsets.symmetric(horizontal: 12.w,vertical: 5.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height:50.h ,
                                    width: 50.w,

                                    decoration: BoxDecoration(
                                        image: const DecorationImage(image: AssetImage(AppAssets.dummyMap),fit: BoxFit.cover),
                                        borderRadius: BorderRadius.circular(10.r)
                                    ),
                                  ),
                                  5.width,
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            MyText(text: capitalizeFirstLetter(addressData.firstname),size: 12.sp,fontWeight: FontWeight.w600),
                                            10.width,
                                            MyText(text: addressData.phone,size: 10.sp,fontWeight: FontWeight.w600,color: textSecondaryColor,),
                                            const Spacer(),
                                            GestureDetector(
                                                onTap: (){
                                                  provider.setDataForUpdate(index);
                                                  Navigator.pushNamed(context, RoutesNames.sellerAddAddressView);

                                                },
                                                child: MyText(text: AppLocalizations.of(context)!.edit,color: primaryColor,size: 12.sp,fontWeight: FontWeight.w600))
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Icon(Icons.location_pin,color: const Color(0xff009EE7),size: 12.sp,),
                                            5.width,
                                            SizedBox(
                                              width: 200.w,
                                              child: MyText(
                                                overflow: TextOverflow.clip,
                                                text: "${addressData.street} ${addressData.country}",size: 12.sp,fontWeight: FontWeight.w500,color: textSecondaryColor,),
                                              //  text: "456 Red Pepper Drive, Spicetown Heights, San Diego, CA 92103, USA.",size: 12.sp,fontWeight: FontWeight.w500,color: textSecondaryColor,),
                                            ),

                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      })



                ],
              ),
            );
          }),
    );
  }
}
