import 'dart:io';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:barcode_scan2/model/android_options.dart';
import 'package:barcode_scan2/model/scan_options.dart';
import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/providers/category/category-provider.dart';
import 'package:sugudeni/providers/products/products-provider.dart';
import 'package:sugudeni/providers/seller-add-product-provider.dart';
import 'package:sugudeni/repositories/category/category-repository.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/round-button.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/dialog-extension.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/view/seller/products/seller-my-products-view.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/constants/app-assets.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/customWidgets/app-bar-title-widget.dart';
import '../../../utils/customWidgets/dropdown-widget.dart';
import '../../../utils/routes/routes-name.dart';
import '../../customer/products/scan/scanned-product-detail.dart';

class SellerAddProductView extends StatefulWidget {
  const SellerAddProductView({super.key});

  @override
  State<SellerAddProductView> createState() => _SellerAddProductViewState();
}

class _SellerAddProductViewState extends State<SellerAddProductView> {

  var _aspectTolerance = 0.00;
  var _numberOfCameras = 0;
  var _selectedCamera = -1;
  var _useAutoFocus = true;
  var _autoEnableFlash = false;
  ScanResult? scanResult;

  final _flashOnController = TextEditingController(text: 'Flash on');
  final _flashOffController = TextEditingController(text: 'Flash off');
  final _cancelController = TextEditingController(text: 'Cancel');

