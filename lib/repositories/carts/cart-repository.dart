import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/api/network/api-client.dart';
import 'package:sugudeni/models/cart/AddToCartModel.dart';
import 'package:sugudeni/models/cart/AddToCartResponse.dart';
import 'package:sugudeni/models/cart/ApplyCouponModel.dart';
import 'package:sugudeni/models/cart/GetCartResponse.dart';
import 'package:sugudeni/models/cart/OrangeMoneyResponseModel.dart';
import 'package:sugudeni/models/cart/UpdateCartQuantityModel.dart';
import 'package:sugudeni/models/cart/UpdateCartQuantityResponse.dart';
import 'package:sugudeni/models/products/ProductStatusChangeModel.dart';
import 'package:sugudeni/models/products/SellerProductListResponse.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:http/http.dart' as http;
import 'package:sugudeni/utils/sharePreference/save-user-token.dart';

import '../../models/cart/CheckoutResponseModel.dart';
import '../../models/cart/DeleteCartResponseModel.dart';
import '../../models/orders/CashOrderModel.dart';
import '../../models/orders/CashOrderResponseModel.dart';
import '../../models/products/UpdatedProductResponse.dart';

class CartRepository{

  static Future<AddToCartResponse> addProductToCart(AddToCartModel model,BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.postRequest(ApiEndpoints.carts,model.toJson()).timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
    final statusCode=response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==200||response.statusCode==201){
      return _handleResponse(response, (data) => AddToCartResponse.fromJson(body));
    }else{
      final error=body['error'];
      showSnackbar(context, error.toString(),color: textSecondaryColor);
      throw error;
    }
  }
  static Future<AddToCartResponse> applyCoupon(ApplyCouponModel model,BuildContext context) async {
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
    if(response.statusCode==200||response.statusCode==201){
      return _handleResponse(response, (data) => AddToCartResponse.fromJson(body));
    }else{
      final error=body['error'];
      showSnackbar(context, error.toString(),color: textSecondaryColor);
      throw error;
    }
  }
  static Future<UpdateCartQuantityResponse> updateCartQuantity(UpdateCartQuantityModel model,String productId,BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.putRequest("${ApiEndpoints.carts}/$productId",model.toJson()).timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
    final statusCode=response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==200||response.statusCode==201){
      return _handleResponse(response, (data) => UpdateCartQuantityResponse.fromJson(body));
    }else{
      final error=body['error'] ?? 'Failed to update cart quantity';
      // Handle NaN discount error specifically
      if (error.toString().contains('NaN') || error.toString().contains('discount')) {
        showSnackbar(context, 'Cart calculation error. Please try again.', color: textSecondaryColor);
      } else {
        showSnackbar(context, error.toString(), color: textSecondaryColor);
      }
      throw error;
    }
  }
  static Future<DeleteCartResponseModel> removeProductFromCart(String productId,BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.deleteRequest("${ApiEndpoints.carts}/$productId").timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
    final statusCode=response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==200||response.statusCode==201){
      return _handleResponse(response, (data) => DeleteCartResponseModel.fromJson(body));
    }else{
      final error=body['error'];
      showSnackbar(context, error.toString(),color: textSecondaryColor);
      throw error;
    }
  }
  static Future<GetCartResponse> getCartProducts(BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.getRequest(ApiEndpoints.carts).timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
    final statusCode=response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==200){
      return _handleResponse(response, (data) => GetCartResponse.fromJson(body));
    }else{
      final error=body['error'] ?? 'An error occurred while loading cart';
      // Don't show snackbar for 500 errors as they might be temporary backend issues
      if (statusCode != 500) {
        showSnackbar(context, error.toString(),color: textSecondaryColor);
      }
      throw error;
    }
  }
  static Future<CashOrderResponseModel> createCashOrder(CashOrderModel model,String cartId,BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.postRequest("${ApiEndpoints.orders}/$cartId",model.toJson()).timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
    final statusCode=response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==200||response.statusCode==201){
      return _handleResponse(response, (data) => CashOrderResponseModel.fromJson(body));
    }else{
      final error=body['error'];
      showSnackbar(context, error.toString(),color: textSecondaryColor);
      throw error;
    }
  }
  static Future<CheckOutResponse> createCheckoutOrderForStripe(CashOrderModel model,String cartId,BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.postRequest("${ApiEndpoints.createCheckoutForStripe}/$cartId",model.toJson()).timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
    final statusCode=response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==200){
      return _handleResponse(response, (data) => CheckOutResponse.fromJson(body));
    }else{
      final error=body['error'];
      showSnackbar(context, error.toString(),color: textSecondaryColor);
      throw error;
    }
  }
  static Future<OrangeMoneyResponse> createCheckoutOrderForOrangeMoney(CashOrderModel model,String cartId,BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.postRequest("${ApiEndpoints.createCheckoutForOrangeMoney}/$cartId",model.toJson()).timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
    final statusCode=response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==200){
      return _handleResponse(response, (data) => OrangeMoneyResponse.fromJson(body));
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