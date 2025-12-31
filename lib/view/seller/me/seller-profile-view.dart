import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/main.dart';
import 'package:sugudeni/providers/chatSocketProvider/chat-socket-provider.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';
import 'package:sugudeni/utils/sharePreference/save-user-token.dart';
import 'package:sugudeni/view/language/language-widget.dart';
import 'package:sugudeni/view/seller/me/chat-setting-diolog.dart';
import 'package:sugudeni/view/seller/me/seller-feedback-dialog.dart';

import '../../../l10n/app_localizations.dart';
import '../../../services/social-services.dart';
import '../../../utils/customWidgets/symetric-padding.dart';
import '../../../utils/sharePreference/save-user-type.dart';
import '../home/seller-home-view.dart';

class SellerProfileView extends StatefulWidget {
  const SellerProfileView({super.key});

  @override
  State<SellerProfileView> createState() => _SellerProfileViewState();
}

class _SellerProfileViewState extends State<SellerProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 80.h,
        title: const SellerInfoWidget(isShowLastIcon: true,isForProfile: true,),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              10.height,
              // Container(
              //   width: double.infinity,
              //  // height: 70.h,
              //   color: whiteColor,
              //   child: Padding(
              //     padding:  EdgeInsets.all(15.sp),
              //     child: Column(
              //       children: [
              //         Row(
              //           children: [
              //             MyText(text: AppLocalizations.of(context)!.numberofdaysasaseller,fontWeight: FontWeight.w500,
              //             size: 12.sp,
              //             ),
              //             const Spacer(),
              //             MyText(text: "68 ",fontWeight: FontWeight.w600,
              //             size: 12.sp,
              //             ),
              //
              //             MyText(text: "Days",fontWeight: FontWeight.w500,
              //             size: 12.sp,
              //             ),
              //           ],
              //         ),
              //         const Divider(
              //           color: borderColor,
              //         ),
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Container(
              //               height: 26.h,
              //               width: 26.w,
              //               decoration: BoxDecoration(
              //                 borderRadius: BorderRadius.circular(6.r),
              //                 image: const DecorationImage(image: AssetImage(AppAssets.shopHomePageIcon),scale: 3),
              //                 border: Border.all(color: primaryColor)
              //               ),
              //             ),
              //             8.width,
              //             MyText(text: AppLocalizations.of(context)!.shophomepage,fontWeight: FontWeight.w500,
              //               size: 12.sp,
              //             ),
              //             const Spacer(),
              //             Container(
              //               height: 20.h,
              //               width: 2.w,
              //               color: borderColor,
              //             ),
              //             const Spacer(),
              //             Image.asset(AppAssets.shareShopIcon,scale: 3,),
              //             8.width,
              //             MyText(text: AppLocalizations.of(context)!.shareshop,fontWeight: FontWeight.w500,
              //               size: 12.sp,
              //             ),
              //           ],
              //         ),
              //
              //       ],
              //     ),
              //   ),
              // ),
              //
              // 20.height,
               SymmetricPadding(
                child: Column(
                  children: [
                    10.height,
                    const LanguageSelectorForSeller(),
                    SellerProfileWidget(title: AppLocalizations.of(context)!.accountsetting,onPressed: (){
                      Navigator.pushNamed(context, RoutesNames.sellerAccountSettingView);
                    },),
                    SellerProfileWidget(title: AppLocalizations.of(context)!.accounthealth,onPressed: (){
                      Navigator.pushNamed(context, RoutesNames.sellerAccountHealthView);

                    },),
                    SellerProfileWidget(title: AppLocalizations.of(context)!.bankdetail,onPressed: (){
                      Navigator.pushNamed(context, RoutesNames.sellerBankDetailView);
                    },),
                    SellerProfileWidget(title: AppLocalizations.of(context)!.pickupaddress,onPressed: (){
                      Navigator.pushNamed(context, RoutesNames.sellerAddressView);
                    },),
                     SellerProfileWidget(title: AppLocalizations.of(context)!.chatsetting,onPressed: (){
                      showDialog(context: context,
                          barrierDismissible: false,
                          builder: (context){

                            return const Dialog(
                              backgroundColor: whiteColor,
                              child: SellerChatSettingDialog(),
                            );
                          });
                    },),
                     SellerProfileWidget(title: AppLocalizations.of(context)!.notifications,isShowImage: true,),
                    //  SellerProfileWidget(title: AppLocalizations.of(context)!.chatwithus,onPressed: (){
                    //   Navigator.pushNamed(context, RoutesNames.sellerMessageDetailDetailView,arguments: 'SUGUDENI');
                    // },),
                     SellerProfileWidget(title: AppLocalizations.of(context)!.deactivateaccount,isShowToggle: true,isShowArrow: false,onPressed: (){

                     },),
                     SellerProfileWidget(title: AppLocalizations.of(context)!.feedback,onPressed: (){
                      showDialog(context: context,
                          barrierDismissible: false,
                          builder: (context){

                        return const Dialog(
                          backgroundColor: whiteColor,
                          child: SellerFeedBackDialog(),
                        );
                      });
                    },),
                40.height,
                GestureDetector(
                  onTap: ()async{
                    context.read<ChatSocketProvider>().disconnectSocket();

                    await clearSessionToken();
                    await clearUserId();
                    await clearUserType();

                    await SocialServices.signOutUser();
                    Navigator.pushNamedAndRemoveUntil(context, RoutesNames.loginView, (route) => false);
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(8.r)
                    ),
                    margin: EdgeInsets.only(bottom: 15.h),
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 15.w,vertical: 7.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(AppAssets.logoutIcon,scale: 3,),
                          10.width,
                          MyText(text: AppLocalizations.of(context)!.logout,size: 12.sp,fontWeight: FontWeight.w600,),

                        ],
                      ),
                    ),
                  ),
                )
                  ],
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
class SellerProfileWidget extends StatefulWidget {
  final String title;
  final VoidCallback? onPressed;
  final bool? isShowImage;
  final bool? isShowToggle;
  final bool? isShowArrow;
  const SellerProfileWidget({super.key, required this.title,this.onPressed, this.isShowImage=false, this.isShowToggle=false, this.isShowArrow=true});

  @override
  State<SellerProfileWidget> createState() => _SellerProfileWidgetState();
}

class _SellerProfileWidgetState extends State<SellerProfileWidget> {
  bool isActivate=false;

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(8.r)
        ),
        margin: EdgeInsets.only(bottom: 15.h),
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 15.w,vertical: 7.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyText(text: widget.title,size: 12.sp,fontWeight: FontWeight.w600,),
              const Spacer(),
              widget.isShowToggle==true?
              SizedBox(
                width: 30,
                child: FittedBox(
                  child: Switch(
                    thumbColor: WidgetStatePropertyAll(whiteColor.withAlpha(getAlpha(0.5))),
                      activeColor: primaryColor,
                      value: isActivate, onChanged: (v){
                    setState(() {
                      isActivate=!isActivate;
                    });
                  }),
                ),
              ):const SizedBox(),
             widget.isShowImage==true? Image.asset(AppAssets.appLogo,scale: 15,):const SizedBox(),
              widget.isShowArrow==true?   Image.asset(AppAssets.arrowIcon,scale: 3,):const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
