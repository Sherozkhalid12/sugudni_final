import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/models/user/UpdateSellerModel.dart';
import 'package:sugudeni/providers/image-pickers-provider.dart';
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

  // Store original values to detect changes
  String originalEmail = '';
  String originalPhone = '';
  String profilePicture = '';
  
  Future<void> fetchData()async{
    customPrint("Init ===============================================");
    var data=await UserRepository.getSellerData(context);
    customPrint("Init data===============================================${data.user!.email}");

    nameController.text=data.user!.name;
    emailController.text=data.user!.email;
    phoneController.text=data.user!.phone;
    profilePicture = data.user!.profilePic ?? '';
    
    // Store original values
    originalEmail = data.user!.email;
    originalPhone = data.user!.phone;
    
    if (mounted) {
      setState(() {

      });
    }
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
    final imagePickerProvider=Provider.of<ImagePickerProviders>(context,listen: false);
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
                // Profile Image Section - Centered
                Center(
                  child: SizedBox(
                    height: 90.h,
                    width: 90.w,
                    child: Stack(
                      children: [
                        Consumer<ImagePickerProviders>(builder: (context, imageProvider, child) {
                          final hasLocalPic = imageProvider.sellerProfilePic != null;
                          final hasApiPic = profilePicture.isNotEmpty;
                          
                          return Positioned(
                            top: 0,
                            left: 0,
                            child: Container(
                              height: 80.h,
                              width: 80.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: !hasLocalPic && !hasApiPic ? Colors.orange.shade400 : whiteColor,
                                image: hasLocalPic
                                    ? DecorationImage(
                                        image: FileImage(File(imageProvider.sellerProfilePic!.path)),
                                        fit: BoxFit.cover,
                                      )
                                    : hasApiPic
                                        ? DecorationImage(
                                            image: NetworkImage("${ApiEndpoints.productUrl}/$profilePicture"),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                              ),
                              child: !hasLocalPic && !hasApiPic
                                  ? Icon(
                                      Icons.person,
                                      color: whiteColor,
                                      size: 40.sp,
                                    )
                                  : null,
                            ),
                          );
                        }),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: GestureDetector(
                            onTap: () {
                              _showImagePickerBottomSheet(context);
                            },
                            child: Container(
                              height: 28.h,
                              width: 28.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: primaryColor,
                                border: Border.all(color: whiteColor, width: 3)
                              ),
                              child: Center(
                                child: Icon(Icons.edit, color: whiteColor, size: 12.sp),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                30.height,
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
                      );
                    try{
                      loadingProvider.setLoading(true);
                      // Upload profile picture if changed
                      if (imagePickerProvider.sellerProfilePic != null) {
                        await imagePickerProvider.uploadSellerProfilePicture(context);
                        // Refresh profile picture after upload
                        await fetchData();
                        // Clear the local image so API image shows
                        imagePickerProvider.sellerProfilePic = null;
                        imagePickerProvider.notifyListeners();
                      }
                      await UserRepository.updateSellerSetting(model, context).then((v){
                        loadingProvider.setLoading(false);
                        showSnackbar(context, AppLocalizations.of(context)!.informationupdatedsuccessfully,color: greenColor);
                        // Refresh data to show updated profile picture
                        fetchData();
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

  void _showImagePickerBottomSheet(BuildContext context) {
    final imagePickerProvider = Provider.of<ImagePickerProviders>(context, listen: false);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Cancel button
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: Icon(Icons.close, size: 24.sp),
                  ),
                ),
              ),
              // Options
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      imagePickerProvider.pickSellerImage(ImageSource.camera);
                    },
                    child: Column(
                      spacing: 10.h,
                      children: [
                        Image.asset(AppAssets.cameraImg, scale: 3),
                        MyText(
                          text: AppLocalizations.of(context)!.camera,
                          size: 10.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff545454),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      imagePickerProvider.pickSellerImage(ImageSource.gallery);
                    },
                    child: Column(
                      spacing: 10.h,
                      children: [
                        Image.asset(AppAssets.photosImg, scale: 3),
                        MyText(
                          text: AppLocalizations.of(context)!.photos,
                          size: 10.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff545454),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
