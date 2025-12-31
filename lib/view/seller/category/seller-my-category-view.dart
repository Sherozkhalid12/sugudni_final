import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/models/category/NameModel.dart';
import 'package:sugudeni/providers/category/category-provider.dart';
import 'package:sugudeni/providers/seller-products-tab-provider.dart';
import 'package:sugudeni/repositories/category/category-repository.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/cached-network-image.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/round-button.dart';
import 'package:sugudeni/utils/customWidgets/search-product-textfield.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/dialog-extension.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/utils/customWidgets/shimmer-widgets.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';

import '../../../l10n/app_localizations.dart';
import '../../../providers/seller-scroll-tab-provider.dart';
import '../../../utils/customWidgets/app-bar-title-widget.dart';
import '../../../utils/customWidgets/tab-bar-widget.dart';
import '../home/seller-home-view.dart';

class SellerMyCategoriesView extends StatefulWidget {
  const SellerMyCategoriesView({super.key});

  @override
  State<SellerMyCategoriesView> createState() => _SellerMyCategoriesViewState();
}

class _SellerMyCategoriesViewState extends State<SellerMyCategoriesView> {

  Future<void> refresh() async {
    setState(() {}); // Trigger rebuild
    await Future.delayed(const Duration(milliseconds: 500)); // Optional delay to prevent flickering
  }
  @override
  Widget build(BuildContext context) {
    final categoryProvider=Provider.of<CategoryProvider>(context,listen: false);
    return PopScope(
       onPopInvokedWithResult: (didPop, result) {
         categoryProvider.clearQuery();
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
               AppBarTitleWidget(title: AppLocalizations.of(context)!.mycategories),
              RoundIconButton(onPressed: (){
        context.read<CategoryProvider>().clearResources();
          Navigator.pushNamed(context, RoutesNames.sellerAddCategoryView);
              },iconUrl: AppAssets.addIconT),
            ],
          ),

        ),
        body:Consumer<CategoryProvider>(builder: (context,provider,child){
          return  RefreshIndicator(
            onRefresh: () => refresh(),
            child: Column(
              children: [
                SymmetricPadding(child: Column(
                  children: [
                     SearchProductTextField(
                       hintText: AppLocalizations.of(context)!.searchyoucategory,
                       onChange: (v){
                         provider.changeQuery(v!);
                       },
                       controller: categoryProvider.nameController,),
                    10.height,

                  ],
                )),
                10.height,
                FutureBuilder(
                    future: CategoryRepository.allCategory(context),
                    builder: (context,snapshot){
                      if(snapshot.connectionState==ConnectionState.waiting){
                        return const CategoryGridShimmer();
                      }
                      if(snapshot.hasError){
                        return SizedBox(
                            height: 500.h,

                            child: Center(child: MyText(text: snapshot.error.toString())));
                      }
                      if(snapshot.data!.getAllCategories.isEmpty){
                        return SizedBox(
                          height: 500.h,

                          child:  Center(
                            child: GestureDetector(
                              onTap: (){
                                context.read<CategoryProvider>().clearResources();

                                Navigator.pushNamed(context, RoutesNames.sellerAddCategoryView);
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 10.h,
                                children: [
                                  Image.asset(AppAssets.addCategory),
                                  MyText(text: AppLocalizations.of(context)!.letsaddyourfirstcategory,size: 13.sp,fontWeight: FontWeight.w500,),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                      var data=snapshot.data;
                      var categoryList=data!.getAllCategories;
                      var filteredCategory=categoryList.where((d){
                        return provider.query.isEmpty|| d.name.toLowerCase().toString().contains(provider.query.toLowerCase().toString());
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
                            itemBuilder: (context,index){
                              var categoryData=filteredCategory[index];
                              String categoryId=categoryData.id;
                              return Container(
                                // height: 124.h,
                                  margin: EdgeInsets.only(bottom: 10.h),
                                  color: whiteColor,
                                  child: Padding(
                                    padding:  EdgeInsets.all(12.sp),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            MyCachedNetworkImage(
                                                height:65.h ,
                                                width: 65.w,
                                                radius: 6.r,
                                                imageUrl: "${ApiEndpoints.productUrl}${categoryData.image}"),
                                            // Container(
                                            //   height:65.h ,
                                            //   width: 65.w,
                                            //   decoration: BoxDecoration(
                                            //       borderRadius: BorderRadius.circular(6.r),
                                            //       image:  DecorationImage(image: NetworkImage(categoryData.image),fit: BoxFit.contain)
                                            //   ),
                                            // ),
                                            10.width,
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                MyText(text:capitalizeFirstLetter( categoryData.name),size: 10.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                3.height,
                                                MyText(text: "${AppLocalizations.of(context)!.categoryid} : ${categoryData.id}",size: 8.sp,
                                                  color: textPrimaryColor.withOpacity(0.7),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        10.height,
                                        Row(
                                          children: [
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
                                                  title: AppLocalizations.of(context)!.subcategory,
                                                  onTap: () {
                                                    showDialog(context: context, builder: (context){
                                                      return AlertDialog(
                                                        backgroundColor: whiteColor,

                                                        content: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                          children: [
                                                            ElevatedButton(onPressed: (){
                                                              //  Navigator.pop(context);
                                                              context.showTextFieldDialog(
                                                                  title: AppLocalizations.of(context)!.entername,
                                                                  keyboardType: TextInputType.text,

                                                                  controller: categoryProvider.subcategoryNameController,
                                                                  onNo: (){}, onYes: (){

                                                                context.read<CategoryProvider>().addSubCategory(categoryId, context).then((v){

                                                                });
                                                              });

                                                            }, child: MyText(text: AppLocalizations.of(context)!.add,size: 12.sp,
                                                              fontWeight: FontWeight.w700,
                                                            )),   ElevatedButton(onPressed: (){
                                                              Navigator.pop(context);
                                                              Navigator.pushNamed(context, RoutesNames.sellerSubCategoryView,arguments: categoryId);
                                                            }, child: MyText(text: AppLocalizations.of(context)!.view,size: 12.sp,
                                                              fontWeight: FontWeight.w700,
                                                            )),
                                                          ],
                                                        ),
                                                      );

                                                    });

                                                  }),
                                            ),
                                            5.width,
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

                                                      context.read<CategoryProvider>().updateCategory(categoryId, context).then((v){
                                                        setState(() {});
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
                                                          context.read<CategoryProvider>().deleteCategory(categoryId, context).then((v){
                                                            setState(() {});
                                                          });
                                                        },
                                                        onNo: (){

                                                        }
                                                    );
                                                  }),
                                            ),

                                          ],
                                        )
                                      ],
                                    ),
                                  )
                              );
                            }),
                      );
                    })
              ],
            ),
          );
        },),
      ),
    );
  }
}
class RoundIconButton extends StatelessWidget {
  final String iconUrl;
  final VoidCallback? onPressed;
  const RoundIconButton({super.key, required this.iconUrl, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onPressed,
      child: Material(
        elevation: 2,
        shape: const CircleBorder(),
        child: Container(
          height: 44.h,
          width: 44.w,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primaryColor.withOpacity(0.15),
              border: Border.all(color: whiteColor, width: 5),
              image:  DecorationImage(
                image: AssetImage(iconUrl),
                scale: 3,
              )
          ),
          child: Center(
            child: Image.asset(iconUrl,scale: 3,color: primaryColor,),
          ),
        ),
      ),
    );
  }
}
