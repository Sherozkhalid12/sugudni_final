import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/models/user/SellerDataResponseModel.dart';
import 'package:sugudeni/repositories/user-repository.dart';

import '../../api/api-endpoints.dart';
import '../../models/user/UpdateCustomerModel.dart';
import '../../utils/constants/colors.dart';
import '../../utils/global-functions.dart';
import '../../utils/sharePreference/save-user-token.dart';
import '../loading-provider.dart';
import '../../l10n/app_localizations.dart';

class UserProfileProvider extends ChangeNotifier{
  File? customerProfilePic;
  bool isChangePicture=false;
  bool isLoading=true;
  String errorText = '';
SellerDataResponse? sellerData;
String profilePicture='';
final nameController=TextEditingController();
final emailController=TextEditingController();
final phoneController=TextEditingController();
  void pickCustomerImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
    await picker.pickImage(source: source);
    if (pickedFile != null) {
      isChangePicture=true;
      customerProfilePic = File(pickedFile.path);
      notifyListeners();
    }
  }
  void fetchUserData(BuildContext context) async {
    if (isLoading) return;

    isLoading = true;
    errorText = '';

    try {
      var response = await UserRepository.getSellerData(context);
   SellerDataResponse data = response;
      nameController.text=data.user!.name;
      emailController.text=data.user!.email;
      phoneController.text=data.user!.phone;
      profilePicture=data.user!.profilePic;

      notifyListeners();
    } catch (e) {  isLoading = false;
      errorText = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addProfilePicture(BuildContext context) async {
    final loadingProvider = Provider.of<LoadingProvider>(context, listen: false);
    if (customerProfilePic==null) {
      showSnackbar(context, AppLocalizations.of(context)!.pleasechooseimage, color: redColor);
      return;
    }



    try {
      final customerId = await getUserId();
      loadingProvider.setLoading(true);
      var url = Uri.parse("${ApiEndpoints.baseUrl}/${ApiEndpoints.updateCustomerProfile}/$customerId");

      var request = http.MultipartRequest('PATCH', url);
      final token = await getSessionTaken();

      customPrint("token======$token");
      // Add headers
      request.headers.addAll({
        'token': token,
        'Authorization': 'Bearer $token'
      });

      // Attach files
      request.files.add(await http.MultipartFile.fromPath(
        'profilePic',customerProfilePic!.path,
        contentType: MediaType('image', 'jpeg'), // Explicit content type
      ));



      // Send request
      http.StreamedResponse response = await request.send();
      customPrint("Status code ==============${response.statusCode}");
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final body = jsonDecode(responseBody);
        customPrint("Response: $body");

        loadingProvider.setLoading(false);
        if (context.mounted) {
          showSnackbar(context,body['message'], color: redColor);
        }
      }
      else if (response.statusCode == 201) {
        final responseBody = await response.stream.bytesToString();
        final body = jsonDecode(responseBody);
        customPrint("Response: $body");

        loadingProvider.setLoading(false);
        if (context.mounted) {
          // Clear local file after successful upload so API pic shows
          customerProfilePic = null;
          isChangePicture = false;
          notifyListeners();
          showSnackbar(context, AppLocalizations.of(context)!.successfullyaddedprofile, color: greenColor);
        }
      } else if (response.statusCode == 500) {
        final responseBody = await response.stream.bytesToString();
        final body = jsonDecode(responseBody);
        customPrint("Response: $body");

        loadingProvider.setLoading(false);
        if (context.mounted) {
          showSnackbar(context,body['error'], color: redColor);
        }
      }

      else {
        loadingProvider.setLoading(false);
        if (context.mounted) {
          showSnackbar(context, "Error: ${response.reasonPhrase}", color: redColor);
        }
      }
    } catch (e) {
      loadingProvider.setLoading(false);
      if (context.mounted) {
        showSnackbar(context, e.toString(), color: redColor);
      }
    }
  }
  Future<void>updateCustomerData(UpdateCustomerModel model,BuildContext context)async{
    final loadingProvider = Provider.of<LoadingProvider>(context, listen: false);
    try{
      loadingProvider.setLoading(true);
      UserRepository.updateCustomerSetting(model, context).then((v){
        showSnackbar(context, AppLocalizations.of(context)!.yourinformationhasbeenupdated,color: greenColor);
        loadingProvider.setLoading(false);
      });
    }catch(e){
      loadingProvider.setLoading(false);
    }
  }
  clearResources(){
    customerProfilePic=null;
    isChangePicture=false;
  }
}