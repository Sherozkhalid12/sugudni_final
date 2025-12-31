import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/repositories/category/category-repository.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';

import '../../../l10n/app_localizations.dart';
import '../../../providers/products/customer/all-customer-category-products.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/customWidgets/shimmer-widgets.dart';
import '../appBar/customer-used-appbar.dart';
import '../products/customer-all-product-by-category-view.dart';

class CustomerCategoriesView extends StatelessWidget {
  const CustomerCategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        automaticallyImplyLeading: false,
        forceMaterialTransparency: true,
        toolbarHeight: 70.h,
        flexibleSpace: Container(
          color: whiteColor,
        ),
        title:const CustomerUsedAppBar(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          20.height,
          SymmetricPadding(child: MyText(text: AppLocalizations.of(context)!.shopbycategory,size: 14.sp,fontWeight: FontWeight.w600,)),
          20.height,
          FutureBuilder(
              future: CategoryRepository.allCategory(context),
              builder: (context,snapshot){
                if(snapshot.connectionState==ConnectionState.waiting){
                  return const Expanded(child: CategoryGridShimmer());
                }  if(snapshot.hasError){
                  return Expanded(
                    child: Center(
                      child: MyText(
                        text: snapshot.error.toString(),
                        color: textSecondaryColor,
                        size: 12.sp,
                      ),
                    ),
                  );
                }
                var data=snapshot.data!.getAllCategories;
            return Expanded(
              child: GridView.builder(
                  itemCount: data.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 0.4,
                    mainAxisSpacing:0.7,
                    childAspectRatio: 0.9

                  ),
                  itemBuilder: (context,index){
                    var catData=data[index];
                return  CategoryWidget(title: catData.name, imgUrl: catData.image,onPressed: (){
                  context.read<CustomerFetchProductByCategoryProvider>().updateCategory(catData.id);

                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const CustomerAllProductsByCategoryView()));
                },);
                  }),
            );
          }),
        ],
      ),
    );
  }
}
class CategoryWidget extends StatelessWidget {
  final String title;
  final String imgUrl;
  final VoidCallback? onPressed;
  const CategoryWidget({super.key, required this.title, required this.imgUrl, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onPressed,
      child: SizedBox(
       // height: 109.h,
       // width: 75.w,
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 62.h,
                  width: 75.w,
                  decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(10.r),
                      boxShadow: [
                        BoxShadow(
                            color: blackColor.withAlpha(getAlpha(0.2)),
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: const Offset(-4, 4)
                        )
                      ]
                  ),
                ),
                20.height,
                Container(
                  height: 55.h,
                  width: 65.w,
                  decoration: BoxDecoration(
                    //color: redColor,
                    image: DecorationImage(image: NetworkImage("${ApiEndpoints.productUrl}/$imgUrl"),fit:BoxFit.cover),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ],
            ),
            5.height,
            SizedBox(
              width: 90.w,
              child: MyText(
                  textAlignment: TextAlign.center,
                  overflow: TextOverflow.clip,
                  text: title,size: 10.sp,fontWeight: FontWeight.w500,color: textSecondaryColor),
            )
          ],
        ),
      ),
    );
  }
}
// Row(
//   mainAxisAlignment: MainAxisAlignment.center,
//   children: [
//     MyText(text: "See More",size: 10.sp,fontWeight: FontWeight.w600),
//     const Icon(Icons.keyboard_arrow_down)
//   ],
// ),
// Column(
//   spacing: 7.h,
//   children: List.generate(5, (index) => Container(
//     width: double.infinity,
//     //height: 83.h,
//     margin: EdgeInsets.symmetric(horizontal: 15.h),
//     decoration: BoxDecoration(
//         color: whiteColor,
//         borderRadius: BorderRadius.circular(10.r),
//         boxShadow: [
//           BoxShadow(
//               color: blackColor.withAlpha(getAlpha(0.2)),
//               spreadRadius: 1,
//               blurRadius: 10,
//              // offset: const Offset(-4, 4)
//           )
//         ]
//
//     ),
//     child:  Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         MyText(text: "In the Spotlight",size: 14.sp,fontWeight: FontWeight.w600,),
//         Padding(
//           padding: const EdgeInsets.only(left: 8.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             spacing: 3.h,
//             children: [
//               Row(
//                 children: [
//                   Container(
//                     height: 40.h,
//                     width: 40.w,
//                     decoration: const BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: lightPinkColor
//                     ),
//                     child: Center(
//                       child: MyText(text: "AMY",color: whiteColor,size: 12.sp,fontWeight: FontWeight.w600),
//                     ),
//                   ),
//                   5.width,
//                   MyText(text: "AMY Online Shopping\nStore",size: 12.sp,fontWeight: FontWeight.w600),
//
//                 ],
//               ),
//               Row(
//                 children: [
//                   MyText(text: "84%",size: 12.sp,fontWeight: FontWeight.w600),
//                   MyText(text: "  Positive seller ratings",size: 10.sp,fontWeight: FontWeight.w400),
//                 ],
//               ),
//               Row(
//                 children: List.generate(5, (index) => Image.asset(AppAssets.starIcon,scale: 3,),),
//               )
//
//             ],
//           ),
//         ),
//         Container(
//           width: 129.w,
//           height: 83.h,
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.only(
//                 topRight: Radius.circular(10.r),
//                 bottomRight: Radius.circular(10.r),
//               ),
//               image: const DecorationImage(image: AssetImage(AppAssets.dummyGirlShopping),fit: BoxFit.cover)
//           ),
//         )
//       ],
//     ),
//   ),),
// ),
// 100.height,
