import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/repositories/category/category-repository.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/cached-network-image.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/view/customer/products/customer-all-product-by-category-view.dart';

import '../../../l10n/app_localizations.dart';
import '../../../providers/products/customer/all-customer-category-products.dart';


class ShopByCategory extends StatelessWidget {
  const ShopByCategory({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String,dynamic>> list=[
      {
        'title':'Cutlery',
        'pic':AppAssets.cuteryPic,
      },
      {
        'title':'Spices',
        'pic':AppAssets.specPic,
      },
      {
        'title':'Edible Oil',
        'pic':AppAssets.oilPic,
      },
      {
        'title':'Baby Products',
        'pic':AppAssets.babyProducts,
      },
    ];

    return SymmetricPadding(
      child: FutureBuilder(
          future: CategoryRepository.allCategory(context),
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return const SizedBox();
            }  if(snapshot.hasError){
              return const SizedBox();
            }
            var data=snapshot.data!.getAllCategories;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyText(text: AppLocalizations.of(context)!.shopbycategory,size: 14.sp,fontWeight: FontWeight.w700),
            10.height,
            SizedBox(
              height: 120.h,
              child: ListView.builder(
                  itemCount: data.length,
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context,index){
                    final d=data[index];
                    return  GestureDetector(
                      onTap: (){
                        context.read<CustomerFetchProductByCategoryProvider>().updateCategory(d.id);

                        Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomerAllProductsByCategoryView()));
                      },
                      child: Column(
                        children: [
                          MyCachedNetworkImage(
                              height: 90.h,
                              width: 90.w,
                              radius: 4.r,
                              rightMargin: 5.w,
                              imageUrl: "${ApiEndpoints.productUrl}/${d.image}"),
                          // Container(
                          //   height: 90.h,
                          //   width: 90.w,
                          //   margin: EdgeInsets.only(right: 5.w),
                          //   decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.circular(4.r),
                          //       image:  DecorationImage(image: AssetImage(d['pic']),fit: BoxFit.cover),
                          //       border: Border.all(color: primaryColor)
                          //   ),
                          // ),
                          3.height,
                          MyText(text: d.name,size: 10.sp,fontWeight: FontWeight.w700,)
                        ],
                      ),
                    );
                  }),
            )
          ],
        );
      }),
    );
  }
}
