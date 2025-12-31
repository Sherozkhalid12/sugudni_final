import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/models/cart/AddToCartModel.dart';
import 'package:sugudeni/models/products/ProductListResponse.dart';
import 'package:sugudeni/models/wishlist/AddWishListModel.dart';
import 'package:sugudeni/repositories/carts/cart-repository.dart';
import 'package:sugudeni/repositories/products/product-repository.dart';
import 'package:sugudeni/repositories/user-repository.dart';
import 'package:sugudeni/repositories/wishlist/wishlist-repository.dart';
import 'package:sugudeni/utils/constants/fonts.dart';
import 'package:sugudeni/utils/constants/screen-sizes.dart';
import 'package:sugudeni/utils/customWidgets/cached-network-image.dart';
import 'package:sugudeni/utils/customWidgets/loading-dialog.dart';
import 'package:sugudeni/utils/customWidgets/round-button.dart';
import 'package:sugudeni/utils/customWidgets/shimmer-widgets.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/media-query.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/utils/product-status.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/customWidgets/my-text.dart';

class CustomerAllWishListView extends StatefulWidget {
  const CustomerAllWishListView({super.key});

  @override
  State<CustomerAllWishListView> createState() => _CustomerAllWishListViewState();
}

class _CustomerAllWishListViewState extends State<CustomerAllWishListView> {
  final searchController=TextEditingController();
  String query='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        forceMaterialTransparency: true,
        flexibleSpace: Container(
          color: whiteColor,
        ),
        title: Row(
          children: [
            IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: const Icon(Icons.arrow_back_ios)),
            Flexible(
              child: TextFormField(
                controller: searchController,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 10.sp,
                    color: const Color(0xff545454)
                ),
                onChanged: (v){
                  query=v;
                  setState(() {

                  });
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search,color: Color(0xff545454),),
                  hintText: AppLocalizations.of(context)!.searchinwishlist,
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 10.sp,
                      color: const Color(0xff545454)
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(
                      color: primaryColor,

                    ),
                  ),
                  enabledBorder:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(
                      color: primaryColor,

                    ),
                  ) ,
                  focusedBorder:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
      body: FutureBuilder(
          future: WishlistRepository.getWishlistProducts(context),
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return const ProductGridShimmer(
                crossAxisCount: 2,
                aspectRatio: 0.8,
              );
            }
            if(snapshot.hasError){
              return  Center(
                child: MyText(text: snapshot.error.toString()),
              );
            }if(snapshot.data!.getAllUserWishList.isEmpty){
              return  Center(
                child: MyText(text: AppLocalizations.of(context)!.emptywishlist),
              );
            }
            var data=snapshot.data!.getAllUserWishList;
            var filteredList=data.where((d){
              return query.isEmpty||d.title.toString().toLowerCase().contains(query.toLowerCase().toString());
            }).toList();
        return ListView.builder(
            itemCount: filteredList.length,
            itemBuilder: (context,index){
              var wishlistData=filteredList[index];
          return Padding(
            padding:  EdgeInsets.all(8.sp),
            child: GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, RoutesNames.customerProductDetailView,arguments: wishlistData);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyCachedNetworkImage(
                      height:65.h ,
                      width: 65.w,
                      radius: 6.r,
                      imageUrl: "${ApiEndpoints.productUrl}/${wishlistData.imgCover}"),
                  // Container(
                  //   height:65.h ,
                  //   width: 65.w,
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(6.r),
                  //       image:   DecorationImage(image: NetworkImage("${ApiEndpoints.productUrl}/$img"),fit: BoxFit.cover)
                  //   ),
                  // ),
                  10.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      8.height,
                      MyText(text:capitalizeFirstLetter(wishlistData.title ),size: 10.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      3.height,
                      // MyText(text: "AMY Online Shopping Store",size: 8.sp,
                      //   color: textPrimaryColor.withOpacity(0.7),
                      //   fontWeight: FontWeight.w600,
                      // ),
                      // 3.height,
                      MyText(text: "\$ ${wishlistData.priceAfterDiscount?? 76.25}",size: 10.sp, fontWeight: FontWeight.w500,color: appRedColor,),
                      MyText(text: "\$ ${wishlistData.price??85.25}",size: 10.sp, fontWeight: FontWeight.w500,color: greyColor,textDecoration: TextDecoration.lineThrough),


                    ],
                  ),
                  const Spacer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    spacing: 10.h,
                    children: [
                      const Icon(Icons.favorite,color: primaryColor,),
                      RoundButton(
                        height: 21.h,
                        btnTextSize: 12.sp,
                        width: 150.w,
                        borderColor: primaryColor,
                        bgColor: transparentColor,
                        textColor: primaryColor,
                        borderRadius: BorderRadius.circular(10.r),
                        title: AppLocalizations.of(context)!.removefromwishlish,
                        onTap: () async{
                          var model=AddToWishlistModel(productId: wishlistData.id);
                          await WishlistRepository.removeFromWishlist(model, context).then((v){
                            showSnackbar(context, AppLocalizations.of(context)!.producthasbeenaddedtowishlish,color: greenColor);
                            setState(() {

                            });
                          });
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
      }),
    );
  }
}
