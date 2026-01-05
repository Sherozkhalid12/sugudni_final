import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/api/network/api-client.dart';
import 'package:sugudeni/models/orders/CashOrderModel.dart';
import 'package:sugudeni/models/orders/GetAllOrderResponseModel.dart';
import 'package:sugudeni/models/orders/GetAllOrderSellerResponseModel.dart';
import 'package:sugudeni/models/products/AddSaleToProductModel.dart';
import 'package:sugudeni/models/products/ProductStatusChangeModel.dart';
import 'package:sugudeni/models/products/SellerProductListResponse.dart';
import 'package:sugudeni/models/simple/SimpleMessageResponseModel.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:http/http.dart' as http;
import 'package:sugudeni/utils/sharePreference/save-user-token.dart';

import '../../models/cart/AddToCartResponse.dart';
import '../../models/orders/GetAllOrdersCutomerModel.dart';
import '../../models/products/UpdatedProductResponse.dart';
class CustomerOrderRepository{
  static Future<GetCustomerAllOrderResponseModel> allCustomersOrders(BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    String customerId = await getUserId();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.getRequest("${ApiEndpoints.allCustomersOrders}/$customerId",).timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
    final statusCode=response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==200){
      return _handleResponse(response, (data) => GetCustomerAllOrderResponseModel.fromJson(body));
    }else{
      final error=body['error'];
      // Don't show snackbar for authorization errors (401) - they're expected for sellers
      if(response.statusCode != 401){
        showSnackbar(context, error.toString(),color: redColor);
      }
      throw error;
    }
  }
  // static Future<GetCustomerAllOrderResponseModel> allCustomersOrders(BuildContext context) async {
  //   bool isConnected = await checkInternetConnection();
  //   String customerId = await getUserId();
  //   if (!isConnected) {
  //     throw 'Please check your internet and try again.';
  //   }
  //
  //   final response = await ApiClient.getRequest("${ApiEndpoints.allCustomersOrders}/$customerId")
  //       .timeout(const Duration(seconds: 30), onTimeout: () {
  //     throw 'Request timed out. Please try again.';
  //   });
  //
  //   final body = jsonDecode(response.body);
  //   final statusCode = response.statusCode;
  //
  //   customPrint("Body type:================${body.runtimeType}");
  //   customPrint("Status code:================$statusCode");
  //
  //   if (statusCode == 200) {
  //     // Convert response to model
  //     GetCustomerAllOrderResponseModel result = GetCustomerAllOrderResponseModel.fromJson(body);
  //
  //     // Filter out orders where all cart items have productId as null
  //     result.orders.removeWhere((order) =>
  //         order.cartItem.every((cartItem) => cartItem.productId == null)
  //     );
  //
  //     return result;
  //   } else {
  //     final error = body['error'];
  //     showSnackbar(context, error.toString(), color: redColor);
  //     throw error;
  //   }
  // }

  static Future<SimpleMessageResponseModel> reorderProducts(CashOrderModel model,String orderId,BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.postRequest("${ApiEndpoints.reorder}/$orderId",model.toJson()).timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
    final statusCode=response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==200||response.statusCode==201){
      return _handleResponse(response, (data) => SimpleMessageResponseModel.fromJson(body));
    }else{
      final error=body['error'];
      showSnackbar(context, error.toString(),color: redColor);
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