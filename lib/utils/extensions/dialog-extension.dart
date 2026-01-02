import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';

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
    String? hintText,
  }) {
    showDialog(
      context: this,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      useSafeArea: true,
      builder: (context) => PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) {
          // Prevent parent PopScope from intercepting
        },
        child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        elevation: 8,
        child: Container(
          padding: EdgeInsets.all(24.sp),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              MyText(
                text: title,
                size: 18.sp,
                fontWeight: FontWeight.w700,
                color: textPrimaryColor,
              ),
              20.height,
              // Text Field
              TextField(
                keyboardType: keyboardType ?? TextInputType.text,
                controller: controller,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: hintText ?? "Enter here",
                  hintStyle: TextStyle(
                    fontSize: 14.sp,
                    color: textPrimaryColor.withOpacity(0.4),
                    fontWeight: FontWeight.w400,
                  ),
                  filled: true,
                  fillColor: textFieldColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: borderColor, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: borderColor, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: primaryColor, width: 2),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                ),
                style: TextStyle(
                  fontSize: 15.sp,
                  color: textPrimaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              24.height,
              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onNo();
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: MyText(
                      text: declineText ?? "Cancel",
                      size: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: textPrimaryColor,
                    ),
                  ),
                  12.width,
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [gradientColorThree, gradientColorTwo, gradientColorOne],
                      ),
                      borderRadius: BorderRadius.circular(8.r),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onYes();
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: MyText(
                        text: confirmText ?? "Confirm",
                        size: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: whiteColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}
