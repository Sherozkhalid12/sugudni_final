import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/models/products/SimpleProductModel.dart';
import 'package:sugudeni/providers/products/products-provider.dart';
import 'package:sugudeni/providers/products/seller-products-tabs/seller-violation-tab-products-provider.dart';
import 'package:sugudeni/repositories/products/seller-product-repository.dart';
import 'package:sugudeni/utils/extensions/dialog-extension.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/utils/product-status.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../repositories/products/product-repository.dart';
import '../../../../utils/customWidgets/cached-network-image.dart';
import '../../../../utils/customWidgets/loading-dialog.dart';
import '../../../../utils/customWidgets/my-text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sugudeni/main.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/round-button.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/customWidgets/shimmer-widgets.dart';
import 'package:sugudeni/utils/customWidgets/empty-state-widget.dart';

import '../../../../utils/routes/routes-name.dart';

class ViolationTab extends StatefulWidget {
  const ViolationTab({super.key});

  @override
  State<ViolationTab> createState() => _ViolationTabState();
}

class _ViolationTabState extends State<ViolationTab> {
  late SellerViolationTabProductProvider productProvider;
  final ScrollController _scrollController = ScrollController();

  final discountController=TextEditingController();
  @override
  void initState() {
    super.initState();
    productProvider = Provider.of<SellerViolationTabProductProvider>(context, listen: false);
    productProvider.fetchViolationProducts(context);
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
      productProvider.fetchViolationProducts(context);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sellerInActiveTab=Provider.of<SellerViolationTabProductProvider>(context,listen: false);

    return Consumer<SellerViolationTabProductProvider>(
        builder: (context,provider,child){
          if (provider.isLoading && provider.productList.isEmpty) {
            return ProductGridShimmer();
          }

          if (provider.errorText.isNotEmpty) {
            return SizedBox(
                height: 500.h,
                child: Center(
                    child: Text(provider.errorText, style: const TextStyle(color: redColor))));
          }
          if (provider.filteredProductList.isEmpty) {
            return EmptyStateWidget(
              title: 'No Violation Products',
              description: 'Great! You don\'t have any products with violations. Keep up the good work!',
              icon: Icons.check_circle_outline,
            );
          }
          WidgetsBinding.instance.addPostFrameCallback((_) {
            double screenHeight = MediaQuery.of(context).size.height;
            double itemHeight = 120; // Approximate height of a single list item
            provider.autoLoadMoreIfNeeded(context, screenHeight, itemHeight);
          });
      return Expanded(
        child: RefreshIndicator(
          onRefresh: () => provider.refreshProducts(context),

          child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: provider.filteredProductList.length + (provider.hasMoreData ? 1 : 0),
              controller: _scrollController,
              itemBuilder: (context, index) {
                if (index == provider.filteredProductList.length) {
                  return ProductGridShimmer();
                }

                var productData = provider.filteredProductList[index];

                return Container(
                  // height: 124.h,
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 10.h),
                    color: whiteColor,
                    child: Padding(
                      padding: EdgeInsets.all(12.sp),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyCachedNetworkImage(
                                  height:65.h ,
                                  width: 65.w,
                                  radius: 6.r,
                                imageUrl:productData.bulk==true?productData.imgCover :"${ApiEndpoints.productUrl}${productData.imgCover}",
                              ),
                              10.width,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 150.w,
                                    child: MyText(
                                      overflow: TextOverflow.clip,
                                      text: capitalizeFirstLetter(productData.title),size: 10.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  3.height,
                                  MyText(text: "${AppLocalizations.of(context)!.productid} : ${productData.id}",size: 8.sp,
                                    color: textPrimaryColor.withOpacity(0.7),
                                    fontWeight: FontWeight.w600,
                                  ),
                                  3.height,
                                  MyText(text: "\$ ${productData.price}",size: 10.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  3.height,
                                  MyText(text: "${AppLocalizations.of(context)!.stock} : ${productData.quantity}",size: 10.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                              Flexible(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    MyText(text: AppLocalizations.of(context)!.rejected, color: primaryColor,
                                      size: 12.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    30.height,
                                    RoundButton(
                                      // width: 100.w,
                                        height: 20.h,
                                        btnTextSize: 8.sp,
                                        title: AppLocalizations.of(context)!.seeviolationdetail,
                                        onTap: () {
                                          showDialog(barrierDismissible: false,
                                              context: context,

                                              builder: (context){
                                                return  Dialog(
                                                  backgroundColor: whiteColor,
                                                  child: ViolationDialog(product: productData,),
                                                );
                                              });
                                        })
                                  ],
                                ),
                              )

                            ],
                          ),

                        ],
                      ),
                    )
                );
              }),
        ),
      );
    });
  }
}
class ViolationDialog extends StatelessWidget {
  final Product product;
  const ViolationDialog({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding:  EdgeInsets.all(12.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Spacer(),
              MyText(text: AppLocalizations.of(context)!.seeviolationdetail,size: 15.sp,fontWeight: FontWeight.w700,),
              const Spacer(),
              GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Image.asset(AppAssets.cancelIcon,scale: 3,))

            ],
          ),
          10.height,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 65.h,
                width: 65.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.r),
                    image: const DecorationImage(
                        image: AssetImage(AppAssets.dummyChilliIcon),
                        fit: BoxFit.contain)
                ),
              ),
              10.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  10.height,
                  MyText(
                    text: capitalizeFirstLetter(product.title),
                    size: 10.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  3.height,
                  MyText(text: "${AppLocalizations.of(context)!.productid} : ${product.id}", size: 8
                      .sp,
                    color: textPrimaryColor.withOpacity(0.7),
                    fontWeight: FontWeight.w600,
                  ),


                ],
              ),


            ],
          ),
          15.height,
          MyText(text: AppLocalizations.of(context)!.violationdetail,size: 11.sp,fontWeight: FontWeight.w600,),
          10.height,
    ReadMoreText(
      style: TextStyle(
        color: textPrimaryColor.withOpacity(0.7),
        fontSize: 8.sp,
        fontWeight: FontWeight.w600
      ),
      product.violation==null?"N/A":product.violation!.description,
    trimMode: TrimMode.Line,
    trimLines: 1,
    colorClickableText: Colors.pink,
    trimCollapsedText: AppLocalizations.of(context)!.showmore,
    trimExpandedText: AppLocalizations.of(context)!.showless,

    moreStyle: TextStyle(
        color: blackColor,
        fontSize: 8.sp,
        fontWeight: FontWeight.bold
    ),
    ),
          10.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: RoundButton(
                    height: 34.h,
                    btnTextSize: 12.sp,
                    textColor: primaryColor,
                    bgColor: transparentColor,
                    borderColor: primaryColor,
                    textFontWeight: FontWeight.w700,

                    borderRadius: BorderRadius.circular(10.r),
                    title: AppLocalizations.of(context)!.delete, onTap: ()async{
                      Navigator.pop(context);
                  context.showConfirmationDialog(title: AppLocalizations.of(context)!.doyouwanttodeleteproduct,
                      onYes: ()async{
                        await ProductRepository.deleteProduct(product.id, context).then((v){
                          showSnackbar(context, AppLocalizations.of(context)!.productdeletedsuccessfully,color: greenColor);
                        });
                        Navigator.pop(context);
                      }, onNo: (){

                      });
                }),
              ),

              10.width,
              Flexible(
                child: RoundButton(
                    height: 34.h,
                    textFontWeight: FontWeight.w700,
                    btnTextSize: 12.sp,

                    borderRadius: BorderRadius.circular(10.r),
                    title: AppLocalizations.of(context)!.editproduct, onTap: ()async{

                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context){
                        return const LoadingDialog();
                      });
                  
                  final productsProvider = context.read<ProductsProvider>();
                  
                  // Clear resources EXCEPT files - we need to preserve them
                  productsProvider.clearResourcesExceptFiles();
                  
                  productsProvider.setDraftToPublish();
                  productsProvider.setViolationToPendingQx();
                  productsProvider.setProductId(product.id);
                  
                  // Prepare all image URLs including imgCover (avoid duplicates)
                  List<String> allImageUrls = [];
                  if (product.imgCover.isNotEmpty) {
                    allImageUrls.add(product.imgCover);
                  }
                  // Add images that are not already in the list (avoid duplicates)
                  for (String imageUrl in product.images) {
                    if (imageUrl.isNotEmpty && !allImageUrls.contains(imageUrl)) {
                      allImageUrls.add(imageUrl);
                    }
                  }
                  
                  customPrint("========== VIOLATION TO PUBLISH DEBUG ==========");
                  customPrint("Product ID: ${product.id}");
                  customPrint("imgCover: ${product.imgCover}");
                  customPrint("Images list: ${product.images}");
                  customPrint("All image URLs to download: $allImageUrls");
                  
                  await productsProvider.addFiles(allImageUrls);
                  
                  if(context.mounted){
                    productsProvider.setValues(product);
                    Navigator.pop(context);
                    Navigator.pushNamed(context, RoutesNames.sellerAddProductView);
                  }
                }),
              ),
            ],
          ),

        ],
      ),
    );
  }
}
