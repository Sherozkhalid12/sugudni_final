import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/api/network/api-client.dart';
import 'package:sugudeni/models/activity/ActivityResponseModel.dart';
import 'package:sugudeni/utils/global-functions.dart';

class ActivityRepository {
  static Future<ActivityResponseModel> getAllActivities(
      BuildContext context) async {
    try {
      bool isConnected = await checkInternetConnection();
      if (!isConnected) {
        // Return empty activities instead of throwing
        return ActivityResponseModel(activities: []);
      }

      final response = await ApiClient.getRequest(
        ApiEndpoints.activity,
        headers: await ApiClient.bearerHeader,
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('Request timed out. Please try again.');
        },
      );

      final body = jsonDecode(response.body);
      final statusCode = response.statusCode;

      customPrint("Activity API Status code:================$statusCode");
      customPrint("Activity API Body:================$body");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return _handleResponse(
            response, (data) => ActivityResponseModel.fromJson(body));
      } else {
        // Handle error gracefully - return empty list instead of throwing
        customPrint("Activity API Error: ${body['error'] ?? 'Unknown error'}");
        return ActivityResponseModel(activities: []);
      }
    } on TimeoutException {
      // Return empty activities on timeout
      customPrint("Activity API: Request timed out");
      return ActivityResponseModel(activities: []);
    } on SocketException {
      // Return empty activities on network error
      customPrint("Activity API: No internet connection");
      return ActivityResponseModel(activities: []);
    } catch (e) {
      // Handle any other exceptions gracefully
      customPrint("Activity API Exception: $e");
      return ActivityResponseModel(activities: []);
    }
  }

  static T _handleResponse<T>(
      http.Response response, T Function(dynamic data) onSuccess) {
    final statusCode = response.statusCode;
    final body = json.decode(response.body);

    switch (statusCode) {
      case 200:
      case 201:
        return onSuccess(body);
      default:
        return onSuccess({'activities': []});
    }
  }
}

