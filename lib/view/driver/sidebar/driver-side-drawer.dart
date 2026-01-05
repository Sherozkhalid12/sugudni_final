import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sugudeni/services/social-services.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';
import 'package:sugudeni/utils/sharePreference/save-user-token.dart';
import 'package:sugudeni/utils/sharePreference/save-user-type.dart';
import 'package:sugudeni/view/language/language-widget.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/constants/app-assets.dart';
import '../../../utils/constants/colors.dart';

class DriverDrawer extends StatelessWidget {
  const DriverDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          60.height,
          40.height,
          const DrawerWidget(title: "Home", img: AppAssets.homeSideIcon),
           DrawerWidget(title: AppLocalizations.of(context)!.myprofiles, img: AppAssets.myProfileSideIcon,
             onPressed: (){
               Navigator.pushNamed(context, RoutesNames.driverProfileView);

             },),
           DrawerWidget(title: AppLocalizations.of(context)!.pendingdeliveries, img: AppAssets.pedingDeliveriesIcon,
           onPressed: (){
             Navigator.pushNamed(context, RoutesNames.driverPendingDeliveriesView);

           },
           ),
           DrawerWidget(title: AppLocalizations.of(context)!.viewhistory, img: AppAssets.viewHistoryIcon,
          onPressed: (){
            Navigator.pushNamed(context, RoutesNames.driverCompletedDeliveryView);

          },
          ),
           DrawerWidget(title: "Support Chat", img: AppAssets.helpCenterIcon,
          onPressed: (){
            Navigator.pushNamed(context, RoutesNames.driverSupportChatView);
          },
          ),
           DrawerWidget(title: AppLocalizations.of(context)!.termsandconditions, img: AppAssets.termAndConditionIcon,onPressed: (){
            Navigator.pushNamed(context, RoutesNames.driverTermAndConditions);
          },),
           DrawerWidget(title: AppLocalizations.of(context)!.privacypolicy, img: AppAssets.privacyIcon,onPressed: (){
             Navigator.pushNamed(context, RoutesNames.driverPrivacyPolicy);

           },),
          const LanguageSelectorForDriver(),
          DrawerWidget(title: AppLocalizations.of(context)!.logout, img: AppAssets.logoutIcon,onPressed: ()async{
           // context.read<ChatSocketProvider>().disconnectSocket();

            await clearSessionToken();
            await clearUserId();
            await clearUserType();
            await SocialServices.signOutUser();

            Navigator.pushNamedAndRemoveUntil(context, RoutesNames.loginView, (route) => false);
           },),

        ],
      ),
    );
  }
}
class DrawerWidget extends StatelessWidget {
  final String title;
  final String img;
  final VoidCallback? onPressed;
  const DrawerWidget({super.key, required this.title, required this.img, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return   GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 34.h,
        color: whiteColor,
        margin: EdgeInsets.only(bottom: 20.h),
        child: Padding(
          padding:  EdgeInsets.only(left:15.w),
          child: Row(
            children: [
              Image.asset(
                height: 20.h,
                width: 20.w,
                img,scale: 2,),
              20.width,
              MyText(text: title,size: 12.sp,

                fontWeight: FontWeight.w600,)

            ],
          ),
        ),
      ),
    );
  }
}
