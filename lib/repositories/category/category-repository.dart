import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/api/network/api-client.dart';
import 'package:sugudeni/models/category/CategoryListResponse.dart';
import 'package:sugudeni/models/category/CategoryUpdatedResponse.dart';
import 'package:sugudeni/models/category/DeletedCategoryResponse.dart';
import 'package:sugudeni/models/category/DeletedSubCategoryResponse.dart';
import 'package:sugudeni/models/category/NameModel.dart';
import 'package:sugudeni/models/category/SubCategoryAddedResponse.dart';
import 'package:sugudeni/models/category/SubCategoryListResponse.dart';
import 'package:sugudeni/models/category/SubCategoryUpdatedResponse.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:http/http.dart' as http;

class CategoryRepository{

  static Future<SubCategoryAddedResponse> addSubCategory(NameModel name,String categoryId,BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.postRequest("${ApiEndpoints.categories}/$categoryId/${ApiEndpoints.subcategories}",name.toJson(),headers: await ApiClient.bearerHeader).timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
    final statusCode=response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==200||response.statusCode==201){
      return _handleResponse(response, (data) => SubCategoryAddedResponse.fromJson(body));
    }else{
      final error=body['error'];
      showSnackbar(context, error.toString(),color: redColor);
      throw error;
    }
  }
  static Future<SubCategoryListResponse> allSubCategory(String categoryId,BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.getRequest("${ApiEndpoints.categories}/$categoryId/${ApiEndpoints.subcategories}",headers:await ApiClient.bearerHeader).timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
    final statusCode=response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==200||response.statusCode==201){
      return _handleResponse(response, (data) => SubCategoryListResponse.fromJson(body));
    }else{
      final error=body['error'];
      showSnackbar(context, error.toString(),color: redColor);
      throw error;
    }
  }
  static Future<CategoryListResponse> allCategory(BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.getRequest(ApiEndpoints.categories,headers:await ApiClient.bearerHeader).timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
    final statusCode=response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==200||response.statusCode==201){
      return _handleResponse(response, (data) => CategoryListResponse.fromJson(body));
    }else{
      final error=body['error'];
      showSnackbar(context, error.toString(),color: redColor);
      throw error;
    }
  }
  static Future<DeletedCategoryResponse> deleteCategory(String id,BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.deleteRequest("${ApiEndpoints.categories}/$id",headers:await ApiClient.bearerHeader).timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
    final statusCode=response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==200||response.statusCode==201){
      return _handleResponse(response, (data) => DeletedCategoryResponse.fromJson(body));
    }else{
      final error=body['error'];
      showSnackbar(context, error.toString(),color: redColor);
      throw error;
    }
  }
  static Future<DeleteSubCategoryResponse> deleteSubCategory(String categoryId,String subCategoryId,BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.deleteRequest("${ApiEndpoints.categories}/$categoryId/${ApiEndpoints.subcategories}/$subCategoryId").timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
    final statusCode=response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==200||response.statusCode==201){
      return _handleResponse(response, (data) => DeleteSubCategoryResponse.fromJson(body));
    }else{
      final error=body['error'];
      showSnackbar(context, error.toString(),color: redColor);
      throw error;
    }
  }
  static Future<CategoryUpdateResponse> updateCategory(NameModel name,String categoryId,BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.putRequest("${ApiEndpoints.categories}/$categoryId",name.toJson(),headers: await ApiClient.bearerHeader).timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
    final statusCode=response.statusCode;
    customPrint("Url:================${ApiEndpoints.categories}/$categoryId");
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==200||response.statusCode==201){
      return _handleResponse(response, (data) => CategoryUpdateResponse.fromJson(body));
    }else{
      final error=body['error'];
      showSnackbar(context, error.toString(),color: redColor);
      throw error;
    }
  }
  static Future<SubCategoryUpdatedResponse> updateSubCategory(NameModel name,String categoryId,String subCategoryId,BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.putRequest("${ApiEndpoints.categories}/$categoryId/${ApiEndpoints.subcategories}/$subCategoryId",name.toJson()).timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
    final statusCode=response.statusCode;
    customPrint("Url:================${ApiEndpoints.categories}/$categoryId");
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==200||response.statusCode==201){
      return _handleResponse(response, (data) => SubCategoryUpdatedResponse.fromJson(body));
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