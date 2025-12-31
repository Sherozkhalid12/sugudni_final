import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/models/file-model.dart';
import 'package:sugudeni/models/products/AddSaleToProductModel.dart';
import 'package:sugudeni/models/products/SellerProductListResponse.dart';
import 'package:sugudeni/providers/loading-provider.dart';
import 'package:sugudeni/providers/products/seller-products-tabs/seller-active-tab-products-provider.dart';
import 'package:sugudeni/providers/products/seller-products-tabs/seller-inactive-tab-products-provider.dart';
import 'package:sugudeni/providers/select-role-provider.dart';
import 'package:http/http.dart' as http;
import 'package:sugudeni/providers/seller-products-tab-provider.dart';
import 'package:sugudeni/repositories/products/product-repository.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/utils/product-status.dart';
import 'package:sugudeni/utils/sharePreference/save-user-token.dart';

import '../../models/products/SimpleProductModel.dart';
import '../../l10n/app_localizations.dart';


class ProductsProvider extends ChangeNotifier{

  final productTitleController=TextEditingController();
  final quantityController=TextEditingController();
  final discriptionController=TextEditingController();
  final priceController=TextEditingController();
 bool draftLoading=false;
 bool publishLoading=false;
 bool isDraftToPublish=false;
 bool isViolationToPendingQc=false;
  String? productId;
  String? categoryId;
  String? subCategoryId;
  String? category;
  String? subCategory;
  String? weight;
  String? color;
  String? size;
  var categoryList=[
    'Fruits',
    'Vegetables',
    'Bags'
  ];

  var weightsList=[
    '100 grams',
    '300 grams',
    '500 grams',
    '700 grams',
    '1 Kg',
  ];
  var colorsList=[
    'Black',
    'Red',
    'Blue',

  ];
  var sizeList=[
    'Small',
    'Medium',
    'Large',

  ];

