import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/api/api-endpoints.dart';

import 'package:sugudeni/providers/products/customer/all-customer-products.dart';

import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/constants/app-assets.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/customWidgets/my-text.dart';
import '../../../utils/customWidgets/shimmer-widgets.dart';

import '../../currency/find-currency.dart';

class CustomerAllProductsView extends StatefulWidget {
  final bool? isComeFromSearch;
  const CustomerAllProductsView({super.key, this.isComeFromSearch=false});

  @override
  State<CustomerAllProductsView> createState() => _CustomerAllProductsViewState();
}

class _CustomerAllProductsViewState extends State<CustomerAllProductsView> {
  final FocusNode _focusNode = FocusNode();

  String query='';
  late CustomerFetchProductProvider productProvider;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    productProvider = Provider.of<CustomerFetchProductProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Clear search if not coming from search
      if (widget.isComeFromSearch != true) {
        productProvider.clearValues();
        productProvider.clearResources();
      }
      widget.isComeFromSearch==true?  _focusNode.requestFocus():null;
      // Defer fetchActiveProducts to avoid calling setState during build
      productProvider.fetchActiveProducts(context);
    });
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
      productProvider.fetchActiveProducts(context);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final customerProductProvider=Provider.of<CustomerFetchProductProvider>(context,listen: false);

    return PopScope(
        onPopInvokedWithResult: (didPop, result) {
          customerProductProvider.clearResources();
          customerProductProvider.clearValues();
        },
        child: Scaffold(
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
              flex: 9,
              child: TextFormField(
                controller: productProvider.searchController,
                focusNode: _focusNode,

                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 10.sp,
                    color: const Color(0xff545454)
                ),
                onChanged: (v){

                  customerProductProvider.getSuggestions(v);
                  customPrint(v);
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search,color: Color(0xff545454),),
                  hintText:AppLocalizations.of(context)!.search,
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 10.sp,
                      color: const Color(0xff545454)
                  ),
                  suffixIcon: GestureDetector(
                    onTap: (){

                       customerProductProvider.changeQuery(productProvider.searchController.text.trim(),context);
                      customerProductProvider.clearSuggestions();
                      FocusManager.instance.primaryFocus!.unfocus();
                    },
                    child: Container(
                      height: 25.h,
                      width: 70.w,
                      margin: EdgeInsets.all(4.sp),
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(5.r)
                      ),
                      child: Center(
                        child: MyText(text: AppLocalizations.of(context)!.search,color: whiteColor,size: 12.sp,fontWeight: FontWeight.w500,),
                      ),
                    ),
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
            Flexible(
                flex: 1,
                child: IconButton(onPressed: (){
                  _showFilterDialog(context);

                }, icon: const Icon(Icons.filter_list_sharp,color: primaryColor,)))

          ],
        ),
      ),
      body: Stack(
        children: [

          Consumer<CustomerFetchProductProvider>(builder: (context,provider,child){
            if (provider.isLoading && provider.productList.isEmpty) {
              return const ProductGridShimmer(
                crossAxisCount: 2,
                aspectRatio: 0.8,
              );
            }

            if (provider.errorText.isNotEmpty) {
              return SizedBox(
                  height: 500.h,
                  child: Center(
                      child: Text(provider.errorText, style: const TextStyle(color: redColor))));
            }
            if (provider.filteredProductList.isEmpty) {
              return SizedBox(
                  height: 500.h,
                  child: Center(
                      child: MyText(text: AppLocalizations.of(context)!.empty,size: 12.sp,)));
            }
            WidgetsBinding.instance.addPostFrameCallback((_) {
              double screenHeight = MediaQuery.of(context).size.height;
              double itemHeight = 204.h;
              provider.autoLoadMoreIfNeeded(context, screenHeight, itemHeight);
            });
            return RefreshIndicator(
              onRefresh: () => provider.refreshProducts(context),
              child: GridView.builder(
                shrinkWrap: true,
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns
                  crossAxisSpacing: 2, // Space between columns
                  mainAxisSpacing: 8, // Space between rows
                  childAspectRatio:0.8, // Adjusts the size ratio of grid items
                ),
                itemCount: provider.filteredProductList.length, // Number of items
                itemBuilder: (context, index) {
                  final d=provider.filteredProductList[index];
                  String discount=calculateDiscountPercentage(d.price.toDouble(), d.priceAfterDiscount.toDouble());
                  bool isBulk=d.bulk;

                  return GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, RoutesNames.customerProductDetailView,arguments: d);
                    },
                    child: Container(
                      // height: 204.h,
                      margin: EdgeInsets.symmetric(horizontal: 8.w,vertical: 10),
                      width: 108.w,
                      decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(4.r),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 6,
                                offset: const Offset(0, 4),
                                color: blackColor.withOpacity(0.2)
                            )
                          ]
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 110.h,
                            // width: 108.w,
                            decoration:  BoxDecoration(
                                image: DecorationImage(image: NetworkImage(
                                    isBulk==true? d.imgCover: "${ApiEndpoints.productUrl}/${d.imgCover}"),fit: BoxFit.contain)
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    d.saleDiscount==0?  const SizedBox():       Container(
                                      height: 16.h,
                                      width: 54.w,
                                      decoration: BoxDecoration(
                                          gradient: const LinearGradient(colors: [
                                            Color(0xffFF9C59),
                                            Color(0xffFF6600)
                                          ]),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(4.r),
                                            bottomRight: Radius.circular(4.r),
                                          )
                                      ),
                                      child: Center(
                                        child: MyText(text: discount,color: whiteColor,fontWeight: FontWeight.w600,size: 10.sp),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      height: 25.h,
                                      width: 25.w,
                                      decoration: BoxDecoration(
                                          color: appRedColor,
                                          borderRadius: BorderRadius.circular(4.sp)
                                      ),
                                      child: Center(
                                        child: Image.asset(AppAssets.addIconT,scale: 3,),
                                      ),
                                    ),
                                    2.width,
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 5.w,vertical: 5.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyText(text: d.title,size:10.sp,fontWeight: FontWeight.w600,),
                                MyText(text: d.size,size:9.sp,fontWeight: FontWeight.w600,color: textPrimaryColor.withOpacity(0.7),),
                                Row(
                                  children: [
                                    d.saleDiscount==0?FindCurrency(usdAmount: d.price):FindCurrency(usdAmount: d.priceAfterDiscount),
                                    //MyText(text:d.saleDiscount==0? "\$ ${d.price}":"\$ ${d.priceAfterDiscount}",size:10.sp,fontWeight: FontWeight.w600,color: appPinkColor,),
                                    5.width,
                                    d.saleDiscount==0? const SizedBox():
                                    FindCurrency(usdAmount: d.price,color: greyColor,textDecoration: TextDecoration.lineThrough),

                                  //  MyText(text: "\$ ${d.price}",size:10.sp,fontWeight: FontWeight.w600,color: greyColor,textDecoration: TextDecoration.lineThrough,),
                                  ],
                                ),
                                3.height,
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(AppAssets.starIcon,scale: 4,),
                                    1.width,
                                    MyText(text: " ${d.ratingAvg}",size:10.sp,fontWeight: FontWeight.w600,color: greyColor,),
                                    MyText(text: "( ${d.ratingCount})",size:8.sp,fontWeight: FontWeight.w600,color: greyColor,),
                                    MyText(text: " | ${d.sold} ${AppLocalizations.of(context)!.sold}",size:8.sp,fontWeight: FontWeight.w600,color: greyColor,),

                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }),
          Consumer<CustomerFetchProductProvider>(builder: (context,provider,child){
            if(provider.suggestions.isEmpty){
              return const SizedBox();
            }
            return Container(
              width: double.infinity,
              height: 250.h,
              color: whiteColor,
              child: ListView.builder(
                  itemCount:provider.suggestions.length ,
                  itemBuilder: (context,index){
                    var suggestion=provider.suggestions[index];
                    return ListTile(
                      onTap: (){
                      //  provider.changeQuery(suggestion);
                        provider.setValueToController(suggestion);
                        FocusManager.instance.primaryFocus!.unfocus();


                      },
                      title: MyText(text: provider.suggestions[index],size: 12.sp),
                    );
                  }),
            );
          }),
        ],
      ),
    ));
  }
}
void _showFilterDialog(BuildContext context) {
  final filterProvider=Provider.of<CustomerFetchProductProvider>(context,listen: false);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title:  Text(AppLocalizations.of(context)!.filterbyprice),
        content: Consumer<CustomerFetchProductProvider>(
          builder: (context, provider, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                 Text(AppLocalizations.of(context)!.selectpricerange),
                RangeSlider(
                  values: RangeValues(provider.minPrice, provider.maxPrice),
                  min: 0,
                  max: 5000,
                  divisions: 50,
                  labels: RangeLabels(
                    "\$${provider.minPrice.round()}",
                    "\$${provider.maxPrice.round()}",
                  ),
                  onChanged: (RangeValues newRange) {
                    provider.updatePriceRange(newRange.start, newRange.end);
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("\$${provider.minPrice.round()}"),
                    Text("\$${provider.maxPrice.round()}"),
                  ],
                ),

                // Rating Range Slider
                Text("${AppLocalizations.of(context)!.rating}: ${provider.minRating.toStringAsFixed(1)} - ${provider.maxRating.toStringAsFixed(1)}"),
                RangeSlider(
                  min: 0,
                  max: 5,
                  divisions: 10,
                  values: RangeValues(provider.minRating, provider.maxRating),
                  onChanged: (RangeValues values) {
                    provider.setRatingRange(values.start, values.end);
                  },
                ),
                Text("Discount: ${provider.minDiscount.toStringAsFixed(1)} - ${provider.maxDiscount.toStringAsFixed(1)}"),
                RangeSlider(
                  min: 0,
                  max: 100,
                  divisions: 10,
                  values: RangeValues(provider.minDiscount, provider.maxDiscount),
                  onChanged: (RangeValues values) {
                    provider.updateDiscount(values.start, values.end);
                  },
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:  Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              filterProvider.filterProducts(
                  filterProvider.minPrice,
                  filterProvider.maxPrice,
                  minRating: filterProvider.minRating,
                  maxRating: filterProvider.maxPrice,
                minDiscount: filterProvider.minDiscount,
                maxDiscount: filterProvider.maxDiscount
              );
              Navigator.pop(context);
            },
            child:  Text(AppLocalizations.of(context)!.apply),
          ),
        ],
      );
    },
  );
}
