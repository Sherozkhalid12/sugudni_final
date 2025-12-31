
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/extensions/media-query.dart';

import '../constants/colors.dart';
import '../constants/fonts.dart';

class CustomTextFiled extends StatelessWidget {
 final String? hintText;
 final TextEditingController? controller;
 final bool? isFilled;
 final Color? fillColor;
 final String? fontFamily;
 final Color? hintColor;
 final Color? prefixImageColor;
 final  FontWeight? fontWeight;
 final double? hintTextSize;
 final  String? Function(String?)? validator;
 final String? Function(String?)? onChange;
 final String? Function(String?)? onSubmit;
 final String? Function()? passwordFunction;
 final  double? borderRadius;
 final bool? isBorder;
 final bool? isFocusBorder;
 final  IconData? suffixIcon;
 final IconData? prefixIcon;
 final  bool? isErrorBorder;
 final TextInputType? keyboardType;
 final bool? isPassword;
 final  IconData? beforePasswordIcon;
 final IconData? afterPasswordIcon;
 final bool? isObscure;
 final bool? isShowPrefixIcon;
 final bool? isShowPrefixImage;
 final bool? isEnable;
 final String? prefixImgUrl;
 final TextAlign? textAlign;
 final int? maxLine;
 final List<TextInputFormatter>? inputFormatters; // New parame
  const CustomTextFiled(
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
        this.isShowPrefixIcon,
        this.isFocusBorder,
        this.isShowPrefixImage=false,
        this.prefixImgUrl,
        this.textAlign,
        this.inputFormatters,
        this.prefixImageColor,
        this.maxLine,
        this.onSubmit, this.isEnable
      });

  @override
  Widget build(BuildContext context) {
    final screenHeight =context.screenHeight;
    return TextFormField(
      textAlign: textAlign??TextAlign.start,
      enabled: isEnable??true,
      style:  TextStyle(
        fontFamily: fontFamily ?? AppFonts.poppins,
        fontSize: hintTextSize ?? 12.sp,
        color: hintColor ?? Colors.black,
        fontWeight: fontWeight ?? FontWeight.w500,
      ),
      controller: controller,
      validator: validator,
      onChanged: onChange,
      onFieldSubmitted: onSubmit,
      keyboardType: keyboardType,
      obscureText: isObscure ?? false,
      maxLines: maxLine??1,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        suffixIcon: isPassword == true
            ? IconButton(
            onPressed: passwordFunction,
            icon: Image.asset(isObscure == true
                ? AppAssets.passwordEyeIcon
                : AppAssets.passwordEyeIcon,scale: 2.5,))
            : null,
        prefixIcon:isShowPrefixIcon==false? null:
        isShowPrefixImage==true? Image.asset(prefixImgUrl!,
          scale: 2.2.sp,
          height: 12.h,
          width: 12.w,
          color: prefixImageColor??primaryColor,


        ):
        Icon(prefixIcon,color: blackColor,),
        filled: isFilled ?? true,
        fillColor: fillColor ??textFieldColor,
        //contentPadding: const EdgeInsets.only(left: 12),
        hintText: hintText,
        hintStyle: TextStyle(

          fontFamily: fontFamily ?? AppFonts.poppins,
          fontSize: hintTextSize ?? 12.sp,
          color: hintColor ?? Colors.black,
          fontWeight: fontWeight ?? FontWeight.w500,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius??13.31.r),
          borderSide:   const BorderSide(color: textFieldColor),),
        enabledBorder:  OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius??13.31.r),
            borderSide:   const BorderSide(color: textFieldColor),),
        border: isBorder == true
            ? OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius??13.31.r),
            borderSide:  const BorderSide(color: textFieldColor))
            : InputBorder.none,
        errorBorder: isErrorBorder == true
            ? OutlineInputBorder(
            borderSide: const BorderSide(color: textFieldColor),
            borderRadius: BorderRadius.circular(borderRadius??13.31.r))
            : InputBorder.none,
      ),
    );
  }
}