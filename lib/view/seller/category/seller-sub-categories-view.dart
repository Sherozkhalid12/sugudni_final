import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/providers/category/category-provider.dart';
import 'package:sugudeni/repositories/category/category-repository.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/app-bar-title-widget.dart';
import 'package:sugudeni/utils/customWidgets/cached-network-image.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/round-button.dart';
import 'package:sugudeni/utils/customWidgets/search-product-textfield.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/dialog-extension.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/utils/customWidgets/shimmer-widgets.dart';
import 'package:sugudeni/view/seller/category/seller-my-category-view.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/routes/routes-name.dart';

class SellerSubCategoriesView extends StatefulWidget {
  const SellerSubCategoriesView({super.key});

  @override
  State<SellerSubCategoriesView> createState() => _SellerSubCategoriesViewState();
}

class _SellerSubCategoriesViewState extends State<SellerSubCategoriesView> {

  Future<void> refresh() async {
    setState(() {}); // Trigger rebuild
    await Future.delayed(const Duration(milliseconds: 500)); // Optional delay to prevent flickering
  }
  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;
    String categoryId;
    bool isSelectionMode = false;
    
    if (arguments is Map) {
      categoryId = arguments['categoryId'] as String;
      isSelectionMode = arguments['isSelectionMode'] as bool? ?? false;
    } else {
      categoryId = arguments as String;
    }
    
    final categoryProvider=Provider.of<CategoryProvider>(context,listen: false);

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        categoryProvider.clearSubQuery();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
               AppBarTitleWidget(title: AppLocalizations.of(context)!.subcategories),
             const Spacer(),
            ],
          ),

        ),
        body: Consumer<CategoryProvider>(
            builder: (context,provider,child){
          return RefreshIndicator(
            onRefresh: () => refresh(),
            child: Column(
              children: [
                SymmetricPadding(child: Column(
                  children: [
                    SearchProductTextField(
                      hintText: AppLocalizations.of(context)!.searchsubcategories,
                      onChange: (v){
                        provider.changeSubQuery(v!);
                      },
                      controller: categoryProvider.subcategoryNameController,),

                    10.height,

                  ],
                )),
                FutureBuilder(
                    future: CategoryRepository.allSubCategory(categoryId,context),
                    builder: (context,snapshot){
                      if(snapshot.connectionState==ConnectionState.waiting){
                        return const CategoryGridShimmer();
                      }
                      if(snapshot.hasError){
                        return SizedBox(
                            height: 500.h,

                            child: Center(child: MyText(text: snapshot.error.toString())));
                      }
                      if(snapshot.data!.getAllSubCategories.isEmpty){
                        return SizedBox(
                          height: 500.h,
                          child:  Center(
                            child:   MyText(text: AppLocalizations.of(context)!.notfound,size: 13.sp,fontWeight: FontWeight.w500,),
                          ),
                        );
                      }
                      var data=snapshot.data;
                      var categoryList=data!.getAllSubCategories;
                      var filteredCategory=categoryList.where((d){
                        return provider.subQuery.isEmpty|| d.name.toLowerCase().toString().contains(provider.subQuery.toLowerCase().toString());
                      }).toList();
                      if(filteredCategory.isEmpty){
                        return SizedBox(
                          height: 500.h,

                          child:  Center(
                            child: GestureDetector(
                              onTap: (){
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 10.h,
                                children: [
                                  MyText(text: AppLocalizations.of(context)!.notfound,size: 13.sp,fontWeight: FontWeight.w500,),
                                ],
                              ),
                            ),
                          ),
                        );

                      }
                      return Expanded(
                        child: ListView.builder(
                            itemCount: filteredCategory.length,
                            itemBuilder: (c,index){
                              var categoryData=filteredCategory[index];
                              String subCategoryId=categoryData.id;
                              return GestureDetector(
                                onTap: isSelectionMode ? () {
                                  // Return selected subcategory data
                                  Navigator.pop(context, {
                                    'id': categoryData.id,
                                    'name': categoryData.name,
                                  });
                                } : null,
                                child: Container(
                                  // height: 124.h,
                                    margin: EdgeInsets.only(bottom: 10.h),
                                    color: whiteColor,
                                    child: Padding(
                                      padding:  EdgeInsets.all(12.sp),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                MyText(text:capitalizeFirstLetter( categoryData.name),size: 10.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                3.height,
                                                MyText(text: "${AppLocalizations.of(context)!.subcategoryid} : ${categoryData.id}",size: 8.sp,
                                                  color: textPrimaryColor.withOpacity(0.7),
                                                  fontWeight: FontWeight.w600,
                                                  overflow: TextOverflow.clip,
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (!isSelectionMode) ...[
                                            10.height,
                                            Flexible(
                                              child: Row(
                                                children: [
                                                  //  50.width,
                                                  Flexible(flex: 3,
                                                    child: RoundButton(
                                                        height: 21.h,
                                                        btnTextSize: 10.sp,
                                                        borderColor: primaryColor,
                                                        bgColor: transparentColor,
                                                        textColor: primaryColor,
                                                        borderRadius:
                                                        BorderRadius.circular(10.r),
                                                        title: AppLocalizations.of(context)!.edit,
                                                        onTap: () {
                                                          categoryProvider.setCategoryName(categoryData.name);
                                                          context.showTextFieldDialog(
                                                              title: AppLocalizations.of(context)!.entername,
                                                              keyboardType: TextInputType.text,
                                                              controller: categoryProvider.nameController,
                                                              onNo: (){}, onYes: (){

                                                            context.read<CategoryProvider>().updateSubCategory(categoryId, categoryData.id,context).then((v){
                                                              // setState(() {});
                                                            });
                                                          });
                                                        }),
                                                  ),

                                                  5.width,
                                                  Flexible(
                                                    flex: 3,
                                                    child: RoundButton(
                                                        height: 21.h,
                                                        btnTextSize: 10.sp,
                                                        borderColor: primaryColor,
                                                        bgColor: transparentColor,
                                                        textColor: primaryColor,
                                                        borderRadius:
                                                        BorderRadius.circular(10.r),
                                                        title: AppLocalizations.of(context)!.delete,
                                                        onTap: () {
                                                          context.showConfirmationDialog(
                                                              title: AppLocalizations.of(context)!.areyousuretodelete,
                                                              onYes: (){
                                                                context.read<CategoryProvider>().deleteSubCategory(categoryId, categoryData.id,context).then((v){
                                                                  // setState(() {});
                                                                });
                                                              },
                                                              onNo: (){

                                                              }
                                                          );
                                                        }),
                                                  ),
                                                  // 50.width,
                                                ],
                                              ),
                                            )
                                          ] else ...[
                                            const Spacer(),
                                            Icon(Icons.arrow_forward_ios, size: 14.sp, color: primaryColor),
                                          ]
                                        ],
                                      ),
                                    )
                                ),
                              );
                            }),
                      );
                    }),
                10.height,
              ],
            ),
          );
        }),
      ),
    );
  }
}
