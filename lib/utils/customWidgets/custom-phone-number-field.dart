// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/colors.dart';
import '../constants/fonts.dart';

class CustomPhoneNumberField extends StatelessWidget {
  String? hintText;
  TextEditingController? controller;
  bool? isFilled;
  Color? fillColor;
  String? fontFamily;
  Color? hintColor;
  FontWeight? fontWeight;
  double? hintTextSize;
  Widget? childWidget;
  String? Function(String?)? validator;
  String? Function(String?)? onChange;
  String? Function()? passwordFunction;
  double? borderRadius;
  bool? isBorder;
  Widget? suffixIcon;
  String? prefixIcon;
  bool? isErrorBorder;
  TextInputType? keyboardType;
  bool? isPassword;
  IconData? beforePasswordIcon;
  IconData? afterPasswordIcon;
  bool? isObscure;
  CustomPhoneNumberField(
      {super.key,
        this.hintText,
        this.controller,
        this.isFilled,
        this.fillColor,
        this.fontFamily,
        this.hintColor,
        this.hintTextSize,
        this.fontWeight,
        this.validator,
        this.isBorder,
        this.borderRadius,
        this.suffixIcon,
        this.prefixIcon,
        this.isErrorBorder,
        this.onChange,
        this.keyboardType,
        this.isPassword,
        this.passwordFunction,
        this.beforePasswordIcon,
        this.isObscure,
        this.afterPasswordIcon,
        this.childWidget
      });

  @override
  Widget build(BuildContext context) {

    return ClipRRect(
      borderRadius: BorderRadius.circular(13.r),
      child: TextFormField(
        controller: controller,
        validator: validator,
        onChanged: onChange,
        keyboardType: keyboardType,
        obscureText: isObscure ?? false,
        style: TextStyle(
            fontWeight: fontWeight??FontWeight.w500,
            fontSize:hintTextSize?? 14.sp,
            color: blackColor,height: 2.5
        ),
        decoration: InputDecoration(
          prefixIcon: childWidget,
          border:  InputBorder.none,
          filled: isFilled ?? true,
          fillColor: fillColor ??textFieldColor,
          //contentPadding: const EdgeInsets.only(left: 12),
          hintText: hintText,
          hintStyle: TextStyle(
            fontFamily: fontFamily ?? AppFonts.poppins,
            fontSize: hintTextSize ?? 14.sp,
            color: hintColor ?? primaryColor,
            fontWeight: fontWeight ?? FontWeight.w500,
          ),

          enabledBorder:  InputBorder.none,
          errorBorder: isErrorBorder == true
              ? OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(borderRadius??13.r))
              : InputBorder.none,
          // focusedBorder: OutlineInputBorder(
          //     borderSide: const BorderSide(color: primaryColor),
          //     borderRadius: BorderRadius.circular(borderRadius!)),
          // enabledBorder: OutlineInputBorder(
          //     borderSide:  BorderSide(color:isNotEmpty? primaryColor:Colors.grey),
          //     borderRadius: BorderRadius.circular(borderRadius!)),

        ),
      ),
    );
  }
}