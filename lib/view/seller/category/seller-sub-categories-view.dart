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
import 'package:sugudeni/utils/customWidgets/empty-state-widget.dart';
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
                SymmetricPadding(
                  child: Column(
                    children: [
                      8.height,
                      Container(
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: SearchProductTextField(
                          hintText: AppLocalizations.of(context)!.searchsubcategories,
                          onChange: (v) {
                            provider.changeSubQuery(v!);
                          },
                          controller: categoryProvider.subcategoryNameController,
                        ),
                      ),
                      16.height,
                    ],
                  ),
                ),
                // Subcategory count header
                FutureBuilder(
                  future: CategoryRepository.allSubCategory(categoryId, context),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!.getAllSubCategories.isNotEmpty) {
                      final allCategories = snapshot.data!.getAllSubCategories;
                      final filteredCount = allCategories.where((d) {
                        return provider.subQuery.isEmpty || 
                               d.name.toLowerCase().contains(provider.subQuery.toLowerCase());
                      }).length;
                      
                      if (filteredCount > 0) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            children: [
                              MyText(
                                text: '${filteredCount} ${filteredCount == 1 ? 'Subcategory' : 'Subcategories'}',
                                size: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: textPrimaryColor.withOpacity(0.7),
                              ),
                              const Spacer(),
                              if (provider.subQuery.isNotEmpty)
                                GestureDetector(
                                  onTap: () {
                                    provider.changeSubQuery('');
                                    categoryProvider.subcategoryNameController.clear();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                    decoration: BoxDecoration(
                                      color: primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.clear, size: 16.sp, color: primaryColor),
                                        4.width,
                                        MyText(
                                          text: 'Clear',
                                          size: 12.sp,
                                          color: primaryColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      }
                    }
                    return const SizedBox.shrink();
                  },
                ),
                8.height,
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
                        return Expanded(
                          child: Center(
                            child: EmptyStateWidget(
                              title: 'No Subcategories',
                              description: 'This category doesn\'t have any subcategories yet. Add subcategories to better organize your products.',
                              icon: Icons.subdirectory_arrow_right_outlined,
                            ),
                          ),
                        );
                      }
                      var data=snapshot.data;
                      var categoryList=data!.getAllSubCategories;
                      var filteredCategory=categoryList.where((d){
                        return provider.subQuery.isEmpty|| d.name.toLowerCase().toString().contains(provider.subQuery.toLowerCase().toString());
                      }).toList();
                      if(filteredCategory.isEmpty){
                        return Expanded(
                          child: Center(
                            child: EmptyStateWidget(
                              title: 'No Subcategories Found',
                              description: 'No subcategories match your search. Try adjusting your search terms.',
                              icon: Icons.search_off_outlined,
                            ),
                          ),
                        );
                      }
                      return Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          itemCount: filteredCategory.length,
                          itemBuilder: (c, index) {
                            var categoryData = filteredCategory[index];
                            String subCategoryId = categoryData.id;
                            return TweenAnimationBuilder<double>(
                              duration: Duration(milliseconds: 300 + (index * 50)),
                              tween: Tween(begin: 0.0, end: 1.0),
                              curve: Curves.easeOut,
                              builder: (context, value, child) {
                                return Transform.translate(
                                  offset: Offset(0, 20 * (1 - value)),
                                  child: Opacity(
                                    opacity: value,
                                    child: child,
                                  ),
                                );
                              },
                              child: GestureDetector(
                                onTap: isSelectionMode ? () {
                                  // Return selected subcategory data
                                  Navigator.pop(context, {
                                    'id': categoryData.id,
                                    'name': categoryData.name,
                                  });
                                } : null,
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 16.h),
                                  decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: BorderRadius.circular(16.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(16.r),
                                      onTap: isSelectionMode ? () {
                                        Navigator.pop(context, {
                                          'id': categoryData.id,
                                          'name': categoryData.name,
                                        });
                                      } : null,
                                      child: Padding(
                                        padding: EdgeInsets.all(16.sp),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            // Icon/Visual Element
                                            Container(
                                              width: 56.w,
                                              height: 56.h,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    primaryColor.withOpacity(0.2),
                                                    primaryColor.withOpacity(0.1),
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                                borderRadius: BorderRadius.circular(12.r),
                                              ),
                                              child: Icon(
                                                Icons.category_outlined,
                                                color: primaryColor,
                                                size: 28.sp,
                                              ),
                                            ),
                                            16.width,
                                            // Content
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  MyText(
                                                    text: capitalizeFirstLetter(categoryData.name),
                                                    size: 16.sp,
                                                    fontWeight: FontWeight.w700,
                                                    color: blackColor,
                                                  ),
                                                  6.height,
                                                  Container(
                                                    padding: EdgeInsets.symmetric(
                                                      horizontal: 8.w,
                                                      vertical: 4.h,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: textPrimaryColor.withOpacity(0.1),
                                                      borderRadius: BorderRadius.circular(6.r),
                                                    ),
                                                    child: MyText(
                                                      text: "ID: ${categoryData.id.substring(0, 8)}...",
                                                      size: 11.sp,
                                                      color: textPrimaryColor.withOpacity(0.7),
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            if (!isSelectionMode) ...[
                                              // Action Buttons
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  // Edit Button
                                                  Material(
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                      onTap: () {
                                                        categoryProvider.setCategoryName(categoryData.name);
                                                        context.showTextFieldDialog(
                                                          title: AppLocalizations.of(context)!.entername,
                                                          keyboardType: TextInputType.text,
                                                          controller: categoryProvider.nameController,
                                                          onNo: () {},
                                                          onYes: () {
                                                            context.read<CategoryProvider>().updateSubCategory(categoryId, categoryData.id, context).then((v) {
                                                              refresh();
                                                            });
                                                          },
                                                        );
                                                      },
                                                      borderRadius: BorderRadius.circular(8.r),
                                                      child: Container(
                                                        padding: EdgeInsets.all(10.sp),
                                                        decoration: BoxDecoration(
                                                          color: primaryColor.withOpacity(0.1),
                                                          borderRadius: BorderRadius.circular(8.r),
                                                        ),
                                                        child: Icon(
                                                          Icons.edit_outlined,
                                                          size: 20.sp,
                                                          color: primaryColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  12.width,
                                                  // Delete Button
                                                  Material(
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                      onTap: () {
                                                        context.showConfirmationDialog(
                                                          title: AppLocalizations.of(context)!.areyousuretodelete,
                                                          onYes: () {
                                                            context.read<CategoryProvider>().deleteSubCategory(categoryId, categoryData.id, context).then((v) {
                                                              refresh();
                                                            });
                                                          },
                                                          onNo: () {},
                                                        );
                                                      },
                                                      borderRadius: BorderRadius.circular(8.r),
                                                      child: Container(
                                                        padding: EdgeInsets.all(10.sp),
                                                        decoration: BoxDecoration(
                                                          color: appRedColor.withOpacity(0.1),
                                                          borderRadius: BorderRadius.circular(8.r),
                                                        ),
                                                        child: Icon(
                                                          Icons.delete_outline,
                                                          size: 20.sp,
                                                          color: appRedColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ] else ...[
                                              // Selection Mode Indicator
                                              Container(
                                                padding: EdgeInsets.all(8.sp),
                                                decoration: BoxDecoration(
                                                  color: primaryColor.withOpacity(0.1),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  Icons.arrow_forward_ios,
                                                  size: 16.sp,
                                                  color: primaryColor,
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
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
