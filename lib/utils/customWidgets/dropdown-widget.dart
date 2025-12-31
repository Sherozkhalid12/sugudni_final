
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';

class DropDownWidget extends StatelessWidget {
  final String textName;
  final List<String> list;
  final String? initialValue;
  final String? Function(String?)? onChange;

  const DropDownWidget({super.key, required this.textName, required this.list, this.initialValue, this.onChange});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(

      child: DropdownButton2<String>(
        alignment: Alignment.centerLeft,
        iconStyleData: IconStyleData(
            icon: Icon(Icons.keyboard_arrow_down_sharp,color: blackColor,size: 30.sp,)
        ),
        isExpanded: true,
        hint: MyText(
          textAlignment: TextAlign.center,
          text: textName,
          fontWeight: FontWeight.w400,color: blackColor,size: 12.sp,),
        items: list
            .map((String item) => DropdownMenuItem<String>(
          value: item,
          child: MyText(
            textAlignment: TextAlign.center,
            text: item,
            fontWeight: FontWeight.w400,color: blackColor,size: 14.sp,),
        ))
            .toList(),
        value: initialValue,
        onChanged: onChange,
        buttonStyleData:  ButtonStyleData(
          decoration: BoxDecoration(

            color: whiteColor,
            borderRadius: BorderRadius.circular(5.r),

          ),
          padding: EdgeInsets.symmetric(horizontal: 10.sp),
          height: 46.h,
          width: double.infinity,
        ),
        menuItemStyleData:  MenuItemStyleData(
          height: 40.h,


        ),
      ),
    );
  }
}
