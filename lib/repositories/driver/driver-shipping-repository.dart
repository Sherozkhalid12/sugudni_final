import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/api/network/api-client.dart';
import 'package:sugudeni/models/shipment/GetAllAvailableShipmentModel.dart';
import 'package:sugudeni/models/shipment/UpdateShipmentAddressModel.dart';
import 'package:sugudeni/models/simple/SimpleMessageResponseModel.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:http/http.dart' as http;
import 'package:sugudeni/utils/sharePreference/save-user-token.dart';

import '../../models/shipment/ShipmentFailedModel.dart';

class DriverShippingRepository{

  static Future<SimpleMessageResponseModel> acceptDeliveryToShip(String orderId,BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.patchRequest("${ApiEndpoints.acceptDeliveryToShip}/$orderId",{}).timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
    final statusCode=response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==200){
      return _handleResponse(response, (data) => SimpleMessageResponseModel.fromJson(body));
    }else{
      final error=body['error'];
      showSnackbar(context, error.toString(),color: redColor);
      throw error;
    }
  }
  static Future<SimpleMessageResponseModel> shipmentPicked(String orderId,BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.patchRequest("${ApiEndpoints.shipmentPicket}/$orderId",{}).timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
    final statusCode=response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==200){
      return _handleResponse(response, (data) => SimpleMessageResponseModel.fromJson(body));
    }else{
      final error=body['error'];
      showSnackbar(context, error.toString(),color: redColor);
      throw error;
    }
  }
  static Future<SimpleMessageResponseModel> deliveredShipment(String orderId,BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.patchRequest("${ApiEndpoints.deliverShipment}/$orderId",{}).timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
    final statusCode=response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==200){
      return _handleResponse(response, (data) => SimpleMessageResponseModel.fromJson(body));
    }else{
      final error=body['error'];
      showSnackbar(context, error.toString(),color: redColor);
      throw error;
    }
  }
  static Future<SimpleMessageResponseModel> updateShipmentAddress(UpdateShipmentModel model,String orderId,BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.patchRequest("${ApiEndpoints.updateShipment}/$orderId",model.toJson()).timeout(const Duration(seconds: 30),onTimeout: (){
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
  static Future<GetAllShipmentResponse> getAllAvailableShipment(BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    if(!isConnected){
      if (context.mounted) {
        showSnackbar(context, 'Please check your internet connection and try again.', color: redColor);
      }
      throw 'Please check your internet and try again.';
    }
    try {
      final response = await ApiClient.getRequest(ApiEndpoints.allAvailableShipments).timeout(const Duration(seconds: 30),onTimeout: (){
        if (context.mounted) {
          showSnackbar(context, 'Request timed out. Please try again.', color: redColor);
        }
        throw 'Request timed out. Please try again.';
      });
      final body=jsonDecode(response.body);
      final statusCode=response.statusCode;
      customPrint("Body type:================${body.runtimeType}");
      customPrint("Status code:================$statusCode");
      if(response.statusCode==200){
        try {
          return _handleResponse(response, (data) => GetAllShipmentResponse.fromJson(body));
        } catch (e) {
          // Handle exceptions from _handleResponse
          String errorMessage = e.toString().replaceAll('Exception: ', '');
          if (context.mounted) {
            showSnackbar(context, errorMessage, color: redColor);
          }
          throw errorMessage;
        }
      }else{
        final error=body['error'] ?? 'Failed to load available shipments. Please try again.';
        if (context.mounted) {
          showSnackbar(context, error.toString(), color: redColor);
        }
        throw error;
      }
    } catch (e) {
      // Catch any other exceptions (network errors, etc.)
      String errorMessage = e.toString().replaceAll('Exception: ', '');
      if (context.mounted && !errorMessage.contains('Request timed out') && !errorMessage.contains('internet')) {
        showSnackbar(context, errorMessage, color: redColor);
      }
      rethrow;
    }
  }
  static Future<GetAllShipmentResponse> getAllPendingShipment(BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    String driverId = await getUserId();
    if(!isConnected){
      if (context.mounted) {
        showSnackbar(context, 'Please check your internet connection and try again.', color: redColor);
      }
      throw 'Please check your internet and try again.';
    }
    try {
      final response = await ApiClient.getRequest("${ApiEndpoints.driverShipments}/$driverId").timeout(const Duration(seconds: 30),onTimeout: (){
        if (context.mounted) {
          showSnackbar(context, 'Request timed out. Please try again.', color: redColor);
        }
        throw 'Request timed out. Please try again.';
      });
      final body=jsonDecode(response.body);
      final statusCode=response.statusCode;
      customPrint("Body type:================${body.runtimeType}");
      customPrint("Status code:================$statusCode");
      if(response.statusCode==200){
        try {
          return _handleResponse(response, (data) => GetAllShipmentResponse.fromJson(body));
        } catch (e) {
          // Handle exceptions from _handleResponse
          String errorMessage = e.toString().replaceAll('Exception: ', '');
          if (context.mounted) {
            showSnackbar(context, errorMessage, color: redColor);
          }
          throw errorMessage;
        }
      }else{
        final error=body['error'] ?? 'Failed to load shipments. Please try again.';
        if (context.mounted) {
          showSnackbar(context, error.toString(), color: redColor);
        }
        throw error;
      }
    } catch (e) {
      // Catch any other exceptions (network errors, etc.)
      String errorMessage = e.toString().replaceAll('Exception: ', '');
      if (context.mounted && !errorMessage.contains('Request timed out') && !errorMessage.contains('internet')) {
        showSnackbar(context, errorMessage, color: redColor);
      }
      rethrow;
    }
  }
  static Future<SimpleMessageResponseModel> deliveryFailed(FailedDeliveryModel model,String id,BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.patchRequest("${ApiEndpoints.deliveryFailed}/$id",model.toJson()).timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
    final statusCode=response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==200){
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