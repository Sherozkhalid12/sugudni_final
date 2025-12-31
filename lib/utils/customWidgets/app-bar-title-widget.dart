import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/colors.dart';
import '../safe-google-fonts.dart';

class AppBarTitleWidget extends StatelessWidget {
  final String title;
  const AppBarTitleWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: SafeGoogleFonts.roboto(
            color: primaryColor,
            fontSize: 24.sp,
            fontWeight: FontWeight.w600));
  }
}
