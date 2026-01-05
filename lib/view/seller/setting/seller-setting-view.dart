import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/models/user/UpdateSellerModel.dart';
import 'package:sugudeni/providers/loading-provider.dart';
import 'package:sugudeni/repositories/user-repository.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';
import 'package:sugudeni/view/seller/products/seller-my-products-view.dart';

import '../../../providers/sellerProfile/user-profile-provider.dart';
import '../../../utils/constants/fonts.dart';
import '../../../utils/customWidgets/app-bar-title-widget.dart';
import '../../../utils/customWidgets/round-button.dart';
import '../../../utils/customWidgets/text-field.dart';
import '../../../l10n/app_localizations.dart';

class SellerAccountSettingView extends StatefulWidget {
  const SellerAccountSettingView({super.key});

  @override
  State<SellerAccountSettingView> createState() => _SellerAccountSettingViewState();
}

class _SellerAccountSettingViewState extends State<SellerAccountSettingView> {

  final nameController=TextEditingController();
  final emailController=TextEditingController();
  final phoneController=TextEditingController();
  final passwordController=TextEditingController();

  bool _showPassword = false;

  // Store original values to detect changes
  String originalEmail = '';
  String originalPhone = '';
  
  void fetchData()async{
    customPrint("Init ===============================================");
    var data=await UserRepository.getSellerData(context);
    customPrint("Init data===============================================${data.user!.email}");

    nameController.text=data.user!.name;
    emailController.text=data.user!.email;
    phoneController.text=data.user!.phone;
    
    // Store original values
    originalEmail = data.user!.email;
    originalPhone = data.user!.phone;
    
    setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final sellerProvider=Provider.of<UserProfileProvider>(context,listen: false);
    final loadingProvider=Provider.of<LoadingProvider>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.h,
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            RoundIconButton(onPressed: (){
              Navigator.pop(context);
            },iconUrl: AppAssets.arrowBack),
            20.width,
             AppBarTitleWidget(title: AppLocalizations.of(context)!.accountsetting),

          ],
        ),
      ),
      body: Consumer<UserProfileProvider>(builder: (context,sellerProvider,child){

        return  SymmetricPadding(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                40.height,
                MyText(text: AppLocalizations.of(context)!.name,size: 12.sp,fontWeight: FontWeight.w500,),
                5.height,
                CustomTextFiled(
                  controller: nameController,
                  borderRadius: 15.r,
                  isBorder: true,
                  isShowPrefixIcon: true,
                  isFilled: true,
                  hintText: AppLocalizations.of(context)!.storename,
                  isShowPrefixImage: true,
                  prefixImgUrl: AppAssets.personIcon,

                ),
                10.height,
                MyText(text: AppLocalizations.of(context)!.email,size: 12.sp,fontWeight: FontWeight.w500,),
                5.height,
                CustomTextFiled(
                  controller: emailController,
                  borderRadius: 15.r,
                  isBorder: true,
                  isShowPrefixIcon: true,
                  isFilled: true,
                  hintText: AppLocalizations.of(context)!.enteryouremail,
                  isShowPrefixImage: true,
                  prefixImgUrl: AppAssets.emailIcon,

                ),
                10.height,
                MyText(text: AppLocalizations.of(context)!.phonenumber,size: 12.sp,fontWeight: FontWeight.w500,),
                5.height,
                CustomTextFiled(
                  controller: phoneController,
                  borderRadius: 15.r,
                  isBorder: true,
                  isShowPrefixIcon: true,
                  isFilled: true,
                  hintText: AppLocalizations.of(context)!.pleaseinputphonenumber,
                  isShowPrefixImage: true,
                  prefixImgUrl: AppAssets.callIcon,

                ),
                10.height,
                MyText(text: AppLocalizations.of(context)!.password,size: 12.sp,fontWeight: FontWeight.w500,),
                5.height,
                CustomTextFiled(
                  key: ValueKey(_showPassword),
                  controller: passwordController,
                  borderRadius: 15.r,
                  isShowPrefixIcon: true,
                  isBorder: true,
                  isFilled: true,
                  hintText: AppLocalizations.of(context)!.enteryourpassword,
                  isShowPrefixImage: true,
                  isPassword: true,
                  isObscure: !_showPassword,
                  passwordFunction: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                  prefixImgUrl: AppAssets.passwordIcon,
                ),
                150.height,
                RoundButton(
                    isLoad: true,
                    title: AppLocalizations.of(context)!.savechanges, onTap: ()async{
                      if(nameController.text.isEmpty){
                        showSnackbar(context, AppLocalizations.of(context)!.informationmisiing,color: redColor);
                        return;
                      }
                      
                      // Only include email if it has changed
                      final emailChanged = emailController.text.trim() != originalEmail;
                      // Only include phone if it has changed
                      final phoneChanged = phoneController.text.trim() != originalPhone;
                      
                      var model=UpdateSellerModel(
                          name: nameController.text.trim(),
                          email: emailChanged ? emailController.text.trim() : null,
                          phone: phoneChanged ? phoneController.text.trim() : null,
                          password: passwordController.text.isNotEmpty ? passwordController.text.trim() : null,
                      );
                    try{
                      loadingProvider.setLoading(true);
                      await UserRepository.updateSellerSetting(model, context).then((v){
                        loadingProvider.setLoading(false);
                        showSnackbar(context, AppLocalizations.of(context)!.informationupdatedsuccessfully,color: greenColor);
                      });
                    }catch(e){
                      loadingProvider.setLoading(false);
                    }
                }),
                20.height,
                Row(
                  children: [
                    Container(
                      height: 15.h,
                      width: 15.w,
                      decoration: BoxDecoration(
                          color: appRedColor,
                          borderRadius: BorderRadius.circular(2.r),
                          image: const DecorationImage(image: AssetImage(AppAssets.productRemoveIcon),scale: 2)
                      ),
                    ),
                    5.width,
                    RichText(

                      textAlign: TextAlign.center,

                      text: TextSpan(

                        text: AppLocalizations.of(context)!.delete,
                        style: TextStyle(
                          fontSize: 12.sp,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w600,
                          color: blackColor,
                          fontFamily: AppFonts.poppins,

                        ),
                        children: [

                          TextSpan(
                            text: ' SUGUDENI ',
                            style: GoogleFonts.blinker(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp,
                            ),
                            recognizer: TapGestureRecognizer()..onTap = () {
                              // Navigate to Terms & Conditions
                            },
                          ),
                          TextSpan(
                            text: AppLocalizations.of(context)!.account,
                            style: TextStyle(
                              color: blackColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp,
                              fontFamily: AppFonts.poppins,

                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                30.height,
                RichText(

                  textAlign: TextAlign.start,

                  text: TextSpan(

                    text: '${AppLocalizations.of(context)!.asyouareupdatingaccountsettingyoualreadyreadandaccepted} ',
                    style: TextStyle(
                      fontSize: 12.sp,

                      fontWeight: FontWeight.w400,
                      color: blackColor,
                      fontFamily: AppFonts.poppins,

                    ),
                    children: [
                      TextSpan(
                        text: ' ${AppLocalizations.of(context)!.termsandcondition}',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                          fontFamily: AppFonts.poppins,

                        ),
                      ),
                    ],
                  ),
                ),
                20.height,

              ],
            ),
          ),
        );
      }),

    );
  }
}
