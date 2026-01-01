import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/providers/category/category-provider.dart';
import 'package:sugudeni/providers/products/products-provider.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/app-bar-title-widget.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';
import 'package:sugudeni/view/seller/home/seller-home-view.dart';
import 'package:sugudeni/view/seller/products/seller-my-products-view.dart';

import '../../../l10n/app_localizations.dart';
import '../../../providers/seller-products-tab-provider.dart';
import '../../../utils/constants/app-assets.dart';

class SellerToolsView extends StatelessWidget {
  const SellerToolsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,

        toolbarHeight: 70.h,
        automaticallyImplyLeading: false,
        title:  AppBarTitleWidget(title: AppLocalizations.of(context)!.tools),
        actions: [
          RoundIconButton(
            iconUrl: AppAssets.bellIcon,
            onPressed: () {
              Navigator.pushNamed(context, RoutesNames.notificationsView);
            },
          ),
          15.width,
        ],
      ),
      body: Column(
        children: [
          const SymmetricPadding(child: SellerInfoWidget()),
          40.height,
           ToolsWidget(title: AppLocalizations.of(context)!.addproduct, img: AppAssets.addProductIcon,iconImg: AppAssets.addIcon,onPressed: (){
             context.read<ProductsProvider>().clearResources();

             Navigator.pushNamed(context, RoutesNames.sellerAddProductView);
           },),
          15.height,
          ToolsWidget(title: AppLocalizations.of(context)!.addcategory,    iconScale: 2,img: AppAssets.addCategory,iconImg: AppAssets.addIcon,onPressed: (){
            context.read<CategoryProvider>().clearResources();

            Navigator.pushNamed(context, RoutesNames.sellerAddCategoryView);
           },),
          15.height,
           ToolsWidget(title: AppLocalizations.of(context)!.myproducts, img: AppAssets.myProductSellerIcon,onPressed: (){
             context.read<SellerProductsTabProvider>().clearResources();

             Navigator.pushNamed(context, RoutesNames.sellerMyProductsView);
          },),
          15.height,
           ToolsWidget(title: AppLocalizations.of(context)!.mycategories, img: AppAssets.myCategory,
             iconScale: 2,
             onPressed: (){
            Navigator.pushNamed(context, RoutesNames.sellerMyCategoriesView);
          },),
          15.height,

           ToolsWidget(title: AppLocalizations.of(context)!.orders, img: AppAssets.orderIcon,onPressed: (){
            Navigator.pushNamed(context, RoutesNames.sellerOrdersView);
          },),
          15.height,
    //
    //        ToolsWidget(title: "Return Orders", img: AppAssets.returnOrderIcon,onPressed: (){
    // Navigator.pushNamed(context, RoutesNames.sellerReturnOrdersView);
    // },),
    //       15.height,

           ToolsWidget(title: AppLocalizations.of(context)!.managereviews, img: AppAssets.manageReviewsIcon,onPressed: (){
    Navigator.pushNamed(context, RoutesNames.sellerManageReviewView);
    },),
          15.height,

    //        ToolsWidget(title: "My Income", img: AppAssets.myIncomeIcon,onPressed: (){
    // Navigator.pushNamed(context, RoutesNames.sellerIncomeView);
    // },),
          15.height,

           // ToolsWidget(title: "Contact Help center", img: AppAssets.helpCenterIcon,onPressed: (){
           //   Navigator.pushNamed(context, RoutesNames.driverHelpCenterView);
           //
           // },),

        ],
      ),
    );
  }
}
class ToolsWidget extends StatelessWidget {
  final String title;
  final String img;
  final String? iconImg;
  final double? iconScale;
  final VoidCallback? onPressed;
  const ToolsWidget({super.key, required this.title,required this.img, this.iconImg, this.onPressed, this.iconScale});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Material(
        elevation: 2,
        child: Container(
          height: 46.h,
          width: double.infinity,
          color: whiteColor,
        //  margin: EdgeInsets.only(bottom: 20.h),
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 15.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  height: 39.h,
                  width: 39.w,
                  img,scale:iconScale?? 3,),
                SizedBox(),
                MyText(text: title,size: 16.sp,fontWeight: FontWeight.w600),
                6.width,
                Image.asset(iconImg?? AppAssets.arrowIcon,color: primaryColor,scale: 3,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
