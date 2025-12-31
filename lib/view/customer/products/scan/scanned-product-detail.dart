import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sugudeni/models/ScannedProductModel.dart';
import 'package:sugudeni/providers/products/products-provider.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/round-button.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:http/http.dart' as http;

import '../../../../utils/customWidgets/loading-dialog.dart';

class QRProductDetailsScreen extends StatefulWidget {
  final String productId;
  final bool? isSeller;

  const QRProductDetailsScreen({super.key, required this.productId, this.isSeller=false});

  @override
  State<QRProductDetailsScreen> createState() => _QRProductDetailsScreenState();
}

class _QRProductDetailsScreenState extends State<QRProductDetailsScreen> {
  ScannedProductModel? product;
  bool isLoading = true;

  final pageController=PageController(initialPage: 0);
  Future<ScannedProductModel?> fetchProductData(String productId) async {
    final String apiUrl =
        'https://go-upc.com/api/v1/code/$productId?key=76f0868987ae3c2fd6dbaa7bb797b5a8ce7eeea0e317d6a38b2630de01629b7f';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        customPrint("Data:====================$data");
        return ScannedProductModel.fromJson(data);
      } else {
        customPrint('Failed to fetch product:================================================================ ${response.statusCode}');
        return null;
      }
    } catch (e) {
      customPrint('Error fetching product:===================================================== $e');
      return null;
    }
  }
  Future<void> loadProduct() async {
    customPrint('Enter fetch product:================================================================}');
    ScannedProductModel? result = await fetchProductData(widget.productId);
    setState(() {
      product = result;
      isLoading = false;
      customPrint("Result =======================================================$product");
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    loadProduct();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // Removed dummy productData - using real API data from loadProduct()
    return Scaffold(
      backgroundColor: blackColor.withAlpha(getAlpha(0.2)),
      // appBar: AppBar(
      //   title: const Text('Product Details'),
      // ),
      body: isLoading==true? 
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 200.h,
                    width: 200.w,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
                20.height,
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 20.h,
                    width: 150.w,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
                10.height,
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 20.h,
                    width: 120.w,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
              ],
            ),
          ):
          product==null?const Center(
            child: MyText(text: "Not Found",color: whiteColor,),
          ):
      Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      120.height,
                     SizedBox(
                       height: 250,
                       child: PageView(
                         onPageChanged: (index){

                         },
                         controller: pageController,
                         children: [
                           Center(
                             child: Container(
                               height: 250,
                               width: 250,
                               decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(20.r),
                                   image: DecorationImage(image: NetworkImage(product!.product!.imageUrl!))
                               ),
                             ),
                           ),
                           Center(
                             child: Container(
                               height: 250,
                               width: 250,
                               decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(20.r),
                                   image: DecorationImage(image: NetworkImage(product!.product!.imageUrl!))
                               ),
                             ),
                           ),
                           Center(
                             child: Container(
                               height: 250,
                               width: 250,
                               decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(20.r),
                                   image: DecorationImage(image: NetworkImage(product!.product!.imageUrl!))
                               ),
                             ),
                           ),
                         ],
                       ),
                     ),
                      10.height,
                      Center(
                          child: SmoothPageIndicator(
                              controller: pageController,
                              count: 3,
                            effect: ScrollingDotsEffect(
                              activeDotColor: primaryColor,
                              dotColor: whiteColor,radius: 10.r,dotHeight: 10.h,dotWidth: 10.w
                            ),
                          )),
                      10.height,
                      const SizedBox(height: 50),
                      Text(
                        textAlign: TextAlign.center,
                        product!.product!.name!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: whiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Center(
                      //   child: Container(
                      //     width: 80,
                      //     height: 30,
                      //     decoration: BoxDecoration(
                      //       color: whiteColor,
                      //       borderRadius: BorderRadius.circular(20.r)
                      //     ),
                      //     child: const Center(
                      //       child: MyText(text: "Add to list",size: 12,fontWeight: FontWeight.w500,),
                      //     ),
                      //   ),
                      // ),
                      // const SizedBox(height: 20),
                      const Text(
                        textAlign: TextAlign.center,
                       "Discription",
                        style: TextStyle(
                          fontSize: 14,
                          color: whiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        textAlign: TextAlign.justify,
                        product!.product!.description!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: whiteColor,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 20),

                      product!.product!.ingredients==null? const SizedBox(): ExpansionTile(
                        initiallyExpanded: false,
                        iconColor: whiteColor,
                        collapsedIconColor: whiteColor,
                        title:   const Text(
                          textAlign: TextAlign.center,
                          "Ingredients",
                          style: TextStyle(
                            fontSize: 14,  color: whiteColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        children: [
                          Text(
                            textAlign: TextAlign.justify,
                            product!.product!.ingredients!.text!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: whiteColor,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                       ExpansionTile(
                        initiallyExpanded: false,
                         iconColor: whiteColor,
                         collapsedIconColor: whiteColor,
                        title:   const Text(
                          textAlign: TextAlign.center,
                          "Additional Attributes",
                          style: TextStyle(
                            fontSize: 14,  color: whiteColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        children: [
                         SpecsTable(specs:  product!.product!.specs!,)
                        ],
                      ),


                    ],
                  ),
                ),
              ),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 15.w,vertical: 5.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Flexible(
                      child: RoundButton(

                          height: 34.h,
                          borderRadius: BorderRadius.circular(5.r),
                          btnTextSize: 12.sp,
                          textFontWeight: FontWeight.w700,
                          bgColor:primaryColor,
                          title:widget.isSeller==true? "Add Product":"Go Back", onTap:
                          widget.isSeller==false? (){
                            Navigator.pop(context);
                          }:()async{
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context){
                              return const LoadingDialog();
                            });
                         context.read<ProductsProvider>().clearResources();
                        // context.read<ProductsProvider>(). setDraftToPublish();
                        // context.read<ProductsProvider>(). setProductId(productData.id);
                        await context.read<ProductsProvider>().addFileFromBarcode(product!.product!.imageUrl!);
                        await context.read<ProductsProvider>().setValueFromBarcode(product!.product!.name!,product!.product!.description!,);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }),
                    ),

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


class SpecsTable extends StatelessWidget {
  final List<List<String>> specs;
  final Color valueTextColor;

  const SpecsTable({
    Key? key,
    required this.specs,
    this.valueTextColor = Colors.white, // Default color for values
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(color: Colors.grey),
      columnWidths: const {
        0: FixedColumnWidth(150), // Column for Spec Name
        1: FlexColumnWidth(), // Column for Spec Value
      },
      children: specs.map((row) {
        return TableRow(
          children: [
            // First column (spec name) - Bold text
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                row[0],
                style: const TextStyle(fontWeight: FontWeight.bold,color: whiteColor),
              ),
            ),
            // Second column (spec value) - Colored text
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                row[1],
                style: TextStyle(color: valueTextColor), // Color applied here
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}

