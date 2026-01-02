import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sugudeni/api/network/api-client.dart';
import 'package:sugudeni/models/driver/DriverToggleResponse.dart';
import 'package:sugudeni/models/driver/DriverUpdateResponseModel.dart';
import 'package:sugudeni/utils/global-functions.dart';

import '../../api/api-endpoints.dart';
import '../../utils/constants/colors.dart';
import '../../utils/sharePreference/save-user-token.dart';
import '../../utils/sharePreference/isDriver-online.dart';
import '../user-repository.dart';
class DriverAuthRepository{


  static Future<DriverUpdateResponseModel> updateDriver(dynamic b,BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    if(!isConnected){
      throw 'Please check your internet and try again.';
    }
    final response = await ApiClient.patchRequest(ApiEndpoints.updateDriver, b).timeout(const Duration(seconds: 30),onTimeout: (){
      throw 'Request timed out. Please try again.';
    });
    final body=jsonDecode(response.body);
    final statusCode=response.statusCode;
    customPrint("Body type:================${body.runtimeType}");
    customPrint("Status code:================$statusCode");
    if(response.statusCode==200||response.statusCode==201){
      return _handleResponse(response, (data) => DriverUpdateResponseModel.fromJson(body));
    }else{
      final error=body['error'];
      showSnackbar(context, error.toString(),color: redColor);
      throw error;
    }
  }
  static Future<DriverToggleResponse> toggleDriver(BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    if(!isConnected){
      if (context.mounted) {
        showSnackbar(context, 'Please check your internet connection and try again.', color: redColor);
      }
      throw 'Please check your internet connection and try again.';
    }
    try {
      final response = await ApiClient.patchRequest(ApiEndpoints.toggleDriver,{}).timeout(const Duration(seconds: 30),onTimeout: (){
        if (context.mounted) {
          showSnackbar(context, 'Request timed out. Please try again.', color: redColor);
        }
        throw 'Request timed out. Please try again.';
      });
      final body=jsonDecode(response.body);
      final statusCode=response.statusCode;
      customPrint("Body type:================${body.runtimeType}");
      customPrint("Status code:================$statusCode");
      
      if(response.statusCode==201){
        // Clear pending approval status on successful toggle
        await clearDriverApprovalStatus();
        return _handleResponse(response, (data) => DriverToggleResponse.fromJson(body));
      } else if(response.statusCode==404){
        // Handle driver not approved error
        final error = body['error'] ?? 'You are not approved to go online';
        String userFriendlyMessage;
        if (error.toString().toLowerCase().contains('not approved') || 
            error.toString().toLowerCase().contains('approval')) {
          userFriendlyMessage = 'Your driver account is pending approval. Please wait for admin approval before going online.';
          // Store approval status
          await setDriverApprovalStatus(true);
        } else {
          userFriendlyMessage = error.toString();
        }
        // Show snackbar immediately with proper context check
        customPrint("Showing snackbar for driver approval error: $userFriendlyMessage");
        if (context.mounted) {
          // Use SchedulerBinding to ensure it runs after the current frame
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              try {
                final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
                if (scaffoldMessenger != null) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text(userFriendlyMessage),
                      duration: const Duration(seconds: 4),
                      backgroundColor: redColor,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  customPrint("Snackbar shown successfully in repository");
                } else {
                  // Fallback to showSnackbar function
                  showSnackbar(context, userFriendlyMessage, color: redColor, duration: const Duration(seconds: 4));
                  customPrint("Snackbar shown using fallback function");
                }
              } catch (e) {
                customPrint("Error showing snackbar: $e");
                // Last resort - try showSnackbar directly
                try {
                  showSnackbar(context, userFriendlyMessage, color: redColor, duration: const Duration(seconds: 4));
                } catch (e2) {
                  customPrint("Final snackbar attempt failed: $e2");
                }
              }
            }
          });
        }
        throw userFriendlyMessage;
      } else {
        // Handle other errors
        final error = body['error'] ?? 'Failed to update driver status. Please try again.';
        String userFriendlyMessage = error.toString();
        // Show snackbar - use Future.microtask to ensure it displays
        if (context.mounted) {
          Future.microtask(() {
            if (context.mounted) {
              showSnackbar(context, userFriendlyMessage, color: redColor);
            }
          });
        }
        throw userFriendlyMessage;
      }
    } catch (e) {
      // If error wasn't already shown, show it now
      String errorMessage = e.toString().replaceAll('Exception: ', '');
      if (context.mounted) {
        // Check if this is a known error that should have been shown already
        bool alreadyShown = errorMessage.contains('Request timed out') || 
                           errorMessage.contains('internet') ||
                           errorMessage.contains('pending approval') ||
                           errorMessage.contains('not approved') ||
                           errorMessage.contains('Failed to update driver status');
        
        if (!alreadyShown) {
          Future.microtask(() {
            if (context.mounted) {
              showSnackbar(context, errorMessage, color: redColor);
            }
          });
        }
      }
      rethrow;
    }
  }


  static Future<DriverUpdateResponseModel> updateDriverMultiParts(
      Map<String, String> fields,
      File? licenseFront,
      File? licenseBack,
      BuildContext context) async {

    bool isConnected = await checkInternetConnection();
    if (!isConnected) {
      throw 'Please check your internet and try again.';
    }

    try {
      var url = Uri.parse('${ApiEndpoints.baseUrl}/${ApiEndpoints.updateDriver}');
      var request = http.MultipartRequest("PATCH", url);

      // Add form fields
      fields.forEach((key, value) {
        request.fields[key] = value;
      });

      // Attach images (if available)
      if (licenseFront != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'licenseFront', licenseFront.path,
        ));
      }

      if (licenseBack != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'licenseBack', licenseBack.path,
        ));
      }

      final token = await getSessionTaken();
      // Add headers (optional, if required by API)
      request.headers.addAll({
        'token': token, // If needed
        'Content-Type': 'application/json',       // 'Content-Type': 'multipart/form-data',
      });

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = jsonDecode(response.body);
        return DriverUpdateResponseModel.fromJson(body);
      } else {
        final error = jsonDecode(response.body)['error'];
        showSnackbar(context, error.toString(), color: redColor);
        throw error;
      }
    } catch (e) {
      showSnackbar(context, e.toString(), color: redColor);
      throw e;
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