  Future<void> _scan() async {
    try {
      final result = await BarcodeScanner.scan(
        options: ScanOptions(
          strings: {
            'cancel': _cancelController.text,
            'flash_on': _flashOnController.text,
            'flash_off': _flashOffController.text,
          },
          useCamera: _selectedCamera,
          autoEnableFlash: _autoEnableFlash,
          android: AndroidOptions(
            aspectTolerance: _aspectTolerance,
            useAutoFocus: _useAutoFocus,
          ),
        ),
      );
      setState(() {
        scanResult = result;
        customPrint("Raw Result ===========================${scanResult!.rawContent}");
        if(scanResult!.rawContent.isNotEmpty){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>QRProductDetailsScreen(productId: scanResult!.rawContent,isSeller: true,)));
        }
        customPrint("Result============================================================: ${scanResult!.rawContent}");
      });
    } on PlatformException catch (e) {
      setState(() {
        scanResult = ScanResult(
          rawContent: e.code == BarcodeScanner.cameraAccessDenied
              ? 'The user did not grant the camera permission!'
              : 'Unknown error: $e',
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final productProvider=Provider.of<ProductsProvider>(context,listen: false);

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
             AppBarTitleWidget(title: AppLocalizations.of(context)!.addproduct),


            GestureDetector(
                onTap: (){
                  _scan();

                },
                child: Image.asset(AppAssets.scanIcon,scale: 3,))
          ],
        ),
      ),
      body: Column(
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MyText(text: AppLocalizations.of(context)!.productimages,size: 12.sp,fontWeight: FontWeight.w500,),
                        10.width,
                       Consumer<ProductsProvider>(builder: (context,provider,child){
                         return  Row(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             MyText(text: "(${provider.files.length}/8)",size: 10.sp,fontWeight: FontWeight.w500,),
                             MyText(text: "*",size: 12.sp,fontWeight: FontWeight.w500,color: const Color(0xffFF0000),),
                           ],
                         );
                       })
                      ],
                    ),
                    10.height,
                    Consumer<ProductsProvider>(builder: (context,provider,child){
                      return Wrap(
                        children: [
                          GestureDetector(
                            onTap: (){
                              provider.pickFile();
                            },
                            child: Container(
                              height: 60.h,
                              width: 60.w,
                              margin: const EdgeInsets.only(right: 10),

                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.r),
                                  border: Border.all(color: borderColor),
                                  image: const DecorationImage(image: AssetImage(AppAssets.selectProductIcon),scale: 3)
                              ),
                            ),
                          ),
                          ...provider.files.map((f){
                            return Container(
                              height: 60.h,
                              width: 60.w,
                              margin: EdgeInsets.only(right: 10.w,bottom: 10.h),
                              child: Stack(
                                children: [
                                  Container(
                                    height: 60.h,
                                    width: 60.w,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5.r),
                                        color: whiteColor,
                                        image:  DecorationImage(image: FileImage(File(f.path)),scale: 3,fit: BoxFit.cover)
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: GestureDetector(
                                      onTap: (){
                                        provider.removeFile(f);
                                      },
                                      child: Container(
                                        height: 13.h,
                                        width: 13.w,
                                        decoration: BoxDecoration(
                                            color: appRedColor,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(2.r),
                                              topRight: Radius.circular(5.r),
                                              bottomRight: Radius.circular(2.r),
                                              bottomLeft: Radius.circular(2.r),
                                            ),
                                            image: const DecorationImage(image: AssetImage(AppAssets.productRemoveIcon),scale: 2)
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          })
                        ],
                      );
                    }),
                    10.height,
                    Row(
                      children: [

                        MyText(text: AppLocalizations.of(context)!.productname,size: 12.sp,fontWeight: FontWeight.w500,),
                        MyText(text: "(English)",size: 8.sp,fontWeight: FontWeight.w500,),
                        MyText(text: "*",size: 12.sp,fontWeight: FontWeight.w500,color: appRedColor,),
                      ],
                    ),
                    5.height,
                    const Divider(),
                    TextFormField(
                      controller: productProvider.productTitleController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: AppLocalizations.of(context)!.productname,
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w400,color: blackColor,fontSize: 12.sp,
                          )
                      ),
                    ),
                    const Divider(),
                    text(title: AppLocalizations.of(context)!.selectcategory),
                    5.height,

                    FutureBuilder(
                        future: CategoryRepository.allCategory(context),
                        builder: (context,snapshot){
                          if(snapshot.connectionState==ConnectionState.waiting){
                            return const Center(
                              child: SizedBox(),
                            );
                          }
                          if(snapshot.data!.getAllCategories.isEmpty){
                            return Center(
                              child: GestureDetector(
                                onTap: (){
                                  context.read<CategoryProvider>().clearResources();

                                  Navigator.pushNamed(context, RoutesNames.sellerAddCategoryView);
                                },
                                child: MyText(text: AppLocalizations.of(context)!.letsaddyourfirstcategory,size: 13.sp,fontWeight: FontWeight.w500,),
                              ),
                            );
                          }
                          var data =snapshot.data!;
                          var catList=data.getAllCategories;
                          List<Map<String, String>> extractedList = catList.map((category) {
                            return {
                              'id': category.id,
                              'name': category.name,
                            };
                          }).toList();
                          return Consumer<ProductsProvider>(builder: (context,provider,child){
                            return DropDownWidget(
                              textName: AppLocalizations.of(context)!.category,
                              initialValue: provider.category,
                              list: extractedList.map((cat){
                                return cat['name']!;
                              }).toList(),
                              onChange: (value){
                                customPrint("Value================================$value");
                                provider.changeCategoryList(value!);
                                final newCategoryId = extractedList
                                    .firstWhere((category) => category['name'] == value)['id']!;
                                
                                // Only clear subcategory if category actually changed
                                if (productProvider.categoryId != newCategoryId) {
                                  productProvider.changeSubCategoryList('');
                                  productProvider.subCategoryId = null;
                                  productProvider.notifyListeners();
                                }
                                productProvider.setCategoryId(newCategoryId);
                              },
                            );
                          });
                        }),
                    10.height,
                    Consumer<ProductsProvider>(builder: (context,provider,child){
                      return provider.categoryId==null? const SizedBox():  FutureBuilder(
                          future: CategoryRepository.allCategory(context),
                          builder: (context,snapshot){
                            if(snapshot.connectionState==ConnectionState.waiting){
                              return const Center(
                                child: SizedBox(),
                              );
                            }
                            if(snapshot.data!.getAllCategories.isEmpty){
                              return const SizedBox();
                            }
                            var data =snapshot.data!;
                            var catList=data.getAllCategories;
                            List<Map<String, String>> extractedList = catList.map((category) {
                              return {
                                'id': category.id,
                                'name': category.name,
                              };
                            }).toList();
                            return  FutureBuilder(
                                future: CategoryRepository.allSubCategory(provider.categoryId!, context),
                                builder: (context,subSnapshot){
                                  if(subSnapshot.connectionState==ConnectionState.waiting){
                                    return const Center(
                                      child: SizedBox(),
                                    );
                                  }
                                  if(subSnapshot.data!.getAllSubCategories.isEmpty){
                                    return Column(
                                      children: [
                                        text(title: AppLocalizations.of(context)!.selectsubcategory),
                                        5.height,
                                        GestureDetector(
                                          onTap: () async {
                                            // Navigate to subcategory selection screen even if empty
                                            final result = await Navigator.pushNamed(
                                              context,
                                              RoutesNames.sellerSubCategoryView,
                                              arguments: {
                                                'categoryId': provider.categoryId!,
                                                'isSelectionMode': true,
                                              },
                                            );
                                            
                                            if (result != null && result is Map) {
                                              final selectedSubCategoryId = result['id'] as String;
                                              final selectedSubCategoryName = result['name'] as String;
                                              
                                              customPrint("========== SUBCATEGORY SELECTED ==========");
                                              customPrint("Selected SubCategory Name: $selectedSubCategoryName");
                                              customPrint("Selected SubCategory ID: $selectedSubCategoryId");
                                              
                                              provider.changeSubCategoryList(selectedSubCategoryName);
                                              provider.setSubCategoryId(selectedSubCategoryId);
                                              
                                              customPrint("After setting - SubCategory ID in provider: ${provider.subCategoryId}");
                                              customPrint("After setting - SubCategory Name in provider: ${provider.subCategory}");
                                              customPrint("===========================================");
                                              
                                              setState(() {});
                                            }
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                                            decoration: BoxDecoration(
                                              color: whiteColor,
                                              borderRadius: BorderRadius.circular(5.r),
                                              border: Border.all(color: borderColor, width: 1),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: MyText(
                                                    text: AppLocalizations.of(context)!.subcategory,
                                                    size: 12.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: textPrimaryColor.withOpacity(0.5),
                                                  ),
                                                ),
                                                Icon(Icons.arrow_forward_ios, size: 14.sp, color: textPrimaryColor),
                                              ],
                                            ),
                                          ),
                                        ),
                                        10.height,
                                        RoundButton(
                                          height: 40.h,
                                          btnTextSize: 12.sp,
                                          borderColor: primaryColor,
                                          bgColor: transparentColor,
                                          textColor: primaryColor,
                                          borderRadius: BorderRadius.circular(5.r),
                                          title: AppLocalizations.of(context)!.addsubcategory,
                                          onTap: () {
                                            final categoryProvider = context.read<CategoryProvider>();
                                            categoryProvider.subcategoryNameController.clear();
                                            context.showTextFieldDialog(
                                              title: AppLocalizations.of(context)!.addsubcategory,
                                              keyboardType: TextInputType.text,
                                              controller: categoryProvider.subcategoryNameController,
                                              confirmText: AppLocalizations.of(context)!.add,
                                              declineText: AppLocalizations.of(context)!.cancel,
                                              onNo: () {},
                                              onYes: () {
                                                if (categoryProvider.subcategoryNameController.text.trim().isEmpty) {
                                                  showSnackbar(context, AppLocalizations.of(context)!.subcategorynamerequired, color: redColor);
                                                  return;
                                                }
                                                categoryProvider.addSubCategory(provider.categoryId!, context).then((v) {
                                                  // Refresh the FutureBuilder by triggering setState
                                                  setState(() {});
                                                });
                                              },
                                            );
                                          },
                                        ),
                                        10.height,
                                      ],
                                    );
                                  }
                                  var data =subSnapshot.data!;
                                  var catList=data.getAllSubCategories;
                                  List<Map<String, String>> extractedList = catList.map((category) {
                                    return {
                                      'id': category.id,
                                      'name': category.name,
                                    };
                                  }).toList();
                                  return Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: text(title: AppLocalizations.of(context)!.selectsubcategory),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              final categoryProvider = context.read<CategoryProvider>();
                                              categoryProvider.subcategoryNameController.clear();
                                              context.showTextFieldDialog(
                                                title: AppLocalizations.of(context)!.addsubcategory,
                                                keyboardType: TextInputType.text,
                                                controller: categoryProvider.subcategoryNameController,
                                                confirmText: AppLocalizations.of(context)!.add,
                                                declineText: AppLocalizations.of(context)!.cancel,
                                                onNo: () {},
                                                onYes: () {
                                                  if (categoryProvider.subcategoryNameController.text.trim().isEmpty) {
                                                    showSnackbar(context, AppLocalizations.of(context)!.subcategorynamerequired, color: redColor);
                                                    return;
                                                  }
                                                  categoryProvider.addSubCategory(provider.categoryId!, context).then((v) {
                                                    // Refresh the FutureBuilder by triggering setState
                                                    setState(() {});
                                                  });
                                                },
                                              );
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                              decoration: BoxDecoration(
                                                color: primaryColor.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(5.r),
                                                border: Border.all(color: primaryColor, width: 1),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(Icons.add, size: 14.sp, color: primaryColor),
                                                  4.width,
                                                  MyText(
                                                    text: AppLocalizations.of(context)!.addsubcategory,
                                                    size: 10.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: primaryColor,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      5.height,
                                      GestureDetector(
                                        onTap: () async {
                                          // Navigate to subcategory selection screen
                                          final result = await Navigator.pushNamed(
                                            context,
                                            RoutesNames.sellerSubCategoryView,
                                            arguments: {
                                              'categoryId': provider.categoryId!,
                                              'isSelectionMode': true,
                                            },
                                          );
                                          
                                          if (result != null && result is Map) {
                                            final selectedSubCategoryId = result['id'] as String;
                                            final selectedSubCategoryName = result['name'] as String;
                                            
                                            customPrint("========== SUBCATEGORY SELECTED ==========");
                                            customPrint("Selected SubCategory Name: $selectedSubCategoryName");
                                            customPrint("Selected SubCategory ID: $selectedSubCategoryId");
                                            
                                            provider.changeSubCategoryList(selectedSubCategoryName);
                                            provider.setSubCategoryId(selectedSubCategoryId);
                                            
                                            customPrint("After setting - SubCategory ID in provider: ${provider.subCategoryId}");
                                            customPrint("After setting - SubCategory Name in provider: ${provider.subCategory}");
                                            customPrint("===========================================");
                                            
                                            setState(() {});
                                          }
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                                          decoration: BoxDecoration(
                                            color: whiteColor,
                                            borderRadius: BorderRadius.circular(5.r),
                                            border: Border.all(color: borderColor, width: 1),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: MyText(
                                                  text: provider.subCategory ?? AppLocalizations.of(context)!.subcategory,
                                                  size: 12.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: provider.subCategory != null ? blackColor : textPrimaryColor.withOpacity(0.5),
                                                ),
                                              ),
                                              Icon(Icons.arrow_forward_ios, size: 14.sp, color: textPrimaryColor),
                                            ],
                                          ),
                                        ),
                                      ),
                                      10.height,
                                    ],
                                  );
                                });
                          });
                    }),
                    text(title: AppLocalizations.of(context)!.selectweight),
                    5.height,
                    Consumer<ProductsProvider>(builder: (context,provider,child){
                      return  DropDownWidget(
                        textName: AppLocalizations.of(context)!.weight,
                        initialValue:  provider.weight,
                        list: provider.weightsList,
                        onChange: (value){
                          provider.changeWeightList(value!);

                        },
                      );
                    }),

                    10.height,

                    text(title: AppLocalizations.of(context)!.selectcolor),
                    5.height,
                    Consumer<ProductsProvider>(builder: (context,provider,child){
                      return DropDownWidget(
                        textName: AppLocalizations.of(context)!.color,
                        initialValue:  provider.color,
                        list: provider.colorsList,
                        onChange: (value){
                          provider.changeColorList(value!);
                        },
                      );
                    }),

                    10.height,

                    text(title: AppLocalizations.of(context)!.selectsize),
                    5.height,
                    Consumer<ProductsProvider>(builder: (context,provider,child){
                      return DropDownWidget(
                        textName: AppLocalizations.of(context)!.size,
                        initialValue:  provider.size,
                        list: provider.sizeList,
                        onChange: (value){
                          provider.changeSizeList(value!);

                        },
                      );
                    }),

                    10.height,

                    text(title: AppLocalizations.of(context)!.adddescription),
                    5.height,
                    TextFormField(
                      maxLines: 5,
                      controller: productProvider.discriptionController,

                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: AppLocalizations.of(context)!.writediscriptionhere,
                          fillColor:whiteColor,
                          filled: true,
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w400,color: blackColor,fontSize: 12.sp,
                          )
                      ),
                    ),
                    10.height,
                    text(title: AppLocalizations.of(context)!.addstock),
                    5.height,
                    TextFormField(
                      controller: productProvider.quantityController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: AppLocalizations.of(context)!.stock,
                          fillColor:whiteColor,
                          filled: true,
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w400,color: blackColor,fontSize: 12.sp,
                          )
                      ),
                    ),
                    10.height,
                    text(title: AppLocalizations.of(context)!.addprice),
                    5.height,
                    TextFormField(
                      controller: productProvider.priceController,

                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: AppLocalizations.of(context)!.price,
                          fillColor:whiteColor,
                          filled: true,
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w400,color: blackColor,fontSize: 12.sp,
                          )
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          10.height,

          //const Spacer(),
         Consumer<ProductsProvider>(
             builder: (context,provider,child){

               if(provider.isViolationToPendingQc==true){
                 return Container(
                   height: 72.h,
                   width: double.infinity,
                   color: whiteColor,
                   child: Padding(
                     padding:  EdgeInsets.all(15.sp),
                     child: RoundButton(
                         isLoad: true,
                         borderRadius: BorderRadius.circular(5.r),
                         height: 34.h,
                         width: 163.w,
                         btnTextSize: 14.sp,
                         title: AppLocalizations.of(context)!.senttoreview, onTap: ()async{
                       await productProvider.updateProduct(provider.productId!, context);

                     }),
                   ),
                 );
               }
           return Expanded(
             child: Container(
               height: 72.h,
               width: double.infinity,
               color: whiteColor,
               child: provider.isDraftToPublish==true?
               Padding(
                 padding:  EdgeInsets.all(15.sp),
                 child: RoundButton(
                     isLoad: true,
                     borderRadius: BorderRadius.circular(5.r),
                     height: 34.h,
                     width: 163.w,
                     btnTextSize: 12.sp,
                     title: AppLocalizations.of(context)!.publishproduct, onTap: ()async{
                   await productProvider.updateProduct(provider.productId!, context);

                 }),
               ) : Row(
                 mainAxisAlignment: MainAxisAlignment.spaceAround,
                 children: [
                   Consumer<ProductsProvider>(builder: (context,provider,child){
                     return  RoundButton(
                         isLoad: productProvider.draftLoading,
                         borderRadius: BorderRadius.circular(5.r),
                         height: 34.h,
                         width: 173.w,
                         btnTextSize: 10.sp,
                         bgColor: transparentColor,
                         borderColor: primaryColor,
                         textColor: primaryColor,
                         textFontWeight: FontWeight.w700,
                         loadingColor: primaryColor,
                         title: AppLocalizations.of(context)!.saveasdraft, onTap: ()async{
                       await productProvider.addToDraftProduct(context);

                     });
                   }),

                   Consumer<ProductsProvider>(builder: (context,provider,child){
                     return  RoundButton(
                         isLoad: productProvider.publishLoading,
                         borderRadius: BorderRadius.circular(5.r),
                         height: 34.h,
                         width: 163.w,
                         btnTextSize: 10.sp,
                         textFontWeight: FontWeight.w700,
                         title: AppLocalizations.of(context)!.publishproduct, onTap: ()async{

                       await productProvider.publishProduct(context);
                     });
                   })
                 ],
               ),
             ),
           );
         })
        ],
      ),

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
