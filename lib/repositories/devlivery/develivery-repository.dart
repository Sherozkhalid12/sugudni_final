import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/api/network/api-client.dart';
import 'package:sugudeni/models/deliveryslots/GetAllDeliverySlotsModel.dart';
import 'package:sugudeni/models/orders/GetAllOrderResponseModel.dart';
import 'package:sugudeni/models/orders/GetAllOrderSellerResponseModel.dart';
import 'package:sugudeni/models/products/AddSaleToProductModel.dart';
import 'package:sugudeni/models/products/ProductStatusChangeModel.dart';
import 'package:sugudeni/models/products/SellerProductListResponse.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:http/http.dart' as http;
import 'package:sugudeni/utils/sharePreference/save-user-token.dart';

import '../../models/cart/AddToCartResponse.dart';
import '../../models/orders/GetAllOrdersCutomerModel.dart';
import '../../models/products/UpdatedProductResponse.dart';

class DeliveryRepository{

  static Future<GetDeliverySlotsModel> getAllDeliverySlot(BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.getRequest(ApiEndpoints.deliveryslot).timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
    final statusCode=response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==201){
      return _handleResponse(response, (data) => GetDeliverySlotsModel.fromJson(body));
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