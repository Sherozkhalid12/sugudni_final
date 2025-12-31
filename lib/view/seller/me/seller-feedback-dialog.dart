import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sugudeni/main.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/round-button.dart';
import 'package:sugudeni/utils/customWidgets/text-field.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';

import '../../../l10n/app_localizations.dart';

class SellerFeedBackDialog extends StatelessWidget {
  const SellerFeedBackDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.all(12.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          MyText(text: AppLocalizations.of(context)!.giveyourfeedback,size: 18.sp,fontWeight: FontWeight.w700,),
          5.height,
           CustomTextFiled(
            maxLine: 5,
            isShowPrefixIcon: false,
            hintText: AppLocalizations.of(context)!.writesomethinghere,
          ),
          10.height,
          Row(
            children: [
              Flexible(
                child: RoundButton(
                    btnTextSize: 14.sp,
                    height: 40.h,
                    borderColor: primaryColor,
                    bgColor: transparentColor,
                    textColor: primaryColor,
                    borderRadius: BorderRadius.circular(10.r),
                    textFontWeight: FontWeight.w700,
                    title: AppLocalizations.of(context)!.cancel,
                    onTap: (){
                      Navigator.pop(context);
                    }),
              ),
              10.width,

              Flexible(
                child: RoundButton(
                    btnTextSize: 14.sp,
                    height: 40.h,
                    borderRadius: BorderRadius.circular(10.r),
                    textFontWeight: FontWeight.w700,
                    title: AppLocalizations.of(context)!.send,
                    onTap: (){
                      Navigator.pop(context);

                    }),
              ),

            ],
          )
        ],
      ),
    );
  }
}
