import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/providers/carts/cart-provider.dart';
import 'package:sugudeni/providers/chatSocketProvider/chat-socket-provider.dart';
import 'package:sugudeni/services/social-services.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/sharePreference/save-user-token.dart';
import 'package:sugudeni/utils/sharePreference/save-user-type.dart';
import 'package:sugudeni/view/currency/your-country.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/constants/app-assets.dart';
import '../../../utils/routes/routes-name.dart';
import 'package:awesome_dialog/awesome_dialog.dart';


class CustomerSettingView extends StatelessWidget {
  const CustomerSettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              SymmetricPadding(
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
                    MyText(text: AppLocalizations.of(context)!.setting, size: 28.sp, fontWeight: FontWeight.w700),
                    15.height,
                    MyText(text: AppLocalizations.of(context)!.personal, size: 20.sp, fontWeight: FontWeight.w700),
                    15.height,
                    CustomerSettingWidget(title: AppLocalizations.of(context)!.profile, onPressed: (){
                      Navigator.pushNamed(context, RoutesNames.customerProfileSettingView);
                    }),
                    CustomerSettingWidget(title: AppLocalizations.of(context)!.shippingaddress, onPressed: (){
                      context.read<CartProvider>().clearResources();
                      Navigator.pushNamed(context, RoutesNames.customerAddressView);
                    }),
                    CustomerSettingWidget(title: AppLocalizations.of(context)!.paymentmethod, onPressed: (){
                      Navigator.pushNamed(context, RoutesNames.customerPaymentMethodsView);
                    }),
                    CustomerSettingWidget(title: AppLocalizations.of(context)!.termsandcondition, onPressed: (){
                      Navigator.pushNamed(context, RoutesNames.customerTermAndConditionView);
                    }),
            
                    const YourCountry(),
                    CustomerSettingWidget(title: AppLocalizations.of(context)!.requestaccountdeletion, onPressed: (){
                      AwesomeDialog(
                        context: context,
                        animType: AnimType.scale,
                        dialogType: DialogType.info,
                        customHeader: Container(
                          width: 50.w,
                          height: 50.h,
                          decoration: const BoxDecoration(
                              color: Color(0xffF9F9F9),
                              shape: BoxShape.circle,
                              image: DecorationImage(image: AssetImage(AppAssets.accountDeletionIcon))
                          ),child: Center(
                          child: Image.asset(AppAssets.infoIcon,scale: 3,),
                        ),
                        ),
                        body: Column(
                          children: [
                            Text(
                              textAlign: TextAlign.center,
                              AppLocalizations.of(context)!.youaregoingtodeleteyouraccount,
                              style: GoogleFonts.raleway(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 19.sp
                              ),),
                            MyText(text: AppLocalizations.of(context)!.youwontbeabletorestoreyourdata,size: 13.sp,),
                            20.height,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    height: 40.h,
                                    width: 128.w,
                                    decoration: BoxDecoration(
                                        color: const Color(0xff202020),
                                        borderRadius: BorderRadius.circular(11.r)
                                    ),
                                    child: Center(
                                      child: MyText(text: AppLocalizations.of(context)!.cancel,color: whiteColor,size: 16.sp,fontWeight: FontWeight.w300,),
                                    ),
                                  ),
                                ),
                                14.width,
                                GestureDetector(
                                  onTap: (){
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    height: 40.h,
                                    width: 128.w,
                                    decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.circular(11.r)
                                    ),
                                    child: Center(
                                      child: MyText(text: AppLocalizations.of(context)!.delete,color: whiteColor,size: 16.sp,fontWeight: FontWeight.w300,),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            20.height
                          ],
                        ),
            
                      ).show();
                      // showDialog(context: context, builder: (context){
                      //   return Dialog(
                      //
                      //     child: AccountDeletionDialog()
                      //   );
                      // });
                    },hideArrow: true),
            
                  ],
                ),
              ),
                50.height,
                GestureDetector(
                  onTap: ()async{
                    context.read<ChatSocketProvider>().disconnectSocket();
                    await clearUserId();
                    await clearSessionToken();
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
                      padding:  EdgeInsets.symmetric(horizontal: 15.w,vertical: 15.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(AppAssets.logoutIcon,scale: 2,),
                          10.width,
                          MyText(text: AppLocalizations.of(context)!.logout,size: 12.sp,fontWeight: FontWeight.w600,),
            
                        ],
                      ),
                    ),
                  ),
                )
            
              ],
            ),
          )),
    );
  }
}
class CustomerSettingWidget extends StatelessWidget {
  final String title;
  final bool? hideArrow;
  final VoidCallback onPressed;
  const CustomerSettingWidget({super.key, required this.title, required this.onPressed,this.hideArrow=false});

  @override
  Widget build(BuildContext context) {
    return   InkWell(
      onTap: onPressed,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding:  EdgeInsets.symmetric(vertical: 15.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText(text: title, size: 16.sp, fontWeight: FontWeight.w600),
               hideArrow==true? const SizedBox():const Icon(Icons.arrow_forward_ios_outlined)

              ],
            ),
            Divider(
              color: borderColor.withOpacity(0.2),
            )
          ],
        ),
      ),
    );
  }
}
