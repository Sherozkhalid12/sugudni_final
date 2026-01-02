import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/round-button.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';

class EmptyStateWidget extends StatelessWidget {
  final String? title;
  final String? description;
  final IconData? icon;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final bool showButton;

  const EmptyStateWidget({
    super.key,
    this.title,
    this.description,
    this.icon,
    this.buttonText,
    this.onButtonPressed,
    this.showButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(40.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120.w,
              height: 120.h,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon ?? Icons.inventory_2_outlined,
                size: 64.sp,
                color: textPrimaryColor.withOpacity(0.3),
              ),
            ),
            24.height,
            MyText(
              text: title ?? 'No Products Found',
              size: 18.sp,
              fontWeight: FontWeight.w600,
              color: textPrimaryColor,
            ),
            12.height,
            MyText(
              text: description ?? 
                    'You don\'t have any products in this category yet. Start by adding your first product to get started.',
              size: 14.sp,
              fontWeight: FontWeight.w400,
              color: textPrimaryColor.withOpacity(0.6),
              textAlignment: TextAlign.center,
            ),
            if (showButton && buttonText != null && onButtonPressed != null) ...[
              24.height,
              RoundButton(
                title: buttonText!,
                onTap: onButtonPressed!,
                width: 200.w,
                height: 45.h,
                btnTextSize: 14.sp,
              ),
            ],
          ],
        ),
      ),
    );
  }
}



