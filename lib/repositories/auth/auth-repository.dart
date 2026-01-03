import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/api/network/api-client.dart';
import 'package:sugudeni/models/auth/ResetPasswordModel.dart';
import 'package:sugudeni/models/auth/SignInModel.dart';
import 'package:sugudeni/models/auth/SignInResponseModel.dart';
import 'package:sugudeni/models/auth/SignInWithPhoneModel.dart';
import 'package:sugudeni/models/auth/SignUpSuccess.dart';
import 'package:sugudeni/models/auth/VerifySignUpOtpModel.dart';
import 'package:sugudeni/models/simple/SimpleMessageResponseModel.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/sharePreference/save-user-token.dart';

import '../../models/auth/SignInWithPhoneRespnseModel.dart';
import '../../models/auth/SignUpModel.dart';
import '../../models/auth/SuccessfullVerifyOtpResponse.dart';
import '../../models/auth/SuccessfullVerifySignInOtpModel.dart';
import '../../models/auth/VerifySignInOtpModel.dart';
class AuthRepository{
  static Future<SignUpSuccess> signUpUser(SignUpModel model, BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    if (!isConnected) {
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.postRequest(ApiEndpoints.signup, model.toJson(), headers: await ApiClient.headers)
        .timeout(const Duration(seconds: 30), onTimeout: () {
      throw 'Request timed out. Please try again.';
    });
    final body = jsonDecode(response.body);
    final statusCode = response.statusCode;
    print("Response Body: $body"); // Debug log
    print("Status Code: $statusCode"); // Debug log
    if (response.statusCode == 200 || response.statusCode == 201) {
      return _handleResponse(response, (data) => SignUpSuccess.fromJson(body));
    } else {
      final error = body['error'];
      showSnackbar(context, error.toString(), color: redColor);
      throw error;
    }
  }  // static Future<SuccessfulVerifyOtpResponse> verifySignUpOtp(VerifySignInOtpModel  model,BuildContext context) async {
  //   bool isConnected = await checkInternetConnection();
  //   if(!isConnected){
  //     throw 'Please check your internet and try again.';
  //   }
  //   final response = await ApiClient.patchRequest(ApiEndpoints.verifySignUpOtp,model.toJson(),headers:await ApiClient.headers).timeout(const Duration(seconds: 30),onTimeout: (){
  //     throw 'Request timed out. Please try again.';
  //   });
  //   final body=jsonDecode(response.body);
  //   final statusCode=response.statusCode;
  //   customPrint("Body type:================${body.runtimeType}");
  //   customPrint("Status code:================$statusCode");
  //   if(response.statusCode==200){
  //     return _handleResponse(response, (data) => SuccessfulVerifyOtpResponse.fromJson(body));
  //   }else{
  //     final error=body['error'];
  //     showSnackbar(context, error.toString(),color: redColor);
  //     throw error;
  //   }
  // }
  static Future<SuccessfulVerifyOtpResponse> verifySignUpOtp(VerifySignUpOtpModel model, BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    if (!isConnected) {
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.patchRequest(ApiEndpoints.verifySignUpOtp, model.toJson(), headers: await ApiClient.headers)
        .timeout(const Duration(seconds: 30), onTimeout: () {
      throw 'Request timed out. Please try again.';
    });
    final body = jsonDecode(response.body);
    final statusCode = response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if (response.statusCode == 200) {
      return _handleResponse(response, (data) => SuccessfulVerifyOtpResponse.fromJson(body));
    } else {
      final error = body['error'];
      showSnackbar(context, error.toString(), color: redColor);
      throw error;
    }
  }

  static Future<SuccessfullVerifySignInOtpModel> verifySignInOtp(VerifySignInOtpModel model, BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    if (!isConnected) {
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.patchRequest(ApiEndpoints.verifySigninOtp, model.toJson(), headers: await ApiClient.headers)
        .timeout(const Duration(seconds: 30), onTimeout: () {
      throw 'Request timed out. Please try again.';
    });
    final body = jsonDecode(response.body);
    final statusCode = response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if (response.statusCode == 200) {
      return _handleResponse(response, (data) => SuccessfullVerifySignInOtpModel.fromJson(body));
    } else {
      final error = body['error'];
      showSnackbar(context, error.toString(), color: redColor);
      throw error;
    }
  }
  // static Future<SuccessfullVerifySignInOtpModel> verifySignInOtp(VerifySignInOtpModel  model,BuildContext context) async {
  //   bool isConnected = await checkInternetConnection();
  //   if(!isConnected){
  //     throw 'Please check your internet and try again.';
  //   }
  //   final response = await ApiClient.patchRequest(ApiEndpoints.verifySigninOtp,model.toJson(),headers:await ApiClient.headers).timeout(const Duration(seconds: 30),onTimeout: (){
  //     throw 'Request timed out. Please try again.';
  //   });
  //   final body=jsonDecode(response.body);
  //   final statusCode=response.statusCode;
  //   customPrint("Body type:================${body.runtimeType}");
  //   customPrint("Status code:================$statusCode");
  //   if(response.statusCode==200){
  //     return _handleResponse(response, (data) => SuccessfullVerifySignInOtpModel.fromJson(body));
  //   }else{
  //     final error=body['error'];
  //     showSnackbar(context, error.toString(),color: redColor);
  //     throw error;
  //   }
  // }

  static Future<SignInResponseModel> signInUser(SignInModel  model,BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.postRequest(ApiEndpoints.signin,model.toJson(),headers:await ApiClient.headers).timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
    final statusCode=response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==200||response.statusCode==201){
      return _handleResponse(response, (data) => SignInResponseModel.fromJson(body));
    }else{
      final error=body['error']??body['message'];
      showSnackbar(context, error.toString(),color: redColor);
      throw error;
    }
  }
  static Future<SignInWithPhoneResponseModel> signInUserWithPhoneNumber(SignInWithPhoneModel  model,BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.postRequest(ApiEndpoints.signin,model.toJson(),headers:await ApiClient.headers).timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
    final statusCode=response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==200){
      return _handleResponse(response, (data) => SignInWithPhoneResponseModel.fromJson(body));
    }else{
      final error=body['error'];
      showSnackbar(context, error.toString(),color: redColor);
      throw error;
    }
  }
  static Future<SimpleMessageResponseModel> resetPasswordRequest(ResetPasswordModel  model,BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.patchRequest(ApiEndpoints.resetPassword,model.toJson(),headers:await ApiClient.headers).timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
    final statusCode=response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==200){
      return _handleResponse(response, (data) => SimpleMessageResponseModel.fromJson(body));
    }else{
      final error=body['error']??body['message'];
      showSnackbar(context, error.toString(),color: redColor);
      throw error;
    }
  }
  static Future<SimpleMessageResponseModel> verifyPasswordRequest(ResetPasswordModel  model,BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.patchRequest(ApiEndpoints.verifyResetPasswordOtp,model.toJson(),headers:await ApiClient.headers).timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
    final statusCode=response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==200){
      return _handleResponse(response, (data) => SimpleMessageResponseModel.fromJson(body));
    }else{
      final error=body['error']??body['message'];
      showSnackbar(context, error.toString(),color: redColor);
      throw error;
    }
  }
  static Future<SimpleMessageResponseModel> setNewPassword(ResetPasswordModel  model,BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.patchRequest(ApiEndpoints.newPassword,model.toJson(),headers:await ApiClient.headers).timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
    final statusCode=response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==200){
      return _handleResponse(response, (data) => SimpleMessageResponseModel.fromJson(body));
    }else{
      final error=body['error']??body['message'];
      showSnackbar(context, error.toString(),color: redColor);
      throw error;
    }
  }

  static Future<void> setFcmToken(String fcmToken, BuildContext? context) async {
    try {
      bool isConnected = await checkInternetConnection();
      if (!isConnected) {
        customPrint('No internet connection. Skipping FCM token update.');
        return;
      }
      
      // Verify session token and userId exist before making the request
      final sessionToken = await getSessionTaken();
      final userId = await getUserId();
      
      if (sessionToken == null || sessionToken.isEmpty || sessionToken.trim().isEmpty) {
        customPrint('Cannot send FCM token: No valid session token found');
        return;
      }
      
      // Also verify userId exists - backend needs this to identify the user
      if (userId == null || userId.isEmpty || userId.trim().isEmpty) {
        customPrint('Cannot send FCM token: User ID not found. User may not be fully logged in.');
        return;
      }
      
      // Get headers with auth token
      final headers = await ApiClient.bearerHeader;
      customPrint('FCM Token Update - Auth Token in header: ${headers['token']?.substring(0, 20) ?? 'null'}...');
      customPrint('FCM Token Update - Authorization header: ${headers['Authorization']?.substring(0, 30) ?? 'null'}...');
      
      final body = {'fcmtoken': fcmToken};
      final response = await ApiClient.patchRequest(
        ApiEndpoints.setFcmToken,
        body,
        headers: headers,
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          customPrint('FCM token update timed out.');
          return http.Response('Timeout', 408);
        },
      );
      
      final responseBody = jsonDecode(response.body);
      customPrint("FCM Token Update Response: $responseBody");
      customPrint("FCM Token Update Status Code: ${response.statusCode}");
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        customPrint('FCM token updated successfully');
      } else if (response.statusCode == 400) {
        // 400 Bad Request - likely means token is invalid or user not found
        final error = responseBody['error'] ?? responseBody['message'] ?? 'Bad Request';
        customPrint('Failed to update FCM token: $error (Status: 400)');
        customPrint('This usually means the session token is invalid or expired.');
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        // Unauthorized/Forbidden - user needs to login again
        customPrint('FCM token update failed: User authentication expired (Status: ${response.statusCode})');
      } else {
        final error = responseBody['error'] ?? responseBody['message'] ?? 'Unknown error';
        customPrint('Failed to update FCM token: $error (Status: ${response.statusCode})');
        // Don't throw error - just log it, as this is not critical for login flow
      }
    } catch (e) {
      customPrint('Error updating FCM token: $e');
      // Don't throw error - just log it, as this is not critical for login flow
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