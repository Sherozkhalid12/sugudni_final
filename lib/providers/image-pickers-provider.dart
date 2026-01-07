import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/utils/sharePreference/save-user-token.dart';
import 'package:sugudeni/l10n/app_localizations.dart';
import 'package:sugudeni/providers/loading-provider.dart';

class ImagePickerProviders extends ChangeNotifier{

  File? chequeImage;
  File? sellerProfilePic;
  File? customerProfilePic;

  void pickChequeImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
    await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      chequeImage = File(pickedFile.path);
      notifyListeners();
    }
  }
  Future<bool> pickSellerImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
    await picker.pickImage(source: source);
    if (pickedFile != null) {
      sellerProfilePic = File(pickedFile.path);
      notifyListeners();
      return true;
    }
    return false;
  }
  
  void pickCustomerImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
    await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      customerProfilePic = File(pickedFile.path);
      notifyListeners();
    }
  }

  Future<void> uploadSellerProfilePicture(BuildContext context) async {
    final loadingProvider = Provider.of<LoadingProvider>(context, listen: false);
    if (sellerProfilePic == null) {
      showSnackbar(context, AppLocalizations.of(context)!.pleasechooseimage, color: redColor);
      return;
    }

    try {
      final sellerId = await getUserId();
      loadingProvider.setLoading(true);
      var url = Uri.parse("${ApiEndpoints.baseUrl}/${ApiEndpoints.updateCustomerProfile}/$sellerId");

      var request = http.MultipartRequest('PATCH', url);
      final token = await getSessionTaken();

      customPrint("Uploading seller profile picture with token: $token");
      // Add headers
      request.headers.addAll({
        'token': token,
        'Authorization': 'Bearer $token'
      });

      // Attach files
      request.files.add(await http.MultipartFile.fromPath(
        'profilePic', sellerProfilePic!.path,
        contentType: MediaType('image', 'jpeg'),
      ));

      // Send request
      http.StreamedResponse response = await request.send();
      customPrint("Profile upload status code: ${response.statusCode}");
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = await response.stream.bytesToString();
        final body = jsonDecode(responseBody);
        customPrint("Profile upload response: $body");

        loadingProvider.setLoading(false);
        if (context.mounted) {
          // Clear local file after successful upload so API pic shows
          sellerProfilePic = null;
          notifyListeners();
          showSnackbar(context, 'Profile picture updated successfully', color: greenColor);
        }
      } else {
        final responseBody = await response.stream.bytesToString();
        final body = jsonDecode(responseBody);
        customPrint("Upload error: $body");
        
        loadingProvider.setLoading(false);
        if (context.mounted) {
          showSnackbar(context, body['message'] ?? 'Upload failed', color: redColor);
        }
      }
    } catch (e) {
      loadingProvider.setLoading(false);
      if (context.mounted) {
        showSnackbar(context, e.toString(), color: redColor);
      }
    }
  }
}