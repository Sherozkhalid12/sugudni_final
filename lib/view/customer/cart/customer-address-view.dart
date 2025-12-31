import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/providers/carts/cart-provider.dart';
import 'package:sugudeni/providers/customer/customer-addresses-provider.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/shimmer-widgets.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/constants/colors.dart';

class CustomerAddressView extends StatefulWidget {
  const CustomerAddressView({super.key});

  @override
  State<CustomerAddressView> createState() => _CustomerAddressViewState();
}

class _CustomerAddressViewState extends State<CustomerAddressView> {
  @override
  void initState() {
    super.initState();
    // Fetch data in background without blocking UI
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CustomerAddressProvider>(context,listen: false).fetchUserData(context);
    });
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
            IconButton(onPressed: (){  Navigator.pop(context);
            }, icon: const Icon(Icons.arrow_back_ios)),
            MyText(text: AppLocalizations.of(context)!.myaddress,size:14.sp ,fontWeight: FontWeight.w600,),
          ],
        ),
      ),
      body: Consumer<CustomerAddressProvider>(
          builder: (context,provider,child){
            // Show error if exists
            if(provider.errorText.isNotEmpty && provider.customerData == null){
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(20.sp),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyText(text: provider.errorText, color: textSecondaryColor),
                      20.height,
                      ElevatedButton(
                        onPressed: () => provider.fetchUserData(context),
                        child: MyText(text: "Retry", color: whiteColor),
                      ),
                    ],
                  ),
                ),
              );
            }
            
            // Check if we have data or show shimmer
            final hasData = provider.customerData?.user?.addresses != null;
            final addressList = hasData ? provider.customerData!.user!.addresses : [];
            final isEmpty = hasData && addressList.isEmpty;
            
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
                  Navigator.pushNamed(context, RoutesNames.customerAddAddressView);
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
            // Show shimmer while loading and no cached data
            if(provider.isLoading && !hasData)
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                      child: const ListItemShimmer(height: 80),
                    );
                  },
                ),
              )
            // Show empty state
            else if(isEmpty)
              Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.sp),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_off_outlined, size: 64.sp, color: textSecondaryColor),
                        20.height,
                        MyText(
                          text: "No Address Found",
                          size: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: textSecondaryColor,
                        ),
                        10.height,
                        MyText(
                          text: "You don't have any saved addresses yet. Add your first address to get started.",
                          size: 14.sp,
                          color: textSecondaryColor.withOpacity(0.7),
                          textAlignment: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            // Show address list
            else
              ListView.builder(
                shrinkWrap: true,
                itemCount: addressList.length,
                itemBuilder: (context,index){
                  var addressData=addressList[index];
              return  GestureDetector(
                onTap: context.read<CartProvider>().isComeFromCheckout==true? (){
                  context.read<CartProvider>().setIndex(index);
                  context.read<CartProvider>().setShippingId(addressData.id);
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
                                        Navigator.pushNamed(context, RoutesNames.customerAddAddressView);

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
