import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SellerChatAddDocProvider extends ChangeNotifier{
  bool _isOpenDoc=false;
  bool get isOpenDoc=>_isOpenDoc;
  File? image;

  void pickImage(ImageSource source)async{
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
    await picker.pickImage(source: source);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      _isOpenDoc=false;
      notifyListeners();
    }
  }
  toggle(){
    _isOpenDoc=!_isOpenDoc;
    notifyListeners();
  }
  reset(){
    image=null;
    notifyListeners();
  }
}