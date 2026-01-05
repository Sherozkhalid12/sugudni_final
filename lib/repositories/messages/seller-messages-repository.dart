import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/api/network/api-client.dart';
import 'package:sugudeni/models/auth/SignUpModel.dart';
import 'package:sugudeni/models/messages/ChatHistoryModel.dart';
import 'package:sugudeni/models/messages/MarkAsUnreadModel.dart';
import 'package:sugudeni/models/messages/SellerThreadsResponse.dart';
import 'package:sugudeni/models/messages/UnreadCountResponse.dart';
import 'package:sugudeni/models/messages/UnreadResponse.dart';
import 'package:sugudeni/models/products/AddedProductResponse.dart';
import 'package:sugudeni/models/products/DeleteProductReponse.dart';
import 'package:sugudeni/models/products/SpecificProductResponse.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:http/http.dart' as http;
import 'package:sugudeni/utils/sharePreference/save-user-token.dart';
import '../../models/products/ProductListResponse.dart';
class SellerMessagesRepository{
  static Future<SellerThreadResponse> getThreadsForSeller(BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    String sellerId = await getUserId();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.getRequest("${ApiEndpoints.threads}/$sellerId",headers:await ApiClient.bearerHeader).timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
    final statusCode=response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==200||response.statusCode==201){
      return _handleResponse(response, (data) => SellerThreadResponse.fromJson(body));
    }else{
      final error=body['error'];
      showSnackbar(context, error.toString(),color: redColor);
      throw error;
    }
  }
  static Future<ChatHistoryResponse> getChatHistory(BuildContext context,String receiverId,String senderId) async {
    bool isConnected = await checkInternetConnection();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    customPrint("========== FETCHING CHAT HISTORY ==========");
    customPrint("Sender ID: $senderId, Receiver ID: $receiverId");
    final response = await ApiClient.getRequest("${ApiEndpoints.chatHistory}/$senderId/$receiverId",headers:await ApiClient.bearerHeader).timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
    final statusCode=response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    customPrint("Raw response body: ${response.body}");
    
    if(response.statusCode==200||response.statusCode==201){
      final chatHistory = _handleResponse(response, (data) => ChatHistoryResponse.fromJson(body));
      return chatHistory;
    }else{
      final error=body['error'];
      showSnackbar(context, error.toString(),color: redColor);
      throw error;
    }
  }
  static Future<UnreadCountResponse> getUnreadCount(BuildContext context) async {

    bool isConnected = await checkInternetConnection();
    String userID = await getUserId();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.getRequest("${ApiEndpoints.unreadCounts}/$userID",headers:await ApiClient.bearerHeader).timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
    final statusCode=response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==200||response.statusCode==201){
      return _handleResponse(response, (data) => UnreadCountResponse.fromJson(body));
    }else{
      final error=body['error'];
      showSnackbar(context, error.toString(),color: redColor);
      throw error;
    }
  }
  static Future<UnreadResponse> markAsUnread(MarkAsUnreadModel model,BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.patchRequest(ApiEndpoints.markAsUnread,model.toJson(),headers:await ApiClient.bearerHeader).timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
    final statusCode=response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==200){
      return _handleResponse(response, (data) => UnreadResponse.fromJson(body));
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