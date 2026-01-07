import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/models/user/UpdateCustomerModel.dart';
import 'package:sugudeni/repositories/user-repository.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';

import '../../../l10n/app_localizations.dart';
import '../../../providers/sellerProfile/user-profile-provider.dart';
import '../../../utils/constants/app-assets.dart';
import '../../../utils/customWidgets/my-text.dart';
import '../../../utils/customWidgets/round-button.dart';
import '../../../utils/customWidgets/text-field.dart';

class CustomerProfileSettingView extends StatefulWidget {
  const CustomerProfileSettingView({super.key});

  @override
  State<CustomerProfileSettingView> createState() => _CustomerProfileSettingViewState();
}

class _CustomerProfileSettingViewState extends State<CustomerProfileSettingView> {
  final nameController=TextEditingController();
  final emailController=TextEditingController();
  final phoneController=TextEditingController();
  String profilePicture='';
  Future<void> fetchData()async{
    customPrint("Init ===============================================");
    var data=await UserRepository.getCustomerData(context);
    customPrint("Init data===============================================${data.user!.email}");

    nameController.text=data.user!.name;
    emailController.text=data.user!.email;
    phoneController.text=data.user!.phone;
    profilePicture=data.user!.profilePic ?? '';
    if (mounted) {
      setState(() {
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchData();
    context.read<UserProfileProvider>().fetchUserData(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final provider=Provider.of<UserProfileProvider>(context,listen: false);

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        provider.clearResources();
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: SymmetricPadding(
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
                  MyText(text:AppLocalizations.of(context)!.setting, size: 28.sp, fontWeight: FontWeight.w700),
                  5.height,
                  MyText(text: AppLocalizations.of(context)!.yourprofile, size: 16.sp, fontWeight: FontWeight.w500),
                  20.height,
                  // Profile Image Section - Centered
                  Center(
                    child: SizedBox(
                      height: 90.h,
                      width: 90.w,
                      child: Stack(
                        children: [
                          Consumer<UserProfileProvider>(builder: (context,provider,child){
                            final hasLocalPic = provider.customerProfilePic != null;
                            final hasApiPic = profilePicture.isNotEmpty && provider.isChangePicture == false;
                            
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
                                          image: FileImage(File(provider.customerProfilePic!.path)),
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
                              onTap: (){
                                _showImagePickerBottomSheet(context);
                              },
                              child: Container(
                                height: 28.h,
                                width: 28.w,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: primaryColor,
                                  border: Border.all(color: whiteColor,width: 3)
                                ),
                                child: Center(
                                  child: Icon(Icons.edit,color: whiteColor,size: 12.sp,),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  30.height,
              
                  CustomTextFiled(
                    controller: nameController,
                    borderRadius: 15.r,
                    isBorder: true,
                    isShowPrefixIcon: true,
                    isFilled: true,
                    hintText: AppLocalizations.of(context)!.fullname,
                    isShowPrefixImage: true,
                    prefixImgUrl: AppAssets.personIcon,
              
                  ),
                  10.height,
              
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
                     var model=UpdateCustomerModel(
                         name: nameController.text.trim(),
                         email: emailController.text.trim(),
                         phone: phoneController.text.trim(),
                     );
              
              
                        if(provider.isChangePicture==true) {
                          await provider.addProfilePicture(context);
                          // Refresh profile picture after upload
                          await fetchData();
                          // Clear the local image so API image shows
                          provider.customerProfilePic = null;
                          provider.isChangePicture = false;
                          provider.notifyListeners();
                        }
                        provider.updateCustomerData(model, context);
                        // Refresh data to show updated profile picture
                        fetchData();
              
              
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showImagePickerBottomSheet(BuildContext context) {
    final provider = Provider.of<UserProfileProvider>(context, listen: false);
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
                      provider.pickCustomerImage(ImageSource.camera);
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
                      provider.pickCustomerImage(ImageSource.gallery);
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
