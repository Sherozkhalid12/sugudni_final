import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  void pickSellerImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
    await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      sellerProfilePic = File(pickedFile.path);
      notifyListeners();
    }
  }  void pickCustomerImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
    await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      customerProfilePic = File(pickedFile.path);
      notifyListeners();
    }
  }
}