  changeCategoryList(String v){
    category=v;
    notifyListeners();
  }
  changeSubCategoryList(String v){
    subCategory=v;
    notifyListeners();
  }
  changeWeightList(String v){
    weight=v;
    notifyListeners();
  }
  changeColorList(String v){
    color=v;
    notifyListeners();
  }
  changeSizeList(String v){
    size=v;
    notifyListeners();
  }
  setCategoryId(String id){
    customPrint("Category id ==========================$id");
    categoryId=id;
  }
  setSubCategoryId(String id){
    customPrint("Category id ==========================$id");
    subCategoryId=id;
  }
  setDraftLoading(){
    publishLoading=false;
    draftLoading=true;
    notifyListeners();
  }
  setPublishLoading(){
    publishLoading=true;
    draftLoading=false;
    notifyListeners();
  }
  setDraftToPublish(){
    isDraftToPublish=true;
  }
  setViolationToPendingQx(){
    isViolationToPendingQc=true;
  }
  setProductId(String id){
    productId=id;
  }
  resetLoading(){
    publishLoading=false;
    draftLoading=false;
    notifyListeners();
  }
  final List<FileModel> _files = [];
  List<FileModel> get files => _files;
  Future<void> addFiles(List<String> imageUrls) async {
    final directory = await getApplicationDocumentsDirectory();

    for (String url in imageUrls) {
      try {
        final response = await http.get(Uri.parse("${ApiEndpoints.productUrl}$url"));

        if (response.statusCode == 200) {
          String fileName = url.split('/').last;
          File file = File('${directory.path}/$fileName');

          await file.writeAsBytes(response.bodyBytes);

          _files.add(FileModel(name: fileName, path: file.path));
        }
      } catch (e) {
        customPrint("Error downloading image:================================================= $e");
      }
    }
  }
  Future<void> addFileFromBarcode(String imageUrl) async {
    final directory = await getApplicationDocumentsDirectory();

    try {
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        String fileName = imageUrl.split('/').last;
        File file = File('${directory.path}/$fileName');

        await file.writeAsBytes(response.bodyBytes);

        _files.add(FileModel(name: fileName, path: file.path));
        notifyListeners();
      }
    } catch (e) {
      customPrint("Error downloading image: $e");
    }
  }
  setValueFromBarcode(String name, String description){
    productTitleController.text=name;
    discriptionController.text=description;
    notifyListeners();
  }
  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png','jpg'],
      allowMultiple: true, // Enable multi-file selection
    );
    if (result != null) {
      for (var file in result.files) {
        if (_files.length >= 8) {
          customPrint("Can't select more than 8 Picture");
          break;
        }
        if (file.path != null) {
          addFile(FileModel(name: file.name, path: file.path!));
        }
      }
    }
  }
  Future<void> publishProduct(BuildContext context) async {
    final loadingProvider = Provider.of<LoadingProvider>(context, listen: false);
    if (_files.isEmpty) {
      showSnackbar(context, AppLocalizations.of(context)!.pleaseuploadproductimages, color: redColor);
      return;
    }
    if (productTitleController.text.isEmpty ) {
      showSnackbar(context, AppLocalizations.of(context)!.pleaseenterproducttitle, color: redColor);
      return;
    }
    if (categoryId==null ) {
      showSnackbar(context, AppLocalizations.of(context)!.pleasechoosecategory, color: redColor);
      return;
    }
       if (subCategoryId==null ) {
      showSnackbar(context, AppLocalizations.of(context)!.pleasechoosesubcategory, color: redColor);
      return;
    }
       if (weight==null ) {
      showSnackbar(context, AppLocalizations.of(context)!.pleasechooseweight, color: redColor);
      return;
    }
       if (color==null ) {
      showSnackbar(context, AppLocalizations.of(context)!.pleasechoosecolor, color: redColor);
      return;
    }
       if (size==null ) {
      showSnackbar(context, AppLocalizations.of(context)!.pleasechoosesize, color: redColor);
      return;
    }
       if (discriptionController.text.isEmpty ) {
      showSnackbar(context, AppLocalizations.of(context)!.pleaseenterdescription, color: redColor);
      return;
    }
       if (quantityController.text.isEmpty ) {
      showSnackbar(context, AppLocalizations.of(context)!.addavailablestock, color: redColor);
      return;
    }
   if (priceController.text.isEmpty ) {
      showSnackbar(context,AppLocalizations.of(context)!.pleaseentertheproductprice, color: redColor);
      return;
    }



    try {
      loadingProvider.setLoading(true);
      setPublishLoading();
      var url = Uri.parse("${ApiEndpoints.baseUrl}/${ApiEndpoints.products}");

      var request = http.MultipartRequest('POST', url);
      final token = await getSessionTaken();
      final sellerId = await getUserId();
      customPrint("token======$token");
      // Add headers
      request.headers.addAll({
        'token': token,
        'Authorization': 'Bearer $token'
      });

      // Add text fields
      request.fields.addAll({
        'sellerid': sellerId,
        'title': productTitleController.text.trim(),
        'weight': weight!,
        'color': color!,
        'size': size!,
        'price': priceController.text.trim(),
        'quantity': quantityController.text.trim(),
        'descripton': discriptionController.text.trim(),
        'category': categoryId!,
        'subcategory': subCategoryId!,

      });

      // Attach files
      request.files.add(await http.MultipartFile.fromPath(
        'imgCover', _files[0].path,
        contentType: MediaType('image', 'jpeg'), // Explicit content type
      ));
      for (var i in _files){
        request.files.add(await http.MultipartFile.fromPath('images',i.path,
          contentType: MediaType('image', 'jpeg'), // Explicit content type
        ));
      }


      // Send request
      http.StreamedResponse response = await request.send();
      customPrint("Status code ==============${response.statusCode}");
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final body = jsonDecode(responseBody);
        customPrint("Response: $body");

        loadingProvider.setLoading(false);
        if (context.mounted) {
          showSnackbar(context,body['message'], color: redColor);
        }
      }
     else if (response.statusCode == 201) {
        final responseBody = await response.stream.bytesToString();
        final body = jsonDecode(responseBody);
        customPrint("Response: $body");

        loadingProvider.setLoading(false);
        if (context.mounted) {
          //clearResources();
          showSnackbar(context, AppLocalizations.of(context)!.youproductwasaddedsuccessfully, color: greenColor);
          resetLoading();
        }
      } else if (response.statusCode == 500) {
        final responseBody = await response.stream.bytesToString();
        final body = jsonDecode(responseBody);
        customPrint("Response: $body");

        loadingProvider.setLoading(false);
        if (context.mounted) {
          showSnackbar(context,body['error'], color: redColor);
        }
      }

     else {
        loadingProvider.setLoading(false);
        if (context.mounted) {
          showSnackbar(context, "Error: ${response.reasonPhrase}", color: redColor);
        }
      }
    } catch (e) {
      loadingProvider.setLoading(false);
      if (context.mounted) {
        showSnackbar(context, e.toString(), color: redColor);
      }
    }
  }
  Future<void> addToDraftProduct(BuildContext context) async {
    final loadingProvider = Provider.of<LoadingProvider>(context, listen: false);
   //  if (_files.isEmpty) {
   //    showSnackbar(context, "Product images are missing", color: redColor);
   //    return;
   //  }
   //  if (productTitleController.text.isEmpty ) {
   //    showSnackbar(context, "Product title is missing", color: redColor);
   //    return;
   //  }
   //  if (categoryId==null ) {
   //    showSnackbar(context, "Please select category", color: redColor);
   //    return;
   //  }
   //     if (subCategoryId==null ) {
   //    showSnackbar(context, "Please select sub category", color: redColor);
   //    return;
   //  }
   //     if (weight==null ) {
   //    showSnackbar(context, "Please select Weight", color: redColor);
   //    return;
   //  }
   //     if (color==null ) {
   //    showSnackbar(context, "Please select Color", color: redColor);
   //    return;
   //  }
   //     if (size==null ) {
   //    showSnackbar(context, "Please select Size", color: redColor);
   //    return;
   //  }
   //     if (discriptionController.text.isEmpty ) {
   //    showSnackbar(context, "Please write discription", color: redColor);
   //    return;
   //  }
   //     if (quantityController.text.isEmpty ) {
   //    showSnackbar(context, "Please add stock", color: redColor);
   //    return;
   //  }
   // if (priceController.text.isEmpty ) {
   //    showSnackbar(context, "Please add price", color: redColor);
   //    return;
   //  }



    try {
      loadingProvider.setLoading(true);
      setDraftLoading();
      var url = Uri.parse("${ApiEndpoints.baseUrl}/${ApiEndpoints.products}");

      var request = http.MultipartRequest('POST', url);
      final token = await getSessionTaken();
      final sellerId = await getUserId();
      customPrint("token======$token");
      // Add headers
      request.headers.addAll({
        'token': token,
        'Authorization': 'Bearer $token'
      });

      // Add text fields
      request.fields.addAll({
        'sellerid': sellerId,
        'status': ProductStatus.draft,
        if(productTitleController.text.isNotEmpty)
        'title': productTitleController.text.trim(),
        if(weight!=null)
        'weight': weight==null?'':weight!,
        if(color!=null)
        'color': color==null? '':color!,
        if(size!=null)
        'size': size==null?'':size!,
        if(priceController.text.isNotEmpty)
        'price': priceController.text.trim(),
        if(quantityController.text.isNotEmpty)
        'quantity': quantityController.text.trim(),
        if(discriptionController.text.isNotEmpty)
        'descripton': discriptionController.text.trim(),
        if(categoryId!=null)
        'category': categoryId==null?'':categoryId!,
        if(subCategoryId!=null)
        'subcategory': subCategoryId==null?'':subCategoryId!,

      });

      if(_files.isNotEmpty){
        // Attach files
        request.files.add(await http.MultipartFile.fromPath(
          'imgCover', _files[0].path,
          contentType: MediaType('image', 'jpeg'), // Explicit content type
        ));
        for (var i in _files){
          request.files.add(await http.MultipartFile.fromPath('images',i.path,
            contentType: MediaType('image', 'jpeg'), // Explicit content type
          ));
        }
      }



      // Send request
      http.StreamedResponse response = await request.send();
      customPrint("Status code ==============${response.statusCode}");
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final body = jsonDecode(responseBody);
        customPrint("Response: $body");

        loadingProvider.setLoading(false);
        if (context.mounted) {
          showSnackbar(context,body['message'], color: redColor);
        }
      }
     else if (response.statusCode == 201) {
        final responseBody = await response.stream.bytesToString();
        final body = jsonDecode(responseBody);
        customPrint("Response: $body");

        loadingProvider.setLoading(false);
        if (context.mounted) {
          //clearResources();
          showSnackbar(context, AppLocalizations.of(context)!.youproductwasaddedsuccessfully, color: greenColor);
         resetLoading();
        }
      } else if (response.statusCode == 500) {
        final responseBody = await response.stream.bytesToString();
        final body = jsonDecode(responseBody);
        customPrint("Response: $body");

        loadingProvider.setLoading(false);
        if (context.mounted) {
          showSnackbar(context,body['error'], color: redColor);
        }
      }

     else {
        loadingProvider.setLoading(false);
        if (context.mounted) {
          showSnackbar(context, "Error: ${response.reasonPhrase}", color: redColor);
        }
      }
    } catch (e) {
      loadingProvider.setLoading(false);
      if (context.mounted) {
        showSnackbar(context, e.toString(), color: redColor);
      }
    }
  }
  Future<void> updateProduct(String productId,BuildContext context) async {
    final loadingProvider = Provider.of<LoadingProvider>(context, listen: false);
    if (_files.isEmpty) {
      showSnackbar(context, AppLocalizations.of(context)!.pleaseuploadproductimages, color: redColor);
      return;
    }
    if (productTitleController.text.isEmpty ) {
      showSnackbar(context, AppLocalizations.of(context)!.pleaseenterproducttitle, color: redColor);
      return;
    }
    if (categoryId==null ) {
      showSnackbar(context, AppLocalizations.of(context)!.pleasechoosecategory, color: redColor);
      return;
    }
    if (subCategoryId==null ) {
      showSnackbar(context, AppLocalizations.of(context)!.pleasechoosesubcategory, color: redColor);
      return;
    }
    if (weight==null ) {
      showSnackbar(context, AppLocalizations.of(context)!.pleasechooseweight, color: redColor);
      return;
    }
    if (color==null ) {
      showSnackbar(context, AppLocalizations.of(context)!.pleasechoosecolor, color: redColor);
      return;
    }
    if (size==null ) {
      showSnackbar(context, AppLocalizations.of(context)!.pleasechoosesize, color: redColor);
      return;
    }
    if (discriptionController.text.isEmpty ) {
      showSnackbar(context, AppLocalizations.of(context)!.pleaseenterdescription, color: redColor);
      return;
    }
    if (quantityController.text.isEmpty ) {
      showSnackbar(context, AppLocalizations.of(context)!.addavailablestock, color: redColor);
      return;
    }
    if (priceController.text.isEmpty ) {
      showSnackbar(context,AppLocalizations.of(context)!.pleaseentertheproductprice, color: redColor);
      return;
    }



    try {
      loadingProvider.setLoading(true);

      var url = Uri.parse("${ApiEndpoints.baseUrl}/${ApiEndpoints.products}/$productId");

      var request = http.MultipartRequest('PUT', url);
      final token = await getSessionTaken();
      final sellerId = await getUserId();
      customPrint("token======$token");
      // Add headers
      request.headers.addAll({
        'token': token,
        'Authorization': 'Bearer $token'
      });

      // Add text fields
      request.fields.addAll({
        'sellerid': sellerId,
        'status':isViolationToPendingQc==true? ProductStatus.pendingqc:ProductStatus.active,
        'title': productTitleController.text.trim(),
        'weight': weight!,
        'color': color!,
        'size': size!,
        'price': priceController.text.trim(),
        'quantity': quantityController.text.trim(),
        'descripton': discriptionController.text.trim(),
        'category': categoryId!,
        'subcategory': subCategoryId!,

      });

      // Attach files
      request.files.add(await http.MultipartFile.fromPath(
        'imgCover', _files[0].path,
        contentType: MediaType('image', 'jpeg'), // Explicit content type
      ));
      for (var i in _files){
        request.files.add(await http.MultipartFile.fromPath('images',i.path,
          contentType: MediaType('image', 'jpeg'), // Explicit content type
        ));
      }


      // Send request
      http.StreamedResponse response = await request.send();
      customPrint("Status code ==============${response.statusCode}");
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final body = jsonDecode(responseBody);
        customPrint("Response: $body");

        loadingProvider.setLoading(false);
        if (context.mounted) {
          showSnackbar(context,body['message'], color: redColor);
        }
      }
     else if (response.statusCode == 201) {
        final responseBody = await response.stream.bytesToString();
        final body = jsonDecode(responseBody);
        customPrint("Response: $body");

        loadingProvider.setLoading(false);
        if (context.mounted) {
          clearResources();
          showSnackbar(context, AppLocalizations.of(context)!.youproductwasaddedsuccessfully, color: greenColor);
        }
      } else if (response.statusCode == 500) {
        final responseBody = await response.stream.bytesToString();
        final body = jsonDecode(responseBody);
        customPrint("Response: $body");

        loadingProvider.setLoading(false);
        if (context.mounted) {
          showSnackbar(context,body['error'], color: redColor);
        }
      }

     else {
        loadingProvider.setLoading(false);
        if (context.mounted) {
          showSnackbar(context, "Error: ${response.reasonPhrase}", color: redColor);
        }
      }
    } catch (e) {
      loadingProvider.setLoading(false);
      if (context.mounted) {
        showSnackbar(context, e.toString(), color: redColor);
      }
    }
  }
  Future<void> updateSoldProduct(String productId,BuildContext context) async {
    final loadingProvider = Provider.of<LoadingProvider>(context, listen: false);

    if (productTitleController.text.isEmpty ) {
      showSnackbar(context, AppLocalizations.of(context)!.pleasefillallfields, color: redColor);
      return;
    }
    if (_files.isEmpty) {
      showSnackbar(context, AppLocalizations.of(context)!.pleaseuploadproductimages, color: redColor);
      return;
    }

    try {
      loadingProvider.setLoading(true);

      var url = Uri.parse("${ApiEndpoints.baseUrl}/${ApiEndpoints.products}/$productId");

      var request = http.MultipartRequest('PUT', url);
      final token = await getSessionTaken();
      customPrint("token======$token");
      // Add headers
      request.headers.addAll({
        'token': token,
        'Authorization': 'Bearer $token'
      });

      // Add text fields
      request.fields.addAll({
        'sold': productTitleController.text.trim(),

      });

      // Send request
      http.StreamedResponse response = await request.send();
      customPrint("Status code ==============${response.statusCode}");
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final body = jsonDecode(responseBody);
        customPrint("Response: $body");

        loadingProvider.setLoading(false);
        if (context.mounted) {
          showSnackbar(context,body['message'], color: redColor);
        }
      }
     else if (response.statusCode == 201) {
        final responseBody = await response.stream.bytesToString();
        final body = jsonDecode(responseBody);
        customPrint("Response: $body");

        loadingProvider.setLoading(false);
        if (context.mounted) {
          clearResources();
          showSnackbar(context, AppLocalizations.of(context)!.youproductwasaddedsuccessfully, color: greenColor);
        }
      } else if (response.statusCode == 500) {
        final responseBody = await response.stream.bytesToString();
        final body = jsonDecode(responseBody);
        customPrint("Response: $body");

        loadingProvider.setLoading(false);
        if (context.mounted) {
          showSnackbar(context,body['error'], color: redColor);
        }
      }

     else {
        loadingProvider.setLoading(false);
        if (context.mounted) {
          showSnackbar(context, "Error: ${response.reasonPhrase}", color: redColor);
        }
      }
    } catch (e) {
      loadingProvider.setLoading(false);
      if (context.mounted) {
        showSnackbar(context, e.toString(), color: redColor);
      }
    }
  }
  Future<void> updateProductPrice(String productId,BuildContext context) async {
    final loadingProvider = Provider.of<LoadingProvider>(context, listen: false);
    final sellerActiveProductTabProvider = Provider.of<SellerActiveTabProductProvider>(context, listen: false);
    final sellerInactiveProductTabProvider = Provider.of<SellerInActiveTabProductProvider>(context, listen: false);

    if (priceController.text.isEmpty ) {
      showSnackbar(context, AppLocalizations.of(context)!.pleaseentertheproductprice, color: redColor);
      return;
    }
    try {
      loadingProvider.setLoading(true);

      var url = Uri.parse("${ApiEndpoints.baseUrl}/${ApiEndpoints.products}/$productId");

      var request = http.MultipartRequest('PUT', url);
      final token = await getSessionTaken();
      final sellerId = await getUserId();

      customPrint("token======$token");
      // Add headers
      request.headers.addAll({
        'token': token,
        'Authorization': 'Bearer $token'
      });

      // Add text fields
      request.fields.addAll({
        'sellerid': sellerId,
        'price': priceController.text.trim(),

      });

      // Send request
      http.StreamedResponse response = await request.send();
      customPrint("Status code ==============${response.statusCode}");
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final body = jsonDecode(responseBody);
        customPrint("Response: $body");

        loadingProvider.setLoading(false);
        if (context.mounted) {
          showSnackbar(context,body['message'], color: redColor);
        }
      }
     else if (response.statusCode == 201) {
        final responseBody = await response.stream.bytesToString();
        final body = jsonDecode(responseBody);
        customPrint("Response: $body");

        loadingProvider.setLoading(false);
        if (context.mounted) {
          sellerActiveProductTabProvider.updateProductPrice(productId, double.parse(priceController.text.trim()));
          sellerInactiveProductTabProvider.updateProductPrice(productId, double.parse(priceController.text.trim()));
          clearResources();
          showSnackbar(context, AppLocalizations.of(context)!.productpriceupdatedsuccessfully, color: greenColor);
          Navigator.pop(context);
        }
      } else if (response.statusCode == 500) {
        final responseBody = await response.stream.bytesToString();
        final body = jsonDecode(responseBody);
        customPrint("Response: $body");

        loadingProvider.setLoading(false);
        if (context.mounted) {
          showSnackbar(context,body['error'], color: redColor);
        }
      }

     else {
        loadingProvider.setLoading(false);
        if (context.mounted) {
          showSnackbar(context, "Error: ${response.reasonPhrase}", color: redColor);
        }
      }
    } catch (e) {
      loadingProvider.setLoading(false);
      if (context.mounted) {
        showSnackbar(context, e.toString(), color: redColor);
      }
    }
  }
  Future<void> updateProductStock(String productId,BuildContext context) async {
    final loadingProvider = Provider.of<LoadingProvider>(context, listen: false);
    final sellerActiveProductTabProvider = Provider.of<SellerActiveTabProductProvider>(context, listen: false);
    final sellerInactiveProductTabProvider = Provider.of<SellerInActiveTabProductProvider>(context, listen: false);

    if (quantityController.text.isEmpty ) {
      showSnackbar(context, AppLocalizations.of(context)!.addavailablestock, color: redColor);
      return;
    }

    try {
      loadingProvider.setLoading(true);

      var url = Uri.parse("${ApiEndpoints.baseUrl}/${ApiEndpoints.products}/$productId");

      var request = http.MultipartRequest('PUT', url);
      final token = await getSessionTaken();
      final sellerId = await getUserId();

      customPrint("token======$token");
      // Add headers
      request.headers.addAll({
        'token': token,
        'Authorization': 'Bearer $token'
      });

      // Add text fields
      request.fields.addAll({
        'sellerid': sellerId,

        'quantity': quantityController.text.trim(),

      });

      // Send request
      http.StreamedResponse response = await request.send();
      customPrint("Status code ==============${response.statusCode}");
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final body = jsonDecode(responseBody);
        customPrint("Response: $body");

        loadingProvider.setLoading(false);
        if (context.mounted) {
          showSnackbar(context,body['message'], color: redColor);
        }
      }
     else if (response.statusCode == 201) {
        final responseBody = await response.stream.bytesToString();
        final body = jsonDecode(responseBody);
        customPrint("Response: $body");

        loadingProvider.setLoading(false);
        if (context.mounted) {
          sellerActiveProductTabProvider.updateProductStock(productId, int.parse(quantityController.text.trim()));
          sellerInactiveProductTabProvider.updateProductStock(productId, int.parse(quantityController.text.trim()));
          clearResources();
          showSnackbar(context, AppLocalizations.of(context)!.productstockupdatedsuccessfully, color: greenColor);
          Navigator.pop(context);
        }
      } else if (response.statusCode == 500) {
        final responseBody = await response.stream.bytesToString();
        final body = jsonDecode(responseBody);
        customPrint("Response: $body");

        loadingProvider.setLoading(false);
        if (context.mounted) {
          showSnackbar(context,body['error'], color: redColor);
        }
      }

     else {
        loadingProvider.setLoading(false);
        if (context.mounted) {
          showSnackbar(context, "Error: ${response.reasonPhrase}", color: redColor);
        }
      }
    } catch (e) {
      loadingProvider.setLoading(false);
      if (context.mounted) {
        showSnackbar(context, e.toString(), color: redColor);
      }
    }
  }
  Future<void>getAllProducts(BuildContext context)async{
    final loadingProvider=Provider.of<LoadingProvider>(context,listen: false);

    try{
      loadingProvider.setLoading(true);

      await ProductRepository.allProducts(context).then((v){

        String message=v.message!;
        loadingProvider.setLoading(false);
        if(context.mounted){
          showSnackbar(context, message,color: greenColor);
        }
      }).onError((err,e){
        loadingProvider.setLoading(false);
        if(context.mounted){
          //showSnackbar(context, err.toString(),color: redColor);
        }
      });
    }catch(e){
      if(context.mounted){
        loadingProvider.setLoading(false);
        showSnackbar(context, e.toString(),color: redColor);
      }
    }
  }
  Future<void>getSpecificProduct(String productId,BuildContext context)async{
    final loadingProvider=Provider.of<LoadingProvider>(context,listen: false);

    try{
      loadingProvider.setLoading(true);

      await ProductRepository.specificProduct(productId,context).then((v){

        String message=v.message!;
        loadingProvider.setLoading(false);
        if(context.mounted){
          showSnackbar(context, message,color: greenColor);
        }
      }).onError((err,e){
        loadingProvider.setLoading(false);
        if(context.mounted){
          //showSnackbar(context, err.toString(),color: redColor);
        }
      });
    }catch(e){
      if(context.mounted){
        loadingProvider.setLoading(false);
        showSnackbar(context, e.toString(),color: redColor);
      }
    }
  }
  Future<void>deleteProduct(String productId,BuildContext context)async{
    final loadingProvider=Provider.of<LoadingProvider>(context,listen: false);

    try{
      loadingProvider.setLoading(true);

      await ProductRepository.deleteProduct(productId,context).then((v){

        loadingProvider.setLoading(false);
        if(context.mounted){
          showSnackbar(context, AppLocalizations.of(context)!.successfullydeletedproduct,color: greenColor);
        }
      }).onError((err,e){
        loadingProvider.setLoading(false);
        if(context.mounted){
          //showSnackbar(context, err.toString(),color: redColor);
        }
      });
    }catch(e){
      if(context.mounted){
        loadingProvider.setLoading(false);
        showSnackbar(context, e.toString(),color: redColor);
      }
    }
  }


  void addFile(FileModel file) {
    _files.add(file);
    notifyListeners();
  }

  void removeFile(FileModel file) {
    _files.remove(file);
    notifyListeners();
  }

  setValues(Product data){
    productTitleController.text=data.title;
  weightsList.contains(data.weight)? data.weight:'100 grams';
 categoryList.contains(data.color)? data.color:'Black';
  sizeList.contains(data.size)?data.size:'Small';
    discriptionController.text=data.description;
    quantityController.text=data.quantity.toString();
    priceController.text=data.price.toString();
    categoryId=data.category!.id;
    subCategoryId=data.subcategory!.id;

  }

  clearResources(){
    _files.clear();
    productTitleController.clear();
    quantityController.clear();
    discriptionController.clear();
    priceController.clear();
    category=null;
    subCategory=null;
    weight=null;
    color=null;
    size=null;
    subCategoryId=null;
    categoryId=null;
    isDraftToPublish=false;
    isViolationToPendingQc=false;
    notifyListeners();
  }
}