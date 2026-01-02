import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/api/network/api-client.dart';
import 'package:sugudeni/models/auth/SignInModel.dart';
import 'package:sugudeni/models/auth/SignInResponseModel.dart';
import 'package:sugudeni/models/driver/GetDriverDataResponse.dart';
import 'package:sugudeni/providers/loading-provider.dart';
import 'package:sugudeni/repositories/auth/auth-repository.dart';
import 'package:sugudeni/repositories/auth/driver-auth-repository.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';

import '../../../api/api-endpoints.dart';
import '../../../utils/global-functions.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../l10n/app_localizations.dart';

import '../../utils/sharePreference/save-user-token.dart';
class DriverSignUpProvider extends ChangeNotifier{
  String drivingText='Select Date';
  String dateOfBirth='Date of Birth';

  File? frontImage;
  File? backImage;

  bool term=false;
  bool isUpdate=false;
  bool _isPickingImage = false;

  final firstNameController=TextEditingController();
  final lastNameController=TextEditingController();
  final phoneNumberController=TextEditingController();
  final licenseNumberController=TextEditingController();
  final bikeRegistrationNumberController=TextEditingController();
  final otpController=TextEditingController();
  Future<void> updateDriver(BuildContext context) async {
    final loadingProvider = Provider.of<LoadingProvider>(context, listen: false);

    // Check if at least one field has been changed
    bool hasChanges = false;
    
    // Check text fields
    if (firstNameController.text.isNotEmpty ||
        lastNameController.text.isNotEmpty ||
        phoneNumberController.text.isNotEmpty ||
        licenseNumberController.text.isNotEmpty ||
        bikeRegistrationNumberController.text.isNotEmpty ||
        (drivingText != 'Select Date' && drivingText.isNotEmpty) ||
        (dateOfBirth != 'Date of Birth' && dateOfBirth.isNotEmpty)) {
      hasChanges = true;
    }
    
    // Check images
    if (frontImage != null || backImage != null) {
      hasChanges = true;
    }
    
    // If no changes, show message
    if (!hasChanges) {
      showSnackbar(context, 'Please update at least one field', color: redColor);
      return;
    }

    try {
      loadingProvider.setLoading(true);

      var url = Uri.parse("${ApiEndpoints.baseUrl}/${ApiEndpoints.updateDriver}");

      var request = http.MultipartRequest('PATCH', url);
      final token = await getSessionTaken();
      customPrint("token======$token");
      // Add headers
      request.headers.addAll({
        'token': token,
        'Authorization': 'Bearer $token'
      });

      // Add text fields only if they are not empty
      if (firstNameController.text.isNotEmpty) {
        request.fields['firstname'] = firstNameController.text.trim();
      }
      if (lastNameController.text.isNotEmpty) {
        request.fields['lastname'] = lastNameController.text.trim();
      }
      if (phoneNumberController.text.isNotEmpty) {
        request.fields['phone'] = phoneNumberController.text.trim();
      }
      if (licenseNumberController.text.isNotEmpty) {
        request.fields['licenseNumber'] = licenseNumberController.text.trim();
      }
      if (bikeRegistrationNumberController.text.isNotEmpty) {
        request.fields['bikeRegistrationNumber'] = bikeRegistrationNumberController.text.trim();
      }
      if (drivingText != 'Select Date' && drivingText.isNotEmpty) {
        request.fields['drivingSince'] = drivingText;
      }
      if (dateOfBirth != 'Date of Birth' && dateOfBirth.isNotEmpty) {
        request.fields['dob'] = dateOfBirth;
      }

      // Attach files only if they exist
      if (frontImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'licenseFront', frontImage!.path,
        contentType: MediaType('image', 'jpeg'), // Explicit content type
      ));
      }
      if (backImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'licenseBack', backImage!.path,
        contentType: MediaType('image', 'jpeg'), // Explicit content type
      ));
      }

      // Send request
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200 ||response.statusCode == 201) {
        final responseBody = await response.stream.bytesToString();
        final body = jsonDecode(responseBody);
        customPrint("Response: $body");

        loadingProvider.setLoading(false);
        if (context.mounted) {
           Navigator.pushNamedAndRemoveUntil(context, RoutesNames.driverHomeView,(route) => false);
                  clearResources();
          showSnackbar(context, AppLocalizations.of(context)!.informationsuccessfullyupdated, color: greenColor);
        }
      } else {
        loadingProvider.setLoading(false);
        if (context.mounted) {
          showSnackbar(context, "Error: ${response.statusCode}", color: redColor);
        }
      }
    } catch (e) {
      loadingProvider.setLoading(false);
      if (context.mounted) {
        showSnackbar(context, e.toString(), color: redColor);
      }
    }
  }

  clearResources(){
    firstNameController.clear();
    lastNameController.clear();
    phoneNumberController.clear();
    licenseNumberController.clear();
    bikeRegistrationNumberController.clear();
    otpController.clear();
    frontImage=null;
    backImage=null;
    isUpdate=false;
     drivingText='Select Date';
     dateOfBirth='Date of Birth';

  }

  Future<void> pickFrontImage(BuildContext? context) async {
    if (_isPickingImage) {
      customPrint('Image picker is already open');
      if (context != null && context.mounted) {
        showSnackbar(context, 'Image picker is already open. Please wait...', color: redColor);
      }
      return;
    }
    
    _isPickingImage = true;
    
    try {
      final ImagePicker imagePicker = ImagePicker();
      
      // Use a shorter timeout - 15 seconds should be enough
      final XFile? pickedFile = await imagePicker
          .pickImage(
            source: ImageSource.gallery,
            imageQuality: 85,
          )
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              customPrint('Image picker timed out after 15 seconds');
              return null;
            },
          );
      
      if (pickedFile != null) {
        frontImage = File(pickedFile.path);
        notifyListeners();
        customPrint('Front image picked successfully: ${pickedFile.path}');
      } else {
        customPrint('No image was selected or picker was cancelled');
      }
    } on TimeoutException catch (e) {
      customPrint('TimeoutException: $e');
      if (context != null && context.mounted) {
        showSnackbar(
          context,
          'Image picker timed out. Please try again.',
          color: redColor,
        );
      }
    } catch (e, stackTrace) {
      customPrint('Error picking front image: $e');
      customPrint('Stack trace: $stackTrace');
      if (context != null && context.mounted) {
        showSnackbar(
          context,
          'Failed to pick image. Please try again.',
          color: redColor,
        );
      }
    } finally {
      _isPickingImage = false;
      customPrint('Image picking process finished - flag reset');
    }
  }

  Future<void> pickBackImage(BuildContext? context) async {
    if (_isPickingImage) {
      customPrint('Image picker is already open');
      if (context != null && context.mounted) {
        showSnackbar(context, 'Image picker is already open. Please wait...', color: redColor);
      }
      return;
    }
    
    _isPickingImage = true;
    
    try {
      final ImagePicker imagePicker = ImagePicker();
      
      // Use a shorter timeout - 15 seconds should be enough
      final XFile? pickedFile = await imagePicker
          .pickImage(
            source: ImageSource.gallery,
            imageQuality: 85,
          )
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              customPrint('Image picker timed out after 15 seconds');
              return null;
            },
          );
      
      if (pickedFile != null) {
        backImage = File(pickedFile.path);
        notifyListeners();
        customPrint('Back image picked successfully: ${pickedFile.path}');
      } else {
        customPrint('No image was selected');
      }
    } on TimeoutException catch (e) {
      customPrint('TimeoutException: $e');
      if (context != null && context.mounted) {
        showSnackbar(
          context,
          'Image picker timed out. Please try again.',
          color: redColor,
        );
      }
    } catch (e, stackTrace) {
      customPrint('Error picking back image: $e');
      customPrint('Stack trace: $stackTrace');
      if (context != null && context.mounted) {
        showSnackbar(
          context,
          'Failed to pick image. Please try again.',
          color: redColor,
        );
      }
    } finally {
      _isPickingImage = false;
      customPrint('Image picking process finished');
    }
  }

  changeDrivingDate(DateTime date){
    drivingText=changeDateFormat(date);
    notifyListeners();
  }
  changeDOB(DateTime date){
    dateOfBirth=changeDateFormat(date);
    notifyListeners();
  }

  toggleTerm(){
    term=!term;
    notifyListeners();
  }
  Future<void> downloadAndSaveFrontImage(String imageUrl) async {
    try {
      // Fetch image from URL
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        // Get the temporary directory
        Directory tempDir = await getTemporaryDirectory();
        String filePath = '${tempDir.path}/downloaded_image.jpg';

        // Write image bytes to file
        File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        // Assign to frontImage
        frontImage = file;
        customPrint('Image saved at: $filePath');
      } else {
        customPrint('Failed to download image: ${response.statusCode}');
      }
    } catch (e) {
      customPrint('Error downloading image: $e');
    }
  }
  Future<void> downloadAndSaveBackImage(String imageUrl) async {
    try {
      // Fetch image from URL
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        // Get the temporary directory
        Directory tempDir = await getTemporaryDirectory();
        String filePath = '${tempDir.path}/downloaded_image.jpg';

        // Write image bytes to file
        File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        // Assign to frontImage
        backImage = file;
        customPrint('Image saved at: $filePath');
      } else {
        customPrint('Failed to download image: ${response.statusCode}');
      }
    } catch (e) {
      customPrint('Error downloading image: $e');
    }
  }
  Future<void>setValues(DriverUser drive)async{
    await downloadAndSaveFrontImage("${ApiEndpoints.productUrl}/${drive.licenseFront}");
    await downloadAndSaveBackImage("${ApiEndpoints.productUrl}/${drive.licenseBack}");
    isUpdate=true;
    firstNameController.text=drive.firstname;
    lastNameController.text=drive.lastname;
    phoneNumberController.text=drive.phone;
    licenseNumberController.text=drive.licenseNumber;
    bikeRegistrationNumberController.text=drive.bikeRegistrationNumber;
    drivingText=drive.drivingSince==null? '':dateFormat(drive.drivingSince!);
    dateOfBirth=drive.dob==null? '':dateFormat(drive.dob!);
  }

}