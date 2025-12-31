import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import '../../l10n/app_localizations.dart';

class SearchProductTextField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final  String? Function(String?)? validator;
  final String? Function(String?)? onChange;
  final String? Function(String?)? onSubmit;
  final TextInputType? keyboardType;

  const SearchProductTextField({super.key, this.hintText, this.controller, this.validator, this.onChange, this.onSubmit, this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      onChanged: onChange,
      onFieldSubmitted: onSubmit,
      keyboardType: keyboardType,
      style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 10.sp,
          color: const Color(0xff545454)
      ),
      decoration: InputDecoration(
        hintText:hintText?? AppLocalizations.of(context)!.searchyourproduct,
        hintStyle: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 10.sp,
            color: const Color(0xff545454)
        ),
        prefixIcon: const Icon(Icons.search,color: Color(0xff545454),),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(
            color: primaryColor,

          ),
        ),
        enabledBorder:OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(
            color: primaryColor,

          ),
        ) ,
        focusedBorder:OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(
            color: primaryColor,
          ),
        ),
      ),
    );
  }
}
