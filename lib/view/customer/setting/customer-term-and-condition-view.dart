import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import '../../../l10n/app_localizations.dart';


class CustomerTermAndConditionView extends StatelessWidget {
  const CustomerTermAndConditionView({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: SafeArea(
          child: SymmetricPadding(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  30.height,
                  Row(
                    children: [
                      InkWell(
                          onTap:(){
                            Navigator.pop(context);
                          },
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Icon(Icons.arrow_back_ios))
                    ],
                  ),

                  Center(
                    child: Image.asset(
                        height: 140.h,
                        width: 300.w,
                        AppAssets.appLogo),
                  ),
                  Center(child: MyText(text: AppLocalizations.of(context)!.termsandcondition,size: 22.sp,fontWeight: FontWeight.w600,)),
                  10.height,
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(10.r)
                    ),
                    child: Padding(
                      padding:  EdgeInsets.all(10.sp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(text: "1  Lorem ipsum dolor sit amet",color: whiteColor,
                            size: 14.sp,
                            fontWeight: FontWeight.w700,
                          ),
                          MyText(
                            overflow: TextOverflow.clip,
                            text: '''Consectetur adipiscing elit. Natoque phasellus lobortis mattis cursus faucibus hac proin risus. Turpis phasellus massa ullamcorper volutpat. Ornare commodo non integer fermentum nisi, morbi id. Vel tortor mauris feugiat amet, maecenas facilisis risus, in faucibus. Vestibulum ullamcorper fames eget enim diam fames faucibus duis ac. Aliquam non tellus semper in dignissim nascetur venenatis lacus.''',color: whiteColor,
                            size: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          10.height,
                          MyText(text: "2  Lectus vel non varius",color: whiteColor,
                            size: 14.sp,
                            fontWeight: FontWeight.w700,
                          ),
                          MyText(
                            overflow: TextOverflow.clip,
                            text: '''Consectetur adipiscing elit. Natoque phasellus lobortis mattis cursus faucibus hac proin risus. Turpis phasellus massa ullamcorper volutpat. Ornare commodo non integer fermentum nisi, morbi id. Vel tortor mauris feugiat amet, maecenas facilisis risus, in faucibus. Vestibulum ullamcorper fames eget enim diam fames faucibus duis ac. Aliquam non tellus semper in dignissim nascetur venenatis lacus.''',color: whiteColor,
                            size: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          10.height,
                          MyText(text: "3  Sit praesent mi dolor ",color: whiteColor,
                            size: 14.sp,
                            fontWeight: FontWeight.w700,
                          ),
                          MyText(
                            overflow: TextOverflow.clip,
                            text: '''Consectetur adipiscing elit. Natoque phasellus lobortis mattis cursus faucibus hac proin risus. Turpis phasellus massa ullamcorper volutpat. Ornare commodo non integer fermentum nisi, morbi id. Vel tortor mauris feugiat amet, maecenas facilisis risus, in faucibus. Vestibulum ullamcorper fames eget enim diam fames faucibus duis ac. Aliquam non tellus semper in dignissim nascetur venenatis lacus.''',color: whiteColor,
                            size: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
