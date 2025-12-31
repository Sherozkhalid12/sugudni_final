import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/providers/category/category-provider.dart';
import 'package:sugudeni/providers/products/products-provider.dart';
import 'package:sugudeni/providers/seller-add-product-provider.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/round-button.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/view/seller/products/seller-my-products-view.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/constants/app-assets.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/customWidgets/app-bar-title-widget.dart';
import '../../../utils/customWidgets/dropdown-widget.dart';
import '../../../utils/routes/routes-name.dart';

class SellerAddCategoryView extends StatefulWidget {
  const SellerAddCategoryView({super.key});

  @override
  State<SellerAddCategoryView> createState() => _SellerAddCategoryViewState();
}

class _SellerAddCategoryViewState extends State<SellerAddCategoryView> {


  @override
  Widget build(BuildContext context) {
    final productProvider=Provider.of<CategoryProvider>(context,listen: false);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.h,
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RoundIconButton(onPressed: (){
              Navigator.pop(context);
            },iconUrl: AppAssets.arrowBack),
            const Spacer(),
             AppBarTitleWidget(title: AppLocalizations.of(context)!.addcategory),
            const Spacer(),

          ],
        ),
      ),
      body: Consumer<CategoryProvider>(builder: (context,provider,child){
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 8,
              child: SingleChildScrollView(
                child: SymmetricPadding(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      10.height,
                      MyText(text: AppLocalizations.of(context)!.categoryimage,size: 12.sp,fontWeight: FontWeight.w500,),

                      10.height,
                      GestureDetector(
                        onTap: (){
                          provider.pickCategoryImage();
                        },
                        child: Container(
                          height: 200.h,
                          width: double.infinity,
                          margin: const EdgeInsets.only(right: 10),

                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.r),
                              border: Border.all(color: borderColor),
                              image:  DecorationImage(image:provider.categoryPicture==null? const AssetImage(AppAssets.selectProductIcon):
                                  FileImage(File(provider.categoryPicture!.path)),fit:provider.categoryPicture==null? BoxFit.none:BoxFit.cover
                                  ,scale: 2)
                          ),
                        ),
                      ),
                      20.height,
                      Row(
                        children: [

                          MyText(text: AppLocalizations.of(context)!.categoryname,size: 12.sp,fontWeight: FontWeight.w500,),
                          MyText(text: " (English)",size: 8.sp,fontWeight: FontWeight.w500,),
                        ],
                      ),
                      5.height,
                      const Divider(),
                      TextFormField(
                        controller: productProvider.nameController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: AppLocalizations.of(context)!.categoryname,
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.w400,color: blackColor,fontSize: 12.sp,
                            )
                        ),
                      ),
                      const Divider(),

                    ],
                  ),
                ),
              ),
            ),
            10.height,

            //const Spacer(),
            Expanded(
              child: Container(
                height: 72.h,
                width: double.infinity,
                color: whiteColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // RoundButton(
                    //     borderRadius: BorderRadius.circular(5.r),
                    //     height: 34.h,
                    //     width: 163.w,
                    //     btnTextSize: 12.sp,
                    //     bgColor: transparentColor,
                    //     borderColor: primaryColor,
                    //     textColor: primaryColor,
                    //     textFontWeight: FontWeight.w700,
                    //     title: "Save as Draft", onTap: (){}),
                    RoundButton(
                        isLoad: true,
                        borderRadius: BorderRadius.circular(5.r),
                        height: 34.h,
                        width: 163.w,
                        btnTextSize: 12.sp,
                        textFontWeight: FontWeight.w700,
                        title: AppLocalizations.of(context)!.addcategory, onTap: ()async{
                        await productProvider.addCategory(context);
                    }),
                  ],
                ),
              ),
            )
          ],
        );
      }),

    );
  }

  Widget text({required String title}){
    return             Row(
      children: [

        MyText(text: title,size: 12.sp,fontWeight: FontWeight.w500,),
        MyText(text: "*",size: 12.sp,fontWeight: FontWeight.w500,color: appRedColor,),
      ],
    );

  }
}
