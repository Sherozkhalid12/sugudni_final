import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/api/network/api-client.dart';
import 'package:sugudeni/models/auth/SignUpModel.dart';
import 'package:sugudeni/models/coupon/ApplyCouponModel.dart';
import 'package:sugudeni/models/products/AddedProductResponse.dart';
import 'package:sugudeni/models/products/DeleteProductReponse.dart';
import 'package:sugudeni/models/products/SpecificProductResponse.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:http/http.dart' as http;
import '../../models/products/ProductListResponse.dart';
import '../../models/simple/SimpleMessageResponseModel.dart';

class ProductRepository{
  //
  // static Future<AddedProductResponse> addProducts(,BuildContext context) async {
  //   bool isConnected = await checkInternetConnection();
  //   if(!isConnected){
  //     throw 'Please check your internet and try again.';
  //   }
  //   final response = await ApiClient.postRequest(,ApiEndpoints.products,headers:await ApiClient.bearerHeader).timeout(const Duration(seconds: 30),onTimeout: (){
  //     throw 'Request timed out. Please try again.';
  //   });
  //   final body=jsonDecode(response.body);
  //   final statusCode=response.statusCode;
  //   customPrint("Body type:================${body.runtimeType}");
  //   customPrint("Status code:================$statusCode");
  //   if(response.statusCode==200||response.statusCode==201){
  //     return _handleResponse(response, (data) => AddedProductResponse.fromJson(body));
  //   }else{
  //     final error=body['error'];
  //     showSnackbar(context, error.toString(),color: redColor);
  //     throw error;
  //   }
  // }
  static Future<ProductListResponse> allProducts(BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.getRequest(ApiEndpoints.products,headers:await ApiClient.bearerHeader).timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
    final statusCode=response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==200||response.statusCode==201){
      return _handleResponse(response, (data) => ProductListResponse.fromJson(body));
    }else{
      final error=body['error'];
      showSnackbar(context, error.toString(),color: textSecondaryColor);
      throw error;
    }
  }
  static Future<ProductListResponse> allProductsUsingPagination(BuildContext context,int page) async {
    bool isConnected = await checkInternetConnection();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.getRequest("${ApiEndpoints.products}?limit=10&page=$page&status=active",headers:await ApiClient.bearerHeader).timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
   final statusCode=response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==200||response.statusCode==201){
      return _handleResponse(response, (data) => ProductListResponse.fromJson(body));
    }else{
      final error=body['error'];
      showSnackbar(context, error.toString(),color: textSecondaryColor);
      throw error;
    }
  }
  static Future<ProductListResponse> allProductsUsingPaginationWithFilter(BuildContext context,int page,String query) async {
    bool isConnected = await checkInternetConnection();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = query.isEmpty?await ApiClient.getRequest("${ApiEndpoints.products}?limit=10&page=$page&status=active",headers:await ApiClient.bearerHeader).timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    }) :await ApiClient.getRequest("${ApiEndpoints.products}?limit=10&page=$page&status=active&keyword=$query",headers:await ApiClient.bearerHeader).timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
   final statusCode=response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==201){
      return _handleResponse(response, (data) => ProductListResponse.fromJson(body));
    }else{
      final error=body['error'];
      showSnackbar(context, error.toString(),color: textSecondaryColor);
      throw error;
    }
  }
  static Future<ProductListResponse> allProductsForCustomer(BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.getRequest("${ApiEndpoints.products}?page=1&limit=10&status=active",headers:await ApiClient.bearerHeader).timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
    final statusCode=response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==200||response.statusCode==201){
      return _handleResponse(response, (data) => ProductListResponse.fromJson(body));
    }else{
      final error=body['error'];
      showSnackbar(context, error.toString(),color: textSecondaryColor);
      throw error;
    }
  }
  static Future<SpecificProductResponse> specificProduct(String id,BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.getRequest("${ApiEndpoints.products}/$id").timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
    final statusCode=response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==200||response.statusCode==201){
      return _handleResponse(response, (data) => SpecificProductResponse.fromJson(body));
    }else{
      final error=body['error'];
      showSnackbar(context, error.toString(),color: textSecondaryColor);
      throw error;
    }
  }
  static Future<DeleteProductResponse> deleteProduct(String id,BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.deleteRequest("${ApiEndpoints.products}/$id").timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
    final statusCode=response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==200||response.statusCode==201){
      return _handleResponse(response, (data) => DeleteProductResponse.fromJson(body));
    }else{
      final error=body['error'];
      showSnackbar(context, error.toString(),color: textSecondaryColor);
      throw error;
    }
  }

  static Future<ProductListResponse> allProductsOfCategoryUsingPagination(String categoryId,BuildContext context,int page) async {
    bool isConnected = await checkInternetConnection();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.getRequest("${ApiEndpoints.getCategoryProducts}/$categoryId?page=$page&limit=10",headers:await ApiClient.bearerHeader).timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
    final statusCode=response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==200||response.statusCode==201){
      return _handleResponse(response, (data) => ProductListResponse.fromJson(body));
    }else{
      final error=body['error'];
      showSnackbar(context, error.toString(),color: textSecondaryColor);
      throw error;
    }
  }
  static Future<ProductListResponse> allProductsOfSubCategoryUsingPagination(String subCategoryId,BuildContext context,int page) async {
    bool isConnected = await checkInternetConnection();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.getRequest("${ApiEndpoints.getSubCategoryProducts}/$subCategoryId?page=$page",headers:await ApiClient.bearerHeader).timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
    final statusCode=response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==200){
      return _handleResponse(response, (data) => ProductListResponse.fromJson(body));
    }else{
      final error=body['error'];
      showSnackbar(context, error.toString(),color: textSecondaryColor);
      throw error;
    }
  }
  static Future<SimpleMessageResponseModel> applyCoupon(Coupon model,BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.postRequest(ApiEndpoints.applyCoupons,model.toJson()).timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
    final statusCode=response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==201){
      return _handleResponse(response, (data) => SimpleMessageResponseModel.fromJson(body));
    }else{
      final error=body['error'];
      showSnackbar(context, error.toString(),color: textSecondaryColor);
      throw error;
    }
  }
  static T _handleResponse<T>(http.Response response, T Function(dynamic data) onSuccess) {
    final statusCode = response.statusCode;
    final body = json.decode(response.body);

    switch (statusCode) {
      case 200:
        return onSuccess(body);
      case 201:
        return onSuccess(body);
      case 400:
        throw 'Account Not Found';
      case 401:
        throw 'Unauthorized: You are not authorized to perform this action';
      case 403:
        throw Exception('Forbidden: You do not have permission to access this resource.');
      case 404:
        throw Exception('Not Found: The resource you are looking for could not be found.');
      case 500:
        throw Exception('Error. No result returned.');
      default:
        throw Exception('An unexpected error occurred (Status Code: $statusCode).');
    }
  }
}