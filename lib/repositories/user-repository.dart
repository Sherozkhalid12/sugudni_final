import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/api/network/api-client.dart';
import 'package:sugudeni/models/address-model/AddAddressModel.dart';
import 'package:sugudeni/models/driver/GetDriverDataResponse.dart';
import 'package:sugudeni/models/messages/GetUserNameModel.dart';
import 'package:sugudeni/models/products/ProductStatusChangeModel.dart';
import 'package:sugudeni/models/products/SellerProductListResponse.dart';
import 'package:sugudeni/models/user/CustomerDataResponseModel.dart';
import 'package:sugudeni/models/user/SellerDataResponseModel.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:http/http.dart' as http;
import 'package:sugudeni/utils/sharePreference/save-user-token.dart';

import '../../models/products/UpdatedProductResponse.dart';
import '../models/address-model/AddedAddressResponseModel.dart';
import '../models/address-model/billing-model.dart';
import '../models/simple/SimpleMessageResponseModel.dart';
import '../models/user/UpdateCustomerModel.dart';
import '../models/user/UpdateSellerModel.dart';
import '../models/user/UpdateSellerResponse.dart';

class UserRepository{
  static Future<GetUserNameModel> getUserNameAndId(String userId,BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.getRequest("${ApiEndpoints.users}/$userId",).timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
    final statusCode=response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==200||response.statusCode==201){
      return _handleResponse(response, (data) => GetUserNameModel.fromJson(body));
    }else{
      final error=body['error'];
      showSnackbar(context, error.toString(),color: redColor);
      throw error;
    }
  }
  static Future<SellerDataResponse> getSellerData(BuildContext context) async {

    bool isConnected = await checkInternetConnection();
    String userId = await getUserId();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.getRequest("${ApiEndpoints.users}/$userId",).timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
    final statusCode=response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==200||response.statusCode==201){
      return _handleResponse(response, (data) => SellerDataResponse.fromJson(body));
    }else{
      final error=body['error'];
      showSnackbar(context, error.toString(),color: redColor);
      throw error;
    }
  }
  static Future<CustomerDataResponse> getCustomerData(BuildContext context) async {

    bool isConnected = await checkInternetConnection();
    String userId = await getUserId();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.getRequest("${ApiEndpoints.users}/$userId",).timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
    final statusCode=response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==200||response.statusCode==201){
      return _handleResponse(response, (data) => CustomerDataResponse.fromJson(body));
    }else{
      final error=body['error'];
      showSnackbar(context, error.toString(),color: redColor);
      throw error;
    }
  }
  static Future<SellerDataResponse> getSellerDataForCustomer(String sellerId,BuildContext context) async {

    bool isConnected = await checkInternetConnection();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.getRequest("${ApiEndpoints.users}/$sellerId",).timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
    final statusCode=response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==200||response.statusCode==201){
      return _handleResponse(response, (data) => SellerDataResponse.fromJson(body));
    }else{
      final error=body['error'];
      showSnackbar(context, error.toString(),color: redColor);
      throw error;
    }
  }
  static Future<GetDriverDataResponse> getDriverData(BuildContext context) async {

    bool isConnected = await checkInternetConnection();
    String driverId = await getUserId();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.getRequest("${ApiEndpoints.users}/$driverId",).timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
    final statusCode=response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==200||response.statusCode==201){
      return _handleResponse(response, (data) => GetDriverDataResponse.fromJson(body));
    }else{
      final error=body['error'];
      showSnackbar(context, error.toString(),color: redColor);
      throw error;
    }
  }
  static Future<UpdateSellerResponse> updateSellerSetting(UpdateSellerModel model,BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.patchRequest(ApiEndpoints.updateSellerSetting,model.toJson()).timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
    final statusCode=response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==201){
      return _handleResponse(response, (data) => UpdateSellerResponse.fromJson(body));
    }else{
      final error=body['error'];
      showSnackbar(context, error.toString(),color: redColor);
      throw error;
    }
  }
  static Future<SimpleMessageResponseModel> updateCustomerSetting(UpdateCustomerModel model,BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    String userId = await getUserId();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.patchRequest("${ApiEndpoints.users}/$userId",model.toJson()).timeout(const Duration(seconds: 30),onTimeout: (){
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
      showSnackbar(context, error.toString(),color: redColor);
      throw error;
    }
  }
  static Future<UpdateSellerResponse> updateBillingAddress(BillingAddressModel model,BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    String userId = await getUserId();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.patchRequest("${ApiEndpoints.users}/$userId",model.toJsonBillingUpdate()).timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
    final statusCode=response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==201){
      return _handleResponse(response, (data) => UpdateSellerResponse.fromJson(body));
    }else{
      final error=body['error'];
      showSnackbar(context, error.toString(),color: redColor);
      throw error;
    }
  }
  static Future<UpdateSellerResponse> updateShippingAddress(BillingAddressModel model,BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    String userId = await getUserId();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.patchRequest("${ApiEndpoints.users}/$userId",model.toJsonShippingUpdate()).timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
    final statusCode=response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==201){
      return _handleResponse(response, (data) => UpdateSellerResponse.fromJson(body));
    }else{
      final error=body['error'];
      showSnackbar(context, error.toString(),color: redColor);
      throw error;
    }
  }
  static Future<AddedAddressResponseModel> addCustomerAddress(AddAddressModel model,BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.postRequest(ApiEndpoints.address,model.toJson()).timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
    final statusCode=response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==201){
      return _handleResponse(response, (data) => AddedAddressResponseModel.fromJson(body));
    }else{
      final error=body['error'];
      showSnackbar(context, error.toString(),color: redColor);
      throw error;
    }
  }
  static Future<SimpleMessageResponseModel> updateCustomerAddress(String addressId,AddAddressModel model,BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.patchRequest("${ApiEndpoints.address}/$addressId",model.toJson()).timeout(const Duration(seconds: 30),onTimeout: (){
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