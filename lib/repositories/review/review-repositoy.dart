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
import 'package:sugudeni/models/delivery/AddDeliveryRatingModel.dart';
import 'package:sugudeni/models/review/AddReviewModel.dart';
import 'package:sugudeni/models/review/AddReviewResponseModel.dart';
import 'package:sugudeni/models/review/GetSingleProductReviewModel.dart';
import 'package:sugudeni/models/wishlist/AddToWishlistResponse.dart';
import 'package:sugudeni/models/wishlist/AddWishListModel.dart';
import 'package:sugudeni/models/wishlist/GetAllWishlistResponseModel.dart';
import 'package:sugudeni/models/wishlist/RemoveFromWishlistRespnseModel.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:http/http.dart' as http;
import 'package:sugudeni/utils/sharePreference/save-user-token.dart';
class ReviewRepository{
  static Future<AddReviewResponseModel> addReview(AddReviewModel model,BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.postRequest(ApiEndpoints.review,model.toJson()).timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
    final statusCode=response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==201){
      return _handleResponse(response, (data) => AddReviewResponseModel.fromJson(body));
    }else{
      final error=body['error'];
      showSnackbar(context, error.toString(),color: redColor);
      throw error;
    }
  }
  static Future<AddReviewResponseModel> addReviewToDelivery(AddDeliveryRatingModel model,String orderId,BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.patchRequest("${ApiEndpoints.addReviewToDelivery}/$orderId",model.toJson()).timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
    final statusCode=response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==201){
      return _handleResponse(response, (data) => AddReviewResponseModel.fromJson(body));
    }else{
      final error=body['error'];
      showSnackbar(context, error.toString(),color: redColor);
      throw error;
    }
  }

  static Future<GetReviewsOfSingleProduct> getReviewOfSingleProduct(String productId,BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.getRequest("${ApiEndpoints.productReviews}/$productId").timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
    final statusCode=response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==201){
      return _handleResponse(response, (data) => GetReviewsOfSingleProduct.fromJson(body));
    }else{
      final error=body['error'];
      showSnackbar(context, error.toString(),color: redColor);
      throw error;
    }
  }
  static Future<GetReviewsOfSingleProduct> getReviewsForSeller(int page,BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    String sellerId = await getUserId();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.getRequest("${ApiEndpoints.sellerReviews}/$sellerId?page=$page").timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
    final statusCode=response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==201){
      return _handleResponse(response, (data) => GetReviewsOfSingleProduct.fromJson(body));
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