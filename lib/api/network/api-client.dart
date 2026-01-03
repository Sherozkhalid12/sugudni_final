import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/utils/global-functions.dart';

import '../../utils/sharePreference/save-user-token.dart';

class ApiClient {
  static const String baseUrl = ApiEndpoints.baseUrl;

  static Future<http.Response> getRequest(String endpoint,
      {Map<String, String>? headers}) async {
    customPrint("Enter in get request of Api client====================");

    final url = Uri.parse('$baseUrl/$endpoint');
    customPrint("URL of Api client====================$url");
    return _sendRequest(
        () async => http.get(url, headers: headers ?? await _headers));
  }

  static Future<http.Response> postRequest(String endpoint, dynamic body,
      {Map<String, String>? headers}) async {
    customPrint("Enter in post request of Api client====================");
    final url = Uri.parse('$baseUrl/$endpoint');
    customPrint("URL of Api client====================$url");
    customPrint("Sent Body of Api client====================$body");

    return _sendRequest(() async => http.post(url,
        body: jsonEncode(body), headers: headers ?? await _headers));
  }

  static Future<http.Response> putRequest(String endpoint, dynamic body,
      {Map<String, String>? headers}) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    customPrint("Url:================$baseUrl/$endpoint");

    return _sendRequest(() async => http.put(url,
        body: jsonEncode(body), headers: headers ?? await _headers));
  }

  static Future<http.Response> patchRequest(String endpoint, dynamic body,
      {Map<String, String>? headers}) async {
    customPrint("Enter in patch request of Api client====================");

    final url = Uri.parse('$baseUrl/$endpoint');
    customPrint("URL of patch client====================$url");
    customPrint("Sent Body of patch client====================$body");
    return _sendRequest(() async => http.patch(url,
        body: jsonEncode(body), headers: headers ?? await _headers));
  }

  static Future<http.Response> deleteRequest(String endpoint,
      {Map<String, String>? headers}) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    return _sendRequest(
        () async => http.delete(url, headers: headers ?? await _headers));
  }

  static Future<http.Response> deleteRequestWithBody(
      String endpoint, dynamic body,
      {Map<String, String>? headers}) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    return _sendRequest(() async => http.delete(url,
        body: jsonEncode(body), headers: headers ?? await _headers));
  }

  static Future<http.Response> _sendRequest(
      Future<http.Response> Function() requestFunc) async {
    try {
      customPrint(
          "Enter in send request of Api client ===============================");
      final response = await requestFunc().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException(
              'Request timed out after 30 seconds. Please try again.');
        },
      );
      customPrint(
          "response in send request of Api client====================${response.body}");
      customPrint(
          "Status code in send request of Api client====================${response.statusCode}");
      // customPrint("Status code====================${response.statusCode}");

      //  _handleResponse(response);
      return response;
    } on SocketException {
      throw Exception('No Internet Connection');
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, String>> get _headers async {
    final token = await getSessionTaken();
    if (token.isEmpty) {
      throw 'Token is empty';
    }
    customPrint("Token===============================$token");
    return {
      'Content-Type': 'application/json',
      'token': token,
    };
  }

  static Future<Map<String, String>> get headers async {
    return {
      'Content-Type': 'application/json',
    };
  }

  static Future<Map<String, String>> get bearerHeader async {
    final token = await getSessionTaken();
    customPrint("Token===============================$token");

    return {
      'token': token,
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }
}
//
// static void _handleResponse(http.Response response) {
// switch (response.statusCode) {
// case 200:
// case 201:
// break;
// case 400:
// throw BadRequestException(response.statusCode.toString());
// case 404:
// throw UnauthorizedException(response.statusCode.toString());
// default:
// throw FetchDataException('Error occurred while communicating with server ' +
// 'with status code' + response.statusCode.toString());
// }
// }
