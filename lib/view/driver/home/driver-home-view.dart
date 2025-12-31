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
import 'package:sugudeni/utils/sharePreference/isDriver-online.dart';
import 'package:sugudeni/view/driver/home/driver-status-widget.dart';
import 'package:sugudeni/view/driver/sidebar/driver-side-drawer.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/customWidgets/my-text.dart';

class DriverHomeView extends StatefulWidget {
  const DriverHomeView({super.key});

  @override
  State<DriverHomeView> createState() => _DriverHomeViewState();
}

class _DriverHomeViewState extends State<DriverHomeView> {

  @override
  void initState() {

    context.read<ShippingProvider>().getAllAvailableShipments(context);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            return  FutureBuilder(
                future: isDriverOnline(),
                builder: (context,snapshot){
                  bool isOnline=snapshot.data??false;
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
                });
          })
        ],
        title: MyText(text: AppLocalizations.of(context)!.currentshift,fontWeight: FontWeight.w700,size: 20.sp,),

      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

           const DriverStatusWidget(),
            10.height,
            Consumer<DriverProvider>(builder: (context,provider,child){
              return FutureBuilder(
                  future: isDriverOnline(),
                  builder: (context,u){
                    bool isOnline=u.data??false;
                    if(isOnline==false){
                      return  Center(
                        child: MyText(text: AppLocalizations.of(context)!.youareoffline),
                      );
                    }
                return SymmetricPadding(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      MyText(text: AppLocalizations.of(context)!.availableshipments,fontWeight: FontWeight.w700,size: 22.sp,),
                      5.height,
                      FutureBuilder(
                          future: DriverShippingRepository.getAllAvailableShipment(context),
                          builder: (context,snapshot){
                            if(snapshot.connectionState==ConnectionState.waiting){
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if(snapshot.hasError){
                              return Center(
                                child: MyText(text: snapshot.error.toString()),
                              );
                            }
                            var data = snapshot.data!.shipments.where((shipment) => shipment.shippingAddress != null).toList();
                            if(data.isEmpty){
                              return SizedBox(
                                height: 250.h,
                                child:  Center(
                                  child: MyText(text: AppLocalizations.of(context)!.notfound),
                                ),
                              );
                            }
                            return  ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: data.length,
                                itemBuilder: (context,index){
                                  // var data=dummyOrderData[index];
                                  var availableShippingData=data[index];
                                  return CompletedOrderWidget(
                                      shipmentModel: availableShippingData,
                                      img: availableShippingData.cartItems[0].product.imgCover,
                                      title:  availableShippingData.cartItems[0].product.title,
                                      discription:  availableShippingData.cartItems[0].product.description,
                                      stars:  availableShippingData.cartItems[0].product.ratingAvg.toString(),
                                      rupees:  availableShippingData.cartItems[0].product.price.toString());
                                });
                          })

                    ],
                  ),
                );
              });
            })



          ],
        ),
      ),
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
  bool? isBulk;

   CompletedOrderWidget({super.key, required this.img, required this.title, required this.stars, required this.rupees,this.isBulk=false, required this.discription, required this.shipmentModel});

  @override
  Widget build(BuildContext context) {
    final screenWidth=context.screenWidth;
    final screenHeight=context.screenHeight;
    return   GestureDetector(
      onTap: (){
        if(shipmentModel.trackingStatus==DeliveryStatus.readytoship){
          Navigator.pushNamed(context, RoutesNames.driverNewOrderView,arguments: shipmentModel);
        }
        if(shipmentModel.trackingStatus==DeliveryStatus.shipping){
          if(shipmentModel.driverPicked==false){
            Navigator.pushNamed(context, RoutesNames.arrivedAtVendor,arguments: shipmentModel);
          }
         else if(shipmentModel.driverPicked==true){
            Navigator.pushNamed(context, RoutesNames.arrivedAtCustomer,arguments: shipmentModel);
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
              Container(
                height: 70.h,
                width: 70.w,
                decoration:  BoxDecoration(
                    image: DecorationImage(image: NetworkImage(
                       isBulk==true? img:"${ApiEndpoints.productUrl}/$img"
                    ),fit: BoxFit.cover)
                ),
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
                        Container(
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
