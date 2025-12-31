import 'package:flutter/material.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';

extension AlertDialogExtension on BuildContext {
  void showConfirmationDialog({
    required String title,
    required VoidCallback onYes,
    required VoidCallback onNo,
  }) {
    showDialog(
      context: this,
      builder: (context) => AlertDialog(
        backgroundColor: whiteColor,

        title: MyText(text: title),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onNo();
            },
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
             // Navigator.pop(context);
              onYes();
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }
}

extension TextFieldDialogExtension on BuildContext {
  void showTextFieldDialog({
    required String title,
     String? confirmText,
     String? declineText,
    TextEditingController? controller,
    required VoidCallback onNo,
    required VoidCallback onYes,
    TextInputType? keyboardType,
  }) {
    showDialog(
      context: this,
      builder: (context) => AlertDialog(
        backgroundColor: whiteColor,
        title: MyText(text: title),
        content: TextField(
          keyboardType: keyboardType!,
          controller: controller,
          decoration: const InputDecoration(
            hintText: "Enter here",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onNo();
            },
            child:  Text(declineText??"No"),
          ),
          TextButton(
            onPressed: () {
            //  Navigator.pop(context);
              onYes();
            },
            child:  Text(confirmText??"Yes"),
          ),
        ],
      ),
    );
  }
}
