import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/models/category/NameModel.dart';
import 'package:sugudeni/providers/loading-provider.dart';
import 'package:sugudeni/repositories/category/category-repository.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:http/http.dart' as http;
import 'package:sugudeni/utils/sharePreference/save-user-token.dart';
import '../../l10n/app_localizations.dart';

class CategoryProvider extends ChangeNotifier{

  File? categoryPicture;
  final nameController=TextEditingController();
  final subcategoryNameController=TextEditingController();
  final slugController=TextEditingController();
  String query='';
  String subQuery='';
  changeQuery(String v){
    query=v;
    notifyListeners();
  }
  changeSubQuery(String v){
    subQuery=v;
    notifyListeners();
  }
  clearQuery(){
    nameController.clear();
    query='';
  } clearSubQuery(){
    subcategoryNameController.clear();
    query='';
  }
  setCategoryName(String n){
    nameController.text=n;
  }
  void pickCategoryImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
    await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      categoryPicture = File(pickedFile.path);
      notifyListeners();
    }
  }

  Future<void> addCategory(BuildContext context) async {
    final loadingProvider = Provider.of<LoadingProvider>(context, listen: false);

    if (nameController.text.isEmpty) {
      showSnackbar(context, AppLocalizations.of(context)!.categorynamerequired, color: redColor);
      return;
    }
    if (categoryPicture==null) {
      showSnackbar(context, AppLocalizations.of(context)!.categoryimagerequired, color: redColor);
      return;
    }

    try {
      loadingProvider.setLoading(true);

      var url = Uri.parse("${ApiEndpoints.baseUrl}/${ApiEndpoints.categories}");

      var request = http.MultipartRequest('POST', url);
      final token = await getSessionTaken();
      customPrint("token======$token");
      // Add headers
      request.headers.addAll({
        'token': token,
        'Authorization': 'Bearer $token'
      });

      // Add text fields
      request.fields.addAll({
        'name': nameController.text.trim(),
       // 'slug':  slugController.text.trim(),
      });

      // Attach files
      request.files.add(await http.MultipartFile.fromPath(
        'Image', categoryPicture!.path,
        contentType: MediaType('image', 'jpeg'), // Explicit content type
      ));


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
          clearResources();
          showSnackbar(context, AppLocalizations.of(context)!.newcategoryhasbeenadded, color: greenColor);
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
  Future<void>getAllCategory(BuildContext context)async{
    final loadingProvider=Provider.of<LoadingProvider>(context,listen: false);

    try{
      loadingProvider.setLoading(true);

      await CategoryRepository.allCategory(context).then((v){

        String message=v.message!;
        loadingProvider.setLoading(false);
        if(context.mounted){
          showSnackbar(context, message,color: greenColor);
        }
      }).onError((err,e){
        loadingProvider.setLoading(false);
        if(context.mounted){
          //showSnackbar(context, err.toString(),color: redColor);
        }
      });
    }catch(e){
      if(context.mounted){
        loadingProvider.setLoading(false);
        showSnackbar(context, e.toString(),color: redColor);
      }
    }
  }
  Future<void>deleteCategory(String categoryId,BuildContext context)async{
    final loadingProvider=Provider.of<LoadingProvider>(context,listen: false);

    try{
      loadingProvider.setLoading(true);

      await CategoryRepository.deleteCategory(categoryId,context).then((v){

        loadingProvider.setLoading(false);
        if(context.mounted){
          showSnackbar(context, AppLocalizations.of(context)!.successfullydeletedcategory,color: greenColor);
          Navigator.pop(context);
        }
      }).onError((err,e){
        loadingProvider.setLoading(false);
        if(context.mounted){
          //showSnackbar(context, err.toString(),color: redColor);
        }
      });
    }catch(e){
      if(context.mounted){
        loadingProvider.setLoading(false);
        showSnackbar(context, e.toString(),color: redColor);
      }
    }
  }
  Future<void>deleteSubCategory(String categoryId,String subCategoryId,BuildContext context)async{
    final loadingProvider=Provider.of<LoadingProvider>(context,listen: false);

    try{
      loadingProvider.setLoading(true);

      await CategoryRepository.deleteSubCategory(categoryId,subCategoryId,context).then((v){

        loadingProvider.setLoading(false);
        if(context.mounted){
          showSnackbar(context, AppLocalizations.of(context)!.sucssfullydeletedsubcategory,color: greenColor);
          Navigator.pop(context);
        }
      }).onError((err,e){
        loadingProvider.setLoading(false);
        if(context.mounted){
          //showSnackbar(context, err.toString(),color: redColor);
        }
      });
    }catch(e){
      if(context.mounted){
        loadingProvider.setLoading(false);
        showSnackbar(context, e.toString(),color: redColor);
      }
    }
  }
  Future<void>updateCategory(String categoryId,BuildContext context)async{
    final loadingProvider=Provider.of<LoadingProvider>(context,listen: false);
    if(nameController.text.isEmpty){
      showSnackbar(context, AppLocalizations.of(context)!.categorynamerequired,color: redColor);

      return;
    }
    try{
      loadingProvider.setLoading(true);
      var model=NameModel(name: nameController.text.toString().trim());
      await CategoryRepository.updateCategory(model,categoryId,context).then((v){

        loadingProvider.setLoading(false);
        if(context.mounted){
          showSnackbar(context, AppLocalizations.of(context)!.categoryupdated,color: greenColor);
          Navigator.pop(context);
        }
      }).onError((err,e){
        loadingProvider.setLoading(false);
        if(context.mounted){
          //showSnackbar(context, err.toString(),color: redColor);
        }
      });
    }catch(e){
      if(context.mounted){
        loadingProvider.setLoading(false);
        showSnackbar(context, e.toString(),color: redColor);
      }
    }
  }
  Future<void>updateSubCategory(String categoryId,String subCategoryId,BuildContext context)async{
    final loadingProvider=Provider.of<LoadingProvider>(context,listen: false);
    if(nameController.text.isEmpty){
      showSnackbar(context, AppLocalizations.of(context)!.subcategorynamerequired,color: redColor);

      return;
    }
    try{
      loadingProvider.setLoading(true);
      var model=NameModel(name: nameController.text.toString().trim());
      await CategoryRepository.updateSubCategory(model,categoryId,subCategoryId,context).then((v){

        loadingProvider.setLoading(false);
        if(context.mounted){
          showSnackbar(context,AppLocalizations.of(context)!.subcategoryupdated ,color: greenColor);
          Navigator.pop(context);
        }
      }).onError((err,e){
        loadingProvider.setLoading(false);
        if(context.mounted){
          //showSnackbar(context, err.toString(),color: redColor);
        }
      });
    }catch(e){
      if(context.mounted){
        loadingProvider.setLoading(false);
        showSnackbar(context, e.toString(),color: redColor);
      }
    }
  }
  Future<void>addSubCategory(String categoryId,BuildContext context)async{
    final loadingProvider=Provider.of<LoadingProvider>(context,listen: false);
    if(subcategoryNameController.text.isEmpty){
      showSnackbar(context, AppLocalizations.of(context)!.subcategorynamerequired,color: redColor);

      return;
    }
    var model=NameModel(name: subcategoryNameController.text.toString().trim());
    try{
      loadingProvider.setLoading(true);

      await CategoryRepository.addSubCategory(model,categoryId,context).then((v){

        loadingProvider.setLoading(false);
        if(context.mounted){
          subcategoryNameController.clear();
          // Close only the dialog, not the entire screen
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
          showSnackbar(context, AppLocalizations.of(context)!.subcategorycreatedsuccessfully,color: greenColor);
        }
      }).onError((err,e){
        loadingProvider.setLoading(false);
        if(context.mounted){
          //showSnackbar(context, err.toString(),color: redColor);
        }
      });
    }catch(e){
      if(context.mounted){
        loadingProvider.setLoading(false);
        showSnackbar(context, e.toString(),color: redColor);
      }
    }
  }

  clearResources(){
    nameController.clear();
    slugController.clear();
    categoryPicture=null;
    notifyListeners();

  }
}